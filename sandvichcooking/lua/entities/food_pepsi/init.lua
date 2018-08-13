AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )

include("shared.lua")

if SERVER then
    util.AddNetworkString("playsound_client")
end

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/foodnhouseholditems/sodacan04.mdl")
        self:SetColor(Color(255, 255, 255))
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.DamageTaken = 0
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
    if (self.DamageTaken > 50) then
        local plutonium = ents.Create("ingr_plutonium-239")
        plutonium:SetPos(Activator:EyePos() + Activator:GetAimVector() * 30)
        plutonium:Spawn()
    end
    self:Remove()
end

function ENT:OnTakeDamage(damage)
    self.DamageTaken = self.DamageTaken + damage:GetDamage()
end