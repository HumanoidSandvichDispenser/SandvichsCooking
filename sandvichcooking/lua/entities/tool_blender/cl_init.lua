include("shared.lua")

local Drawn3D2D = false

BlenderBlending = {}

net.Receive('vgui_show_blender', function(len)
    //TODO: Optimize the hell out of this, make it more readable
    
    local StoveEntity = net.ReadEntity()
    local IsActivated = net.ReadBool()
    local slotitems = net.ReadTable()
    local slotcolors = net.ReadTable()
    local StoveVec = net.ReadVector()

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Blender - Options")
    frame:SetSize(256,244)
    frame:SetVisible(true)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) // overriding the default panel
        draw.RoundedBox(0, 8, 24, 240, 2, Color(41, 148, 225))
    end

    // Drawing Slots 1 - 3

    local slot1 = vgui.Create("DButton", frame)
    slot1:SetPos(8, 32)
    slot1:SetSize(240, 48)
    slot1:SetText("empty")
    slot1:SetTextColor(Color(255, 255, 255))
    slot1:SetFont("DermaLarge")
    
    slot1.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 ))
        if (slotcolors[1] == 1) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(125, 125, 125, 225))
        elseif (slotcolors[1] == 2) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(0, 195, 250, 225))
        elseif(slotcolors[1] == 3) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(20, 127, 210, 225))
        elseif(slotcolors[1] == 4) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(244, 68, 224, 225))
        elseif(slotcolors[1] == 5) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(175, 5, 2, 225))
        end
    end

    local slot2 = vgui.Create("DButton", frame)
    slot2:SetPos(8, 84)
    slot2:SetSize(240, 48)
    slot2:SetText("empty")
    slot2:SetTextColor(Color(255, 255, 255))
    slot2:SetFont("DermaLarge")

    slot2.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 ))
        if (slotcolors[2] == 1) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(125, 125, 125, 225))
        elseif (slotcolors[2] == 2) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(0, 195, 250, 225))
        elseif(slotcolors[2] == 3) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(20, 127, 210, 225))
        elseif(slotcolors[2] == 4) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(244, 68, 224, 225))
        elseif(slotcolors[2] == 5) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(175, 5, 2, 225))
        end
    end

    local slot3 = vgui.Create("DButton", frame)
    slot3:SetPos(8, 136)
    slot3:SetSize(240, 48)
    slot3:SetText("empty")
    slot3:SetTextColor(Color(255, 255, 255))
    slot3:SetFont("DermaLarge")

    slot3.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 ))
        if (slotcolors[3] == 1) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(125, 125, 125, 225))
        elseif (slotcolors[3] == 2) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(0, 195, 250, 225))
        elseif(slotcolors[3] == 3) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(20, 127, 210, 225))
        elseif(slotcolors[3] == 4) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(244, 68, 224, 225))
        elseif(slotcolors[3] == 5) then
            draw.RoundedBox( 0, 0, 0, 8, h, Color(175, 5, 2, 225))
        end
    end

    slot1:SetText(RenameEnt(slotitems[1]))
    slot2:SetText(RenameEnt(slotitems[2]))
    slot3:SetText(RenameEnt(slotitems[3]))

    local button = vgui.Create("DButton", frame)
    button:SetPos(8, 188)
    button:SetSize(240, 48)
    button:SetText("Blend!")
    button:SetTextColor(Color(255, 255, 255))
    button:SetFont("DermaLarge")
    button.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) )
    end



    button.DoClick = function() 
        net.Start("blender_toggle")
        net.WriteEntity(StoveEntity)
        net.SendToServer()
    end
    
    slot1.DoClick = function()
        if not IsActivated and slot1:GetText() != "Empty" then
            net.Start("stove_remove_item")
            net.WriteString(slotitems[1])
            net.WriteEntity(StoveEntity)
            net.WriteInt(1, 4)
            net.SendToServer()
            slot1:SetText("Empty")
            slot1.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 )) end
        end
    end

    slot2.DoClick = function()
        if not IsActivated and slot2:GetText() != "Empty" then
            net.Start("stove_remove_item")
            net.WriteString(slotitems[2])
            net.WriteEntity(StoveEntity)
            net.WriteInt(2, 4)
            net.SendToServer()
            slot2:SetText("Empty")
            slot2.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 )) end
        end
    end

    slot3.DoClick = function()
        if not IsActivated and slot3:GetText() != "Empty" then
            net.Start("stove_remove_item")
            net.WriteString(slotitems[3])
            net.WriteEntity(StoveEntity)
            net.WriteInt(3, 4)
            net.SendToServer()
            slot3:SetText("Empty")
            slot3.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 )) end
        end
    end

    frame:SetDeleteOnClose(true)
end)

function ENT:Draw()
    self:DrawModel()
end

function ENT:DrawTranslucent()
    local x, y, z = self:GetAngles().x, LocalPlayer():EyeAngles().Yaw - 90, self:GetAngles().z + 90  
    local status = "Powered Off"

    if (BlenderBlending[self:EntIndex()]) then // check if this value is not nil
        if (BlenderBlending[self:EntIndex()] == -1) then // value of -1 represents that it is done cooking, and ready to collect
            status = "Press E to Collect"
        elseif (BlenderBlending[self:EntIndex()] - CurTime() >= 0) then
            status = "Blending... " .. tostring(math.ceil(BlenderBlending[self:EntIndex()] - CurTime() )) .. "s" // Time left is rounded up and converted to a string for some reason it rounds down so i add 1
        else table.remove(BlenderBlending, self:EntIndex()) end
    end

    // Sets position of 3D2D with a position and angle offset
    cam.Start3D2D(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z + 32), Angle(0, y, 90), 0.1)
        draw.RoundedBox(0, -75, 0, 150, 52, Color(0, 0, 0, 155))
        draw.RoundedBox(0, -75, 0, 150, 32, Color(0, 195, 250, 225))
        draw.SimpleText("Blender", "DermaLarge", 0, 0, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(status, "DermaDefaultBold", 0, 35, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    cam.End3D2D()
end

net.Receive("blender_update_3d2d", function(len) 
    local StoveEntity = net.ReadEntity()
    local IsCooking = net.ReadBool()
    local Time = net.ReadFloat()
    if IsCooking then table.insert(BlenderBlending, StoveEntity:EntIndex(), Time)
    else table.remove(BlenderBlending, StoveEntity:EntIndex()) end
end)

function RenameEnt(str)
    // Removes entity prefixes
    str = string.gsub(str, "ingr_", "")
    str = string.gsub(str, "food_", "")
    str = string.gsub(str, "_", " ")
    str = string.gsub(str, "(%a)([%w_']*)", titleCase) // Capitalizes every first letter
    return(str)
end

function titleCase( first, rest )
   return first:upper()..rest:lower()
end