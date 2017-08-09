package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- this teleporter key is given by the Haatii

function getNumTurrets(seed, rarity)
    return math.max(1, rarity.value + 6)
end

function getHyperSpaceRange(seed, rarity)
	math.randomseed(seed)
	
	randomx = getInt(1, 6)
	rarityx = rarity.value + 4
	number = rarityx + randomx -- 6 max 9
	
    return number
end

function getHyperspaceRechargeEnergy(seed, rarity)
	math.randomseed(seed)

	math.randomseed(seed)
	
	randomx = math.random() * 10
	roundx = round(randomx)
	number = rarity.value * 3
	number = number + roundx  -- 35 max 50
	number = number / 100

	
	return -number
end

function onInstalled(seed, rarity)
    addMultiplyableBias(StatsBonuses.ArbitraryTurrets, getNumTurrets(seed, rarity))
	addMultiplyableBias(StatsBonuses.HyperspaceReach, getHyperSpaceRange(seed, rarity))
	addBaseMultiplier(StatsBonuses.HyperspaceRechargeEnergy, getHyperspaceRechargeEnergy(seed, rarity))
end

function onUninstalled(seed, rarity)
end

function getName(seed, rarity)
    return "XSTN-K I"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key1.png"
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
        {ltext = "All Turrets", rtext = "+" .. getNumTurrets(seed, rarity), icon = "data/textures/icons/turret.png"},
		{ltext = "Jump Range", rtext =  "+" .. getHyperSpaceRange(seed, rarity), icon = "data/textures/icons/star-cycle.png"},
		{ltext = "Recharge Energy", rtext = (getHyperspaceRechargeEnergy(seed, rarity) * 100) .. "%", icon = "data/textures/icons/electric.png"}
    }
end

function getDescriptionLines(seed, rarity)
    return
    {
        {ltext = "This system has a vertical "%_t, rtext = "", icon = ""},
        {ltext = "scratch on its surface."%_t, rtext = "", icon = ""}
    }
end
