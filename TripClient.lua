-- Gothbreach Simple Cheat v1.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Простые настройки
local Settings = {
    Aimbot = false,
    ESP = false,
    ThirdPerson = false,
    ShowFOV = true,
    FOV = 80
}

-- Создаем простой GUI который точно работает
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GothbreachSimpleGUI"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Gothbreach Cheat - RightShift to Hide"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Контейнер для кнопок
local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Parent = MainFrame
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Position = UDim2.new(0, 10, 0, 40)
ButtonsFrame.Size = UDim2.new(1, -20, 1, -50)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonsFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Функция создания кнопки
function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Parent = ButtonsFrame
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

-- Создаем кнопки
CreateButton("Aimbot: OFF", function()
    Settings.Aimbot = not Settings.Aimbot
    _G.AimbotEnabled = Settings.Aimbot
    thisButton.Text = "Aimbot: " .. (Settings.Aimbot and "ON" or "OFF")
    thisButton.BackgroundColor3 = Settings.Aimbot and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(80, 80, 80)
end)

CreateButton("ESP: OFF", function()
    Settings.ESP = not Settings.ESP
    _G.ESPEnabled = Settings.ESP
    thisButton.Text = "ESP: " .. (Settings.ESP and "ON" or "OFF")
    thisButton.BackgroundColor3 = Settings.ESP and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(80, 80, 80)
    UpdateESP()
end)

CreateButton("Third Person: OFF", function()
    Settings.ThirdPerson = not Settings.ThirdPerson
    thisButton.Text = "Third Person: " .. (Settings.ThirdPerson and "ON" or "OFF")
    thisButton.BackgroundColor3 = Settings.ThirdPerson and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(80, 80, 80)
    UpdateThirdPerson()
end)

CreateButton("Show FOV: ON", function()
    Settings.ShowFOV = not Settings.ShowFOV
    thisButton.Text = "Show FOV: " .. (Settings.ShowFOV and "ON" or "OFF")
    thisButton.BackgroundColor3 = Settings.ShowFOV and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(80, 80, 80)
end)

CreateButton("EXIT CHEAT", function()
    ScreenGui:Destroy()
    if _G.FOVCircle then _G.FOVCircle:Remove() end
    print("Gothbreach Cheat - EXITED")
end)

-- Простой FOV круг
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = Settings.ShowFOV
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
_G.FOVCircle = FOVCircle

-- Обновление FOV
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Settings.ShowFOV and Settings.Aimbot
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Color = Settings.Aimbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Простой аимбот
function IsEnemy(player)
    if not player.Team then return true end
    return player.Team ~= LocalPlayer.Team
end

function IsAlive(player)
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

RunService.RenderStepped:Connect(function()
    if not Settings.Aimbot or not IsAlive(LocalPlayer) then return end
    
    local closestTarget = nil
    local closestDistance = Settings.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) and IsAlive(player) then
            local character = player.Character
            local head = character and character:FindFirstChild("Head")
            
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local pos = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (center - pos).Magnitude
                    
                    if dist < closestDistance then
                        closestDistance = dist
                        closestTarget = head
                    end
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

-- Простой ESP
local ESPObjects = {}

function UpdateESP()
    -- Очистка старого ESP
    for _, obj in pairs(ESPObjects) do
        if obj then obj:Remove() end
    end
    ESPObjects = {}
    
    if not Settings.ESP then return end
    
    -- Создание ESP для врагов
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP"
                highlight.Adornee = character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.Parent = character
                
                table.insert(ESPObjects, highlight)
            end
        end
    end
end

-- Third Person
function UpdateThirdPerson()
    if Settings.ThirdPerson then
        Camera.CameraType = Enum.CameraType.Scriptable
        RunService:BindToRenderStep("ThirdPerson", Enum.RenderPriority.Camera.Value, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = LocalPlayer.Character.HumanoidRootPart
                Camera.CFrame = CFrame.new(rootPart.Position - rootPart.CFrame.LookVector * 8, rootPart.Position)
            end
        end)
    else
        RunService:UnbindFromRenderStep("ThirdPerson")
        Camera.CameraType = Enum.CameraType.Custom
    end
end

-- Бинд на скрытие GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("🎯 Gothbreach Simple Cheat LOADED!")
print("GUI should be visible on screen!")
print("RightShift - Hide/Show GUI")
