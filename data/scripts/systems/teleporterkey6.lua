package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- this key is dropped by the AI


function getNumTurrets(seed, rarity)
    math.randomseed(seed)
	
	randomx = getInt(1, 4)
	rarityx = rarity.value + 2
	number = rarityx + randomx -- 7 max 11
	
    return number + 6
end

function getShieldRecharge(seed, rarity)
    math.randomseed(seed)
	
	randomx = math.random() * 10 
	roundx = round(randomx)
	number = rarity.value * 8
	number = number + roundx -- 40 max 50
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
