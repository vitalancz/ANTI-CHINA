-- Load CIDR ranges from file
local chineseCIDRs = {}

-- Function to load CIDR ranges
local function LoadCIDRList()
    local filePath = "lua/antichina/cnip-cidr.txt"
    if file.Exists(filePath, "GAME") then
        local fileContents = file.Read(filePath, "GAME")
        if fileContents then
            for line in fileContents:gmatch("[^\r\n]+") do
                -- Skip empty lines and comments
                if line and line ~= "" and not line:match("^%s*#") then
                    -- Clean up any whitespace
                    local cidr = line:match("^%s*(.-)%s*$")
                    if cidr ~= "" then
                        table.insert(chineseCIDRs, cidr)
                    end
                end
            end
            print("[Anti-China] Loaded " .. #chineseCIDRs .. " Chinese CIDR ranges")
        else
            print("[Anti-China] Failed to read CIDR file")
        end
    else
        print("[Anti-China] CIDR file not found: " .. filePath)
    end
end

-- IP in CIDR check function
local function ip_in_cidr(ip, cidr)
    local cidr_ip, cidr_bits = cidr:match("^(.-)/(%d+)$")
    if not cidr_ip or not cidr_bits then return false end
    
    cidr_bits = tonumber(cidr_bits)
    if not cidr_bits then return false end
    
    local function ip_to_binary(ip)
        local binary = ""
        for octet in ip:gmatch("%d+") do
            binary = binary .. string.format("%08b", tonumber(octet))
        end
        return binary
    end
    
    local ip_binary = ip_to_binary(ip)
    local cidr_binary = ip_to_binary(cidr_ip)
    
    return ip_binary:sub(1, cidr_bits) == cidr_binary:sub(1, cidr_bits)
end

-- Check if IP is Chinese
local function IsChineseIP(ip)
    for _, cidr in ipairs(chineseCIDRs) do
        if ip_in_cidr(ip, cidr) then
            return true
        end
    end
    return false
end

-- Load CIDRs when starting
LoadCIDRList()

-- Player connection handler
hook.Add("PlayerInitialSpawn", "AntiChina_CheckPlayerIP", function(ply)
    if ply:IsBot() then return end  -- Ignore bots
    local ip = string.Explode(":", ply:IPAddress())[1]  -- Get player IP (without port)

    if IsChineseIP(ip) then
        local steamid = ply:SteamID()
        local name = ply:Nick()
        
        print("[Anti-China] Banning " .. name .. " (" .. steamid .. ", " .. ip .. ") from China.")
        AntiChina_BanPlayer(ply, 0, "Banned: Connecting from China")
        
        -- Log to server console and file
        local logMsg = os.date("[%Y-%m-%d %H:%M:%S] ") .. "Banned " .. name .. " (" .. steamid .. ", " .. ip .. ") from China."
        print(logMsg)
        file.Append("antichina_bans.txt", logMsg .. "\n")
    end
end)