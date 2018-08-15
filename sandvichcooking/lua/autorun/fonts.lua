if CLIENT then
    surface.CreateFont("3D2DTitle", {
        font = "Verdana",
        size = 75,
        weight = 500,
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
    
    surface.CreateFont("3D2DLabel", {
        font = "Verdana",
        size = 25,
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