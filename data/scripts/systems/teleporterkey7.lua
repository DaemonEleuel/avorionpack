
package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- this key is dropped by the mad scientist

function getNumTurrets(seed, rarity)
    return math.max(1, rarity.value + 2)
end

function getEnergyGen(seed, rarity)
    math.randomseed(seed)

	number = math.random(70, 80) -- 70 max 80
	number = number / 100

    return number
end

function getBattRech(seed, rarity)
    math.randomseed(seed)
	
	number = math.random(40, 50) -- 40 max 50
	number = number / 100

    return number
end

function onInstalled(seed, rarity)
    addMultiplyableBias(StatsBonuses.ArmedTurrets, getNumTurrets(seed, rarity))
	addMultiplyableBias(StatsBonuses.UnarmedTurrets, getNumTurrets(seed, rarity))
	addBaseMultiplier(StatsBonuses.GeneratedEnergy, getEnergyGen(seed, rarity))
	addBaseMultiplier(StatsBonuses.BatteryRecharge, getBattRech(seed, rarity))
end

function onUninstalled(seed, rarity)
end

function getName(seed, rarity)
    return "XSTN-K VII"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key7.png"
end

function getEnergy(seed, rarity)
    return 0
end

function getPrice(seed, rarity)
    return 10000
end

function getTooltipLines(seed, rarity)
    return
    {
        {ltext = "Armed turrets", rtext = "+" .. getNumTurrets(seed, rarity), icon = "data/textures/icons/turret.png"},
		{ltext = "Unarmed turrets", rtext = "+" .. getNumTurrets(seed, rarity), icon = "data/textures/icons/turret.png"},
		{ltext = "Generated Energy", rtext = "+" .. (getEnergyGen(seed, rarity) * 100) .. "%", icon = "data/textures/icons/electric.png"},
		{ltext = "Recharge Rate", rtext = "+" ..(getBattRech(seed, rarity) * 100) .. "%", icon = "data/textures/icons/energise.png"}
    }
end

function getDescriptionLines(seed, rarity)
    return
    {
        {ltext = "This system has 7 vertical "%_t, rtext = "", icon = ""},
        {ltext = "scratches on its surface."%_t, rtext = "", icon = ""}
    }
end
