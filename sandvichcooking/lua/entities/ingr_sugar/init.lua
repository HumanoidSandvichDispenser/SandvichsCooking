AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props/de_dust/hr_dust/dust_flour_sack/dust_flour_sack.mdl")
    self:SetColor(Color(255, 255, 255))
    self:PhysicsInit(SOLID_VPHYSICS)
    --self:MoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self.IsRunning = false
    self.TargetTime = 8
    self.ItemName = "Sugar"
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end