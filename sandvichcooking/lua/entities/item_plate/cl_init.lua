include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function ENT:DrawTranslucent()
    local x, y, z = self:GetAngles().x, LocalPlayer():EyeAngles().Yaw - 90, 90
    
    // Sets position of 3D2D with a position and angle offset
    cam.Start3D2D(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z + 16), Angle(0, y, z), 0.1)
        draw.RoundedBox(0, -75, 0, 150, 52, Color(0, 0, 0, 155))
        draw.SimpleText(self.ItemName, "DermaLarge", 0, 5, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText("Item", "DermaDefaultBold", 0, 35, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    cam.End3D2D()
end