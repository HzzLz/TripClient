-- Gothbreach Premium Cheat v2.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local Settings = {
    Aimbot = {Enabled = false, FOV = 80, Smoothness = 0.1, ShowFOV = true},
    ESP = {Enabled = false, Skeletons = true},
    Visuals = {ThirdPerson = false, Distance = 10},
    AntiAim = {Enabled = false}
}

-- Создаем красивое GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GothbreachPremiumGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.Parent = MainFrame
DropShadow.BackgroundTransparency = 1
DropShadow.BorderSizePixel = 0
DropShadow.Size = UDim2.new(1, 0, 1, 0)
DropShadow.ZIndex = -1
DropShadow.Image = "rbxassetid://6015897843"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.5
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

-- Заголовок
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 40)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Gothbreach Premium"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -30, 0, 10)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

-- Вкладки
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.Size = UDim2.new(1, 0, 0, 30)

local Tabs = {"Aimbot", "Visuals", "Movement"}
local CurrentTab = "Aimbot"

local function CreateTabButton(name, xPos)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TabButton.BorderSizePixel = 0
    TabButton.Position = UDim2.new(xPos, 0, 0, 0)
    TabButton.Size = UDim2.new(0.333, 0, 1, 0)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 12
    
    TabButton.MouseButton1Click:Connect(function()
        CurrentTab = name
        UpdateTabDisplay()
    end)
    
    return TabButton
end

for i, tabName in ipairs(Tabs) do
    CreateTabButton(tabName, (i-1) * 0.333)
end

-- Контент
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 10, 0, 80)
ContentFrame.Size = UDim2.new(1, -20, 1, -90)

-- Функции для элементов UI
function CreateToggle(name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Parent = ContentFrame
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Button"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 90)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -50, 0, 5)
    ToggleButton.Size = UDim2.new(0, 50, 0, 20)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = default and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 11
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newState = not default
        default = newState
        ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 90)
        ToggleButton.Text = newState and "ON" or "OFF"
        callback(newState)
    end)
    
    return ToggleFrame
end

function CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Parent = ContentFrame
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
    SliderLabel.Size = UDim2.new(0, 200, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 13
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "Value"
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -40, 0, 0)
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "Track"
    SliderTrack.Parent = SliderFrame
    SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Position = UDim2.new(0, 0, 0, 25)
    SliderTrack.Size = UDim2.new(1, 0, 0, 6)
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 3)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Parent = SliderTrack
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "Button"
    SliderButton.Parent = SliderTrack
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Position = UDim2.new((default - min) / (max - min), -6, 0, -4)
    SliderButton.Size = UDim2.new(0, 12, 0, 12)
    SliderButton.Text = ""
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
    local dragging = false
    
    local function UpdateSlider(value)
        value = math.clamp(value, min, max)
        local percent = (value - min) / (max - min)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderButton.Position = UDim2.new(percent, -6, 0, -4)
        ValueLabel.Text = tostring(math.floor(value))
        callback(value)
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relativeX = mousePos.X - SliderTrack.AbsolutePosition.X
            local percent = math.clamp(relativeX / SliderTrack.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            UpdateSlider(value)
        end
    end)
    
    return SliderFrame
end

-- Создаем элементы управления
local AimbotElements = {}
local VisualsElements = {}
local MovementElements = {}

-- Aimbot Tab
AimbotElements.Toggle1 = CreateToggle("Enable Aimbot", false, function(state)
    Settings.Aimbot.Enabled = state
    UpdateAimbot()
end)

AimbotElements.Toggle2 = CreateToggle("Show FOV Circle", true, function(state)
    Settings.Aimbot.ShowFOV = state
    UpdateFOVCircle()
end)

AimbotElements.Slider1 = CreateSlider("FOV Size", 20, 150, 80, function(value)
    Settings.Aimbot.FOV = value
    UpdateFOVCircle()
end)

AimbotElements.Slider2 = CreateSlider("Smoothness", 1, 50, 10, function(value)
    Settings.Aimbot.Smoothness = value / 100
end)

-- Visuals Tab
VisualsElements.Toggle1 = CreateToggle("Enable ESP", false, function(state)
    Settings.ESP.Enabled = state
    UpdateESP()
end)

VisualsElements.Toggle2 = CreateToggle("Skeletons", true, function(state)
    Settings.ESP.Skeletons = state
    UpdateESP()
end)

VisualsElements.Toggle3 = CreateToggle("Third Person", false, function(state)
    Settings.Visuals.ThirdPerson = state
    UpdateThirdPerson()
end)

VisualsElements.Slider1 = CreateSlider("TP Distance", 5, 20, 10, function(value)
    Settings.Visuals.Distance = value
    UpdateThirdPerson()
end)

-- Movement Tab
MovementElements.Toggle1 = CreateToggle("Anti-Aim", false, function(state)
    Settings.AntiAim.Enabled = state
    UpdateAntiAim()
end)

-- Функция обновления вкладок
function UpdateTabDisplay()
    for _, element in pairs(AimbotElements) do
        element.Visible = (CurrentTab == "Aimbot")
    end
    for _, element in pairs(VisualsElements) do
        element.Visible = (CurrentTab == "Visuals")
    end
    for _, element in pairs(MovementElements) do
        element.Visible = (CurrentTab == "Movement")
    end
end

-- Закрытие GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Бинд на скрытие
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Инициализация
UpdateTabDisplay()

-- Функции чита (упрощенные)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = Settings.Aimbot.ShowFOV
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 170, 255)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

function UpdateFOVCircle()
    FOVCircle.Visible = Settings.Aimbot.ShowFOV and Settings.Aimbot.Enabled
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function UpdateAimbot()
    -- Аимбот логика здесь
end

function UpdateESP()
    -- ESP логика здесь
end

function UpdateThirdPerson()
    -- Third Person логика здесь
end

function UpdateAntiAim()
    -- Anti-Aim логика здесь
end

-- Обновление FOV
RunService.RenderStepped:Connect(UpdateFOVCircle)

print("🎯 Gothbreach Premium v2.0 LOADED!")
print("RightShift - Hide/Show GUI")
print("Beautiful GUI with working toggles!")
