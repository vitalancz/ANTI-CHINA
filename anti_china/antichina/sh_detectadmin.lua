local adminSystem = "unknown"

-- Detect which admin mod is installed
if ULib and ULib.bans then
    adminSystem = "ulx"
elseif sam and sam.player then
    adminSystem = "sam"
elseif FAdmin and FAdmin.BAN then
    adminSystem = "fadmin"
elseif sAdmin then
    adminSystem = "sadmin"
end

-- Ban function that works with any supported admin system
function AntiChina_BanPlayer(ply, duration, reason)
    duration = duration or 0 -- 0 = permanent
    reason = reason or "Banned: Connecting from China"

    if adminSystem == "ulx" then
        ULib.ban(ply, duration, reason)
    elseif adminSystem == "sam" then
        sam.player.ban(ply, duration, reason, "Anti-China IP Ban")
    elseif adminSystem == "fadmin" then
        FAdmin.BAN.DoBan(ply, duration, reason)
    elseif adminSystem == "sadmin" then
        sAdmin.Ban(ply:SteamID(), duration, reason)
    else
        -- Fallback to simple kick if no admin system found
        ply:Kick(reason)
    end
end