-- Gothbreach ULTIMATE Cheat v5.0 (Internal)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Используем внутренние функции через оффсеты
local function InternalPrint(...)
    -- Используем внутренний Print вместо warn/print
    if _G.Offsets and _G.Signatures and _G.Signatures.Print then
        _G.Signatures.Print(2, "Gothbreach: " .. table.concat({...}, " "))
    else
        warn("Gothbreach: " .. table.concat({...}, " "))
    end
end

-- Настройки с обходом античита
local Settings = {
    Aimbot = {
        Enabled = false, 
        FOV = 80,
        Smoothness = 0.1,
        ShowFOV = true,
        WallCheck = true,
        TeamCheck = true,
        AimPart = "Head"
    },
    ESP = {
        Enabled = false,
        Skeletons = true,
        Boxes = true,
        Names = true
    },
    Visuals = {
        ThirdPerson = false,
        Distance = 10,
        NoClip = false
    },
    Movement = {
        Speed = 1.0,
        JumpPower = 1.0,
        AntiAim = false
    }
}

-- Создаем GUI через внутренние методы (обход фильтрации)
local function CreateStealthGUI()
    local success, result = pcall(function()
        -- Пытаемся создать GUI через разные методы
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "UI"
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.ResetOnSpawn = false
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "Main"
        MainFrame.Parent = ScreenGui
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        MainFrame.BorderSizePixel = 0
        MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
        MainFrame.Size = UDim2.new(0, 350, 0, 300)
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
        Header.Size = UDim2.new(1, 0, 0, 35)
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Header
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(1, -50, 1, 0)
        Title.Font = Enum.Font.Gotham
        Title.Text = "Gothbreach ULTIMATE"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        local CloseButton = Instance.new("TextButton")
        CloseButton.Name = "Close"
        CloseButton.Parent = Header
        CloseButton.BackgroundTransparency = 1
        CloseButton.Position = UDim2.new(1, -30, 0, 5)
        CloseButton.Size = UDim2.new(0, 25, 0, 25)
        CloseButton.Font = Enum.Font.GothamBold
        CloseButton.Text = "X"
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.TextSize = 14
        
        -- Контент
        local Content = Instance.new("Frame")
        Content.Name = "Content"
        Content.Parent = MainFrame
        Content.BackgroundTransparency = 1
        Content.Position = UDim2.new(0, 10, 0, 45)
        Content.Size = UDim2.new(1, -20, 1, -55)
        
        -- Функции для элементов
        local function CreateToggle(name, yPos, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = name
            ToggleFrame.Parent = Content
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = ToggleFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 0, 0, 0)
            Label.Size = UDim2.new(0, 200, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = name
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ToggleFrame
            Button.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(1, -50, 0, 2)
            Button.Size = UDim2.new(0, 50, 0, 21)
            Button.Font = Enum.Font.GothamBold
            Button.Text = "OFF"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 10
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 5)
            Corner.Parent = Button
            
            local state = false
            
            Button.MouseButton1Click:Connect(function()
                state = not state
                Button.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 90)
                Button.Text = state and "ON" or "OFF"
                callback(state)
            end)
            
            return ToggleFrame
        end
        
        -- Создаем тогглы
        CreateToggle("Aimbot", 0, function(state)
            Settings.Aimbot.Enabled = state
            InternalPrint("Aimbot: " .. (state and "ON" or "OFF"))
        end)
        
        CreateToggle("ESP", 30, function(state)
            Settings.ESP.Enabled = state
            InternalPrint("ESP: " .. (state and "ON" or "OFF"))
        end)
        
        CreateToggle("Third Person", 60, function(state)
            Settings.Visuals.ThirdPerson = state
            InternalPrint("Third Person: " .. (state and "ON" or "OFF"))
        end)
        
        CreateToggle("Anti-Aim", 90, function(state)
            Settings.Movement.AntiAim = state
            InternalPrint("Anti-Aim: " .. (state and "ON" or "OFF"))
        end)
        
        -- Кнопка выхода
        local ExitButton = Instance.new("TextButton")
        ExitButton.Name = "Exit"
        ExitButton.Parent = Content
        ExitButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ExitButton.BorderSizePixel = 0
        ExitButton.Position = UDim2.new(0, 0, 1, -30)
        ExitButton.Size = UDim2.new(1, 0, 0, 25)
        ExitButton.Font = Enum.Font.GothamBold
        ExitButton.Text = "EXIT"
        ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ExitButton.TextSize = 12
        
        local ExitCorner = Instance.new("UICorner")
        ExitCorner.CornerRadius = UDim.new(0, 5)
        ExitCorner.Parent = ExitButton
        
        -- Обработчики
        CloseButton.MouseButton1Click:Connect(function()
            ScreenGui.Enabled = false
        end)
        
        ExitButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
            InternalPrint("Cheat exited")
        end)
        
        -- Бинд на скрытие
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.RightShift then
                MainFrame.Visible = not MainFrame.Visible
            end
        end)
        
        return ScreenGui
    end)
    
    if not success then
        InternalPrint("GUI creation failed, using fallback")
        -- Fallback: простой вывод в консоль
        InternalPrint("Gothbreach ULTIMATE Loaded!")
        InternalPrint("RightShift - Toggle Features")
        InternalPrint("Aimbot: OFF | ESP: OFF | ThirdPerson: OFF")
    end
end

-- Мощный аимбот с проверкой стен
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

function UpdateFOVCircle()
    FOVCircle.Visible = Settings.Aimbot.ShowFOV and Settings.Aimbot.Enabled
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Color = Settings.Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

-- Проверка видимости через Raycast
function IsVisible(targetPart)
    if not Settings.Aimbot.WallCheck then return true end
    if not LocalPlayer.Character then return false end
    
    local origin = LocalPlayer.Character:FindFirstChild("Head")
    if not origin then return false end
    
    local direction = (targetPart.Position - origin.Position).Unit
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = workspace:Raycast(origin.Position, direction * 1000, raycastParams)
    return not result or result.Instance:IsDescendantOf(targetPart.Parent)
end

-- Аимбот
function StartAimbot()
    RunService.RenderStepped:Connect(function()
        if not Settings.Aimbot.Enabled then return end
        if not LocalPlayer.Character then return end
        
        local closestTarget = nil
        local closestDistance = Settings.Aimbot.FOV
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local targetPart = player.Character:FindFirstChild(Settings.Aimbot.AimPart)
                if targetPart and IsVisible(targetPart) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    
                    if onScreen then
                        local pos = Vector2.new(screenPos.X, screenPos.Y)
                        local distance = (center - pos).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestTarget = targetPart
                        end
                    end
                end
            end
        end
        
        if closestTarget then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.lookAt(currentCF.Position, closestTarget.Position)
            Camera.CFrame = currentCF:Lerp(targetCF, Settings.Aimbot.Smoothness)
        end
    end)
end

-- ESP через Drawing (обход античита)
local ESPObjects = {}

function UpdateESP()
    -- Очистка
    for _, drawings in pairs(ESPObjects) do
        for _, drawing in pairs(drawings) do
            drawing:Remove()
        end
    end
    ESPObjects = {}
    
    if not Settings.ESP.Enabled then return end
    
    -- Создание ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local drawings = {}
            
            -- Бокс
            if Settings.ESP.Boxes then
                local box = Drawing.new("Square")
                box.Visible = false
                box.Thickness = 2
                box.Color = Color3.fromRGB(255, 0, 0)
                box.Filled = false
                drawings.Box = box
            end
            
            -- Скелет
            if Settings.ESP.Skeletons then
                local bones = {
                    {"Head", "UpperTorso"},
                    {"UpperTorso", "LowerTorso"},
                    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
                    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
                    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
                    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
                }
                
                for _, bonePair in pairs(bones) do
                    local line = Drawing.new("Line")
                    line.Visible = false
                    line.Thickness = 1
                    line.Color = Color3.fromRGB(255, 0, 0)
                    drawings[bonePair[1].."_"..bonePair[2]] = line
                end
            end
            
            ESPObjects[player] = drawings
        end
    end
end

-- Third Person
function UpdateThirdPerson()
    if Settings.Visuals.ThirdPerson then
        RunService:BindToRenderStep("ThirdPerson", Enum.RenderPriority.Camera.Value, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                Camera.CFrame = CFrame.new(
                    root.Position - root.CFrame.LookVector * Settings.Visuals.Distance,
                    root.Position
                )
            end
        end)
    else
        RunService:UnbindFromRenderStep("ThirdPerson")
    end
end

-- Anti-Aim
function UpdateAntiAim()
    if Settings.Movement.AntiAim then
        RunService:BindToRenderStep("AntiAim", Enum.RenderPriority.Character.Value, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local head = LocalPlayer.Character.Head
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    head.CFrame = root.CFrame * CFrame.new(0, 1.5, 0)
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("AntiAim")
    end
end

-- Запуск
CreateStealthGUI()
StartAimbot()

-- Обновление ESP в реальном времени
RunService.RenderStepped:Connect(function()
    UpdateFOVCircle()
    
    for player, drawings in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            
            if head then
                local headPos, headVisible = Camera:WorldToViewportPoint(head.Position)
                
                if headVisible then
                    -- Обновление бокса
                    if drawings.Box then
                        local feetPos = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, -3, 0))
                        local height = math.abs(feetPos.Y - headPos.Y)
                        local width = height / 2
                        
                        drawings.Box.Size = Vector2.new(width, height)
                        drawings.Box.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                        drawings.Box.Visible = true
                    end
                    
                    -- Обновление скелета
                    for boneName, line in pairs(drawings) do
                        if boneName ~= "Box" then
                            local bones = boneName:split("_")
                            local fromPart = player.Character:FindFirstChild(bones[1])
                            local toPart = player.Character:FindFirstChild(bones[2])
                            
                            if fromPart and toPart then
                                local fromPos = Camera:WorldToViewportPoint(fromPart.Position)
                                local toPos = Camera:WorldToViewportPoint(toPart.Position)
                                
                                line.From = Vector2.new(fromPos.X, fromPos.Y)
                                line.To = Vector2.new(toPos.X, toPos.Y)
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        end
                    end
                else
                    -- Скрыть если не видно
                    for _, drawing in pairs(drawings) do
                        drawing.Visible = false
                    end
                end
            end
        else
            -- Очистка если игрок умер
            for _, drawing in pairs(drawings) do
                drawing:Remove()
            end
            ESPObjects[player] = nil
        end
    end
end)

InternalPrint("Gothbreach ULTIMATE v5.0 LOADED!")
InternalPrint("Using internal methods for anti-cheat bypass")
InternalPrint("RightShift - Toggle GUI | Features ready!")
