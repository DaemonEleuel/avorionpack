package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- this key is dropped by the 4

function getNumTurrets(seed, rarity)
    math.randomseed(seed)
	
	rarityx = rarity.value
	number = rarityx + 1 -- 6
	
    return number
end

function getShieldDurab(seed, rarity)
    math.randomseed(seed)
	
	number = math.random(60, 80)  -- 60 max 80
	number = number / 100

    return number
end


function onInstalled(seed, rarity)
	addMultiplyableBias(StatsBonuses.ArmedTurrets, getNumTurrets(seed, rarity))
	addMultiplyableBias(StatsBonuses.UnarmedTurrets, getNumTurrets(seed, rarity))
	addBaseMultiplier(StatsBonuses.ShieldDurability, getShieldDurab(seed, rarity))
end

function onUninstalled(seed, rarity)
end

function getName(seed, rarity)
    return "XSTN-K V"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key5.png"
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
		{ltext = "Shield Durability", rtext = "+" .. (getShieldDurab(seed, rarity) * 100) .. "%", icon = "data/textures/icons/health-normal.png"}
    }
end

function getDescriptionLines(seed, rarity)
    return
    {
        {ltext = "This system has 5 vertical "%_t, rtext = "", icon = ""},
        {ltext = "scratches on its surface."%_t, rtext = "", icon = ""}
    }
end
