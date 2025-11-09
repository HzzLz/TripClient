-- Neverlose.lua Style Cheat Menu for Roblox
-- With Anti-Recoil & Anti-Spread

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Cheat Functions
local Cheats = {
    SilentAim = {
        Enabled = false,
        FOV = 50,
        TeamCheck = true,
        WallCheck = true,
        AutoShoot = false,
        HitPart = "Head",
        UseMouseHit = true
    },
    Movement = {
        Speed = false,
        SpeedValue = 25,
        BunnyHop = false
    },
    ESP = {
        Enabled = false,
        Box = true,
        Skeleton = true
    },
    -- НОВЫЕ ФУНКЦИИ АНТИ-ОТДАЧИ И АНТИ-РАЗБРОСА
    AntiRecoil = {
        Enabled = false,
        Strength = 50, -- Сила компенсации (1-100)
        VerticalReduction = 80, -- Уменьшение вертикальной отдачи (%)
        HorizontalReduction = 90 -- Уменьшение горизонтальной отдачи (%)
    },
    AntiSpread = {
        Enabled = false,
        Accuracy = 95, -- Точность стрельбы (%)
        FirstShotAccuracy = 100, -- Точность первого выстрела
        NoBloom = true -- Убрать разброс при стрельбе очередями
    }
}

-- Переменные для анти-отдачи
local LastCameraCFrame = nil
local RecoilCompensation = Vector3.zero
local IsFiring = false
local ShotCount = 0
local LastShotTime = 0

-- Menu Variables
local ScreenGui = nil
local MainFrame = nil
local MenuVisible = false

-- Create GUI Function
local function CreateGUI()
    if ScreenGui then
        ScreenGui:Destroy()
    end

    -- Main GUI
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeverloseUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Neverlose Roblox"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = Header

    CloseButton.MouseButton1Click:Connect(function()
        ToggleMenu()
    end)

    -- Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(0, 150, 1, -40)
    TabsContainer.Position = UDim2.new(0, 0, 0, 40)
    TabsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabsContainer.BorderSizePixel = 0
    TabsContainer.Parent = MainFrame

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame

    -- Create Tabs
    local Tabs = {}
    local CurrentTab = nil

    local function CreateTab(name)
        local Tab = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 45))
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
        TabButton.Parent = TabsContainer
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = TabContent
        UIListLayout.Padding = UDim.new(0, 5)
        
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                CurrentTab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
            TabContent.Visible = true
            CurrentTab = Tab
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        
        table.insert(Tabs, Tab)
        
        if #Tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
            TabContent.Visible = true
            CurrentTab = Tab
        end
        
        function Tab:CreateSection(name)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name .. "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Name = "SectionLabel"
            SectionLabel.Size = UDim2.new(1, -10, 1, 0)
            SectionLabel.Position = UDim2.new(0, 10, 0, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = name
            SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 12
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame
            
            function Section:CreateToggle(name, default, callback)
                local Toggle = {}
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name .. "Toggle"
                ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = TabContent
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Size = UDim2.new(0, 120, 1, 0)
                ToggleButton.Position = UDim2.new(0, 10, 0, 0)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = name
                ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                ToggleButton.Font = Enum.Font.Gotham
                ToggleButton.TextSize = 11
                ToggleButton.Parent = ToggleFrame
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "ToggleIndicator"
                ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
                ToggleIndicator.Position = UDim2.new(1, -30, 0.5, -10)
                ToggleIndicator.BackgroundColor3 = default and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(80, 80, 90)
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Parent = ToggleFrame
                
                local State = default
                
                ToggleButton.MouseButton1Click:Connect(function()
                    State = not State
                    ToggleIndicator.BackgroundColor3 = State and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(80, 80, 90)
                    callback(State)
                end)
                
                return Toggle
            end
            
            function Section:CreateSlider(name, min, max, default, callback)
                local Slider = {}
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = name .. "Slider"
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = TabContent
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "SliderLabel"
                SliderLabel.Size = UDim2.new(1, -10, 0, 15)
                SliderLabel.Position = UDim2.new(0, 10, 0, 0)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = name .. ": " .. default
                SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextSize = 11
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "SliderBar"
                SliderBar.Size = UDim2.new(1, -20, 0, 5)
                SliderBar.Position = UDim2.new(0, 10, 1, -15)
                SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = SliderFrame
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "SliderButton"
                SliderButton.Size = UDim2.new(0, 15, 0, 15)
                SliderButton.Position = UDim2.new((default - min) / (max - min), -7.5, 0.5, -7.5)
                SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderButton.BorderSizePixel = 0
                SliderButton.Text = ""
                SliderButton.Parent = SliderBar
                
                local Value = default
                local Dragging = false
                
                local function UpdateSlider(input)
                    local relativeX = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                    relativeX = math.clamp(relativeX, 0, 1)
                    
                    Value = math.floor(min + (max - min) * relativeX)
                    SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    SliderButton.Position = UDim2.new(relativeX, -7.5, 0.5, -7.5)
                    SliderLabel.Text = name .. ": " .. Value
                    
                    callback(Value)
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    Dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
                
                return Slider
            end
            
            return Section
        end
        
        return Tab
    end

    -- Create actual tabs
    local RageTab = CreateTab("Rage")
    local AimSection = RageTab:CreateSection("Silent Aim")

    local SilentAimToggle = AimSection:CreateToggle("Silent Aim", false, function(state)
        Cheats.SilentAim.Enabled = state
        print("Silent Aim:", state)
    end)

    local TeamCheckToggle = AimSection:CreateToggle("Team Check", true, function(state)
        Cheats.SilentAim.TeamCheck = state
    end)

    local WallCheckToggle = AimSection:CreateToggle("Wall Check", true, function(state)
        Cheats.SilentAim.WallCheck = state
    end)

    local AutoShootToggle = AimSection:CreateToggle("Auto Shoot", false, function(state)
        Cheats.SilentAim.AutoShoot = state
    end)

    local FOVSlider = AimSection:CreateSlider("FOV", 10, 300, 50, function(value)
        Cheats.SilentAim.FOV = value
    end)

    -- НОВАЯ СЕКЦИЯ: Анти-отдача и анти-разброс
    local RecoilSection = RageTab:CreateSection("Recoil & Spread")

    local AntiRecoilToggle = RecoilSection:CreateToggle("Anti-Recoil", false, function(state)
        Cheats.AntiRecoil.Enabled = state
        print("Anti-Recoil:", state)
    end)

    local RecoilStrengthSlider = RecoilSection:CreateSlider("Recoil Strength", 1, 100, 50, function(value)
        Cheats.AntiRecoil.Strength = value
    end)

    local VerticalRecoilSlider = RecoilSection:CreateSlider("Vertical Reduction", 0, 100, 80, function(value)
        Cheats.AntiRecoil.VerticalReduction = value
    end)

    local HorizontalRecoilSlider = RecoilSection:CreateSlider("Horizontal Reduction", 0, 100, 90, function(value)
        Cheats.AntiRecoil.HorizontalReduction = value
    end)

    local AntiSpreadToggle = RecoilSection:CreateToggle("Anti-Spread", false, function(state)
        Cheats.AntiSpread.Enabled = state
        print("Anti-Spread:", state)
    end)

    local AccuracySlider = RecoilSection:CreateSlider("Accuracy", 50, 100, 95, function(value)
        Cheats.AntiSpread.Accuracy = value
    end)

    local FirstShotSlider = RecoilSection:CreateSlider("First Shot Accuracy", 80, 100, 100, function(value)
        Cheats.AntiSpread.FirstShotAccuracy = value
    end)

    local NoBloomToggle = RecoilSection:CreateToggle("No Bloom", true, function(state)
        Cheats.AntiSpread.NoBloom = state
    end)

    -- Movement Tab
    local MovementTab = CreateTab("Movement")
    local SpeedSection = MovementTab:CreateSection("Movement")

    local SpeedToggle = SpeedSection:CreateToggle("Speed Hack", false, function(state)
        Cheats.Movement.Speed = state
        print("Speed Hack:", state)
    end)

    local SpeedSlider = SpeedSection:CreateSlider("Speed Value", 10, 100, 25, function(value)
        Cheats.Movement.SpeedValue = value
    end)

    local BunnyToggle = SpeedSection:CreateToggle("Bunny Hop", false, function(state)
        Cheats.Movement.BunnyHop = state
        ToggleBunnyHop()
    end)

    -- Make window draggable
    local Dragging = false
    local DragInput, DragStart, StartPos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    print("GUI Created Successfully!")
end

-- Menu Toggle Function
local function ToggleMenu()
    if not MainFrame then
        CreateGUI()
    end
    
    MenuVisible = not MenuVisible
    MainFrame.Visible = MenuVisible
    
    if MenuVisible then
        print("Menu Opened")
    else
        print("Menu Closed")
    end
end

-- Insert Key Bind
local function SetupInsertBind()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Insert then
            ToggleMenu()
        end
    end)
end

-- НОВЫЕ ФУНКЦИИ АНТИ-ОТДАЧИ И АНТИ-РАЗБРОСА

-- Функция для определения, стреляет ли игрок
local function IsPlayerShooting()
    local character = LocalPlayer.Character
    if not character then return false end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return false end
    
    -- Проверяем анимации или звуки выстрела
    for _, sound in pairs(tool:GetDescendants()) do
        if sound:IsA("Sound") and sound.Playing then
            if string.find(sound.Name:lower(), "fire") or string.find(sound.Name:lower(), "shoot") then
                return true
            end
        end
    end
    
    -- Проверяем частицы выстрела
    for _, particle in pairs(tool:GetDescendants()) do
        if particle:IsA("ParticleEmitter") and particle.Enabled then
            return true
        end
    end
    
    return false
end

-- Функция компенсации отдачи
local function ApplyAntiRecoil()
    if not Cheats.AntiRecoil.Enabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Определяем, стреляет ли игрок
    local shooting = IsPlayerShooting()
    
    if shooting then
        if not IsFiring then
            -- Начало стрельбы
            IsFiring = true
            ShotCount = 0
            LastCameraCFrame = Camera.CFrame
        end
        
        ShotCount = ShotCount + 1
        
        -- Вычисляем компенсацию отдачи на основе настроек
        local verticalCompensation = Cheats.AntiRecoil.VerticalReduction / 100
        local horizontalCompensation = Cheats.AntiRecoil.HorizontalReduction / 100
        local strength = Cheats.AntiRecoil.Strength / 100
        
        -- Симуляция отдачи (зависит от количества выстрелов)
        local simulatedRecoil = Vector3.new(
            (math.random() - 0.5) * 0.1 * (1 - horizontalCompensation) * strength,
            -math.random() * 0.15 * (1 - verticalCompensation) * strength,
            0
        ) * (ShotCount * 0.1 + 1)
        
        -- Применяем компенсацию к камере
        RecoilCompensation = RecoilCompensation + simulatedRecoil
        
    else
        -- Конец стрельбы, сбрасываем состояние
        IsFiring = false
        ShotCount = 0
        
        -- Плавно возвращаем камеру в исходное положение
        if RecoilCompensation.Magnitude > 0.01 then
            RecoilCompensation = RecoilCompensation:Lerp(Vector3.zero, 0.3)
        else
            RecoilCompensation = Vector3.zero
        end
    end
    
    -- Применяем компенсацию к камере
    if RecoilCompensation.Magnitude > 0 then
        Camera.CFrame = Camera.CFrame * CFrame.new(RecoilCompensation)
    end
end

-- Функция для уменьшения разброса
local function ApplyAntiSpread()
    if not Cheats.AntiSpread.Enabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    -- Уменьшаем разброс через изменение свойств оружия
    for _, part in pairs(tool:GetDescendants()) do
        -- Уменьшаем разброс у ParticleEmitter (эффекты выстрела)
        if part:IsA("ParticleEmitter") and Cheats.AntiSpread.NoBloom then
            part.SpreadAngle = NumberRange.new(0, math.max(0, part.SpreadAngle.Max * (1 - Cheats.AntiSpread.Accuracy / 100)))
        end
        
        -- Уменьшаем разброс у Beam (лучи)
        if part:IsA("Beam") then
            part.Width0 = math.max(0.01, part.Width0 * (Cheats.AntiSpread.Accuracy / 100))
            part.Width1 = math.max(0.01, part.Width1 * (Cheats.AntiSpread.Accuracy / 100))
        end
    end
end

-- Перехват выстрелов для применения анти-разброса
local function HookWeaponSpread()
    local function HookRemote(remote)
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local oldFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                
                if Cheats.AntiSpread.Enabled and string.find(tostring(self.Parent), "Tool") then
                    -- Применяем анти-разброс к аргументам выстрела
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            -- Увеличиваем точность первого выстрела
                            if ShotCount == 0 then
                                local accuracyMod = Cheats.AntiSpread.FirstShotAccuracy / 100
                                args[i] = args[i] * accuracyMod
                            else
                                local accuracyMod = Cheats.AntiSpread.Accuracy / 100
                                local randomOffset = Vector3.new(
                                    (math.random() - 0.5) * (1 - accuracyMod) * 0.1,
                                    (math.random() - 0.5) * (1 - accuracyMod) * 0.1,
                                    (math.random() - 0.5) * (1 - accuracyMod) * 0.1
                                )
                                args[i] = args[i] + randomOffset
                            end
                        end
                    end
                end
                
                return oldFireServer(self, unpack(args))
            end
        end
    end
    
    -- Хукуем существующие RemoteEvents
    for _, obj in pairs(Workspace:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and string.find(tostring(obj.Parent), "Tool") then
            HookRemote(obj)
        end
    end
    
    -- Хукуем новые RemoteEvents
    Workspace.DescendantAdded:Connect(function(obj)
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and string.find(tostring(obj.Parent), "Tool") then
            wait(0.1)
            HookRemote(obj)
        end
    end)
end

-- Остальные функции остаются без изменений...

-- Initialize everything
local function Initialize()
    print("Initializing Neverlose Cheat...")
    
    -- Create GUI
    CreateGUI()
    
    -- Setup Insert bind
    SetupInsertBind()
    
    -- Setup Silent Aim hooks
    SetupSilentAimHook()
    HookRemoteEvents()
    HookWeaponSpread() -- НОВЫЙ ХУК ДЛЯ АНТИ-РАЗБРОСА
    
    -- Start main loop
    RunService.Heartbeat:Connect(function()
        ApplySpeed()
        ApplyAntiRecoil() -- НОВАЯ ФУНКЦИЯ АНТИ-ОТДАЧИ
        ApplyAntiSpread() -- НОВАЯ ФУНКЦИЯ АНТИ-РАЗБРОСА
    end)
    
    print("Neverlose Cheat Loaded Successfully!")
    print("Press INSERT to open/close menu")
    print("New Features: Anti-Recoil & Anti-Spread")
end

-- Start the cheat
Initialize()
