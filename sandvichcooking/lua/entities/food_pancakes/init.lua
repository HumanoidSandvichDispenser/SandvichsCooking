AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/foodnhouseholditems/pancakes.mdl")
    self:SetColor(Color(255, 255, 255))
    self:PhysicsInit(SOLID_VPHYSICS)
    //self:MoveType(MOVETYPE_VPHYSICS) .. TIL that double shash comments are a thing in lua
    self:SetSolid(SOLID_VPHYSICS)
    self.IsRunning = false
    self.Quality = 15
    self.ItemName = "Pancakes"

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(Activator, Caller)
    Caller:SetHealth(Caller:Health() + self.Quality)
    self:Remove()
end