net.Receive("container_showvgui", function(len)
    local StoveEntity = net.ReadEntity()
    local IsActivated = net.ReadBool()
    local slotitems = net.ReadTable()
    local slotcolors = net.ReadTable()

    local children = net.ReadTable()

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Pot - Options")
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
        if not slot1:IsHovered() then w = 8 end
        if (slotcolors[1] == 1) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(125, 125, 125, 225))
        elseif (slotcolors[1] == 2) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(0, 195, 250, 225))
        elseif (slotcolors[1] == 3) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(20, 127, 210, 225))
        elseif (slotcolors[1] == 4) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(244, 68, 224, 225))
        elseif (slotcolors[1] == 5) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(175, 5, 2, 225))
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
        if not slot2:IsHovered() then w = 8 end
        if (slotcolors[2] == 1) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(125, 125, 125, 225))
        elseif (slotcolors[2] == 2) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(0, 195, 250, 225))
        elseif (slotcolors[2] == 3) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(20, 127, 210, 225))
        elseif (slotcolors[2] == 4) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(244, 68, 224, 225))
        elseif (slotcolors[2] == 5) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(175, 5, 2, 225))
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
        if not slot3:IsHovered() then w = 8 end
        if (slotcolors[3] == 1) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(125, 125, 125, 225))
        elseif (slotcolors[3] == 2) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(0, 195, 250, 225))
        elseif (slotcolors[3] == 3) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(20, 127, 210, 225))
        elseif (slotcolors[3] == 4) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(244, 68, 224, 225))
        elseif (slotcolors[3] == 5) then
            draw.RoundedBox( 0, 0, 0, w, h, Color(175, 5, 2, 225))
        end
    end

    slot1:SetText(RenameEnt(slotitems[1]))
    slot2:SetText(RenameEnt(slotitems[2]))
    slot3:SetText(RenameEnt(slotitems[3]))

    slot1.DoClick = function()
        if not IsActivated and slot1:GetText() != "Empty" then
            net.Start("container_removeitem")
            net.WriteString(slotitems[1])
            net.WriteEntity(StoveEntity)
            net.WriteInt(1, 4)
            net.WriteEntity(children[1])
            net.SendToServer()
            slot1:SetText("Empty")
            slot1.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 )) end
        end
    end

    slot2.DoClick = function()
        if not IsActivated and slot2:GetText() != "Empty" then
            net.Start("container_removeitem")
            net.WriteString(slotitems[2])
            net.WriteEntity(StoveEntity)
            net.WriteInt(2, 4)
            net.WriteEntity(children[2])
            net.SendToServer()
            slot2:SetText("Empty")
            slot2.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 )) end
        end
    end

    slot3.DoClick = function()
        if not IsActivated and slot3:GetText() != "Empty" then
            net.Start("container_removeitem")
            net.WriteString(slotitems[3])
            net.WriteEntity(StoveEntity)
            net.WriteInt(3, 4)
            net.WriteEntity(children[3])
            net.SendToServer()
            slot3:SetText("Empty")
            slot3.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35, 220 )) end
        end
    end

    frame:SetDeleteOnClose(true)
end)