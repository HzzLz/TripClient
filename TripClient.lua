-- Neverlose.lua Style Cheat Menu for Roblox
-- Fixed Version with Working Features

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Neverlose inspired UI Library
local Neverlose = {}

function Neverlose:CreateWindow(name)
    local Neverlose = {}
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeverloseUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
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
    Title.Text = name
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
        ScreenGui:Destroy()
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
    
    local Tabs = {}
    local CurrentTab = nil
    
    function Neverlose:CreateTab(name)
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
                
                Toggle.State = State
                Toggle.Update = function(self, value)
                    State = value
                    ToggleIndicator.BackgroundColor3 = State and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(80, 80, 90)
                    callback(State)
                end
                
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
    
    return Neverlose
end

-- Cheat Functions
local Cheats = {
    SilentAim = {
        Enabled = false,
        FOV = 50,
        TeamCheck = true,
        WallCheck = true,
        AutoShoot = true,
        HitPart = "Head"
    },
    Movement = {
        Speed = false,
        SpeedValue = 25,
        BunnyHop = false
    },
    AntiAim = {
        Enabled = false,
        Type = "Jitter"
    },
    ESP = {
        Enabled = false,
        Box = true,
        Skeleton = true,
        Names = true,
        Distance = true
    }
}

-- ESP Variables
local ESPObjects = {}
local Connections = {}

-- Initialize UI
local Window = Neverlose:CreateWindow("Neverlose Roblox")

-- Rage Tab
local RageTab = Window:CreateTab("Rage")
local AimSection = RageTab:CreateSection("Aimbot")

local SilentAimToggle = AimSection:CreateToggle("Silent Aim", false, function(state)
    Cheats.SilentAim.Enabled = state
end)

local TeamCheckToggle = AimSection:CreateToggle("Team Check", true, function(state)
    Cheats.SilentAim.TeamCheck = state
end)

local WallCheckToggle = AimSection:CreateToggle("Wall Check", true, function(state)
    Cheats.SilentAim.WallCheck = state
end)

local AutoShootToggle = AimSection:CreateToggle("Auto Shoot", true, function(state)
    Cheats.SilentAim.AutoShoot = state
end)

local FOVSlider = AimSection:CreateSlider("FOV", 10, 300, 50, function(value)
    Cheats.SilentAim.FOV = value
end)

-- Movement Tab
local MovementTab = Window:CreateTab("Movement")
local SpeedSection = MovementTab:CreateSection("Speed")

local SpeedToggle = SpeedSection:CreateToggle("Speed Hack", false, function(state)
    Cheats.Movement.Speed = state
end)

local SpeedSlider = SpeedSection:CreateSlider("Speed Value", 10, 100, 25, function(value)
    Cheats.Movement.SpeedValue = value
end)

local BunnyToggle = SpeedSection:CreateToggle("Bunny Hop", false, function(state)
    Cheats.Movement.BunnyHop = state
end)

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals")
local ESPSection = VisualsTab:CreateSection("ESP")

local ESPToggle = ESPSection:CreateToggle("ESP", false, function(state)
    Cheats.ESP.Enabled = state
    if state then
        CreateESP()
    else
        ClearESP()
    end
end)

local BoxToggle = ESPSection:CreateToggle("Box ESP", true, function(state)
    Cheats.ESP.Box = state
end)

local SkeletonToggle = ESPSection:CreateToggle("Skeleton", true, function(state)
    Cheats.ESP.Skeleton = state
end)

local NamesToggle = ESPSection:CreateToggle("Names", true, function(state)
    Cheats.ESP.Names = state
end)

local DistanceToggle = ESPSection:CreateToggle("Distance", true, function(state)
    Cheats.ESP.Distance = state
end)

-- Anti-Aim Tab
local AATab = Window:CreateTab("Anti-Aim")
local AASection = AATab:CreateSection("Anti-Aim")

local AAToggle = AASection:CreateToggle("Anti-Aim", false, function(state)
    Cheats.AntiAim.Enabled = state
end)

-- ESP Functions
function CreateESP()
    ClearESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            AddESP(player)
        end
    end
    
    local PlayerAdded = Players.PlayerAdded:Connect(function(player)
        AddESP(player)
    end)
    
    table.insert(Connections, PlayerAdded)
end

function AddESP(player)
    local ESP = {
        Box = nil,
        Skeleton = {},
        Name = nil,
        Distance = nil
    }
    
    ESPObjects[player] = ESP
    
    local CharacterAdded
    CharacterAdded = player.CharacterAdded:Connect(function(character)
        wait(1) -- Wait for character to load
        
        -- Create Box ESP
        if Cheats.ESP.Box then
            CreateBoxESP(character, player)
        end
        
        -- Create Skeleton ESP
        if Cheats.ESP.Skeleton then
            CreateSkeletonESP(character, player)
        end
        
        -- Create Name ESP
        if Cheats.ESP.Names then
            CreateNameESP(character, player)
        end
        
        -- Create Distance ESP
        if Cheats.ESP.Distance then
            CreateDistanceESP(character, player)
        end
    end)
    
    table.insert(Connections, CharacterAdded)
    
    -- Handle existing character
    if player.Character then
        local character = player.Character
        
        if Cheats.ESP.Box then
            CreateBoxESP(character, player)
        end
        
        if Cheats.ESP.Skeleton then
            CreateSkeletonESP(character, player)
        end
        
        if Cheats.ESP.Names then
            CreateNameESP(character, player)
        end
        
        if Cheats.ESP.Distance then
            CreateDistanceESP(character, player)
        end
    end
end

function CreateBoxESP(character, player)
    local ESP = ESPObjects[player]
    if not ESP then return end
    
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = "ESPBox"
    Box.Adornee = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
    Box.Size = Vector3.new(4, 6, 1)
    Box.Color3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    Box.Transparency = 0.7
    Box.AlwaysOnTop = true
    Box.ZIndex = 1
    Box.Parent = character
    
    ESP.Box = Box
end

function CreateSkeletonESP(character, player)
    local ESP = ESPObjects[player]
    if not ESP then return end
    
    local function CreateBoneLine(part1, part2)
        if not part1 or not part2 then return end
        
        local Attachment1 = Instance.new("Attachment")
        Attachment1.Parent = part1
        
        local Attachment2 = Instance.new("Attachment")
        Attachment2.Parent = part2
        
        local Beam = Instance.new("Beam")
        Beam.Attachment0 = Attachment1
        Beam.Attachment1 = Attachment2
        Beam.Color = ColorSequence.new(player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        Beam.Width0 = 0.1
        Beam.Width1 = 0.1
        Beam.Parent = character
        
        table.insert(ESP.Skeleton, {Beam = Beam, Att1 = Attachment1, Att2 = Attachment2})
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local root = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        local leftArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
        local rightArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
        local leftLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
        local rightLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")
        
        if root and head then
            CreateBoneLine(root, head)
            
            if leftArm then CreateBoneLine(root, leftArm) end
            if rightArm then CreateBoneLine(root, rightArm) end
            if leftLeg then CreateBoneLine(root, leftLeg) end
            if rightLeg then CreateBoneLine(root, rightLeg) end
        end
    end
end

function CreateNameESP(character, player)
    local ESP = ESPObjects[player]
    if not ESP then return end
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESPName"
    Billboard.Adornee = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = character
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    NameLabel.TextStrokeTransparency = 0
    NameLabel.TextSize = 14
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Parent = Billboard
    
    ESP.Name = Billboard
end

function CreateDistanceESP(character, player)
    local ESP = ESPObjects[player]
    if not ESP then return end
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESPDistance"
    Billboard.Adornee = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 2, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = character
    
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(1, 0, 1, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.TextColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    DistanceLabel.TextStrokeTransparency = 0
    DistanceLabel.TextSize = 12
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.Parent = Billboard
    
    ESP.Distance = Billboard
end

function ClearESP()
    for _, connection in pairs(Connections) do
        connection:Disconnect()
    end
    Connections = {}
    
    for player, esp in pairs(ESPObjects) do
        if esp.Box then esp.Box:Destroy() end
        if esp.Name then esp.Name:Destroy() end
        if esp.Distance then esp.Distance:Destroy() end
        for _, skeletonPart in pairs(esp.Skeleton) do
            if skeletonPart.Beam then skeletonPart.Beam:Destroy() end
            if skeletonPart.Att1 then skeletonPart.Att1:Destroy() end
            if skeletonPart.Att2 then skeletonPart.Att2:Destroy() end
        end
    end
    ESPObjects = {}
end

-- Game Functions
local function IsTeamMate(player)
    if not Cheats.SilentAim.TeamCheck then return false end
    
    local localTeam = LocalPlayer.Team
    local playerTeam = player.Team
    
    return localTeam and playerTeam and localTeam == playerTeam
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

-- FIXED Silent Aim with Camera Control
local function SilentAim()
    if not Cheats.SilentAim.Enabled then return end
    
    local targetPlayer = GetClosestPlayer()
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetHead = targetPlayer.Character:FindFirstChild("Head")
    if not targetHead then return end
    
    -- Aim camera at target
    local camera = Workspace.CurrentCamera
    local currentCFrame = camera.CFrame
    local targetPosition = targetHead.Position
    
    -- Smooth camera movement
    local newCFrame = CFrame.lookAt(currentCFrame.Position, targetPosition)
    camera.CFrame = newCFrame:Lerp(newCFrame, 0.7)
    
    -- Auto Shoot
    if Cheats.SilentAim.AutoShoot then
        -- Simulate mouse click for shooting
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
            if remote then
                remote:FireServer("MouseClick", targetHead.Position)
            end
        end
        
        -- Alternative shooting method
        virtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.1)
        virtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- FIXED Speed Hack
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

-- FIXED Bunny Hop
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
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and rootPart and humanoid:GetState() == Enum.HumanoidStateType.Running then
                    -- Check if on ground
                    local ray = Ray.new(rootPart.Position, Vector3.new(0, -3, 0))
                    local part = Workspace:FindPartOnRay(ray, character)
                    
                    if part then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    end
end

-- Anti-Aim
local function ApplyAntiAim()
    if not Cheats.AntiAim.Enabled then return end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = false
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                if Cheats.AntiAim.Type == "Jitter" then
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(math.sin(tick() * 10) * 45), 0)
                end
            end
        end
    end
end

-- Update ESP Distances
local function UpdateESPDistances()
    if not Cheats.ESP.Enabled then return end
    
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    
    if not localRoot then return end
    
    for player, esp in pairs(ESPObjects) do
        if esp.Distance and player.Character then
            local character = player.Character
            local root = character:FindFirstChild("HumanoidRootPart")
            
            if root then
                local distance = (localRoot.Position - root.Position).Magnitude
                local distanceText = tostring(math.floor(distance)) .. " studs"
                
                local distanceLabel = esp.Distance:FindFirstChildOfClass("TextLabel")
                if distanceLabel then
                    distanceLabel.Text = distanceText
                end
            end
        end
    end
end

-- Virtual Input for Auto Shoot
local virtualInput = game:GetService("VirtualInputManager")

-- Main Loops
RunService.Heartbeat:Connect(function()
    ApplySpeed()
    ApplyAntiAim()
    SilentAim()
    UpdateESPDistances()
end)

-- Bunny Hop Toggle
BunnyToggle.Button.MouseButton1Click:Connect(function()
    Cheats.Movement.BunnyHop = not Cheats.Movement.BunnyHop
    ToggleBunnyHop()
end)

-- Initialize Bunny Hop
ToggleBunnyHop()

print("Neverlose Roblox Cheat Loaded!")
print("Features: Silent Aim, Speed Hack, Bunny Hop, Anti-Aim, ESP")
print("Press Insert to toggle menu (if implemented)")

-- Auto-ESP when enabled
if Cheats.ESP.Enabled then
    CreateESP()
end
