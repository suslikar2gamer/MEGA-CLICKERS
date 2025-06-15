local Players = game:GetService("Players")
local HeadSize = 25
local HeadTransparency = 0.5

local old; old = hookmetamethod(game, "__index", newcclosure(function(self, ...)
    local args = {...}

    if tostring(self) == "Head" and args[1] == "Size" then
        return Vector3.one * 1.15
    end

    return old(self, ...)
end))

task.spawn(function()
    while task.wait(1) do
        for _, v in next, Players:GetPlayers() do
            if v == Players.LocalPlayer then continue end
            local Character = v.Character
            local Head = Character and Character.Head
            if not Head then continue end
            Head.Size = Vector3.one * 1.15 * HeadSize
            Head.Transparency = HeadTransparency
        end
    end
end)
