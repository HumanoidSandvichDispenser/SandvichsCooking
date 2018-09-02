AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )

include("shared.lua")
include("../../templates/containerpanel.lua")

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_c17/metalpot001a.mdl")
        self:SetColor(Color(245, 225, 225))
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.IsActivated = false

        self.Items = {
        [1] = "empty",
        [2] = "empty",
        [3] = "empty"}
        self.ItemColors = {
            [1] = 0,
            [2] = 0,
            [3] = 0
        }
        self:CallOnRemove("RemoveSelfTable", RemoveItems)
    end

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self.Collectable = false
    self.IsActivated = false
end