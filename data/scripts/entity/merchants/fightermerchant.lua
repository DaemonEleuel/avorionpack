package.path = package.path .. ";data/scripts/lib/?.lua"
require ("galaxy")
require ("utility")
require ("randomext")
require ("faction")
require ("sellableinventoryitem")
require ("stringutility")
local FighterGenerator = require("fightergenerator")
local Dialog = require("dialogutility")
local ShopAPI = require ("shop")

-- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
-- namespace FighterMerchant
FighterMerchant = {}
FighterMerchant = ShopAPI.CreateNamespace()


local SellableFighterItem = {}
SellableFighterItem.__index = SellableFighterItem

local function new(fighter, index, player)
    local obj = setmetatable({fighter = fighter, item = fighter, index = index}, SellableFighterItem)

    -- initialize the item
    obj.price = obj:getPrice()
    obj.name = "${weaponPrefix} Fighter"%_t % {weaponPrefix = obj.fighter.weaponPrefix}
    obj.rarity = obj.fighter.rarity
    obj.material = obj.fighter.material
    obj.icon = obj.fighter.weaponIcon

    if player and index then
        obj.amount = player:getInventory():amount(index)
    elseif index and type(index) == "number" then
        obj.amount = index
    else
        obj.amount = 1
    end

    return obj
end

function SellableFighterItem:getTooltip()

    if self.tooltip == nil then
        self.tooltip = makeFighterTooltip(self.fighter)
    end

    return self.tooltip
end

function SellableFighterItem:getPrice()
    local value = ArmedObjectPrice(self.fighter)
    local fighter = self.fighter
    -- durability of 100 makes the fighter twice as expensive, 200 three times etc.
    local hpFactor = fighter.durability / 1000 + 1
    value = value * hpFactor
    -- speed of 20 is median, above makes it more expensive, below makes it cheaper
    local speedFactor = fighter.maxVelocity / 60
    value = value * speedFactor
    -- maneuverability of 2 is median, above makes it more expensive, below makes it cheaper
    local maneuverFactor = fighter.turningSpeed / 4
    value = value * maneuverFactor
	-- lets make those fighters waaaaaay cheaper, shall we?
	value = value / 50									
    value = round(value)

    return value
end

function SellableFighterItem:boughtByPlayer(ship)

    local hangar = Hangar(ship.index)

    -- check if there is enough space in ship
    if hangar.freeSpace < self.fighter.volume then
        return "You don't have enough space in your hangar."%_t, {}
    end

    -- find a squad that has space for a fighter
    local squads = {hangar:getSquads()}

    local squad
    for _, i in pairs(squads) do
        local fighters = hangar:getSquadFighters(i)
        local space = hangar:getSquadMaxFighters(i)

        local free = space - fighters

        if free > 0 then
            squad = i
            break
        end
    end

    if squad == nil then
        return "There is no free squad to place the fighter in."%_t, {}
    end

    hangar:addFighter(squad, self.fighter)
end

function SellableFighterItem:soldByPlayer(ship)

    local hangar = Hangar(ship.index)

    self.fighter = hangar:getFighter(self.squadIndex, self.fighterIndex)

    if self.fighter == nil then
        return "Fighter to sell not found"%_t, {}
    end

    local price = getFighterPrice(fighter) / 8.0
    hangar:removeFighter(self.squadIndex, self.fighterIndex)

end

local SellableFighter = setmetatable({new = new}, {__call = function(_, ...) return new(...) end})

-- if this function returns false, the script will not be listed in the interaction window on the client,
-- even though its UI may be registered
function FighterMerchant.interactionPossible(playerIndex, option)
    local player = Player(playerIndex)
    local ship = player.craft
    if not ship then return false end
    if not ship:hasComponent(ComponentType.Hangar) then return false end

    return CheckFactionInteraction(playerIndex, 0)
end

local function comp(a, b)
    local ta = a.fighter;
    local tb = b.fighter;

    if ta.rarity.value == tb.rarity.value then
        if ta.material.value == tb.material.value then
            return ta.weaponPrefix < tb.weaponPrefix
        else
            return ta.material.value > tb.material.value
        end
    else
        return ta.rarity.value > tb.rarity.value
    end
end

function FighterMerchant.shop:addItems()
    local station = Entity()

    if station.title == "" then
        station.title = "Fighter Merchant"%_t
    end

    -- create all fighters
    local allFighters = {}

    for i = 1, 6 do
        local fighter = FighterGenerator.generate(Sector():getCoordinates())

        local pair = {}
        pair.fighter = fighter
        pair.amount = 1

        if fighter.rarity.value == RarityType.Exceptional then
            pair.amount = getInt(3, 5)
        elseif fighter.rarity.value == RarityType.Rare then
            pair.amount = getInt(6, 10)
														   
									   
        elseif fighter.rarity.value == RarityType.Uncommon then
            pair.amount = getInt(8, 15)
        elseif fighter.rarity.value == RarityType.Common then
            pair.amount = getInt(15, 25)
        end

        table.insert(allFighters, pair)
    end

    table.sort(allFighters, comp)

    for _, pair in pairs(allFighters) do
        FighterMerchant.shop:add(pair.fighter, pair.amount)
    end

end

function FighterMerchant.initialize()
    FighterMerchant.shop:initialize("Fighter Merchant"%_t)
end

function FighterMerchant.initUI()
    FighterMerchant.shop:initUI("Buy Fighters"%_t, "Fighter Merchant"%_t)
end

FighterMerchant.shop.ItemWrapper = SellableFighter
FighterMerchant.shop.SortFunction = comp



