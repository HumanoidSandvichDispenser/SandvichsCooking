AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/foodnhouseholditems/bagel1.mdl")
    self:SetColor(Color(255, 255, 255))
    self:PhysicsInit(SOLID_VPHYSICS)
    //self:MoveType(MOVETYPE_VPHYSICS) .. TIL that double shash comments are a thing in lua
    self:SetSolid(SOLID_VPHYSICS)
    self.IsRunning = false
    self.Quality = 8
    self.ItemName = "Bagel"

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(Activator, Caller)
    Caller:SetHealth(Caller:Health() + self.Quality)
    self:Remove()
end