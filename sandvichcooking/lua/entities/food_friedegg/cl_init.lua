include("shared.lua")
include("init.lua")

surface.CreateFont("Default", {
    font = "Arial",
    size = 13,
    weight = 400,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = true,
})

function ENT:Draw()
    self:DrawModel()
    local x, y, z = self:GetAngles().x, LocalPlayer():EyeAngles().Yaw - 90, 90

    //Sets position of 3D2D with a position and angle offset
    cam.Start3D2D(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z + 16), Angle(0, y, z), 0.1)
        draw.RoundedBox(0, -75, 0, 150, 52, Color(0, 0, 0, 155))
        draw.SimpleText(self.ItemName, "DermaLarge", 0, 5, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText("+" .. self.Quality .. " HP", "DermaDefaultBold", 0, 35, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        //draw.RoundedBox(number cornerRadius, number x, number y, number width, number height, table color)
    cam.End3D2D()
end