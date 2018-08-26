if CLIENT then
    function ENT:DrawTranslucent()
        local x, y, z = self:GetAngles().x, LocalPlayer():EyeAngles().Yaw - 90, 90

        local RarityColor = Color(0, 0, 0, 0)
        local description = ""
        if (self.Rarity == 1) then
            RarityColor = Color(175, 175, 175, 125)
            description = "Consumer"
        elseif (self.Rarity == 2) then
            RarityColor = Color(0, 195, 250, 225)
            description = "Professional Grade"
        elseif(self.Rarity == 3) then
            RarityColor = Color(20, 127, 210, 225)
            description = "Exotic"
        elseif(self.Rarity == 4) then
            RarityColor = Color(244, 68, 224, 225)
            description = "⚠ Black Market"
        elseif(self.Rarity == 5) then
            RarityColor = Color(175, 5, 2, 225)
            description = "⚠ Contraband"
        end

        surface.SetFont("3D2DTitle")
        if (string.StartWith(self:GetClass(), "food_")) then description = self.Quality .. " HP" .. " | " .. description end
        if (string.StartWith(self:GetClass(), "ingr_")) then description = description .. " Ingredient" end
        if (string.StartWith(self:GetClass(), "ingr_")) then description = description .. " Tool" end
        local itemlen = select(1, surface.GetTextSize(self.ItemName))
        local desclen = select(1, surface.GetTextSize(description))
        local w = Ternary((itemlen > desclen * 0.5), itemlen, desclen * 0.5)
        
        // Sets position of 3D2D with a position and angle offset
        cam.Start3D2D(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z + 16), Angle(0, y, z), 0.02)
            draw.RoundedBox(0, -(RoundToEven(w)/2) - 72, 0, RoundToEven(w) + 144, 225, Color(0, 0, 0, 105))
            draw.RoundedBox(0, -(RoundToEven(w)/2) - 56, 132, RoundToEven(w) + 112, 8, RarityColor)
            draw.SimpleText(self.ItemName, "3D2DTitle", 0, 10, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(description, "3D2DLabel", 0, 140, Color( 255, 255, 255, 255 ),  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
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
end