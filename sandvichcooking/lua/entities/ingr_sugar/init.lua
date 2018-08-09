AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )

include("shared.lua")

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props/de_dust/hr_dust/dust_flour_sack/dust_flour_sack.mdl")
        self:SetColor(Color(255, 255, 255))
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end