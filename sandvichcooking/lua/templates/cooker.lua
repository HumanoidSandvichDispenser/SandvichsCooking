// This is a template for the Cooker model (Stoves, blenders, etc.)

/*
* self.NetWorkDisplayPanel (string)
* self.NetworkButtonPress (string)
* self.NetworkUpdate3D2D (string)
* self.Items (table)
* self.Capacity (integer)
* self.
* self.PlacePos (vector, nil if none)
*/

// Serverside Code
if SERVER then
    util.AddNetworkString(self.NetworkDisplayPanel)
    util.AddNetworkString(self.NetworkButtonPress)
    util.AddNetworkString(self.NetworkUpdate3D2D)
    function ENT:Initialize()
        
    end
end

// Clientside Code
if CLIENT then
    net.Receive(self.NetworkDisplayPanel, 
    function()
        
        local frame = vgui.Create("DFrame")
        frame:SetTitle(self.ItemName .. " - Options")
        frame:SetSize(256,244)
        frame:SetVisible(true)
        frame:Center()
        frame:MakePopup()
        frame.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, 220 ) ) // overriding the default panel
            draw.RoundedBox(0, 8, 24, 240, 2, Color(41, 148, 225))
        end
        frame:SetDeleteOnClose(true)

        
    end)
end

// Shared Code
