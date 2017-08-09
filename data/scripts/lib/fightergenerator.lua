package.path = package.path .. ";data/scripts/lib/?.lua"

require ("galaxy")
require ("randomext")

local rand = random()

local FighterGenerator =  {}

function FighterGenerator.initialize(seed)
    if seed then
        rand = Random(seed)
    end
end

function FighterGenerator.generate(x, y, offset_in, rarity_in, type_in, material_in) -- server

    local offset = offset_in or 0
    local seed = rand:createSeed()
    local dps = 0
    local sector = math.floor(length(vec2(x, y))) + offset

    local weaponDPS, weaponTech = Balancing_GetSectorWeaponDPS(sector, 0)
    local miningDPS, miningTech = Balancing_GetSectorMiningDPS(sector, 0)
    local materialProbabilities = Balancing_GetMaterialProbability(sector, 0)
    local material = material_in or Material(getValueFromDistribution(materialProbabilities))
    local weaponType = type_in or getValueFromDistribution(Balancing_GetWeaponProbability(sector, 0))

    local tech = 0
    if weaponType == WeaponType.MiningLaser then
        dps = miningDPS
        tech = miningTech
    elseif weaponType == WeaponType.ForceGun then
        dps = random():getFloat(800, 1200); -- force
        tech = weaponTech
    else
        dps = weaponDPS
        tech = weaponTech
    end

    local rarities = {}
    rarities[5] = 0.2 -- legendary
    rarities[4] = 1 -- exotic
    rarities[3] = 4 -- exceptional
    rarities[2] = 8 -- rare
    rarities[1] = 16 -- uncommon
    rarities[0] = 64 -- common

    local rarity = rarity_in or Rarity(getValueFromDistribution(rarities))

local template = GenerateFighterTemplate(seed, weaponType, dps, tech, rarity, material)
	
	local weapons = {template:getWeapons()}
    template:clearWeapons()
    for _, weapon in pairs(weapons) do
        -- give the weak weapons some more punch
        if weaponType == WeaponType.ChainGun then
            weapon.damage = weapon.damage * 3
        elseif weaponType == WeaponType.Bolter then  
            weapon.damage = weapon.damage * 5
		elseif weaponType == WeaponType.PlasmaGun then  
            weapon.damage = weapon.damage * 10
		elseif weaponType == WeaponType.RailGun then  
            weapon.damage = weapon.damage * 5
		elseif weaponType == WeaponType.SalvagingLaser then  
				weapon.reach = weapon.isBeam and weapon.blength * 4 or weapon.pvelocity*weapon.pmaximumTime
				weapon.blockPenetration = weapon.blockPenetration + 6
		elseif weaponType == WeaponType.MiningLaser then
				weapon.blength = weapon.blength * 4
				weapon.reach = weapon.blength
        end
    template:addWeapon(weapon)
    end

	local myMaterial = string.format("%s", template.material)
	local healthFactor = 0.45
		if myMaterial == "Titanium" then
            healthFactor = 0.6
        elseif myMaterial == "Naonite" then  
            healthFactor = 1
        elseif myMaterial == "Trinium" then  
            healthFactor = 1.5
        elseif myMaterial == "Xanion" then  
            healthFactor = 2.25
        elseif myMaterial == "Ogonite" then  
            healthFactor = 3.375
        elseif myMaterial == "Avorion" then  
            healthFactor = 5.1
        end
	
	healthFactor = healthFactor * 2
	local minDurability = 50 * template.diameter
	template.maxVelocity = template.maxVelocity * 3
	template.durability = minDurability + template.durability
	template.durability = template.durability * healthFactor
	template.crew = 1
		if myMaterial == "Iron" then
            template.shield = 0
        elseif myMaterial == "Titanium" then  
            template.shield = 0
        elseif myMaterial == "Naonite" then  
            template.shield = template.durability
        elseif myMaterial == "Trinium" then  
            template.shield = template.durability
        elseif myMaterial == "Xanion" then  
            template.shield = template.durability
        elseif myMaterial == "Ogonite" then  
            template.shield = template.durability
        elseif myMaterial == "Avorion" then  
            template.shield = template.durability
        end
	
    return template 
end

function FighterGenerator.generateArmed(x, y, offset_in, rarity_in, material_in) -- server

    local offset = offset_in or 0
    local sector = math.floor(length(vec2(x, y))) + offset
    local types = Balancing_GetWeaponProbability(sector, 0)

    types[WeaponType.RepairBeam] = nil
    types[WeaponType.MiningLaser] = nil
    types[WeaponType.SalvagingLaser] = nil
    types[WeaponType.ForceGun] = nil

    local weaponType = getValueFromDistribution(types)

    local template = GenerateFighterTemplate(seed, weaponType, dps, tech, rarity, material)
	
	local weapons = {template:getWeapons()}
    template:clearWeapons()
    for _, weapon in pairs(weapons) do
        -- give the weak weapons some more punch
        if weaponType == WeaponType.ChainGun then
            weapon.damage = weapon.damage * 5
        elseif weaponType == WeaponType.Bolter then  
            weapon.damage = weapon.damage * 5
		elseif weaponType == WeaponType.PlasmaGun then  
            weapon.damage = weapon.damage * 10
		elseif weaponType == WeaponType.RailGun then  
            weapon.damage = weapon.damage * 5
        end
    template:addWeapon(weapon)
    end

	local myMaterial = string.format("%s", template.material)
	local healthFactor = 0.45
		if myMaterial == "Titanium" then
            healthFactor = 0.6
        elseif myMaterial == "Naonite" then  
            healthFactor = 1
        elseif myMaterial == "Trinium" then  
            healthFactor = 1.5
        elseif myMaterial == "Xanion" then  
            healthFactor = 2.25
        elseif myMaterial == "Ogonite" then  
            healthFactor = 3.375
        elseif myMaterial == "Avorion" then  
            healthFactor = 5.1
        end
	
	healthFactor = healthFactor * 2.5
	local minDurability = 50 * template.diameter
	template.maxVelocity = template.maxVelocity * 4
	template.durability = minDurability + template.durability
	template.durability = template.durability * healthFactor
	template.crew = 1
		if myMaterial == "Iron" then
            template.shield = 0
        elseif myMaterial == "Titanium" then  
            template.shield = 0
        elseif myMaterial == "Naonite" then  
            template.shield = template.durability
        elseif myMaterial == "Trinium" then  
            template.shield = template.durability
        elseif myMaterial == "Xanion" then  
            template.shield = template.durability
        elseif myMaterial == "Ogonite" then  
            template.shield = template.durability
        elseif myMaterial == "Avorion" then  
            template.shield = template.durability
        end
	
    return template
end

return FighterGenerator
