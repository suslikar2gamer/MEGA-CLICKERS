local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local Window = Library:CreateWindow({
    Title = 'Mega Clickers',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'), 
    Teleports = Window:AddTab("Teleports")
}
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('AutoTap Controls')
local RightGroupBox = Tabs.Main:AddRightGroupbox('Rebirth Controls')
local PlayerGroupBox = Tabs.Main:AddLeftGroupbox('Player Controls')
local HatchGroupBox = Tabs.Main:AddRightGroupbox('Hatch Controls')
local TeleportGroupBox = Tabs.Teleports:AddLeftGroupbox('Teleports')

local function teleportToNearestGem()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char or not char.PrimaryPart then return false end
    
    local gems = workspace.Gems:GetChildren()
    if #gems == 0 then return false end
    

    local closestGem = nil
    local closestDistance = math.huge
    local charPos = char.PrimaryPart.Position
    
    for _, gem in ipairs(gems) do
        if gem:IsA("BasePart") then
            local distance = (gem.Position - charPos).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestGem = gem
            end
        end
    end
    if closestGem then
        char:SetPrimaryPartCFrame(CFrame.new(closestGem.Position))
        return true
    end
    return false
end

getgenv().autoTeleportToGems = false

function startAutoTeleportToGems()
    spawn(function()
        while getgenv().autoTeleportToGems do
            local success = teleportToNearestGem()
            wait(0.5)
        end
    end)
end

TeleportGroupBox:AddToggle('AutoTeleportToGemsToggle', {
    Text = 'Auto Teleport to Gems',
    Default = false,
    Tooltip = 'Continuously teleport to nearest gems',
    Callback = function(Value)
        getgenv().autoTeleportToGems = Value
        if Value then
            startAutoTeleportToGems()
        end
        print('Auto Teleport to Gems is', Value and 'Enabled' or 'Disabled')
    end
})

TeleportGroupBox:AddButton('tp to upgrades', function()
    local char = game.Players.LocalPlayer.Character
    if char and char.PrimaryPart then
        char:SetPrimaryPartCFrame(CFrame.new(-411, 4, 707))
    end
end)
TeleportGroupBox:AddButton('Jungle', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(-3706, 29, -1554))
    end
end)
TeleportGroupBox:AddButton('Volcano', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(-810, 29, 831))
    end
end)
TeleportGroupBox:AddButton('Ice World', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(-3074, 29, 45))
    end
end)
TeleportGroupBox:AddButton('Underwater World', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(-979, 199, 6128))
    end
end)
TeleportGroupBox:AddButton('Heaven', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(-125, 1936, -2014))
    end
end)
TeleportGroupBox:AddButton('The Void', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(4905, -373, 11686))
    end
end)
TeleportGroupBox:AddButton('Magic Forest', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(-1404, -16, 5166))
    end
end)
TeleportGroupBox:AddButton('Beach', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(-5692, 29, 5183))
    end
end)
TeleportGroupBox:AddButton('VIP', function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:SetPrimaryPartCFrame(CFrame.new(-1445, 430, 6784))
    end
end)

getgenv().autoTap = false 

function doTap()
    spawn(function()
        while getgenv().autoTap == true do 
            local args = {true}
            game:GetService("ReplicatedStorage"):WaitForChild("Tap"):InvokeServer(unpack(args))
            wait()
        end
    end)
end

LeftGroupBox:AddToggle('AutoTapToggle', {
    Text = 'Enable Auto Tap',
    Default = false,
    Tooltip = 'Toggle to start/stop auto tapping',
    Callback = function(Value)
        getgenv().autoTap = Value
        if Value then
            doTap()
        end
        print('Auto Tap is', Value and 'Enabled' or 'Disabled')
    end
})

getgenv().autoRebirth = false

function startAutoRebirth()
    spawn(function()
        while getgenv().autoRebirth == true do 
            local rebirthAmount = Options.RebirthAmount.Value
            local args = {rebirthAmount}
            game:GetService("ReplicatedStorage"):WaitForChild("Rebirth"):FireServer(unpack(args))
            wait(0.5)
        end
    end)
end

RightGroupBox:AddDropdown('RebirthAmount', {
    Values = {1, 5, 10, 25, 50, 100},
    Default = 1,
    Multi = false,
    Text = 'Rebirth Amount',
    Tooltip = 'Select rebirth amount',
})

RightGroupBox:AddToggle('AutoRebirthToggle', {
    Text = 'Enable Auto Rebirth',
    Default = false,
    Tooltip = 'Toggle to start/stop auto rebirth',
    Callback = function(Value)
        getgenv().autoRebirth = Value
        if Value then
            startAutoRebirth()
        end
        print('Auto Rebirth is', Value and 'Enabled' or 'Disabled')
    end
})


local plr = game.Players.LocalPlayer
local currentWalkspeed = 16
local walkspeedConnection = nil

local function setWalkspeed(speed)
    currentWalkspeed = speed
    
    if walkspeedConnection then
        walkspeedConnection:Disconnect()
        walkspeedConnection = nil
    end
    
    if plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speed
            
            walkspeedConnection = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if hum.WalkSpeed ~= currentWalkspeed then
                    hum.WalkSpeed = currentWalkspeed
                end
            end)
        end
    end
end

plr.CharacterAdded:Connect(function(char)
    wait(0.5)
    setWalkspeed(currentWalkspeed)
end)

PlayerGroupBox:AddSlider('WalkSpeedSlider', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 0,
    Max = 250,
    Rounding = 0,
    Compact = false,
    Tooltip = 'Set player walk speed (0-250)',
    Callback = function(Value)
        setWalkspeed(Value)
        print('WalkSpeed set to:', Value)
    end
})

PlayerGroupBox:AddButton('Reset Speed', function()
    Options.WalkSpeedSlider:SetValue(16)
    print('WalkSpeed reset to default')
end)

getgenv().autoHatch = false

local function getAvailableEggs()
    local eggs = {}
    local eggsFolder = workspace:FindFirstChild("Eggs")
    
    if eggsFolder then
        for _, egg in ipairs(eggsFolder:GetChildren()) do
            if egg:IsA("Model") or egg:IsA("Part") then
                table.insert(eggs, egg.Name)
            end
        end
    end
    
    if #eggs == 0 then
        table.insert(eggs, "No eggs found")
    end
    
    return eggs
end

function startAutoHatch()
    spawn(function()
        while getgenv().autoHatch do
            local eggType = Options.EggType.Value
            
            
            local eggsFolder = workspace:FindFirstChild("Eggs")
            if eggsFolder then
                local egg = eggsFolder:FindFirstChild(eggType)
                if egg then
                    local args = {egg}
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("EggHatchingRemote")
                            :WaitForChild("HatchServer"):InvokeServer(unpack(args))
                    end)
                    
                    if not success then
                        warn("Hatching error: " .. tostring(err))
                    end
                else
                    warn("Egg not found: " .. eggType)
                end
            else
                warn("Eggs folder not found")
            end
            
            wait(0.5)
        end
    end)
end

local eggList = getAvailableEggs()

HatchGroupBox:AddDropdown('EggType', {
    Values = eggList,
    Default = #eggList > 0 and eggList[1] or nil,
    Multi = false,
    Text = 'Egg Type',
    Tooltip = 'Select egg to hatch',
})

HatchGroupBox:AddToggle('AutoHatchToggle', {
    Text = 'Enable Auto Hatch',
    Default = false,
    Tooltip = 'Toggle to start/stop auto hatching',
    Callback = function(Value)
        getgenv().autoHatch = Value
        if Value then
            startAutoHatch()
        end
        print('Auto Hatch is', Value and 'Enabled' or 'Disabled')
    end
})


HatchGroupBox:AddButton('Refresh Egg List', function()
    local newEggs = getAvailableEggs()
    Options.EggType.Values = newEggs
    Options.EggType:SetValues(newEggs)
    
    if #newEggs > 0 then
        Options.EggType:SetValue(newEggs[1])
    end
    
    print("Egg list refreshed")
end)

Library:OnUnload(function()
    getgenv().autoTap = false
    getgenv().autoRebirth = false
    getgenv().autoHatch = false
    getgenv().autoTeleportToGems = false
    
    if walkspeedConnection then
        walkspeedConnection:Disconnect()
    end
    setWalkspeed(16)
end)

setWalkspeed(Options.WalkSpeedSlider.Value)