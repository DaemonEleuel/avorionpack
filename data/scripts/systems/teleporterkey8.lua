package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- this key is dropped by the smuggler

function getNumTurrets(seed, rarity)
    return math.max(1, rarity.value + 6)
end

function getHyperRecharge(seed, rarity)

    math.randomseed(seed)
	randomx = getInt(0, 9)
	number = rarity.value * 8
	number = number + randomx --40 max 49
	number = number / 100
	
    return -number
	
end

function getVelocity(seed, rarity)
	math.randomseed(seed)

	randomx = math.random() * 15
	roundx = round(randomx)
	number = rarity.value * 4
	number = number + roundx  -- 15 max 30
	number = number / 100

    return number
end	

function onInstalled(seed, rarity)

    addMultiplyableBias(StatsBonuses.ArbitraryTurrets, getNumTurrets(seed, rarity))
	addBaseMultiplier(StatsBonuses.HyperspaceCooldown, getHyperRecharge(seed, rarity))
	addBaseMultiplier(StatsBonuses.Velocity, getVelocity(seed, rarity))
end

function onUninstalled(seed, rarity)
end

function getName(seed, rarity)
    return "XSTN-K VIII"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key8.png"
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
		{ltext = "Hyperspace Cooldown", rtext = (getHyperRecharge(seed, rarity) * 100) .. "%", icon = "data/textures/icons/hourglass.png"},
		{ltext = "Velocity", rtext = "+" .. (getVelocity(seed, rarity) * 100) .. "%", icon = "data/textures/icons/lucifer-cannon.png"}
    }
end

function getDescriptionLines(seed, rarity)
    return
    {
        {ltext = "This system has 8 vertical "%_t, rtext = "", icon = ""},
        {ltext = "scratches on its surface."%_t, rtext = "", icon = ""}
    }
end
