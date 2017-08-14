package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- this key is sold by the travelling merchant

function getNumTurrets(seed, rarity)
    return math.max(3, rarity.value - 2)
end

function getCargoHold(seed, rarity)
	math.randomseed(seed)
	number = math.random (65, 75)  -- 65 max 75
	number = number / 100
	
    return number
end

function onInstalled(seed, rarity)
    addMultiplyableBias(StatsBonuses.ArmedTurrets, getNumTurrets(seed, rarity))
	addMultiplyableBias(StatsBonuses.UnarmedTurrets, getNumTurrets(seed, rarity))
	addBaseMultiplier(StatsBonuses.CargoHold, getCargoHold(seed, rarity))
	
end

function onUninstalled(seed, rarity)
end

function getName(seed, rarity)
    return "XSTN-K IV"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key4.png"
end

function getEnergy(seed, rarity)
    return 0
end

function getPrice(seed, rarity)
    return 3000000
end

function getTooltipLines(seed, rarity)
    return
    {
        {ltext = "Armed turrets", rtext = "+" .. getNumTurrets(seed, rarity), icon = "data/textures/icons/turret.png"},
		{ltext = "Unarmed turrets", rtext = "+" .. getNumTurrets(seed, rarity), icon = "data/textures/icons/turret.png"},
		{ltext = "Cargo Hold", rtext = "+" .. getCargoHold(seed, rarity) * 100 .. "%", icon = "data/textures/icons/wooden-crate.png"}
    }
end

function getDescriptionLines(seed, rarity)
    return
    {
        {ltext = "This system has 4 vertical "%_t, rtext = "", icon = ""},
        {ltext = "scratches on its surface."%_t, rtext = "", icon = ""}
    }
end
