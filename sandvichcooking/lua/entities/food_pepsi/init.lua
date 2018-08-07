AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/foodnhouseholditems/sodacan04.mdl")
    self:SetColor(Color(255, 255, 255))
    self:PhysicsInit(SOLID_VPHYSICS)
    //self:MoveType(MOVETYPE_VPHYSICS) .. TIL that double shash comments are a thing in lua
    self:SetSolid(SOLID_VPHYSICS)
    self.IsRunning = false
    self.Quality = 5
    self.ItemName = "Pepsi"

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(Activator, Caller)
    local plutonium = ents.Create("ingr_plutonium-239")
    plutonium:SetPos(Activator:EyePos() + Activator:GetAimVector() * 30)
    plutonium:Spawn()
    Caller:SetHealth(Caller:Health() + self.Quality)
    self:Remove()
end