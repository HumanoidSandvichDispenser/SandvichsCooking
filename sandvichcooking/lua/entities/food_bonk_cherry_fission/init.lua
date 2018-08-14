AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )

include("shared.lua")

if SERVER then
    util.AddNetworkString("playsound_client")    
end

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/weapons/c_models/c_energy_drink/c_energy_drink.mdl")
        // The default model is the RED team model, so SetSkin is not used
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
    net.Start("playsound_client")
    net.WriteString(self.UseSound)
    net.Send(Activator)
    self:Remove()
end