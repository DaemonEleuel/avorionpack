
package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("randomext")

-- Robotic Crew

function getEngineers(seed, rarity)
    math.randomseed(seed)
		local rarityx = rarity.value + 1
		local randomx = getInt(1, 50)
		if rarity.value < 5 then
			number = (20 + rarityx * 35 + randomx) * 0.79
		return number
		else
			number = (rarityx * 60 + randomx * 3) * 0.79
		return number
		end
end

function getMechanics(seed, rarity)
	math.randomseed(seed)
		local rarityx = rarity.value + 1
		local randomx = getInt(1, 50)
		if rarity.value < 5 then
			number = 20 + rarityx * 35 + randomx
		return number
		else
			number = rarityx * 60 + randomx * 3
		return number
		end
end

function getWeapon(seed, rarity)
	math.randomseed(seed)
		local rarityx = rarity.value + 1
		local randomx = getInt(1, 25)
		if rarity.value < 5 then
			number = 10 + rarityx * 7 + randomx
		return number
		else
			number = rarityx * 15 + randomx
		return number
		end
end

function onInstalled(seed, rarity)
	math.randomseed(seed)

	addMultiplyableBias(StatsBonuses.Engineers, getEngineers(seed, rarity))
	addMultiplyableBias(StatsBonuses.Mechanics, getMechanics(seed, rarity))
	if math.random() >= 0. then
		addMultiplyableBias(StatsBonuses.Miners, getWeapon(seed, rarity))
	else
		addMultiplyableBias(StatsBonuses.Gunners, getWeapon(seed, rarity))
	end
	
end


function onUninstalled(seed, rarity)
end

function getName(seed, rarity)
    return "Robotic Crew"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/backup.png"
end

function getEnergy(seed, rarity)
	math.randomseed(seed)
	
    local num = getMechanics(seed, rarity) + getEngineers(seed, rarity) + getWeapon(seed, rarity)
	if math.random() > 0.05 then
		return num * 75 * 1000 * 600 / 2 * (1.1 ^ (rarity.value + 1))
		else
		return 0
		end
end

function getPrice(seed, rarity)
	math.randomseed(seed)
	
    local num = getMechanics(seed, rarity) + getEngineers(seed, rarity)
    local price = 253 * num;
	if math.random() > 0.05 then
	return price * 2.5 ^ rarity.value
	else
    return price * 4.5 ^ rarity.value
	end
end
 

function getTooltipLines(seed, rarity)
	math.randomseed(seed)
	local texts = {}
	
	local rand = math.random()
	local eng = getEngineers(seed, rarity)
	local mech = getMechanics(seed, rarity)
	local wep = getWeapon(seed, rarity)

		table.insert(texts, {ltext = "Engineer Workforce"%_t, rtext = string.format("%i", eng), icon = "data/textures/icons/gear-hammer.png"})
		table.insert(texts, {ltext = "Mechanic Workforce"%_t, rtext = string.format("%i", mech), icon = "data/textures/icons/tinker.png"})
	
	if rand >= 0.5 then
		table.insert(texts, {ltext = "Miner Workforce"%_t, rtext = string.format("%i", wep), icon = "data/textures/icons/drill.png"})
	else
		table.insert(texts, {ltext = "Gunner Workforce"%_t, rtext = string.format("%i", wep), icon = "data/textures/icons/reticule.png"})
	end

	return texts
end

function getDescriptionLines(seed, rarity)
    return
    {
        {ltext = "Adding Bonus to Workforce "%_t, rtext = "", icon = ""}
    }
end
