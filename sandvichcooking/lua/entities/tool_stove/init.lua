AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )
util.AddNetworkString("vgui_show_stove")
util.AddNetworkString("stove_toggle")
util.AddNetworkString("stove_remove_item")
util.AddNetworkString("stove_update_3d2d")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_interiors/stove02.mdl")
    self:SetColor(Color(255, 255, 255))
    self:PhysicsInit(SOLID_VPHYSICS)
    --self:MoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.IsRunning = false
    self.ItemName = "Stove"
    self.Cooking = ""
    self.IsActivated = false
    self.Collectable = false
    self.Items = {
        [1] = "empty", 
        [2] = "empty",
        [3] = "empty"}
    self.ItemColors = {
        [1] = 0,
        [2] = 0,
        [3] = 0
    }
    self:SetVar("Activated", false)
    self.Temperature = 25
    self.FinishTime = 0

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:StartTouch(ent)
    local arrayFull = true
    for i = 1,3 do
        if self.Items[i] == "empty" then arrayFull = false end
    end
    if string.StartWith(ent:GetClass(), "ingr_") and not arrayFull and not self.IsActivated then
        //self.IsBeingUsed = true
        //self.FinishTime = self.FinishTime + ent.TargetTime
        if (self.Items[1] == "empty") then
            self.Items[1] = ent:GetClass()
            self.ItemColors[1] = ent.Rarity
        elseif (self.Items[2] == "empty") then
            self.Items[2] = ent:GetClass()
            self.ItemColors[2] = ent.Rarity
        elseif (self.Items[3] == "empty") then
            self.Items[3] = ent:GetClass()
            self.ItemColors[3] = ent.Rarity
        end
        ent:Remove()
    end
end

function ENT:Think()
    if self.IsActivated then
        self:SetColor(Color(255, 255 - self.Temperature, 255 - self.Temperature))
    else
        self:SetColor(Color(255, 255, 255))
    end

    if self.IsActivated and self.FinishTime <= CurTime() and self.FinishTime != 0 then

        net.Start("stove_update_3d2d")
        net.WriteEntity(StoveEntity)
        net.WriteBool(true)
        net.WriteFloat(-1)
        net.Broadcast()

        self.FinishTime = 0
        self.Collectable = true

    end
end

function ENT:Use(Activator, Caller)
    if self.Collectable then
        local food = ents.Create(self.Cooking)
        food:SetPos(Activator:EyePos() + Activator:GetAimVector() * 30)
        food:Spawn()

        net.Start("blender_update_3d2d")
        net.WriteEntity(StoveEntity)
        net.WriteBool(false)
        net.WriteFloat(0)
        net.Broadcast()
        self.Collectable = false
        self.IsActivated = false
    else
        net.Start('vgui_show_stove')
        net.WriteEntity(self)
        net.WriteBool(self.IsActivated)
        net.WriteTable(self.Items)
        net.WriteTable(self.ItemColors)
        net.WriteVector(self:GetPos())
        net.Send(Activator)
    end
end

function EndTime()

end

net.Receive("stove_toggle", function(len, ply)
    local StoveEntity = net.ReadEntity()
    ToggleStove(StoveEntity, ply)
end)

function ToggleStove(StoveEntity, ply)
    if not StoveEntity.IsActivated then
        print("[DEBUG] Turned on")
        local items = table.Copy(StoveEntity.Items)
        table.sort(items)
        local recipe = items[1] .. items[2] .. items[3] //concat all strings
        print("[DEBUG] Recipe: " .. recipe)
        local recipefound = true
        if (recipe == "emptyingr_doughingr_dough") then // Checks the recipe names based on alphabetical order, so it doesn't matter which slot the item is placed
            print("[DEBUG] Cooking Bread.")
            StoveEntity.FinishTime = CurTime() + 12
            StoveEntity.Cooking = "food_bread"
            StoveEntity:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav")
        elseif (recipe == "ingr_doughingr_eggingr_milk") then 
            print("[DEBUG] Cooking Pancakes.")
            StoveEntity.FinishTime = CurTime() + 15
            StoveEntity.Cooking = "food_pancakes"
            StoveEntity:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav")
        elseif (recipe == "emptyemptyingr_dough") then
            print("[DEBUG] Cooking Bagels.")
            StoveEntity.FinishTime = CurTime() + 10
            StoveEntity.Cooking = "food_bagel"
            StoveEntity:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav")
        elseif (recipe == "emptyingr_eggingr_oil") then
            print("[DEBUG] Cooking Bagels.")
            StoveEntity.FinishTime = CurTime() + 8
            StoveEntity.Cooking = "food_friedegg"
            StoveEntity:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav")
        else recipefound = false
        end
        if recipefound then
            StoveEntity.IsActivated = true
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity.ItemColors = {0, 0, 0}
            net.Start("stove_update_3d2d")
            net.WriteEntity(StoveEntity)
            net.WriteBool(true)
            net.WriteFloat(StoveEntity.FinishTime)
            net.Broadcast()
        end
    end
end

net.Receive("stove_remove_item", function(len, ply) // Removing item from stove
    local RemovedEntity = net.ReadString()
    local Stove = net.ReadEntity()
    local Index = net.ReadInt(4)
    Stove.Items[Index] = "empty" // Clears the selected item inside the stove being used
    Stove.ItemColors[Index] = 0
    local newent = ents.Create(RemovedEntity)
    newent:SetPos(ply:EyePos() + ply:GetAimVector() * 30)
    newent:Spawn()
end)