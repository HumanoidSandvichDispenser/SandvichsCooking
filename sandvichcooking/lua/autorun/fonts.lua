if CLIENT then
    surface.CreateFont("3D2DTitle", {
        font = "Roboto",
        size = 255,
        weight = 750,
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
        outline = false,
    })

    surface.CreateFont("3D2DLabel", {
        font = "Roboto",
        size = 70,
        weight = 350,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = true,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })
end