-- Gothbreach Premium Cheat v2.1 (Fixed GUI)
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

-- Создаем красивое GUI с правильным расположением
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GothbreachGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.Size = UDim2.new(0, 350, 0, 350)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

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

-- Создаем кнопки вкладок
local AimbotTabBtn = CreateTabButton("Aimbot", 0)
local VisualsTabBtn = CreateTabButton("Visuals", 0.333)
local MovementTabBtn = CreateTabButton("Movement", 0.666)

-- Контейнер контента с ScrollingFrame
local ContentScrollingFrame = Instance.new("ScrollingFrame")
ContentScrollingFrame.Name = "ContentScrollingFrame"
ContentScrollingFrame.Parent = MainFrame
ContentScrollingFrame.BackgroundTransparency = 1
ContentScrollingFrame.Position = UDim2.new(0, 10, 0, 80)
ContentScrollingFrame.Size = UDim2.new(1, -20, 1, -90)
ContentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScrollingFrame.ScrollBarThickness = 3
ContentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentScrollingFrame
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 10)

-- Функция создания тогглов
function CreateToggle(name, defaultState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Parent = ContentScrollingFrame
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.LayoutOrder = #ContentScrollingFrame:GetChildren()

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
    ToggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 90)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -60, 0, 5)
    ToggleButton.Size = UDim2.new(0, 60, 0, 20)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = defaultState and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 11

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleButton

    local state = defaultState

    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 90)
        ToggleButton.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return ToggleFrame
end

-- Функция создания слайдеров
function CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Parent = ContentScrollingFrame
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.LayoutOrder = #ContentScrollingFrame:GetChildren()

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
    SliderTrack.Position = UDim2.new(0, 0, 0, 30)
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
    SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0, -5)
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Text = ""

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton

    local dragging = false
    local value = default

    local function UpdateSlider(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderButton.Position = UDim2.new(percent, -8, 0, -5)
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
            local newValue = min + (max - min) * percent
            UpdateSlider(newValue)
        end
    end)

    SliderTrack.MouseButton1Down:Connect(function(x, y)
        local relativeX = x - SliderTrack.AbsolutePosition.X
        local percent = math.clamp(relativeX / SliderTrack.AbsoluteSize.X, 0, 1)
        local newValue = min + (max - min) * percent
        UpdateSlider(newValue)
    end)

    return SliderFrame
end

-- Создаем элементы для каждой вкладки
local AimbotElements = {}
local VisualsElements = {}
local MovementElements = {}

-- Aimbot Tab Elements
AimbotElements.Toggle1 = CreateToggle("Enable Aimbot", false, function(state)
    Settings.Aimbot.Enabled = state
    print("Aimbot:", state and "ON" or "OFF")
end)

AimbotElements.Toggle2 = CreateToggle("Show FOV Circle", true, function(state)
    Settings.Aimbot.ShowFOV = state
    print("FOV Circle:", state and "ON" or "OFF")
end)

AimbotElements.Slider1 = CreateSlider("FOV Size", 20, 150, 80, function(value)
    Settings.Aimbot.FOV = value
    print("FOV Size:", value)
end)

AimbotElements.Slider2 = CreateSlider("Smoothness", 1, 50, 10, function(value)
    Settings.Aimbot.Smoothness = value / 100
    print("Smoothness:", value)
end)

-- Visuals Tab Elements
VisualsElements.Toggle1 = CreateToggle("Enable ESP", false, function(state)
    Settings.ESP.Enabled = state
    print("ESP:", state and "ON" or "OFF")
end)

VisualsElements.Toggle2 = CreateToggle("Show Skeletons", true, function(state)
    Settings.ESP.Skeletons = state
    print("Skeletons:", state and "ON" or "OFF")
end)

VisualsElements.Toggle3 = CreateToggle("Third Person", false, function(state)
    Settings.Visuals.ThirdPerson = state
    print("Third Person:", state and "ON" or "OFF")
end)

VisualsElements.Slider1 = CreateSlider("TP Distance", 5, 20, 10, function(value)
    Settings.Visuals.Distance = value
    print("TP Distance:", value)
end)

-- Movement Tab Elements
MovementElements.Toggle1 = CreateToggle("Anti-Aim Protection", false, function(state)
    Settings.AntiAim.Enabled = state
    print("Anti-Aim:", state and "ON" or "OFF")
end)

-- Функция обновления отображения вкладок
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
    
    -- Обновляем подсветку кнопок вкладок
    AimbotTabBtn.BackgroundColor3 = (CurrentTab == "Aimbot") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
    VisualsTabBtn.BackgroundColor3 = (CurrentTab == "Visuals") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
    MovementTabBtn.BackgroundColor3 = (CurrentTab == "Movement") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
    
    AimbotTabBtn.TextColor3 = (CurrentTab == "Aimbot") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    VisualsTabBtn.TextColor3 = (CurrentTab == "Visuals") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    MovementTabBtn.TextColor3 = (CurrentTab == "Movement") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
end

-- Закрытие GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Бинд на скрытие GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Инициализация
UpdateTabDisplay()

-- Простой FOV круг для демонстрации
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = Settings.Aimbot.ShowFOV
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 170, 255)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Обновление FOV круга
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Settings.Aimbot.ShowFOV and Settings.Aimbot.Enabled
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Color = Settings.Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 170, 255)
end)

print("🎯 Gothbreach Premium v2.1 LOADED!")
print("RightShift - Hide/Show GUI")
print("Beautiful organized GUI with proper layout!")
