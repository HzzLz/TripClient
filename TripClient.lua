-- Gothbreach Cheat Menu v2.0
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
        Smoothness = 0.1,
        AimPart = "Head",
        Keybind = "RightShift"
    },
    
    ESP = {
        Enabled = false,
        TeamCheck = true,
        Skeletons = true,
        Boxes = false,
        Names = true,
        Distance = true,
        Keybind = "Insert"
    },
    
    Visuals = {
        FOV = 120,
        ThirdPerson = false
    }
}

-- Хранилище
local ESPObjects = {}
local Connections = {}

-- UI библиотека Kavo
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Gothbreach Cheat", "Sentinel")

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
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(CheatSettings.Aimbot.AimPart) then
            if isEnemy(player) then
                local targetPart = player.Character[CheatSettings.Aimbot.AimPart]
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
        if not CheatSettings.Aimbot.Enabled then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return end
        
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

-- ESP скелетов
function createSkeleton(player)
    if ESPObjects[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local bones = {
        "Head", "UpperTorso", "LowerTorso",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }
    
    local connections = {}
    local parts = {}
    
    -- Создание линий между костями
    local function createLine(fromPart, toPart)
        local line = Instance.new("BoxHandleAdornment")
        line.Name = "SkeletonLine"
        line.Adornee = fromPart
        line.Size = Vector3.new(0.1, 0.1, (fromPart.Position - toPart.Position).Magnitude)
        line.CFrame = CFrame.lookAt(fromPart.Position, toPart.Position) * CFrame.new(0, 0, -line.Size.Z/2)
        line.Color3 = Color3.fromRGB(255, 0, 0)
        line.Transparency = 0.3
        line.AlwaysOnTop = true
        line.ZIndex = 2
        line.Parent = fromPart
        
        return line
    end
    
    -- Соединения костей
    local connectionsMap = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }
    
    local function updateSkeleton()
        if not character or not character.Parent then
            -- Очистка при смерти игрока
            for _, part in pairs(parts) do
                part:Destroy()
            end
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            ESPObjects[player] = nil
            return
        end
        
        -- Обновление линий
        for _, connection in pairs(connectionsMap) do
            local fromPart = character:FindFirstChild(connection[1])
            local toPart = character:FindFirstChild(connection[2])
            
            if fromPart and toPart then
                local lineName = connection[1] .. "_" .. connection[2]
                if not parts[lineName] then
                    parts[lineName] = createLine(fromPart, toPart)
                else
                    parts[lineName].Size = Vector3.new(0.1, 0.1, (fromPart.Position - toPart.Position).Magnitude)
                    parts[lineName].CFrame = CFrame.lookAt(fromPart.Position, toPart.Position) * CFrame.new(0, 0, -parts[lineName].Size.Z/2)
                end
            end
        end
    end
    
    -- Обновление скелета
    connections.update = RunService.RenderStepped:Connect(updateSkeleton)
    ESPObjects[player] = {
        connections = connections,
        parts = parts
    }
end

function startESP()
    -- Очистка старого ESP
    for player, data in pairs(ESPObjects) do
        for _, conn in pairs(data.connections) do
            conn:Disconnect()
        end
        for _, part in pairs(data.parts) do
            part:Destroy()
        end
    end
    ESPObjects = {}
    
    if not CheatSettings.ESP.Enabled then return end
    
    -- Создание ESP для врагов
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) then
            if CheatSettings.ESP.Skeletons then
                createSkeleton(player)
            end
            
            -- Обработка появления персонажа
            player.CharacterAdded:Connect(function(character)
                wait(1)
                if CheatSettings.ESP.Skeletons and isEnemy(player) then
                    createSkeleton(player)
                end
            end)
        end
    end
    
    -- Обработка новых игроков
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            wait(1)
            if CheatSettings.ESP.Skeletons and isEnemy(player) then
                createSkeleton(player)
            end
        end)
    end)
end

-- Бинды
function setupBinds()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Аимбот
        if input.KeyCode == Enum.KeyCode[CheatSettings.Aimbot.Keybind] then
            CheatSettings.Aimbot.Enabled = not CheatSettings.Aimbot.Enabled
            print("Aimbot: " .. (CheatSettings.Aimbot.Enabled and "ON" or "OFF"))
        end
        
        -- ESP
        if input.KeyCode == Enum.KeyCode[CheatSettings.ESP.Keybind] then
            CheatSettings.ESP.Enabled = not CheatSettings.ESP.Enabled
            startESP()
            print("ESP: " .. (CheatSettings.ESP.Enabled and "ON" or "OFF"))
        end
    end)
end

-- Создание меню
local AimbotTab = Window:NewTab("Aimbot")
local AimbotSection = AimbotTab:NewSection("Aimbot Settings")

AimbotSection:NewToggle("Enable Aimbot", "Включить аимбот", function(state)
    CheatSettings.Aimbot.Enabled = state
    startAimbot()
end)

AimbotSection:NewSlider("FOV", "Поле зрения аимбота", 300, 10, function(value)
    CheatSettings.Aimbot.FOV = value
end)

AimbotSection:NewSlider("Smoothness", "Плавность аимбота", 100, 1, function(value)
    CheatSettings.Aimbot.Smoothness = value / 100
end)

AimbotSection:NewDropdown("Aim Part", "Часть тела для аимбота", {"Head", "UpperTorso", "HumanoidRootPart"}, function(part)
    CheatSettings.Aimbot.AimPart = part
end)

AimbotSection:NewKeybind("Aimbot Key", "Клавиша аимбота", Enum.KeyCode.RightShift, function()
    CheatSettings.Aimbot.Enabled = not CheatSettings.Aimbot.Enabled
    print("Aimbot: " .. (CheatSettings.Aimbot.Enabled and "ON" or "OFF"))
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

ESPsection:NewToggle("Team Check", "Проверка команды", function(state)
    CheatSettings.ESP.TeamCheck = state
    CheatSettings.Aimbot.TeamCheck = state
    startESP()
end)

ESPsection:NewKeybind("ESP Key", "Клавиша ESP", Enum.KeyCode.Insert, function()
    CheatSettings.ESP.Enabled = not CheatSettings.ESP.Enabled
    startESP()
    print("ESP: " .. (CheatSettings.ESP.Enabled and "ON" or "OFF"))
end)

local SettingsTab = Window:NewTab("Settings")
local BindSection = SettingsTab:NewSection("Keybinds")

BindSection:NewKeybind("UI Toggle", "Показать/скрыть меню", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Запуск
setupBinds()
startAimbot()
startESP()

print("🎯 Gothbreach Cheat loaded!")
print("RightControl - Show/Hide Menu")
print("RightShift - Toggle Aimbot") 
print("Insert - Toggle ESP")
