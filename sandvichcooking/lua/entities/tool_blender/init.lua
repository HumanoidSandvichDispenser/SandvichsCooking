AddCSLuaFile("shared.lua")
util.AddNetworkString("vgui_show_blender")
util.AddNetworkString("blender_toggle")
util.AddNetworkString("blender_remove_item")
util.AddNetworkString("blender_update_3d2d")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_interiors/coffee_maker.mdl")
    self:SetColor(Color(255, 255, 255))
    self:PhysicsInit(SOLID_VPHYSICS)
    --self:MoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.IsRunning = false
    self.ItemName = "Blender"
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
    if (string.StartWith(ent:GetClass(), "ingr_") or string.StartWith(ent:GetClass(), "food_")) and not arrayFull and not self.IsActivated then
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

        net.Start("blender_update_3d2d")
        net.WriteEntity(StoveEntity)
        net.WriteBool(false)
        net.WriteInt(self.FinishTime, 8)
        net.Broadcast()

        
        self.IsActivated = false
        self.FinishTime = 0
        local food = ents.Create(self.Cooking)
        food:SetPos(self:GetForward())
        food:Spawn()
        
        if (self.Cooking == "food_bonk_blutonium_berry") then
            local explosion = ents.Create("env_explosion") //creates the explosion
            explosion:SetPos(self:GetPos())
            explosion:SetOwner(self)
            explosion:Spawn()
            explosion:SetKeyValue("iMagnitude", "100")
            explosion:Fire("Explode", 0, 0)
            explosion:EmitSound("weapons/explode4.wav")
            self:Remove()
        end
    end
end

function ENT:Use(Activator, Caller)

    net.Start('vgui_show_blender')
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

net.Receive("blender_toggle", function(len, ply)
    local StoveEntity = net.ReadEntity()
    ToggleBlender(StoveEntity, ply)
end)

function ToggleBlender(StoveEntity, ply)
    if not StoveEntity.IsActivated then
        print("[DEBUG] Turned on")
        table.sort(StoveEntity.Items)
        local recipe = StoveEntity.Items[1] .. StoveEntity.Items[2] .. StoveEntity.Items[3] //concat all strings
        local recipefound = true
        print("[DEBUG] Recipe: " .. recipe)
        if (recipe == "ingr_coca_extractingr_sugaringr_water") then // Checks the recipe names based on alphabetical order, so it doesn't matter which slot the item is placed
            print("[DEBUG] Blending for Coke.")
            StoveEntity.FinishTime = CurTime() + 8
            StoveEntity.IsActivated = true
            StoveEntity.Cooking = "food_coke"
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        elseif (recipe == "food_cherriesingr_sugaringr_water") then
            print("[DEBUG] Blending for Cherry Coke.")
            StoveEntity.FinishTime = CurTime() + 10
            StoveEntity.IsActivated = true
            StoveEntity.Cooking = "food_cherry_coke"
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        elseif (recipe == "ingr_sugaringr_sugaringr_water") then
            print("[DEBUG] Blending for Pepsi.")
            StoveEntity.FinishTime = CurTime() + 12
            StoveEntity.IsActivated = true
            StoveEntity.Cooking = "food_pepsi"
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        elseif (recipe == "ingr_plutonium-239ingr_sugaringr_water") then
            print("[DEBUG] Blending for Bonk! Atomic Punch (Blutonium Berry).")
            StoveEntity.FinishTime = CurTime() + 30
            StoveEntity.IsActivated = true
            StoveEntity.Cooking = "food_bonk_blutonium_berry"
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        else recipefound = false
        end
        if recipefound then
            net.Start("blender_update_3d2d")
            net.WriteEntity(StoveEntity)
            net.WriteBool(true)
            net.WriteInt(StoveEntity.FinishTime, 8)
            net.Broadcast()
        end
    end
end

net.Receive("blender_remove_item", function(len, ply) // Removing item from stove
    local RemovedEntity = net.ReadString()
    print(RemovedEntity)
    local Stove = net.ReadEntity()
    local Index = net.ReadInt(4)
    Stove.Items[Index] = "empty" // Clears the selected item inside the stove being used
    local newent = ents.Create(RemovedEntity)
    newent:SetPos(ply:EyePos() + ply:GetAimVector() * 30)
    newent:Spawn()
end)