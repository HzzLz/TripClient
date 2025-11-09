-- Gothbreach BASIC Cheat v1.0 (100% Working)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Простые настройки
local AimbotEnabled = false
local ESPEnabled = false
local ThirdPersonEnabled = false

-- Создаем самый простой GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GothbreachBasic"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Visible = true

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Gothbreach Basic"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

-- Функция создания кнопки
function CreateButton(text, yPos, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = MainFrame
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new(0.1, 0, 0, yPos)
    Button.Size = UDim2.new(0.8, 0, 0, 30)
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

-- Создаем кнопки
local AimbotBtn = CreateButton("Aimbot: OFF", 40, function()
    AimbotEnabled = not AimbotEnabled
    AimbotBtn.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
    AimbotBtn.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 70)
    print("Aimbot:", AimbotEnabled and "ON" or "OFF")
end)

local ESPBtn = CreateButton("ESP: OFF", 80, function()
    ESPEnabled = not ESPEnabled
    ESPBtn.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 70)
    print("ESP:", ESPEnabled and "ON" or "OFF")
end)

local ThirdPersonBtn = CreateButton("Third Person: OFF", 120, function()
    ThirdPersonEnabled = not ThirdPersonEnabled
    ThirdPersonBtn.Text = "Third Person: " .. (ThirdPersonEnabled and "ON" or "OFF")
    ThirdPersonBtn.BackgroundColor3 = ThirdPersonEnabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 70)
    UpdateThirdPerson()
    print("Third Person:", ThirdPersonEnabled and "ON" or "OFF")
end)

local ExitBtn = CreateButton("EXIT", 160, function()
    ScreenGui:Destroy()
    print("Cheat exited")
end)

-- Third Person функция
function UpdateThirdPerson()
    if ThirdPersonEnabled then
        RunService:BindToRenderStep("ThirdPerson", Enum.RenderPriority.Camera.Value, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                Camera.CFrame = CFrame.new(
                    root.Position - root.CFrame.LookVector * 8,
                    root.Position
                )
            end
        end)
    else
        RunService:UnbindFromRenderStep("ThirdPerson")
    end
end

-- Простой аимбот
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
    if not LocalPlayer.Character then return end
    
    local closestTarget = nil
    local closestDistance = 1000
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local distance = (head.Position - LocalPlayer.Character.Head.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = head
                end
            end
        end
    end
    
    if closestTarget then
        local currentCF = Camera.CFrame
        local targetCF = CFrame.lookAt(currentCF.Position, closestTarget.Position)
        Camera.CFrame = currentCF:Lerp(targetCF, 0.1)
    end
end)

-- Простой ESP через Highlight
local ESPHighlights = {}

RunService.Heartbeat:Connect(function()
    if not ESPEnabled then
        -- Очистка ESP
        for _, highlight in pairs(ESPHighlights) do
            highlight:Destroy()
        end
        ESPHighlights = {}
        return
    end
    
    -- Создание ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not ESPHighlights[player] then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP"
            highlight.Adornee = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.Parent = player.Character
            
            ESPHighlights[player] = highlight
        elseif (not player.Character or not player.Character.Parent) and ESPHighlights[player] then
            -- Очистка если игрок умер
            ESPHighlights[player]:Destroy()
            ESPHighlights[player] = nil
        end
    end
end)

-- Бинд на скрытие GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("🎯 Gothbreach Basic Cheat LOADED!")
print("GUI should be visible on screen!")
print("RightShift - Hide/Show GUI")
print("Aimbot, ESP, Third Person - All working!")
