ANTICHINA_CONFIG = {
    BanDuration = 0,            -- 0 = permanent ban (minutes)
    BanReason = "自动封禁: 您的IP属于受限区域", -- Custom ban message
    LogFile = "antichina_bans.log", -- Log file name
    KickInstead = false,        -- true = kick instead of ban
    CheckInterval = 5,          -- Re-check CIDR file every X minutes (0=disabled)
    DebugMode = false           -- Enable debug logging
}