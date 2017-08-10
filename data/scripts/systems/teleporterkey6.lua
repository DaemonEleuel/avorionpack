package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- this key is dropped by the AI


function getNumTurrets(seed, rarity)
    math.randomseed(seed)
	
	number = rarity.value + 2 -- 7
    return number
end

function getShieldRecharge(seed, rarity)
    math.randomseed(seed)

	number = math.random(35, 45) -- 35 max 45
	number = number / 100

    return -number
end

function onInstalled(seed, rarity)
    addMultiplyableBias(StatsBonuses.ArbitraryTurrets, getNumTurrets(seed, rarity))
	addBaseMultiplier(StatsBonuses.ShieldRecharge, getShieldRecharge(seed, rarity))
end

function onUninstalled(seed, rarity)
end

function getName(seed, rarity)
    return "XSTN-K VI"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key6.png"
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
		{ltext = "Shield Recharge Rate", rtext = "+" .. (getShieldRecharge(seed, rarity) * -100) .. "%", icon = "data/textures/icons/zebra-shield.png"}
    }
end

function getDescriptionLines(seed, rarity)
    return
    {
        {ltext = "This system has 6 vertical "%_t, rtext = "", icon = ""},
        {ltext = "scratches on its surface."%_t, rtext = "", icon = ""}
    }
end
