if CLIENT then
    net.Receive("playsound_client", function(len)
        local snd = net.ReadString()
        if snd then surface.PlaySound(snd) else Error("Sound is not specified or is nil.\n") end
    end)
end