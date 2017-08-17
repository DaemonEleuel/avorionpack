package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- this key is researched at the research station

function getNumTurrets(seed, rarity)
    return math.max(1, rarity.value + 1)
end

function getRadarReach(seed, rarity)
    math.randomseed(seed)
	
    return math.max(1, rarity.value + getInt(1, 3))
end

function getHiddenSecRadReach(seed, rarity)
    math.randomseed(seed)
	
	randomx = math.random() * 2
	roundx = round(randomx)
	number = rarity.value + roundx
	
    return number
end

function getScannerReach(seed, rarity)
    math.randomseed(seed)
	
	math.randomseed(seed)
	
	randomx = math.random() * 20
	roundx = round(randomx)
	number = rarity.value * 26
	number = number + roundx  -- 130 max 150
	number = number / 100

	
    return number
end

function onInstalled(seed, rarity)
    addMultiplyableBias(StatsBonuses.ArmedTurrets, getNumTurrets(seed, rarity))
	addMultiplyableBias(StatsBonuses.UnarmedTurrets, getNumTurrets(seed, rarity))
	addMultiplyableBias(StatsBonuses.RadarReach, getRadarReach(seed, rarity))
    addMultiplyableBias(StatsBonuses.HiddenSectorRadarReach, getHiddenSecRadReach(seed, rarity))
	addBaseMultiplier(StatsBonuses.ScannerReach, getScannerReach(seed, rarity))
end

function onUninstalled(seed, rarity)
end

function getName(seed, rarity)
    return "XSTN-K II"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key2.png"
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
		{ltext = "Radar Range", rtext = "+" .. getRadarReach(seed, rarity), icon = "data/textures/icons/turret.png"},
		{ltext = "Deep Scan Range", rtext = "+" .. getHiddenSecRadReach(seed, rarity), icon = "data/textures/icons/turret.png"},
		{ltext = "Scanner Range", rtext = "+" .. (getScannerReach(seed, rarity) * 100) .. "%", icon = "data/textures/icons/electric.png"}
    }
end

function getDescriptionLines(seed, rarity)
    return
    {
        {ltext = "This system has 2 vertical "%_t, rtext = "", icon = ""},
        {ltext = "scratches on its surface."%_t, rtext = "", icon = ""}
    }
end
