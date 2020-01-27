local spectable = {}
local posbefspec = {}

function speclogic(cmdply,ply)
    for i,v in ipairs(spectable) do
        if v.id == cmdply then
         table.remove(spectable,i)
         SetPlayerLocation(cmdply, posbefspec[i].x, posbefspec[i].y, posbefspec[i].z)
         table.remove(posbefspec,i)
        end
     end
     local x, y, z = GetPlayerLocation(cmdply)
        tblspecin = {}
        tblspecin.id = cmdply
        tblspecin.specid = ply
        table.insert(spectable,tblspecin)
        tblinsert = {}
        tblinsert.x = x
        tblinsert.y = y
        tblinsert.z = z
        table.insert(posbefspec,tblinsert)
        AddPlayerChat(cmdply,"You are spectating " .. GetPlayerName(ply))
        local x, y, z = GetPlayerLocation(ply)
        CallRemoteEvent(cmdply,"SpecRemoteEvent",true,ply,x,y,z)
end

AddCommand("spectate",function(cmdply,name,...)
    if GetPlayerVehicle(cmdply) == 0 then
    if (name ~= nil and name ~= "" and name ~= " ") then
    local first = name
    local varargs = false
        if #{...} ~= 0 then
            varargs = true
            name = table.concat({...}, " ")
    end 
    if varargs then
       name = first .. " " .. name
    end
       
    local found = false
    local itsme = false
    local alreadyspectating = false
    for i,ply in ipairs(GetAllPlayers()) do
        if GetPlayerName(ply)==name then
            if cmdply==ply then
                found=true
                itsme = true
            else
                local hmhalreadyspec = false
                for i,v in ipairs(spectable) do
                    if v.id == ply then
                     hmhalreadyspec=true
                    end
                 end
                if hmhalreadyspec==false then
                     found = true
                     speclogic(cmdply,ply)
                else
                    found = true
                   alreadyspectating=true
                end
            end
    end
    end
    if found == false then
       AddPlayerChat(cmdply,name .. " not found on the server")
    end
    if itsme then
        AddPlayerChat(cmdply,"You can't spectate yourself")
    end
    if alreadyspectating then
        AddPlayerChat(cmdply,"This player is spectating")
    end
else
    AddPlayerChat(cmdply,"/spectate <player name>")
end
else
    AddPlayerChat(cmdply,"Exit your vehicle to spectate someone")
end
end)

AddCommand("spectateid",function(cmdply,ply)
    if GetPlayerVehicle(cmdply) == 0 then
    if (ply~=nil and ply ~= "" and ply ~= " ") then
    ply=tonumber(ply)
    local found = false
    if cmdply~=ply then
        local hmhalreadyspec = false
        for i,v in ipairs(spectable) do
            if v.id == ply then
             hmhalreadyspec=true
            end
         end
    if hmhalreadyspec == false then
    for i,v in ipairs(GetAllPlayers()) do
    if v==ply then
        found=true
    speclogic(cmdply,ply)
    end
    end
    else
        AddPlayerChat(cmdply,"This player is spectating")
        found=true
    end
    else
        AddPlayerChat(cmdply,"You can't spectate yourself")
        found=true
    end
    if found==false then
        AddPlayerChat(cmdply,"id not found on the server")
    end
else
    AddPlayerChat(cmdply,"/spectateid <playerid>")
end
else
    AddPlayerChat(cmdply,"Exit your vehicle to spectate someone")
end
end)

AddEvent("OnPlayerQuit",function(ply)
    for i,v in ipairs(spectable) do
       if v.id == ply then
        table.remove(spectable,i)
        table.remove(posbefspec,i)
       end
    end
end)

AddRemoteEvent("NoLongerSpectating",function(ply)
    for i,v in ipairs(spectable) do
        if v.id == ply then
         table.remove(spectable,i)
         SetPlayerLocation(ply, posbefspec[i].x, posbefspec[i].y, posbefspec[i].z)
         table.remove(posbefspec,i)
        end
     end
end)

