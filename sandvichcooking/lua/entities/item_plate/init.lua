AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )

include("shared.lua")



function ENT:Initialize()
    if SERVER then
        self:SetModel("models/foodnhouseholditems/servingplate.mdl")
        self:SetColor(Color(245, 225, 225))
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.IsActivated = false
    end

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Touch(ent)
    if self.IsActivated and (string.StartWith(ent:GetClass(), "food_")) and self.DisableTime != 0 then
        if (ent:GetPos().z > self:GetPos().z) then
            ent:SetParent(self) end// This would attach any food entity that touches it to the plate
    end
end

function ENT:Use()
    self.IsActivated = not self.IsActivated
    if self.IsActivated then
        self:SetColor(Color(255, 255, 255))
    else
        self:SetColor(Color(245, 225, 225))
        if table.Count(self:GetChildren()) != 0 then // This checks to see if this entity contains any children
            for i, child in pairs(self:GetChildren()) do
                child:GetPhysicsObject():EnableMotion(false) // Freezes children before unparenting them
                child:SetParent(NULL) // Unparents all children, so players can separate the food item(s) and the plate
            end 
        end
    end
end