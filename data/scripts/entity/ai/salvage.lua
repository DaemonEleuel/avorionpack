
package.path = package.path .. ";data/scripts/lib/?.lua"

require ("stringutility")

local minedWreckage = nil
local minedLoot = nil
local collectCounter = 0

function getUpdateInterval()
    return 1
end

-- this function will be executed every frame on the server only
function updateServer(timeStep)
    -- find a wreckage that can be harvested
    local ship = Entity()
    local faction = Faction(ship.factionIndex)

    if faction.isPlayer then
        local player = Player(faction.index)

        if player.craftIndex == ship.index then
            return
        end
    end

    updateSalvaging(timeStep)

end

-- check the immediate region around the ship for loot that can be collected
-- and if there is some, assign minedLoot
function findMinedLoot()
    local loots = {Sector():getEntitiesByType(EntityType.Loot)}
    local ship = Entity()

    minedLoot = nil
    for _, loot in pairs(loots) do
        if loot:isCollectable(ship) and distance2(loot.translationf, ship.translationf) < 150 * 150 then
            minedLoot = loot
            break
        end
    end

end

-- check the sector for a wreckage that can be mined
-- if there is one, assign minedwreckage
function findMinedWreckage()

    local radius = 20
    local ship = Entity()
    local sector = Sector()

    minedWreckage = nil

    local mineables = {sector:getEntitiesByType(EntityType.Wreckage)}
	--local mineables = {sector:getEntitiesByComponent(ComponentType.MineableMaterial)}
    local nearest = math.huge

    for _, a in pairs(mineables) do
        if a.type == EntityType.Wreckage then
            --local resources = a:getMineableResources()
            --if resources ~= nil and resources > 0 then

                local dist = distance2(a.translationf, ship.translationf)
                if dist < nearest then
                    nearest = dist
                    minedWreckage = a
                end

            --end
        end
    end

    if minedWreckage then
        broadcastInvokeClientFunction("setMinedWreckage", minedWreckage.index)
    else
        local player = Player(Entity().factionIndex)
        if player then
            local x, y = Sector():getCoordinates()
            local coords = tostring(x) .. ":" .. tostring(y)

            player:sendChatMessage(ship.name or "", ChatMessageType.Error, "Your ship in sector %s can't find any more wreckages."%_T, coords)
            player:sendChatMessage(ship.name or "", ChatMessageType.Normal, "Sir, we can't find any more wreckages in \\s(%s)!"%_T, coords)
        end

        ShipAI(ship.index):setPassive()
        ship:invokeFunction("craftorders.lua", "setAIAction")
        terminate()
    end

end

function updateSalvaging(timeStep)

    -- highest priority is collecting the resources
    if not valid(minedWreckage) and not valid(minedLoot) then

        -- first, check if there is loot to collect
        findMinedLoot()

        -- then, if there's no loot, check if there is a wreckage to mine
        if not valid(minedLoot) then
            findMinedWreckage()
        end

    end

    local ship = Entity()
    local ai = ShipAI()

    if valid(minedLoot) then

        -- there is loot to collect, fly there
        collectCounter = collectCounter + timeStep
        if collectCounter > 3 then
            collectCounter = collectCounter - 3
            ai:setFly(minedLoot.translationf, 0)
        end

    elseif valid(minedWreckage) then

        -- if there is a wreckage to collect, attack it
        if ship.selectedObject == nil
            or ship.selectedObject.index ~= minedWreckage.index
            or ai.state ~= AIState.Attack then

            if ship.numTurrets == 0 then
                local player = Player(Entity().factionIndex)
                if player then
                    player:sendChatMessage("Server", ChatMessageType.Error, "Your ship can't salvage without turrets."%_T)
                end
                terminate()
                return
            end

            ai:setAttack(minedWreckage)
        end
    end

end

function setMinedWreckage(index)
    minedWreckage = Entity(index)
end

---- this function will be executed every frame on the client only
--function updateClient(timeStep)
--
--    if valid(minedWreckage) then
--        drawDebugSphere(minedWreckage:getBoundingSphere(), ColorRGB(1, 0, 0))
--    end
--end
