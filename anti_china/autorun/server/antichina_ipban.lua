-- Anti-China IP Ban
-- Automatically bans players connecting from Chinese IP ranges
-- Supports ULX, sAdmin, fAdmin, and SAM

AddCSLuaFile("antichina/sh_detectadmin.lua")
include("antichina/sh_detectadmin.lua")

if SERVER then
    resource.AddFile("lua/antichina/cnip-cidr.txt")
    include("antichina/sv_ipcheck.lua")
end