-- Neverlose.lua Style Cheat Menu for Roblox
-- Fixed Silent Aim (No Camera Movement)

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
        UseMouseHit = true -- Будет использовать позицию мыши для обмана
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
    }
}

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

-- Game Functions
local function IsTeamMate(player)
    if not Cheats.SilentAim.TeamCheck then return false end
    return LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team
end

local function IsVisible(target, origin)
    if not Cheats.SilentAim.WallCheck then return true end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, target.Parent}
    
    local direction = (target.Position - origin).Unit
    local result = Workspace:Raycast(origin, direction * 1000, params)
    
    return result == nil or result.Instance:IsDescendantOf(target.Parent)
end

local function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = Cheats.SilentAim.FOV
    
    local camera = Workspace.CurrentCamera
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local cameraPos = camera.CFrame.Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not IsTeamMate(player) then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    
                    if distance < closestDistance and IsVisible(head, cameraPos) then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- REAL Silent Aim (без движения камеры)
local function GetClosestTarget()
    if not Cheats.SilentAim.Enabled then return nil end
    
    local targetPlayer = GetClosestPlayer()
    if not targetPlayer or not targetPlayer.Character then return nil end
    
    local targetPart = targetPlayer.Character:FindFirstChild(Cheats.SilentAim.HitPart)
    if not targetPart then return nil end
    
    return targetPart
end

-- Hook для изменения позиции выстрела
local OriginalMouseHit
local function SetupSilentAimHook()
    -- Сохраняем оригинальную функцию мыши
    if not OriginalMouseHit then
        OriginalMouseHit = Mouse.Hit
    end
    
    -- Перехватываем Mouse.Hit
    local __index
    __index = hookmetamethod(game, "__index", function(self, key)
        if self == Mouse and key == "Hit" and Cheats.SilentAim.Enabled then
            local target = GetClosestTarget()
            if target then
                -- Возвращаем позицию цели вместо реальной позиции мыши
                return CFrame.new(target.Position)
            end
        end
        return __index(self, key)
    end)
end

-- Альтернативный метод через перехват RemoteEvents
local function HookRemoteEvents()
    local function HookRemote(remote)
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local oldFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                
                -- Проверяем, связан ли Remote с оружием
                if Cheats.SilentAim.Enabled and string.find(tostring(self.Parent), "Tool") then
                    local target = GetClosestTarget()
                    if target then
                        -- Заменяем позицию выстрела на позицию цели
                        for i, arg in ipairs(args) do
                            if typeof(arg) == "Vector3" then
                                args[i] = target.Position
                            elseif typeof(arg) == "CFrame" then
                                args[i] = CFrame.new(target.Position)
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

-- Speed Hack
local function ApplySpeed()
    if not Cheats.Movement.Speed then return end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Cheats.Movement.SpeedValue
        end
    end
end

-- Bunny Hop
local BunnyHopConnection
local function ToggleBunnyHop()
    if BunnyHopConnection then
        BunnyHopConnection:Disconnect()
        BunnyHopConnection = nil
    end
    
    if Cheats.Movement.BunnyHop then
        BunnyHopConnection = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Running then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end

-- Auto Shoot
local AutoShootConnection
local function ToggleAutoShoot()
    if AutoShootConnection then
        AutoShootConnection:Disconnect()
        AutoShootConnection = nil
    end
    
    if Cheats.SilentAim.AutoShoot then
        AutoShootConnection = RunService.Heartbeat:Connect(function()
            if Cheats.SilentAim.Enabled then
                local target = GetClosestTarget()
                if target then
                    -- Симулируем нажатие мыши
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
                        if remote then
                            remote:FireServer("MouseButton1", "Down", target.Position)
                            task.wait(0.1)
                            remote:FireServer("MouseButton1", "Up", target.Position)
                        end
                    end
                end
            end
        end)
    end
end

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
    
    -- Start main loop
    RunService.Heartbeat:Connect(function()
        ApplySpeed()
    end)
    
    -- Auto update AutoShoot
    Cheats.SilentAim.AutoShoot = false
    ToggleAutoShoot()
    
    print("Neverlose Cheat Loaded Successfully!")
    print("Press INSERT to open/close menu")
    print("Silent Aim: Camera won't move, but bullets will hit targets")
end

-- Start the cheat
Initialize()
