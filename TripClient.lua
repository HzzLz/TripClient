-- Gothbreach Click GUI Cheat v4.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local CheatSettings = {
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        FOV = 80,
        ShowFOV = true,
        Smoothness = 0.2,
        AimPart = "Head"
    },
    
    ESP = {
        Enabled = false,
        TeamCheck = true,
        Skeletons = true
    },
    
    Visuals = {
        ThirdPerson = false,
        ThirdPersonDistance = 10
    },
    
    AntiAim = {
        Enabled = false,
        Pitch = -89
    }
}

-- Хранилище
local ESPObjects = {}
local FOVCircle
local aimbotConnection
local lastTarget = nil
local ClickGUIVisible = false
local originalCameraType = nil

-- Создание Click GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GothbreachGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Visible = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 30)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Gothbreach Cheat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Parent = MainFrame
TabsContainer.BackgroundTransparency = 1
TabsContainer.Position = UDim2.new(0, 0, 0, 35)
TabsContainer.Size = UDim2.new(1, 0, 1, -35)

-- Функции GUI
function toggleClickGUI()
    ClickGUIVisible = not ClickGUIVisible
    MainFrame.Visible = ClickGUIVisible
    
    if ClickGUIVisible then
        MainFrame.Position = UDim2.new(0.5, -150, 0.3, -100)
        MainFrame.Size = UDim2.new(0, 300, 0, 0)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 300, 0, 200),
            Position = UDim2.new(0.5, -150, 0.5, -100)
        })
        tween:Play()
    else
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween = TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 300, 0, 0),
            Position = UDim2.new(0.5, -150, 0.3, -100)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            MainFrame.Visible = false
        end)
    end
end

function createToggle(name, description, callback, parent)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, -20, 0, 25)
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -40, 0, 0)
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.Text = ""
    ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    ToggleButton.TextSize = 14
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleButton
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "ToggleIndicator"
    ToggleIndicator.Parent = ToggleButton
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ToggleIndicator
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "ToggleLabel"
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 12
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = false
    
    local function updateToggle()
        if state then
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 22, 0, 2),
                BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            }):Play()
        else
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            }):Play()
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        callback(state)
    end)
    
    updateToggle()
    return ToggleFrame
end

function createSlider(name, min, max, callback, parent)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame"
    SliderFrame.Parent = parent
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, -20, 0, 40)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "SliderLabel"
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
    SliderLabel.Size = UDim2.new(1, 0, 0, 15)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 12
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Name = "SliderValue"
    SliderValue.Parent = SliderFrame
    SliderValue.BackgroundTransparency = 1
    SliderValue.Position = UDim2.new(1, -40, 0, 0)
    SliderValue.Size = UDim2.new(0, 40, 0, 15)
    SliderValue.Font = Enum.Font.Gotham
    SliderValue.Text = tostring(min)
    SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderValue.TextSize = 12
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "SliderTrack"
    SliderTrack.Parent = SliderFrame
    SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Position = UDim2.new(0, 0, 0, 20)
    SliderTrack.Size = UDim2.new(1, 0, 0, 5)
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 3)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Parent = SliderTrack
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "SliderButton"
    SliderButton.Parent = SliderTrack
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Position = UDim2.new(0, -5, 0, -3)
    SliderButton.Size = UDim2.new(0, 10, 0, 10)
    SliderButton.Font = Enum.Font.SourceSans
    SliderButton.Text = ""
    SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    SliderButton.TextSize = 14
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
    local value = min
    
    local function updateSlider()
        local percentage = (value - min) / (max - min)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderButton.Position = UDim2.new(percentage, -5, 0, -3)
        SliderValue.Text = tostring(math.floor(value))
        callback(value)
    end
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    SliderTrack.MouseButton1Down:Connect(function(x, y)
        local relativeX = x - SliderTrack.AbsolutePosition.X
        local percentage = math.clamp(relativeX / SliderTrack.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * percentage
        updateSlider()
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relativeX = mousePos.X - SliderTrack.AbsolutePosition.X
            local percentage = math.clamp(relativeX / SliderTrack.AbsoluteSize.X, 0, 1)
            value = min + (max - min) * percentage
            updateSlider()
        end
    end)
    
    updateSlider()
    return SliderFrame
end

-- Создание вкладок
local AimbotTab = Instance.new("ScrollingFrame")
AimbotTab.Name = "AimbotTab"
AimbotTab.Parent = TabsContainer
AimbotTab.BackgroundTransparency = 1
AimbotTab.Size = UDim2.new(1, 0, 1, 0)
AimbotTab.CanvasSize = UDim2.new(0, 0, 0, 0)
AimbotTab.ScrollBarThickness = 3

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = AimbotTab
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Visuals Tab
local VisualsTab = Instance.new("ScrollingFrame")
VisualsTab.Name = "VisualsTab"
VisualsTab.Parent = TabsContainer
VisualsTab.BackgroundTransparency = 1
VisualsTab.Size = UDim2.new(1, 0, 1, 0)
VisualsTab.CanvasSize = UDim2.new(0, 0, 0, 0)
VisualsTab.ScrollBarThickness = 3
VisualsTab.Visible = false

local VisualsLayout = Instance.new("UIListLayout")
VisualsLayout.Parent = VisualsTab
VisualsLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisualsLayout.Padding = UDim.new(0, 5)

-- Movement Tab
local MovementTab = Instance.new("ScrollingFrame")
MovementTab.Name = "MovementTab"
MovementTab.Parent = TabsContainer
MovementTab.BackgroundTransparency = 1
MovementTab.Size = UDim2.new(1, 0, 1, 0)
MovementTab.CanvasSize = UDim2.new(0, 0, 0, 0)
MovementTab.ScrollBarThickness = 3
MovementTab.Visible = false

local MovementLayout = Instance.new("UIListLayout")
MovementLayout.Parent = MovementTab
MovementLayout.SortOrder = Enum.SortOrder.LayoutOrder
MovementLayout.Padding = UDim.new(0, 5)

-- Добавление элементов в GUI
-- Aimbot Tab
createToggle("Enable Aimbot", "Включить аимбот", function(state)
    CheatSettings.Aimbot.Enabled = state
    startAimbot()
end, AimbotTab)

createToggle("Show FOV", "Показать FOV круг", function(state)
    CheatSettings.Aimbot.ShowFOV = state
    updateFOVCircle()
end, AimbotTab)

createSlider("FOV Size", 30, 150, function(value)
    CheatSettings.Aimbot.FOV = value
    updateFOVCircle()
end, AimbotTab)

createSlider("Smoothness", 5, 50, function(value)
    CheatSettings.Aimbot.Smoothness = value / 100
end, AimbotTab)

createToggle("Team Check", "Проверка команды", function(state)
    CheatSettings.Aimbot.TeamCheck = state
    CheatSettings.ESP.TeamCheck = state
end, AimbotTab)

-- Visuals Tab
createToggle("Enable ESP", "Включить ESP", function(state)
    CheatSettings.ESP.Enabled = state
    startESP()
end, VisualsTab)

createToggle("Skeletons", "Показать скелеты", function(state)
    CheatSettings.ESP.Skeletons = state
    startESP()
end, VisualsTab)

createToggle("Third Person", "Вид от 3-го лица", function(state)
    CheatSettings.Visuals.ThirdPerson = state
    updateThirdPerson()
end, VisualsTab)

createSlider("TP Distance", 5, 20, function(value)
    CheatSettings.Visuals.ThirdPersonDistance = value
    updateThirdPerson()
end, VisualsTab)

-- Movement Tab
createToggle("Anti-Aim", "Защита от хедшотов", function(state)
    CheatSettings.AntiAim.Enabled = state
    updateAntiAim()
end, MovementTab)

-- Создание кнопок переключения вкладок
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = MainFrame
TabButtons.BackgroundTransparency = 1
TabButtons.Position = UDim2.new(0, 0, 0, 30)
TabButtons.Size = UDim2.new(1, 0, 0, 25)

local function createTabButton(name, targetTab, position)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Parent = TabButtons
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = UDim2.new(0.33, 0, 1, 0)
    button.Font = Enum.Font.Gotham
    button.Text = name
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 12
    
    button.MouseButton1Click:Connect(function()
        AimbotTab.Visible = false
        VisualsTab.Visible = false
        MovementTab.Visible = false
        targetTab.Visible = true
        
        for _, btn in pairs(TabButtons:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

createTabButton("Aimbot", AimbotTab, UDim2.new(0, 0, 0, 0))
createTabButton("Visuals", VisualsTab, UDim2.new(0.33, 0, 0, 0))
createTabButton("Movement", MovementTab, UDim2.new(0.66, 0, 0, 0))

-- Обработчики GUI
CloseButton.MouseButton1Click:Connect(function()
    toggleClickGUI()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleClickGUI()
    end
end)

-- Функции чита
-- FOV Circle
function createFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1
    FOVCircle.Color = Color3.fromRGB(255, 0, 0)
    FOVCircle.Filled = false
    FOVCircle.Radius = CheatSettings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function updateFOVCircle()
    if not FOVCircle then createFOVCircle() end
    
    FOVCircle.Visible = CheatSettings.Aimbot.ShowFOV and CheatSettings.Aimbot.Enabled
    FOVCircle.Radius = CheatSettings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Color = CheatSettings.Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

-- Third Person
function updateThirdPerson()
    if CheatSettings.Visuals.ThirdPerson then
        originalCameraType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Scriptable
        
        RunService:BindToRenderStep("ThirdPerson", Enum.RenderPriority.Camera.Value, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = LocalPlayer.Character.HumanoidRootPart
                local lookVector = rootPart.CFrame.LookVector
                
                Camera.CFrame = CFrame.new(
                    rootPart.Position - lookVector * CheatSettings.Visuals.ThirdPersonDistance,
                    rootPart.Position
                )
            end
        end)
    else
        RunService:UnbindFromRenderStep("ThirdPerson")
        if originalCameraType then
            Camera.CameraType = originalCameraType
        end
    end
end

-- Anti-Aim
function updateAntiAim()
    if CheatSettings.AntiAim.Enabled then
        RunService:BindToRenderStep("AntiAim", Enum.RenderPriority.Character.Value, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local head = LocalPlayer.Character.Head
                local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if rootPart then
                    -- Фиксируем голову близко к телу (защита от хедшотов)
                    head.CFrame = rootPart.CFrame * CFrame.new(0, 1.5, 0)
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("AntiAim")
    end
end

-- Аимбот (упрощенная версия)
function isEnemy(player)
    if not CheatSettings.Aimbot.TeamCheck then return true end
    return player.Team ~= LocalPlayer.Team
end

function isAlive(player)
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

function startAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not CheatSettings.Aimbot.Enabled or not isAlive(LocalPlayer) then 
            lastTarget = nil
            return 
        end
        
        if not lastTarget or tick() % 0.1 > 0.02 then
            local closestTarget = nil
            local closestDistance = CheatSettings.Aimbot.FOV
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and isEnemy(player) and isAlive(player) then
                    local character = player.Character
                    local aimPart = character and character:FindFirstChild(CheatSettings.Aimbot.AimPart)
                    
                    if aimPart then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                        
                        if onScreen then
                            local pos = Vector2.new(screenPos.X, screenPos.Y)
                            local dist = (center - pos).Magnitude
                            
                            if dist < closestDistance then
                                closestDistance = dist
                                closestTarget = aimPart
                            end
                        end
                    end
                end
            end
            
            lastTarget = closestTarget
        end
        
        if lastTarget and lastTarget.Parent then
            local targetChar = lastTarget.Parent
            local player = Players:GetPlayerFromCharacter(targetChar)
            
            if player and isAlive(player) then
                local currentCF = Camera.CFrame
                local targetCF = CFrame.lookAt(currentCF.Position, lastTarget.Position)
                Camera.CFrame = currentCF:Lerp(targetCF, CheatSettings.Aimbot.Smoothness)
            else
                lastTarget = nil
            end
        end
    end)
end

-- ESP (упрощенная версия)
function createSkeleton(player)
    if ESPObjects[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local lines = {}
    local connections = {}
    
    local boneConnections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
    }
    
    for _, bones in pairs(boneConnections) do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1
        line.Color = Color3.fromRGB(255, 0, 0)
        lines[bones[1].."_"..bones[2]] = line
    end
    
    local updateConnection
    local function updateSkeleton()
        if not character or not character.Parent or not isAlive(player) then
            if updateConnection then updateConnection:Disconnect() end
            for _, line in pairs(lines) do
                line:Remove()
            end
            ESPObjects[player] = nil
            return
        end
        
        for bonePair, line in pairs(lines) do
            local bones = bonePair:split("_")
            local fromPart = character:FindFirstChild(bones[1])
            local toPart = character:FindFirstChild(bones[2])
            
            if fromPart and toPart then
                local fromPos, fromVisible = Camera:WorldToViewportPoint(fromPart.Position)
                local toPos, toVisible = Camera:WorldToViewportPoint(toPart.Position)
                
                if fromVisible and toVisible then
                    line.From = Vector2.new(fromPos.X, fromPos.Y)
                    line.To = Vector2.new(toPos.X, toPos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end
    
    updateConnection = RunService.RenderStepped:Connect(updateSkeleton)
    ESPObjects[player] = {
        connection = updateConnection,
        lines = lines
    }
end

function clearESP(player)
    local data = ESPObjects[player]
    if not data then return end
    
    if data.connection then data.connection:Disconnect() end
    for _, line in pairs(data.lines) do
        line:Remove()
    end
    ESPObjects[player] = nil
end

function startESP()
    for player in pairs(ESPObjects) do
        clearESP(player)
    end
    
    if not CheatSettings.ESP.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) then
            createSkeleton(player)
        end
    end
end

-- Автоматическое обновление размеров контента
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    AimbotTab.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

VisualsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    VisualsTab.CanvasSize = UDim2.new(0, 0, 0, VisualsLayout.AbsoluteContentSize.Y)
end)

MovementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MovementTab.CanvasSize = UDim2.new(0, 0, 0, MovementLayout.AbsoluteContentSize.Y)
end)

-- Запуск
createFOVCircle()
startAimbot()

print("🎯 Gothbreach Click GUI v4.0 LOADED!")
print("RightShift - Open/Close GUI")
