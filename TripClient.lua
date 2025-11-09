-- Gothbreach Cheat Menu v2.5 + SPINBOT
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local CheatSettings = {
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        FOV = 80,
        ShowFOV = true,
        Smoothness = 0.2,
        AimPart = "Head",
        Keybind = "RightShift"
    },
    
    ESP = {
        Enabled = false,
        TeamCheck = true,
        Skeletons = true,
        Keybind = "Insert"
    },
    
    Movement = {
        Spinbot = {
            Enabled = false,
            Speed = 50,
            Pitch = -89, -- Взгляд вниз
            Keybind = "Q",
            AntiAim = true -- Защита от хедшотов
        }
    }
}

-- Хранилище
local ESPObjects = {}
local FOVCircle
local spinbotConnection

-- FOV круг
function createFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1
    FOVCircle.Color = Color3.fromRGB(255, 0, 0)
    FOVCircle.Filled = false
    FOVCircle.Radius = CheatSettings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function updateFOVCircle()
    if not FOVCircle then createFOVCircle() end
    
    FOVCircle.Visible = CheatSettings.Aimbot.ShowFOV and CheatSettings.Aimbot.Enabled
    FOVCircle.Radius = CheatSettings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Color = CheatSettings.Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

-- Быстрые проверки
function isEnemy(player)
    if not CheatSettings.Aimbot.TeamCheck then return true end
    return player.Team ~= LocalPlayer.Team
end

function isAlive(player)
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

-- Крутилка (Spinbot)
function startSpinbot()
    if spinbotConnection then spinbotConnection:Disconnect() end
    
    spinbotConnection = RunService.Heartbeat:Connect(function()
        if not CheatSettings.Movement.Spinbot.Enabled or not isAlive(LocalPlayer) then 
            return 
        end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            -- Вращение
            local currentTime = tick()
            local yaw = (currentTime * CheatSettings.Movement.Spinbot.Speed) % 360
            
            -- Создание углов
            local pitch = math.rad(CheatSettings.Movement.Spinbot.Pitch) -- Взгляд вниз
            local yawRad = math.rad(yaw)
            
            -- Расчет направления взгляда
            local lookVector = Vector3.new(
                math.sin(yawRad) * math.cos(pitch),
                math.sin(pitch),
                math.cos(yawRad) * math.cos(pitch)
            )
            
            -- Обновление камеры
            Camera.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, 1.5, 0), 
                                     rootPart.Position + Vector3.new(0, 1.5, 0) + lookVector)
            
            -- Anti-aim защита (голова не выходит вперед)
            if CheatSettings.Movement.Spinbot.AntiAim then
                local head = character:FindFirstChild("Head")
                if head then
                    -- Фиксируем голову близко к телу
                    head.CFrame = rootPart.CFrame * CFrame.new(0, 1.5, 0)
                end
            end
        end
    end)
end

function stopSpinbot()
    if spinbotConnection then
        spinbotConnection:Disconnect()
        spinbotConnection = nil
    end
end

-- Оптимизированный аимбот
local lastTarget = nil
local aimbotConnection

function startAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not CheatSettings.Aimbot.Enabled or not isAlive(LocalPlayer) or CheatSettings.Movement.Spinbot.Enabled then 
            lastTarget = nil
            return 
        end
        
        -- Поиск цели каждые 5 кадров для оптимизации
        if not lastTarget or tick() % 0.1 > 0.02 then
            local closestTarget = nil
            local closestDistance = CheatSettings.Aimbot.FOV
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and isEnemy(player) and isAlive(player) then
                    local character = player.Character
                    local aimPart = character and character:FindFirstChild(CheatSettings.Aimbot.AimPart)
                    
                    if aimPart then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                        
                        if onScreen then
                            local pos = Vector2.new(screenPos.X, screenPos.Y)
                            local dist = (center - pos).Magnitude
                            
                            if dist < closestDistance then
                                closestDistance = dist
                                closestTarget = aimPart
                            end
                        end
                    end
                end
            end
            
            lastTarget = closestTarget
        end
        
        -- Наведение на цель
        if lastTarget and lastTarget.Parent then
            local targetChar = lastTarget.Parent
            local player = Players:GetPlayerFromCharacter(targetChar)
            
            if player and isAlive(player) then
                local currentCF = Camera.CFrame
                local targetCF = CFrame.lookAt(currentCF.Position, lastTarget.Position)
                Camera.CFrame = currentCF:Lerp(targetCF, CheatSettings.Aimbot.Smoothness)
            else
                lastTarget = nil
            end
        end
    end)
end

-- Упрощенный ESP
function createSkeleton(player)
    if ESPObjects[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local lines = {}
    local connections = {}
    
    -- Только основные кости для оптимизации
    local boneConnections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
    }
    
    -- Создание линий
    for _, bones in pairs(boneConnections) do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1
        line.Color = Color3.fromRGB(255, 0, 0)
        lines[bones[1].."_"..bones[2]] = line
    end
    
    -- Функция обновления
    local updateConnection
    local function updateSkeleton()
        if not character or not character.Parent or not isAlive(player) then
            -- Очистка
            if updateConnection then updateConnection:Disconnect() end
            for _, line in pairs(lines) do
                line:Remove()
            end
            ESPObjects[player] = nil
            return
        end
        
        -- Обновление позиций (только видимые кости)
        for bonePair, line in pairs(lines) do
            local bones = bonePair:split("_")
            local fromPart = character:FindFirstChild(bones[1])
            local toPart = character:FindFirstChild(bones[2])
            
            if fromPart and toPart then
                local fromPos, fromVisible = Camera:WorldToViewportPoint(fromPart.Position)
                local toPos, toVisible = Camera:WorldToViewportPoint(toPart.Position)
                
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
    
    -- Запуск обновления с интервалом
    updateConnection = RunService.RenderStepped:Connect(updateSkeleton)
    ESPObjects[player] = {
        connection = updateConnection,
        lines = lines
    }
end

function clearESP(player)
    local data = ESPObjects[player]
    if not data then return end
    
    if data.connection then data.connection:Disconnect() end
    for _, line in pairs(data.lines) do
        line:Remove()
    end
    ESPObjects[player] = nil
end

function startESP()
    -- Очистка
    for player in pairs(ESPObjects) do
        clearESP(player)
    end
    
    if not CheatSettings.ESP.Enabled then return end
    
    -- Создание ESP для врагов
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) then
            createSkeleton(player)
        end
    end
end

-- Бинды
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
    
    if input.KeyCode == Enum.KeyCode[CheatSettings.Movement.Spinbot.Keybind] then
        CheatSettings.Movement.Spinbot.Enabled = not CheatSettings.Movement.Spinbot.Enabled
        if CheatSettings.Movement.Spinbot.Enabled then
            startSpinbot()
        else
            stopSpinbot()
        end
    end
end)

-- UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Gothbreach Pro", "Sentinel")

-- Аимбот
local AimbotTab = Window:NewTab("Aimbot")
local AimbotSection = AimbotTab:NewSection("Aimbot")

AimbotSection:NewToggle("Enable", "Включить аимбот", function(state)
    CheatSettings.Aimbot.Enabled = state
    updateFOVCircle()
    startAimbot()
end)

AimbotSection:NewToggle("Show FOV", "Показывать FOV", function(state)
    CheatSettings.Aimbot.ShowFOV = state
    updateFOVCircle()
end)

AimbotSection:NewSlider("FOV", "Поле зрения", 150, 30, function(value)
    CheatSettings.Aimbot.FOV = value
    updateFOVCircle()
end)

AimbotSection:NewSlider("Smooth", "Плавность", 50, 5, function(value)
    CheatSettings.Aimbot.Smoothness = value / 100
end)

-- Визуалы
local VisualsTab = Window:NewTab("Visuals")
local ESPsection = VisualsTab:NewSection("ESP")

ESPsection:NewToggle("Enable", "Включить ESP", function(state)
    CheatSettings.ESP.Enabled = state
    startESP()
end)

ESPsection:NewToggle("Skeletons", "Скелеты", function(state)
    CheatSettings.ESP.Skeletons = state
    startESP()
end)

ESPsection:NewToggle("Team Check", "Проверка команды", function(state)
    CheatSettings.Aimbot.TeamCheck = state
    CheatSettings.ESP.TeamCheck = state
    startESP()
end)

-- Movement (Крутилка)
local MovementTab = Window:NewTab("Movement")
local SpinbotSection = MovementTab:NewSection("Spinbot")

SpinbotSection:NewToggle("Enable Spinbot", "Включить крутилку", function(state)
    CheatSettings.Movement.Spinbot.Enabled = state
    if state then
        startSpinbot()
    else
        stopSpinbot()
    end
end)

SpinbotSection:NewSlider("Spin Speed", "Скорость вращения", 200, 10, function(value)
    CheatSettings.Movement.Spinbot.Speed = value
end)

SpinbotSection:NewSlider("Pitch", "Угол наклона", -89, -89, function(value)
    CheatSettings.Movement.Spinbot.Pitch = value
end)

SpinbotSection:NewToggle("Anti-Aim", "Защита от хедшотов", function(state)
    CheatSettings.Movement.Spinbot.AntiAim = state
end)

SpinbotSection:NewKeybind("Spinbot Key", "Клавиша крутилки", Enum.KeyCode.Q, function()
    CheatSettings.Movement.Spinbot.Enabled = not CheatSettings.Movement.Spinbot.Enabled
    if CheatSettings.Movement.Spinbot.Enabled then
        startSpinbot()
    else
        stopSpinbot()
    end
end)

-- Настройки
local SettingsTab = Window:NewTab("Settings")
SettingsTab:NewKeybind("Toggle UI", "Открыть/закрыть меню", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Запуск
createFOVCircle()
startAimbot()

print("🌀 Gothbreach Pro v2.5 LOADED!")
print("RightControl - Menu")
print("RightShift - Aimbot") 
print("Insert - ESP")
print("Q - Spinbot")
