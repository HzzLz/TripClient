-- === Neverlose.lua - Advanced Cheat for Roblox ===
-- Silent Aim | Speed | Bunny Hop | ESP | FOV | Config Save
-- Author: GigaCode | Enhanced Version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- === CHEAT CONFIGURATION ===
local Cheats = {
    SilentAim = {
        Enabled = false,
        FOV = 100,
        TeamCheck = true,
        WallCheck = true,
        AutoShoot = false,
        HitPart = "Head",
        Priority = "Crosshair", -- Crosshair, Distance, Health, Random
        ShowFOV = true
    },
    Movement = {
        Speed = false,
        SpeedValue = 25,
        BunnyHop = false
    },
    ESP = {
        Enabled = false,
        Box = true,
        Name = true,
        Health = true,
        Tracer = false,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1.5,
        Filled = false
    },
    Menu = {
        Key = Enum.KeyCode.Insert,
        Visible = false
    }
}

-- === CACHE & STATE ===
local PlayersList = Players:GetPlayers()
local ESPElements = {}
local OriginalWalkSpeed = 16
local FOVCircle = nil
local AutoShootConnection = nil
local BunnyHopConnection = nil
local ScreenGui = nil
local MainFrame = nil

-- === UTILS ===
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

-- === SILENT AIM LOGIC ===
local function GetClosestPlayer()
    if not Cheats.SilentAim.Enabled then return nil end
    local bestPlayer = nil
    local bestScore = math.huge
    local camera = Workspace.CurrentCamera
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local cameraPos = camera.CFrame.Position

    for _, player in ipairs(PlayersList) do
        if player == LocalPlayer or not player.Character then continue end
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local head = player.Character:FindFirstChild("Head")
        if not humanoid or humanoid.Health <= 0 or not head then continue end
        if IsTeamMate(player) then continue end

        local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end

        local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
        if screenDistance > Cheats.SilentAim.FOV then continue end
        if not IsVisible(head, cameraPos) then continue end

        local score = screenDistance

        if Cheats.SilentAim.Priority == "Distance" then
            score = (head.Position - cameraPos).Magnitude
        elseif Cheats.SilentAim.Priority == "Health" then
            score = (1 - (humanoid.Health / humanoid.MaxHealth)) * 1000 + screenDistance
        elseif Cheats.SilentAim.Priority == "Random" then
            score = math.random()
        end

        if score < bestScore then
            bestScore = score
            bestPlayer = player
        end
    end

    return bestPlayer
end

local function GetClosestTarget()
    local targetPlayer = GetClosestPlayer()
    if not targetPlayer or not targetPlayer.Character then return nil end
    local targetPart = targetPlayer.Character:FindFirstChild(Cheats.SilentAim.HitPart)
    return targetPart
end

-- === HOOK SYSTEM ===
local function SetupSilentAimHook()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if self == Mouse and key == "Hit" and Cheats.SilentAim.Enabled then
            local target = GetClosestTarget()
            if target then
                return CFrame.new(target.Position)
            end
        end
        return oldIndex(self, key)
    end)
end

local function HookRemoteEvents()
    local function HookRemote(remote)
        if not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then return end
        local oldFire = remote.FireServer
        remote.FireServer = newcclosure(function(self, ...)
            local args = {...}
            if Cheats.SilentAim.Enabled and string.find(self:GetFullName(), "Weapon") or string.find(self:GetFullName(), "Tool") then
                local target = GetClosestTarget()
                if target then
                    for i, v in ipairs(args) do
                        if typeof(v) == "Vector3" then
                            args[i] = target.Position
                        elseif typeof(v) == "CFrame" then
                            args[i] = CFrame.new(target.Position)
                        end
                    end
                end
            end
            return oldFire(self, unpack(args))
        end)
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        pcall(HookRemote, obj)
    end

    Workspace.DescendantAdded:Connect(function(obj)
        task.delay(0.1, function()
            pcall(HookRemote, obj)
        end)
    end)
end

-- === MOVEMENT HACKS ===
local function ApplySpeed()
    if not Cheats.Movement.Speed then return end
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.WalkSpeed ~= Cheats.Movement.SpeedValue then
            humanoid.WalkSpeed = Cheats.Movement.SpeedValue
        end
    end
end

local function ToggleBunnyHop(state)
    if BunnyHopConnection then
        BunnyHopConnection:Disconnect()
        BunnyHopConnection = nil
    end
    if state then
        BunnyHopConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Running then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- === AUTO SHOOT ===
local function ToggleAutoShoot(state)
    if AutoShootConnection then
        AutoShootConnection:Disconnect()
        AutoShootConnection = nil
    end
    if state then
        AutoShootConnection = RunService.Heartbeat:Connect(function()
            if not Cheats.SilentAim.Enabled or not Cheats.SilentAim.AutoShoot then return end
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if not tool then return end
            local remote = tool:FindFirstChildWhichIsA("RemoteEvent") or tool:FindFirstChildWhichIsA("RemoteFunction")
            if not remote then return end
            local target = GetClosestTarget()
            if target then
                remote:FireServer("MouseButton1", "Down", target.Position)
                task.wait(0.05)
                remote:FireServer("MouseButton1", "Up", target.Position)
            end
        end)
    end
end

-- === ESP SYSTEM ===
local function CreateESP(player)
    if ESPElements[player] then return end
    local esp = {
        Box = Drawing.new("Quad"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    esp.Box.Visible = false
    esp.Box.PointA = Vector2.new(0, 0)
    esp.Box.PointB = Vector2.new(0, 0)
    esp.Box.PointC = Vector2.new(0, 0)
    esp.Box.PointD = Vector2.new(0, 0)
    esp.Box.Color = Cheats.ESP.Color
    esp.Box.Thickness = Cheats.ESP.Thickness
    esp.Box.Filled = Cheats.ESP.Filled

    esp.Name.Visible = false
    esp.Name.Size = 14
    esp.Name.Color = Cheats.ESP.Color
    esp.Name.Outline = true
    esp.Name.Center = true

    esp.Health.Visible = false
    esp.Health.Size = 12
    esp.Health.Color = Color3.fromRGB(0, 255, 0)
    esp.Health.Outline = true

    esp.Tracer.Visible = false
    esp.Tracer.From = Vector2.new(Mouse.X, Mouse.Y)
    esp.Tracer.To = Vector2.new(0, 0)
    esp.Tracer.Color = Cheats.ESP.Color
    esp.Tracer.Thickness = 1.5

    ESPElements[player] = esp
end

local function UpdateESP()
    for player, esp in pairs(ESPElements) do
        local char = player.Character
        if not char or not player.Character:FindFirstChild("Head") then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Health.Visible = false
            esp.Tracer.Visible = false
            continue
        end

        local head, headVis = Camera:WorldToViewportPoint(char.Head.Position)
        local root, rootVis = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
        local hum = char:FindFirstChildOfClass("Humanoid")

        if headVis and rootVis then
            local height = math.abs(head.Y - root.Y)
            local width = height * 0.6
            local top = Vector2.new(head.X - width/2, head.Y - height)
            local bottom = Vector2.new(head.X + width/2, head.Y)

            esp.Box.Visible = Cheats.ESP.Enabled and Cheats.ESP.Box
            esp.Box.PointA = top
            esp.Box.PointB = Vector2.new(bottom.X, top.Y)
            esp.Box.PointC = bottom
            esp.Box.PointD = Vector2.new(top.X, bottom.Y)
            esp.Box.Color = Cheats.ESP.Color

            esp.Name.Visible = Cheats.ESP.Enabled and Cheats.ESP.Name
            esp.Name.Position = Vector2.new(head.X, top.Y - 15)
            esp.Name.Text = player.Name

            esp.Health.Visible = Cheats.ESP.Enabled and Cheats.ESP.Health
            esp.Health.Position = Vector2.new(head.X, bottom.Y + 5)
            esp.Health.Text = tostring(math.floor(hum.Health))

            esp.Tracer.Visible = Cheats.ESP.Enabled and Cheats.ESP.Tracer
            esp.Tracer.To = Vector2.new(head.X, head.Y)
        else
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Health.Visible = false
            esp.Tracer.Visible = false
        end
    end
end

-- === FOV CIRCLE ===
local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = Cheats.SilentAim.Enabled and Cheats.SilentAim.ShowFOV
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 60
    FOVCircle.Filled = false
    FOVCircle.Radius = Cheats.SilentAim.FOV
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
end

-- === CONFIG SAVE/LOAD ===
local function SaveConfig()
    local data = {
        SilentAim = Cheats.SilentAim,
        Movement = Cheats.Movement,
        ESP = Cheats.ESP
    }
    pcall(function()
        writefile("neverlose_config.json", HttpService:JSONEncode(data))
    end)
end

local function LoadConfig()
    if not isfile("neverlose_config.json") then return end
    local content = readfile("neverlose_config.json")
    local data = HttpService:JSONDecode(content)
    for k, v in pairs(data.SilentAim) do Cheats.SilentAim[k] = v end
    for k, v in pairs(data.Movement) do Cheats.Movement[k] = v end
    for k, v in pairs(data.ESP) do Cheats.ESP[k] = v end
end

-- === GUI SYSTEM (simplified) ===
local function CreateGUI()
    if ScreenGui then ScreenGui:Destroy() end
    ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false

    -- Header
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Header.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Neverlose Roblox"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    local Close = Instance.new("TextButton", Header)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Close.Text = "X"
    Close.Font = Enum.Font.GothamBold
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        Cheats.Menu.Visible = false
    end)

    -- Tabs
    local Tabs = Instance.new("Frame", MainFrame)
    Tabs.Size = UDim2.new(0, 150, 1, -40)
    Tabs.Position = UDim2.new(0, 0, 0, 40)
    Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Tabs.BorderSizePixel = 0

    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -150, 1, -40)
    Content.Position = UDim2.new(0, 150, 0, 40)
    Content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Content.BorderSizePixel = 0

    -- Tab Creation
    local function NewTab(name)
        local button = Instance.new("TextButton", Tabs)
        button.Size = UDim2.new(1, -10, 0, 40)
        button.Position = UDim2.new(0, 5, 0, 5 + (#Tabs:GetChildren() - 1) * 45)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        button.Text = name
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.Font = Enum.Font.Gotham

        local frame = Instance.new("ScrollingFrame", Content)
        frame.Size = UDim2.new(1, -20, 1, -20)
        frame.Position = UDim2.new(0, 10, 0, 10)
        frame.BackgroundTransparency = 1
        frame.Visible = false
        frame.ScrollBarThickness = 5

        local layout = Instance.new("UIListLayout", frame)
        layout.Padding = UDim.new(0, 5)

        button.MouseButton1Click:Connect(function()
            for _, child in ipairs(Content:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            frame.Visible = true
        end)

        if #Content:GetChildren() == 1 then
            frame.Visible = true
        end

        return {
            AddToggle = function(text, def, callback)
                local t = Instance.new("Frame", frame)
                t.Size = UDim2.new(1, 0, 0, 30)
                t.BackgroundTransparency = 1

                local b = Instance.new("TextButton", t)
                b.Size = UDim2.new(0, 120, 1, 0)
                b.Position = UDim2.new(0, 10, 0, 0)
                b.Text = text
                b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                b.TextColor3 = Color3.fromRGB(200, 200, 200)

                local ind = Instance.new("Frame", t)
                ind.Size = UDim2.new(0, 20, 0, 20)
                ind.Position = UDim2.new(1, -30, 0.5, -10)
                ind.BackgroundColor3 = def and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(80, 80, 90)

                local state = def
                b.MouseButton1Click:Connect(function()
                    state = not state
                    ind.BackgroundColor3 = state and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(80, 80, 90)
                    callback(state)
                end)
            end,
            AddSlider = function(text, min, max, def, callback)
                -- (реализация слайдера аналогично)
            end
        }
    end

    -- Пример добавления табов (упрощённо)
    local Rage = NewTab("Rage")
    Rage.AddToggle("Silent Aim", Cheats.SilentAim.Enabled, function(v) Cheats.SilentAim.Enabled = v end)
    Rage.AddToggle("Auto Shoot", Cheats.SilentAim.AutoShoot, function(v) Cheats.SilentAim.AutoShoot = v ToggleAutoShoot(v) end)

    -- Перетаскивание
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- === INIT ===
local function Initialize()
    LoadConfig()
    CreateGUI()
    CreateFOVCircle()
    SetupSilentAimHook()
    HookRemoteEvents()

    for _, player in ipairs(PlayersList) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        table.insert(PlayersList, player)
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Cheats.Menu.Key then
            MainFrame.Visible = not MainFrame.Visible
            Cheats.Menu.Visible = MainFrame.Visible
        end
    end)

    RunService.RenderStepped:Connect(function()
        ApplySpeed()
        UpdateESP()
        if FOVCircle then
            FOVCircle.Visible = Cheats.SilentAim.Enabled and Cheats.SilentAim.ShowFOV
            FOVCircle.Radius = Cheats.SilentAim.FOV
            FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        end
    end)

    print("Neverlose Loaded. Press INSERT to open menu.")
    SaveConfig() -- авто-сохранение при старте
end

Initialize()
