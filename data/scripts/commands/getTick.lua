package.path = package.path .. ";data/scripts/lib/?.lua"
<<<<<<< HEAD
OOSPVERSION = "[0.9_91]"  
=======
OOSPVERSION = "[0.9_9]"  
>>>>>>> 4e97886bf91c26c8d19d8db7ae9a5d71e5223ec1
function execute(sender, commandName, ...)
    Player(sender):sendChatMessage("Server", 3, tostring(Server():getValue("online_time")))
    return 0, "", ""
end

function getDescription()
    return "Gives back the current Tickvalue."
end

function getHelp()
    return "/getTick "
end
