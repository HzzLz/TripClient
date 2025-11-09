-- Gothbreach Cheat Menu v2.2
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Настройки чита
local CheatSettings = {
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        WallCheck = true,
        FOV = 50,
        ShowFOV = true,
        Smoothness = 0.1,
        AimPart = "Head",
        Keybind = "RightShift"
    },
    
    ESP = {
        Enabled = false,
        TeamCheck = true,
        Skeletons = true,
        Boxes = true,
        Names = true,
        Distance = true,
        Keybind = "Insert"
    }
}

-- Хранилище
local ESPObjects = {}
local Connections = {}
local FOVCircle

-- Создание FOV круга
function createFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    
    local circle = Drawing.new("Circle")
    circle.Visible = CheatSettings.Aimbot.ShowFOV
    circle.Thickness = 1
    circle.Color = Color3.fromRGB(255, 255, 255)
    circle.Transparency = 1
    circle.Filled = false
    circle.Radius = CheatSettings.Aimbot.FOV
    circle.Position = Vector2.new(Mouse.X, Mouse.Y)
    
    FOVCircle = circle
    return circle
end

-- Обновление FOV круга
function updateFOVCircle()
    if not FOVCircle then
        createFOVCircle()
    end
    
    FOVCircle.Visible = CheatSettings.Aimbot.ShowFOV and CheatSettings.Aimbot.Enabled
    FOVCircle.Radius = CheatSettings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    
    if CheatSettings.Aimbot.Enabled then
        FOVCircle.Color = Color3.fromRGB(0, 255, 0)
    else
        FOVCircle.Color = Color3.fromRGB(255, 0, 0)
    end
end

-- Проверка жив ли игрок
function isPlayerAlive(player)
    if not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    return humanoid.Health > 0
end

-- Функции проверки
function isEnemy(player)
    if not CheatSettings.Aimbot.TeamCheck then return true end
    if game.Teams then
        return player.Team ~= LocalPlayer.Team
    end
    return player ~= LocalPlayer
end

function isVisible(targetPart)
    if not CheatSettings.Aimbot.WallCheck then return true end
    
    local origin = LocalPlayer.Character.Head.Position
    local target = targetPart.Position
    local direction = (target - origin).Unit * 1000
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        return hitPart:IsDescendantOf(targetPart.Parent)
    end
    
    return true
end

-- Аимбот
function findTarget()
    local closestTarget = nil
    local closestDistance = CheatSettings.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isPlayerAlive(player) then
            local targetPart = player.Character:FindFirstChild(CheatSettings.Aimbot.AimPart)
            if targetPart and isEnemy(player) then
                local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen and isVisible(targetPart) then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (mousePos - targetPos).Magnitude
                    
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = targetPart
                    end
                end
            end
        end
    end
    
    return closestTarget
end

function startAimbot()
    if Connections.Aimbot then Connections.Aimbot:Disconnect() end
    
    Connections.Aimbot = RunService.RenderStepped:Connect(function()
        if not CheatSettings.Aimbot.Enabled then 
            updateFOVCircle()
            return 
        end
        
        updateFOVCircle()
        
        if not LocalPlayer.Character or not isPlayerAlive(LocalPlayer) then return end
        
        local target = findTarget()
        if target then
            local camera = workspace.CurrentCamera
            local targetPosition = target.Position
            
            local currentCamera = camera.CFrame
            local targetCamera = CFrame.lookAt(currentCamera.Position, targetPosition)
            camera.CFrame = currentCamera:Lerp(targetCamera, CheatSettings.Aimbot.Smoothness)
        end
    end)
end

-- ESP системы
function createESP(player)
    if ESPObjects[player] then 
        -- Очистка старого ESP
        clearESP(player)
    end
    
    local character = player.Character
    if not character then return end
    
    local espData = {
        Box = nil,
        Name = nil,
        Distance = nil,
        SkeletonLines = {},
        Connections = {}
    }
    
    -- Бокс ESP
    if CheatSettings.ESP.Boxes then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Thickness = 2
        box.Color = Color3.fromRGB(255, 0, 0)
        box.Filled = false
        espData.Box = box
    end
    
    -- Имя игрока
    if CheatSettings.ESP.Names then
        local name = Drawing.new("Text")
        name.Visible = false
        name.Color = Color3.fromRGB(255, 255, 255)
        name.Size = 13
        name.Text = player.Name
        name.Outline = true
        name.OutlineColor = Color3.fromRGB(0, 0, 0)
        name.Center = true
        espData.Name = name
    end
    
    -- Дистанция
    if CheatSettings.ESP.Distance then
        local distance = Drawing.new("Text")
        distance.Visible = false
        distance.Color = Color3.fromRGB(255, 255, 255)
        distance.Size = 12
        distance.Outline = true
        distance.OutlineColor = Color3.fromRGB(0, 0, 0)
        distance.Center = true
        espData.Distance = distance
    end
    
    -- Скелет
    if CheatSettings.ESP.Skeletons then
        local skeletonParts = {
            "Head", "UpperTorso", "LowerTorso",
            "LeftUpperArm", "LeftLowerArm", "LeftHand",
            "RightUpperArm", "RightLowerArm", "RightHand", 
            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
            "RightUpperLeg", "RightLowerLeg", "RightFoot"
        }
        
        local connectionsMap = {
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
            {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
            {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
            {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
        }
        
        -- Создание линий скелета
        for _, connection in pairs(connectionsMap) do
            local line = Drawing.new("Line")
            line.Visible = false
            line.Thickness = 2
            line.Color = Color3.fromRGB(255, 0, 0)
            espData.SkeletonLines[connection[1] .. "_" .. connection[2]] = line
        end
    end
    
    -- Функция обновления ESP
    local function updateESP()
        if not character or not character.Parent or not isPlayerAlive(player) then
            clearESP(player)
            return
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local rootPos, rootVisible = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
        if not rootVisible then
            -- Скрыть ESP если игрок не в поле зрения
            if espData.Box then espData.Box.Visible = false end
            if espData.Name then espData.Name.Visible = false end
            if espData.Distance then espData.Distance.Visible = false end
            for _, line in pairs(espData.SkeletonLines) do
                line.Visible = false
            end
            return
        end
        
        -- Обновление бокса
        if espData.Box then
            local head = character:FindFirstChild("Head")
            if head then
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local feetPos = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, -3, 0))
                
                local height = math.abs(feetPos.Y - headPos.Y)
                local width = height / 2
                
                espData.Box.Size = Vector2.new(width, height)
                espData.Box.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                espData.Box.Visible = true
            end
        end
        
        -- Обновление имени
        if espData.Name then
            local head = character:FindFirstChild("Head")
            if head then
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                espData.Name.Position = Vector2.new(headPos.X, headPos.Y - 40)
                espData.Name.Visible = true
            end
        end
        
        -- Обновление дистанции
        if espData.Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local head = character:FindFirstChild("Head")
            if head then
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                espData.Distance.Text = math.floor(distance) .. " studs"
                espData.Distance.Position = Vector2.new(headPos.X, headPos.Y - 55)
                espData.Distance.Visible = true
            end
        end
        
        -- Обновление скелета
        if CheatSettings.ESP.Skeletons then
            for connection, line in pairs(espData.SkeletonLines) do
                local parts = connection:split("_")
                local fromPart = character:FindFirstChild(parts[1])
                local toPart = character:FindFirstChild(parts[2])
                
                if fromPart and toPart then
                    local fromPos, fromVisible = workspace.CurrentCamera:WorldToViewportPoint(fromPart.Position)
                    local toPos, toVisible = workspace.CurrentCamera:WorldToViewportPoint(toPart.Position)
                    
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
    end
    
    -- Запуск обновления ESP
    espData.Connections.update = RunService.RenderStepped:Connect(updateESP)
    ESPObjects[player] = espData
end

-- Очистка ESP
function clearESP(player)
    local espData = ESPObjects[player]
    if not espData then return end
    
    -- Отключение соединений
    for _, conn in pairs(espData.Connections) do
        conn:Disconnect()
    end
    
    -- Удаление Drawing объектов
    if espData.Box then espData.Box:Remove() end
    if espData.Name then espData.Name:Remove() end
    if espData.Distance then espData.Distance:Remove() end
    
    for _, line in pairs(espData.SkeletonLines) do
        line:Remove()
    end
    
    ESPObjects[player] = nil
end

function startESP()
    -- Очистка старого ESP
    for player, _ in pairs(ESPObjects) do
        clearESP(player)
    end
    
    if not CheatSettings.ESP.Enabled then return end
    
    -- Создание ESP для врагов
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) then
            createESP(player)
            
            -- Обработка появления персонажа
            player.CharacterAdded:Connect(function(character)
                wait(1)
                if CheatSettings.ESP.Enabled and isEnemy(player) then
                    createESP(player)
                end
            end)
        end
    end
    
    -- Обработка новых игроков
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            wait(1)
            if CheatSettings.ESP.Enabled and isEnemy(player) then
                createESP(player)
            end
        end)
    end)
end

-- Бинды
function setupBinds()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode[CheatSettings.Aimbot.Keybind] then
            CheatSettings.Aimbot.Enabled = not CheatSettings.Aimbot.Enabled
            updateFOVCircle()
        end
        
        if input.KeyCode == Enum.KeyCode[CheatSettings.ESP.Keybind] then
            CheatSettings.ESP.Enabled = not CheatSettings.ESP.Enabled
            startESP()
        end
    end)
end

-- UI библиотека Kavo
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Gothbreach Cheat", "Sentinel")

-- Создание меню
local AimbotTab = Window:NewTab("Aimbot")
local AimbotSection = AimbotTab:NewSection("Aimbot Settings")

AimbotSection:NewToggle("Enable Aimbot", "Включить аимбот", function(state)
    CheatSettings.Aimbot.Enabled = state
    updateFOVCircle()
    startAimbot()
end)

AimbotSection:NewToggle("Show FOV", "Показывать FOV круг", function(state)
    CheatSettings.Aimbot.ShowFOV = state
    updateFOVCircle()
end)

AimbotSection:NewSlider("FOV", "Поле зрения аимбота", 300, 10, function(value)
    CheatSettings.Aimbot.FOV = value
    updateFOVCircle()
end)

AimbotSection:NewSlider("Smoothness", "Плавность аимбота", 100, 1, function(value)
    CheatSettings.Aimbot.Smoothness = value / 100
end)

AimbotSection:NewDropdown("Aim Part", "Часть тела для аимбота", {"Head", "UpperTorso", "HumanoidRootPart"}, function(part)
    CheatSettings.Aimbot.AimPart = part
end)

AimbotSection:NewKeybind("Aimbot Key", "Клавиша аимбота", Enum.KeyCode.RightShift, function()
    CheatSettings.Aimbot.Enabled = not CheatSettings.Aimbot.Enabled
    updateFOVCircle()
end)

local VisualsTab = Window:NewTab("Visuals")
local ESPsection = VisualsTab:NewSection("ESP Settings")

ESPsection:NewToggle("Enable ESP", "Включить ESP", function(state)
    CheatSettings.ESP.Enabled = state
    startESP()
end)

ESPsection:NewToggle("Skeletons", "Показывать скелеты", function(state)
    CheatSettings.ESP.Skeletons = state
    startESP()
end)

ESPsection:NewToggle("Boxes", "Показывать боксы", function(state)
    CheatSettings.ESP.Boxes = state
    startESP()
end)

ESPsection:NewToggle("Names", "Показывать имена", function(state)
    CheatSettings.ESP.Names = state
    startESP()
end)

ESPsection:NewToggle("Distance", "Показывать дистанцию", function(state)
    CheatSettings.ESP.Distance = state
    startESP()
end)

ESPsection:NewToggle("Team Check", "Проверка команды", function(state)
    CheatSettings.ESP.TeamCheck = state
    CheatSettings.Aimbot.TeamCheck = state
    startESP()
end)

ESPsection:NewKeybind("ESP Key", "Клавиша ESP", Enum.KeyCode.Insert, function()
    CheatSettings.ESP.Enabled = not CheatSettings.ESP.Enabled
    startESP()
end)

local SettingsTab = Window:NewTab("Settings")
local BindSection = SettingsTab:NewSection("Keybinds")

BindSection:NewKeybind("UI Toggle", "Показать/скрыть меню", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Запуск
createFOVCircle()
setupBinds()
startAimbot()
startESP()

RunService.RenderStepped:Connect(updateFOVCircle)

print("🎯 Gothbreach Cheat v2.2 loaded!")
print("RightControl - Show/Hide Menu")
print("RightShift - Toggle Aimbot") 
print("Insert - Toggle ESP")
