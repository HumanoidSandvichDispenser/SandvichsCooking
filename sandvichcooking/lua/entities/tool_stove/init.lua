AddCSLuaFile("shared.lua")
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
    self.IsBeingUsed = false
    self.Items = {
        [1] = "empty", 
        [2] = "empty",
        [3] = "empty"}
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
        elseif (self.Items[2] == "empty") then
            self.Items[2] = ent:GetClass()
        elseif (self.Items[3] == "empty") then
            self.Items[3] = ent:GetClass()
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
        net.WriteBool(false)
        net.WriteInt(self.FinishTime, 8)
        net.Broadcast()

        print(self.FinishTime)
        self.IsActivated = false
        self.FinishTime = 0
        local food = ents.Create(self.Cooking)
        food:SetPos(self:GetPos() + Vector(0, 0, 75))
        food:Spawn()

    end
end

function ENT:Use(Activator, Caller)

    net.Start('vgui_show_stove')
    net.WriteEntity(self)
    net.WriteBool(self.IsActivated)
    net.WriteString(self.Items[1])
    net.WriteString(self.Items[2])
    net.WriteString(self.Items[3])
    net.WriteVector(self:GetPos())
    net.Send(Activator)
    print(self)
    Activator:PrintMessage( HUD_PRINTTALK, tostring(self))
    //print(self)
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
        table.sort(StoveEntity.Items)
        local recipe = StoveEntity.Items[1] .. StoveEntity.Items[2] .. StoveEntity.Items[3] //concat all strings
        print("[DEBUG] Recipe: " .. recipe)
        local recipefound = true
        if (recipe == "emptyingr_doughingr_dough") then // Checks the recipe names based on alphabetical order, so it doesn't matter which slot the item is placed
            print("[DEBUG] Cooking Bread.")
            StoveEntity.FinishTime = CurTime() + 12
            StoveEntity.IsActivated = true
            StoveEntity.Cooking = "food_bread"
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav")
        elseif (recipe == "ingr_doughingr_eggingr_milk") then 
            print("[DEBUG] Cooking Pancakes.")
            StoveEntity.FinishTime = CurTime() + 15
            StoveEntity.IsActivated = true
            StoveEntity.Cooking = "food_pancakes"
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav")
        elseif (recipe == "emptyemptyingr_dough") then
            print("[DEBUG] Cooking Bagels.")
            StoveEntity.FinishTime = CurTime() + 10
            StoveEntity.IsActivated = true
            StoveEntity.Cooking = "food_bagel"
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav")
        elseif (recipe == "emptyingr_eggingr_oil") then
            print("[DEBUG] Cooking Bagels.")
            StoveEntity.FinishTime = CurTime() + 8
            StoveEntity.IsActivated = true
            StoveEntity.Cooking = "food_friedegg"
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav")
        else recipefound = false
        end
        if recipefound then
            net.Start("stove_update_3d2d")
            net.WriteEntity(StoveEntity)
            net.WriteBool(true)
            net.WriteInt(StoveEntity.FinishTime, 8)
            net.Broadcast()
        end
    end
end

net.Receive("stove_remove_item", function(len, ply) // Removing item from stove
    local RemovedEntity = net.ReadString()
    print(RemovedEntity)
    local Stove = net.ReadEntity()
    local Index = net.ReadInt(4)
    Stove.Items[Index] = "empty" // Clears the selected item inside the stove being used
    local newent = ents.Create(RemovedEntity)
    newent:SetPos(ply:EyePos() + ply:GetAimVector() * 30)
    newent:Spawn()
end)