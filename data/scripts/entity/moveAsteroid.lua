package.path = package.path .. ";data/scripts/lib/?.lua"
package.path = package.path .. ";data/scripts/entity/?.lua"

require ("utility")
require ("stringutility")
MONEY_PER_JUMP = 500000         --change to your needs
CALLDISTANCE = 1000             --10Km is 1.000 not 10.000. Who made this up ?

-- do not touch
MOD = "[mOS]"
VERSION = "[0.91] "          
MSSN = "isMarkedToMove"   --MoveStatuSaveName, gives the movestatus false,nil for not moving. true for needs to be moved
local window
local payButton

--is the player that tries to interact also the owner? Are we close enough? then return true.
function interactionPossible(playerIndex, option)
    local player = Player(playerIndex)
    local this = Entity()
    if this.factionIndex == player.index then
        if Entity():getValue(MSSN) == nil then 
            unregisterAsteroid()
        end

        local craft = player.craft
        if craft == nil then return false end

        local dist = craft:getNearestDistance(this)

        if dist < CALLDISTANCE then                                            
            return true
        end
    end
    return false
end

function initUI()
    print(MOD..VERSION.."UI start")
    local res = getResolution()
    local size = vec2(500, 300)

    local menu = ScriptUI()
    window = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))
    if Entity():getValue(MSSN) then
        window.caption = "Configure Movement of " --.. Entity().index.value
    else
        window.caption = "Move Asteroid " --.. Entity().index.value
    end
    window.showCloseButton = 1
    window.moveable = 1
    window.closeableWithEscape = true
    
    window:createLabel(vec2(50, 10), "You will need "..createMonetaryString(MONEY_PER_JUMP).."Cr to jump this Asteroid.", 15)
    --botton pay
    payButton = window:createButton(Rect(50, 200, 200, 30 + 200 ), "  Pay  ", "onPayPressed")
    if Entity():getValue(MSSN) then                         
        payButton.active = false
    end
    payButton.maxTextSize = 15
    
    --button abort
    local cancelBbutton = window:createButton(Rect(300, 200, 450, 30 + 200 ), " cancel Movement ", "onCancelPressed")
    cancelBbutton.maxTextSize = 15
    
    menu:registerWindow(window, "Move Asteroid");
end

function prepUI()
    window.visible = false
    if Entity():getValue(MSSN) == true then
        window.caption = "Configure Movement of " --.. Entity().index.value
        payButton.active = false
        payButton.tooltip = "Already payed"
    else
        window.caption = "Move Asteroid " --.. Entity().index.value
        payButton.active = true
        payButton.tooltip = "No refunds!"
    end
end


--playerIndex only available on Server
function onCancelPressed(playerIndex)
    if (onClient())then
        invokeServerFunction("onCancelPressed",Player().index)
        print(MOD..VERSION.."Cancel Pressed ")
        unregisterAsteroid()
        prepUI()
        return
    end
    --reenable the other two options
    local scripts = Entity():getScripts()   
    local minefounderRunning = false
    local sellobjectRunning = false

    unregisterAsteroid()
    
    print(MOD..VERSION.."active Asteroid Movement cancelled on: ", Entity().index.value)
end

function onPayPressed()
    if (onClient())then
        registerAsteroid()
        invokeServerFunction("server_onPayPressed",Player().index)
        print(MOD..VERSION.."Pay Pressed ")
        prepUI()
        return
    else 
        print(MOD..VERSION.."Pay Pressed on Server")
    end
    
end

function server_onPayPressed(playerIndex)
    local player = Player(playerIndex)
    if player.name ~= Player().name then                --wrong player called
        print(MOD..VERSION.."Pay pressed server answer by wrong player:".. Player().name .. " | from: " ..Player(playerIndex).name )
        return
    end

    local isMarkedToMove = Entity():getValue(MSSN)
    local canPay, msg, args = player:canPay(MONEY_PER_JUMP)
    
    if canPay and (isMarkedToMove == false or isMarkedToMove == nil) then
        player:payMoney(MONEY_PER_JUMP)      
        registerAsteroid()
        print(MOD..VERSION..tostring(Player(playerIndex).name).." payed for Asteroid moving")
    else
        player:sendChatMessage("Asteroid", 1, msg,unpack(args))
        return
    end
end

function registerAsteroid()
    Entity():setValue(MSSN,true)
    if onServer() then
        local scripts = Entity():getScripts()   
        local minefounderRunning = false
        local sellobjectRunning = false
        for _,script in pairs(scripts) do
            if script == "data/scripts/entity/minefounder.lua" then
                minefounderRunning = true
            end
            if script == "data/scripts/entity/sellobject.lua" then
                sellobjectRunning = true
            end
        end
        if minefounderRunning == true then
            Entity():removeScript("data/scripts/entity/minefounder.lua")
        end
        if sellobjectRunning == true then
            Entity():removeScript("data/scripts/entity/sellobject.lua")
        end 
    end
end

function unregisterAsteroid()

    Entity():setValue(MSSN,false)
    if onServer() then
        local scripts = Entity():getScripts()   
        local minefounderRunning = false
        local sellobjectRunning = false
        for _,script in pairs(scripts) do
            if script == "data/scripts/entity/minefounder.lua" then
                minefounderRunning = true
            end
            if script == "data/scripts/entity/sellobject.lua" then
                sellobjectRunning = true
            end
        end
        if minefounderRunning == false then
            Entity():addScript("data/scripts/entity/minefounder.lua")
        end
        if sellobjectRunning == false then
            Entity():addScript("data/scripts/entity/sellobject.lua")
        end 
    end
end