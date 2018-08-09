AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )

include("shared.lua")

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/weapons/c_models/c_energy_drink/c_energy_drink.mdl")
        self:SetSkin(1)
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

function ENT:Use(Activator, Caller)
    Caller:SetHealth(Caller:Health() + self.Quality)
    self:Remove()
end