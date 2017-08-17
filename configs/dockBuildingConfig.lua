--Contains the configuration for stations that could be implemented.
--Name = Name of the stations
--Costs = Amount the player/alliance will have to pay
--Volume = Minimum volume for the ship founding the station (volume is volume in-game/1000)
--Scripts = Configures which options the player will have when interacting with the station
Scriptables = {
    equipmentDock = {
                    name = "Equipment Dock"%_t,
                    costs = 50000000 --[[50 mil]],
					volume = 200,
                    scripts = {"data/scripts/entity/merchants/equipmentdock.lua",
                               "data/scripts/entity/merchants/turretmerchant.lua",
                               "data/scripts/entity/merchants/fightermerchant.lua"}
                    },
    turretFactory = {
                    name = "Turret Factory"%_t, 
                    costs = 40000000 --[[40 mil]], 
					volume = 200,
                    scripts = {"data/scripts/entity/merchants/turretfactory.lua"}
                    },
    researchStation ={
                      name = "Research Station"%_t, 
                      costs = 50000000 --[[50 mil]], 
					  volume = 200,
                      scripts = {"data/scripts/entity/merchants/researchstation.lua"} 
                      },
    repairDock =    {
                    name = "Repair Dock"%_t, 
                    costs = 30000000 --[[30 mil]], 
					volume = 200,
                    scripts = {"data/scripts/entity/merchants/repairdock.lua"} 
                    },
	shipyard =    {
                    name = "Shipyard"%_t, 
                    costs = 50000000 --[[50 mil]], 
					volume = 200,
                    scripts = {"data/scripts/entity/merchants/shipyard.lua"} 														   
                    },
	resourcetrader =    {
                    name = "Resource Trader"%_t, 
                    costs = 35000000 --[[50 mil]], 
					volume = 200,
                    scripts = {"data/scripts/entity/merchants/resourcetrader.lua"} 														   
                    },
	citadel ={
					name = "Citadel"%_t, 
                    costs = 200000000 --[[200 mil]], 
					volume = 500,
                    scripts = {"data/scripts/entity/merchants/equipmentdock.lua",
                               "data/scripts/entity/merchants/turretmerchant.lua",
							   "data/scripts/entity/merchants/fightermerchant.lua",
							   "data/scripts/entity/merchants/repairdock.lua",
							   "data/scripts/entity/merchants/turretfactory.lua",
							   "data/scripts/entity/merchants/researchstation.lua",
							   "data/scripts/entity/merchants/resourcetrader.lua",
							   "data/scripts/entity/merchants/shipyard.lua"}
					}
}