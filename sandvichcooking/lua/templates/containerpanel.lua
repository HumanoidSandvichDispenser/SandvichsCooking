if CLIENT then

    // Container Panel ////////
    ContainerCooking = {}
    contents = {}

    net.Receive("container_update3d2d", function()
        local Container = net.ReadEntity()
        local IsCooking = net.ReadBool()
        local Time = net.ReadFloat()
        local Items = net.ReadTable()
        local localcontents = ""

        if IsCooking then ContainerCooking[Container:EntIndex()] = Time
        elseif (ContainerCooking[Container:EntIndex()]) then ContainerCooking[Container:EntIndex()] = nil
        end

        for i,v in pairs(Items) do
            local item = v
            if item == "empty" then item = "" else
                if (i == GetItemsLength(Items)) then localcontents = localcontents .. RenameEnt(item)
                else localcontents = localcontents .. RenameEnt(item) .. ", " end
            end
        end

        localcontents = Ternary(localcontents == "", "Empty", localcontents)
        if (contents[Container:EntIndex()]) then contents[Container:EntIndex()] = localcontents end
    end)

    net.Receive("container_removekey", function()
        local ContainerIndex = net.ReadInt(16)
        contents[ContainerIndex] = nil
    end)

    function ENT:DrawTranslucent()
        local y, z = LocalPlayer():EyeAngles().Yaw - 90, 90

        local RarityColor = Color(0, 0, 0, 0)
        local description = ""
        if (self.Rarity == 1) then
            RarityColor = Color(175, 175, 175, 125)
            description = "Consumer"
        elseif (self.Rarity == 2) then
            RarityColor = Color(0, 195, 250, 225)
            description = "Professional Grade"
        elseif (self.Rarity == 3) then
            RarityColor = Color(20, 127, 210, 225)
            description = "Exotic"
        elseif (self.Rarity == 4) then
            RarityColor = Color(244, 68, 224, 225)
            description = "⚠ Black Market"
        elseif (self.Rarity == 5) then
            RarityColor = Color(175, 5, 2, 225)
            description = "⚠ Contraband"
        end

        if not (contents[self:EntIndex()]) then
            contents[self:EntIndex()] = "Empty"
        end

        surface.SetFont("3D2DTitle")
        local itemlen = select(1, surface.GetTextSize(description .. " " .. self.ItemName))
        local desclen = select(1, surface.GetTextSize(contents[self:EntIndex()]))
        local w = Ternary(itemlen > desclen * 0.5, itemlen, desclen * 0.5)

        // Sets position of 3D2D with a position and angle offset
        cam.Start3D2D(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z + 16), Angle(0, y, z), 0.02)
            draw.RoundedBox(0, -(RoundToEven(w) / 2) - 72, 0, RoundToEven(w) + 144, 225, Color(0, 0, 0, 105))
            draw.RoundedBox(0, -(RoundToEven(w) / 2) - 56, 132, RoundToEven(w) + 112, 8, RarityColor)
            draw.SimpleText(description .. " " .. self.ItemName, "3D2DTitle", 0, 10, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(contents[self:EntIndex()], "3D2DLabel", 0, 140, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        cam.End3D2D()
    end

    function RoundToEven(num)
        if (num % 2 != 0) then
            return num - (num % 2) // Truncates the number by removing part of the number that goes over an even number
        end
        return num
    end

    function Ternary(condition, valtrue, valfalse)
        if condition then
            return valtrue
        else return valfalse end
    end

    // Container

    function RenameEnt(str)
        // Removes entity prefixes
        str = string.gsub(str, "ingr_", "")
        str = string.gsub(str, "food_", "")
        str = string.gsub(str, "tool_", "")
        str = string.gsub(str, "_", " ")
        str = string.gsub(str, "(%a)([%w_']*)", titleCase) // Capitalizes every first letter
        return str
    end

    function titleCase( first, rest )
        return first:upper() .. rest:lower()
    end

    function GetItemsLength(tbl)
        local length = 0
        for i,v in ipairs(tbl) do
            if (v and v != "empty") then length = i end
            // The reason why I checked to see if v wasn't nil first is because Lua short-circuits.
        end
        return length
    end
end

if SERVER then
    util.AddNetworkString("container_update3d2d")
    util.AddNetworkString("container_removekey")
    util.AddNetworkString("container_showvgui")
    util.AddNetworkString("container_removeitem")

    function ENT:StartTouch(ent)
        local arrayFull = true
        for i = 1,3 do
            if self.Items[i] == "empty" then arrayFull = false end
        end
        if string.StartWith(ent:GetClass(), "ingr_") and not arrayFull and not IsActivated then
            //self.IsBeingUsed = true
            //self.FinishTime = self.FinishTime + ent.TargetTime
            if (self.Items[1] == "empty") then
                self.Children[1] = ent
                self.Items[1] = ent:GetClass()
                self.ItemColors[1] = ent.Rarity
            elseif (self.Items[2] == "empty") then
                self.Children[2] = ent
                self.Items[2] = ent:GetClass()
                self.ItemColors[2] = ent.Rarity
            elseif (self.Items[3] == "empty") then
                self.Children[3] = ent
                self.Items[3] = ent:GetClass()
                self.ItemColors[3] = ent.Rarity
            end

            if self.TouchHandleType == 0 then ent:Remove()
            elseif self.TouchHandleType == 1 then ent:SetParent(self) end

            net.Start("container_update3d2d")
            net.WriteEntity(self)
            net.WriteBool(false)
            net.WriteFloat(0)
            net.WriteTable(self.Items)
            net.Broadcast()
        end
    end

    function ENT:Use(Activator, Caller)
        if self.Collectable then
            local food = ents.Create(self.Cooking)
            food:SetPos(Activator:EyePos() + Activator:GetAimVector() * 30)
            food:Spawn()

            net.Start("container_update3d2d")
            net.WriteEntity(self)
            net.WriteBool(false)
            net.WriteFloat(0)
            net.WriteTable(self.Items)
            net.Broadcast()
            self.Collectable = false
            self.IsActivated = false
        else
            net.Start("container_showvgui")
            net.WriteEntity(self)
            net.WriteBool(self.IsActivated)
            net.WriteTable(self.Items)
            net.WriteTable(self.ItemColors)
            net.WriteTable(self.Children)
            net.Send(Activator)
        end
    end

    function RemoveItems(entity)
        net.Start("container_removekey")
        net.WriteInt(entity:EntIndex(), 16)
        net.Broadcast()
    end

    net.Receive("container_removeitem", function(len, ply) // Removing item from stove
        local RemovedEntity = net.ReadString()
        local Container = net.ReadEntity()
        local Index = net.ReadInt(4)
        local child = net.ReadEntity()
        if child then child:Remove(); Container.Children[Index] = nil end

        Container.Items[Index] = "empty" // Clears the selected item inside the stove being used
        Container.ItemColors[Index] = 0
        local newent = ents.Create(RemovedEntity)
        newent:SetPos(ply:EyePos() + ply:GetAimVector() * 30)
        newent:Spawn()

        net.Start("container_update3d2d")
        net.WriteEntity(Container)
        net.WriteBool(false)
        net.WriteFloat(0)
        net.WriteTable(Container.Items)
        net.Broadcast()
    end)
end