include("shared.lua")

GlobalStoveEntity = Entity(0) // Declaring with a filler value
GlobalIsActivated = false

local Drawn3D2D = false

StoveCooking = {}

net.Receive('vgui_show_stove', function(len)
    local StoveEntity = net.ReadEntity()
    local IsActivated = net.ReadBool()
    local slot1_item = net.ReadString()
    local slot2_item = net.ReadString()
    local slot3_item = net.ReadString()
    local StoveVec = net.ReadVector()

    local power = "Off"
    if IsActivated then
        power = "On"
    end

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Stove - Options")
    frame:SetSize(250,250)
    frame:SetVisible(true)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) // overriding the default panel
    end

    local powerlabel = vgui.Create("DLabel", frame)
    powerlabel:SetPos(40, 40)
    powerlabel:SetText("Power: " .. power)

    local slot1 = vgui.Create("DButton", frame)
    slot1:SetPos(40, 88)
    slot1:SetSize(72, 24)
    slot1:SetText("empty")
    slot1:SetTextColor(Color(255, 255, 255))
    slot1.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) // overriding the default pan
    end

    local slot2 = vgui.Create("DButton", frame)
    slot2:SetPos(40, 110)
    slot2:SetSize(72, 24)
    slot2:SetText("empty")
    slot2:SetTextColor(Color(255, 255, 255))
    slot2.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) // overriding the default pan
    end

    local slot3 = vgui.Create("DButton", frame)
    slot3:SetPos(40, 132)
    slot3:SetSize(72, 24)
    slot3:SetText("empty")
    slot3:SetTextColor(Color(255, 255, 255))
    slot3.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) // overriding the default pan
    end
    
    local slot1_name = string.gsub(slot1_item, "ingr_", "")
    slot1_name = string.gsub(slot1_name, "food_", "")
    local slot2_name = string.gsub(slot2_item, "ingr_", "")
    slot2_name = string.gsub(slot2_name, "food_", "")
    local slot3_name = string.gsub(slot3_item, "ingr_", "")
    slot3_name = string.gsub(slot3_name, "food_", "")

    slot1:SetText(slot1_name)
    slot2:SetText(slot2_name)
    slot3:SetText(slot3_name)

    local button = vgui.Create("DButton", frame)
    button:SetPos(172, 188)
    button:SetSize(56, 24)
    button:SetText("Toggle")
    button:SetTextColor(Color(255, 255, 255))
    button.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) )
    end



    button.DoClick = function() 
        GlobalStoveEntity = StoveEntity
        if IsActivated then
            power = "Off" else power = "On"
        end
        powerlabel:SetText("Power: " .. power)
        IsActivated = StoveEntity.IsActivated
        GlobalIsActivated = IsActivated

        net.Start("stove_toggle")
        net.WriteEntity(StoveEntity)
        net.SendToServer()
    end
    
    slot1.DoClick = function()
        print(slot1_item .. " " .. slot1:GetText())
        if not IsActivated and slot1:GetText() != "empty" then
            
            net.Start("stove_remove_item")
            net.WriteString(slot1_item)
            net.WriteEntity(StoveEntity)
            net.WriteInt(1, 4)
            net.SendToServer()
            slot1:SetText("empty")
            slot1.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) end
        end
    end

    slot2.DoClick = function()
        if not IsActivated and slot2:GetText() != "empty" then
            net.Start("stove_remove_item")
            net.WriteString(slot2_item)
            net.WriteEntity(StoveEntity)
            net.WriteInt(2, 4)
            net.SendToServer()
            slot2:SetText("empty")
            slot2.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) end
        end
    end

    slot3.DoClick = function()
        if not IsActivated and slot3:GetText() != "empty" then
            net.Start("stove_remove_item")
            net.WriteString(slot3_item)
            net.WriteEntity(StoveEntity)
            net.WriteInt(3, 4)
            net.SendToServer()
            slot3:SetText("empty")
            slot3.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) end
        end
    end

    if slot1_name != "empty" then slot1.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 150, 190, 255 ) ) end end
    if slot2_name != "empty" then slot2.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 150, 190, 255 ) ) end end
    if slot3_name != "empty" then slot3.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 150, 190, 255 ) ) end end


    frame:SetDeleteOnClose(true)
end)

function ENT:Draw()
    self:DrawModel()

    local x, y, z = self:GetAngles().x, LocalPlayer():EyeAngles().Yaw - 90, self:GetAngles().z + 90  
    local status = "Powered Off"
    
    if (self:GetColor() != Color(255, 255, 255)) then
        if (StoveCooking[self:EntIndex()]) then
            if (StoveCooking[self:EntIndex()] - CurTime() >= 0) then
                status = "Cooking... " .. tostring(math.ceil(StoveCooking[self:EntIndex()] - CurTime() )) .. "s" // Time left is rounded up and converted to a string for some reason it rounds down so i add 1
            else table.remove(StoveCooking, self:EntIndex()) end
        end
    end

    //Sets position of 3D2D with a position and angle offset
    cam.Start3D2D(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z + 64), Angle(0, y, z), 0.1)
        draw.RoundedBox(0, -75, 0, 150, 52, Color(0, 0, 0, 155))
        draw.RoundedBox(0, -75, 0, 150, 32, Color(0, 195, 250, 225))
        draw.SimpleText("Stove", "DermaLarge", 0, 0, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        //if self.IsActivated then
        //status = "Cooking... " .. tostring(math.ceil(self.FinishTime - CurTime())) .. "s"
        draw.SimpleText(status, "DermaDefaultBold", 0, 35, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        //draw.RoundedBox(number cornerRadius, number x, number y, number width, number height, table color)
    cam.End3D2D()
end

net.Receive("stove_update_3d2d", function(len) 
    local StoveEntity = net.ReadEntity()
    local IsCooking = net.ReadBool()
    local Time = net.ReadInt(8)
    if IsCooking then table.insert(StoveCooking, StoveEntity:EntIndex(), Time)
    else table.remove(StoveCooking, StoveEntity:EntIndex()) end
end)

--[[
hook.Add("PlayerSay", "ChatHook", function(sender, text, team)
    net.Start('vgui_show_stove')
    net.Send(sender)
    print(sender, text)
end)
]]--