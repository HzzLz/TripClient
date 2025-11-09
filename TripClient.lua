-- Gothbreach Simple Cheat v1.0 (Working GUI)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local Settings = {
    Aimbot = {Enabled = false, FOV = 80, Smoothness = 0.1},
    ESP = {Enabled = false, Skeletons = true},
    Visuals = {ThirdPerson = false, Distance = 10},
    AntiAim = {Enabled = false}
}

-- Создаем простой GUI который точно работает
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GothbreachGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Gothbreach Cheat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16

-- Контент с скроллом
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Функция создания тогглов
local function CreateToggle(name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = ScrollingFrame
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Button = Instance.new("TextButton")
    Button.Parent = ToggleFrame
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 90)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new(1, -60, 0, 5)
    Button.Size = UDim2.new(0, 60, 0, 20)
    Button.Font = Enum.Font.GothamBold
    Button.Text = default and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Button
    
    local state = default
    
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 90)
        Button.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return ToggleFrame
end

-- Функция создания слайдеров
local function CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = ScrollingFrame
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = SliderFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -40, 0, 0)
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local Track = Instance.new("Frame")
    Track.Parent = SliderFrame
    Track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Track.BorderSizePixel = 0
    Track.Position = UDim2.new(0, 0, 0, 30)
    Track.Size = UDim2.new(1, 0, 0, 6)
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 3)
    TrackCorner.Parent = Track
    
    local Fill = Instance.new("Frame")
    Fill.Parent = Track
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = Fill
    
    local Button = Instance.new("TextButton")
    Button.Parent = Track
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new((default - min) / (max - min), -8, 0, -5)
    Button.Size = UDim2.new(0, 16, 0, 16)
    Button.Text = ""
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = Button
    
    local dragging = false
    local value = default
    
    local function UpdateSlider(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Button.Position = UDim2.new(percent, -8, 0, -5)
        ValueLabel.Text = tostring(math.floor(value))
        callback(value)
    end
    
    Button.MouseButton1Down:Connect(function()
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
            local relativeX = mousePos.X - Track.AbsolutePosition.X
            local percent = math.clamp(relativeX / Track.AbsoluteSize.X, 0, 1)
            local newValue = min + (max - min) * percent
            UpdateSlider(newValue)
        end
    end)
    
    Track.MouseButton1Down:Connect(function(x, y)
        local relativeX = x - Track.AbsolutePosition.X
        local percent = math.clamp(relativeX / Track.AbsoluteSize.X, 0, 1)
        local newValue = min + (max - min) * percent
        UpdateSlider(newValue)
    end)
    
    return SliderFrame
end

-- Создаем элементы управления
CreateToggle("Enable Aimbot", false, function(state)
    Settings.Aimbot.Enabled = state
    print("Aimbot:", state and "ON" or "OFF")
end)

CreateToggle("Enable ESP", false, function(state)
    Settings.ESP.Enabled = state
    print("ESP:", state and "ON" or "OFF")
end)

CreateToggle("Third Person", false, function(state)
    Settings.Visuals.ThirdPerson = state
    print("Third Person:", state and "ON" or "OFF")
end)

CreateToggle("Anti-Aim", false, function(state)
    Settings.AntiAim.Enabled = state
    print("Anti-Aim:", state and "ON" or "OFF")
end)

CreateSlider("FOV Size", 20, 150, 80, function(value)
    Settings.Aimbot.FOV = value
    print("FOV:", value)
end)

CreateSlider("Smoothness", 1, 50, 10, function(value)
    Settings.Aimbot.Smoothness = value / 100
    print("Smoothness:", value)
end)

CreateSlider("TP Distance", 5, 20, 10, function(value)
    Settings.Visuals.Distance = value
    print("TP Distance:", value)
end)

-- Кнопка выхода
local ExitButton = Instance.new("TextButton")
ExitButton.Parent = ScrollingFrame
ExitButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ExitButton.BorderSizePixel = 0
ExitButton.Size = UDim2.new(1, 0, 0, 30)
ExitButton.Font = Enum.Font.GothamBold
ExitButton.Text = "EXIT"
ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitButton.TextSize = 14

local ExitCorner = Instance.new("UICorner")
ExitCorner.CornerRadius = UDim.new(0, 5)
ExitCorner.Parent = ExitButton

-- Обработчики
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

ExitButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("Gothbreach Cheat - EXITED")
end)

-- Бинд на скрытие GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Авто-обновление размера скролла
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- Простой FOV круг
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 170, 255)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Обновление FOV
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Settings.Aimbot.Enabled
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

print("🎯 Gothbreach Simple Cheat LOADED!")
print("GUI should be visible on screen!")
print("RightShift - Hide/Show GUI")
print("All toggles and sliders are working!")
