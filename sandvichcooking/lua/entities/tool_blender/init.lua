AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )
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
    if (string.StartWith(ent:GetClass(), "ingr_") or string.StartWith(ent:GetClass(), "food_")) and not arrayFull and not self.IsActivated then
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

        net.Start("blender_update_3d2d")
        net.WriteEntity(StoveEntity)
        net.WriteBool(true)
        net.WriteFloat(-1)
        net.Broadcast()

        self.FinishTime = 0
        self.Collectable = true

        if (self.Cooking == "food_bonk_blutonium_berry") then
            self.Collectable = false // Is this useless? Since it will remove itself at the end
            local food = ents.Create("food_bonk_blutonium_berry")
            food:SetPos(self:GetPos() + Vector(0, 0, 32))
            food:Spawn()
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
        net.Start('vgui_show_blender')
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

net.Receive("blender_toggle", function(len, ply)
    local StoveEntity = net.ReadEntity()
    ToggleBlender(StoveEntity, ply)
end)

function ToggleBlender(StoveEntity, ply)
    if not StoveEntity.IsActivated then
        print("[DEBUG] Turned on")
        local items = table.Copy(StoveEntity.Items)
        table.sort(items)
        local recipe = items[1] .. items[2] .. items[3] //concat all strings
        local recipefound = true
        print("[DEBUG] Recipe: " .. recipe)
        if (recipe == "ingr_coca_extractingr_sugaringr_water") then // Checks the recipe names based on alphabetical order, so it doesn't matter which slot the item is placed
            print("[DEBUG] Blending for Coke.")
            StoveEntity.FinishTime = CurTime() + 8
            StoveEntity.Cooking = "food_coke"
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        elseif (recipe == "food_cherriesingr_sugaringr_water") then
            print("[DEBUG] Blending for Cherry Coke.")
            StoveEntity.FinishTime = CurTime() + 10
            StoveEntity.Cooking = "food_cherry_coke"
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        elseif (recipe == "ingr_sugaringr_sugaringr_water") then
            print("[DEBUG] Blending for Pepsi.")
            StoveEntity.FinishTime = CurTime() + 12
            StoveEntity.Cooking = "food_pepsi"
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        elseif (recipe == "ingr_plutonium-239ingr_sugaringr_water") then
            print("[DEBUG] Blending for Bonk! Atomic Punch (Blutonium Berry).")
            StoveEntity.FinishTime = CurTime() + 30
            StoveEntity.Cooking = "food_bonk_blutonium_berry"
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        elseif (recipe == "food_cherriesingr_natural_uraniumingr_water") then
            print("[DEBUG] Blending for Bonk! Atomic Punch (Chery Fission).")
            StoveEntity.FinishTime = CurTime() + 30
            StoveEntity.Cooking = "food_bonk_chery_fission"
            StoveEntity:EmitSound("plats/tram_motor_start.wav")
        else recipefound = false
        end
        if recipefound then
            StoveEntity.IsActivated = true
            StoveEntity.Items = {"empty", "empty", "empty"}
            StoveEntity.ItemColors = {0, 0, 0}
            net.Start("blender_update_3d2d")
            net.WriteEntity(StoveEntity)
            net.WriteBool(true)
            net.WriteFloat(StoveEntity.FinishTime)
            net.Broadcast()
        end
    end
end

net.Receive("blender_remove_item", function(len, ply) // Removing item from stove
    local RemovedEntity = net.ReadString()
    local Stove = net.ReadEntity()
    local Index = net.ReadInt(4)
    Stove.Items[Index] = "empty" // Clears the selected item inside the stove being used
    Stove.ItemColors[Index] = 0
    local newent = ents.Create(RemovedEntity)
    newent:SetPos(ply:EyePos() + ply:GetAimVector() * 30)
    newent:Spawn()
end)