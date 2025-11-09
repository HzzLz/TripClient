-- Gothbreach RAGE Cheat v7.0 (Silent Aim + WallCheck)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки чита
local CheatSettings = {
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        WallCheck = true,
        FOV = 80,
        MaxFOV = 500, -- Увеличенный FOV
        Smoothness = 0.1,
        AimPart = "Head",
        SilentAim = false, -- Новый Silent Aim
        HitChance = 100, -- Шанс попадания для Silent Aim
        TriggerKey = "MouseButton2" -- Клавиша для Silent Aim
    },
    ESP = {
        Enabled = false,
        Skeletons = true,
        Boxes = true
    },
    Visuals = {
        ThirdPerson = false,
        Distance = 10,
        FOVCircle = true
    },
    Movement = {
        AntiAim = false,
        Speed = 1.0
    }
}

-- Создаем окно Neverlose
local Window = Library:Window({
    text = "Gothbreach RAGE"
})

-- Создаем вкладки
local LegitTab = Window:TabSection({
    text = "LEGIT"
})

local RageTab = Window:TabSection({
    text = "RAGE"
})

local VisualsTab = Window:TabSection({
    text = "VISUALS"
})

local MiscTab = Window:TabSection({
    text = "MISC"
})

-- Legit Tab
local AimbotSection = LegitTab:Tab({
    text = "Aimbot",
    icon = "rbxassetid://7999345313"
}):Section({
    text = "Legit Aimbot"
})

AimbotSection:Toggle({
    text = "Enable Aimbot",
    state = false,
    callback = function(state)
        CheatSettings.Aimbot.Enabled = state
        StartAimbot()
    end
})

AimbotSection:Toggle({
    text = "Team Check",
    state = true,
    callback = function(state)
        CheatSettings.Aimbot.TeamCheck = state
    end
})

AimbotSection:Toggle({
    text = "Wall Check", 
    state = true,
    callback = function(state)
        CheatSettings.Aimbot.WallCheck = state
    end
})

AimbotSection:Slider({
    text = "FOV Size",
    min = 20,
    max = CheatSettings.Aimbot.MaxFOV,
    float = 1,
    callback = function(value)
        CheatSettings.Aimbot.FOV = value
        UpdateFOVCircle()
    end
})

AimbotSection:Slider({
    text = "Smoothness",
    min = 1,
    max = 50,
    float = 1,
    callback = function(value)
        CheatSettings.Aimbot.Smoothness = value / 100
    end
})

AimbotSection:Dropdown({
    text = "Aim Part",
    default = "Head",
    list = {"Head", "UpperTorso", "HumanoidRootPart"},
    callback = function(value)
        CheatSettings.Aimbot.AimPart = value
    end
})

-- Rage Tab
local SilentAimSection = RageTab:Tab({
    text = "Silent Aim",
    icon = "rbxassetid://8010116979"
}):Section({
    text = "Silent Aim"
})

SilentAimSection:Toggle({
    text = "Enable Silent Aim",
    state = false,
    callback = function(state)
        CheatSettings.Aimbot.SilentAim = state
    end
})

SilentAimSection:Slider({
    text = "Hit Chance",
    min = 0,
    max = 100,
    float = 1,
    callback = function(value)
        CheatSettings.Aimbot.HitChance = value
    end
})

SilentAimSection:Toggle({
    text = "Team Check",
    state = true,
    callback = function(state)
        CheatSettings.Aimbot.TeamCheck = state
    end
})

SilentAimSection:Toggle({
    text = "Wall Check",
    state = true,
    callback = function(state)
        CheatSettings.Aimbot.WallCheck = state
    end
})

SilentAimSection:Slider({
    text = "FOV Size",
    min = 20,
    max = CheatSettings.Aimbot.MaxFOV,
    float = 1,
    callback = function(value)
        CheatSettings.Aimbot.FOV = value
        UpdateFOVCircle()
    end
})

SilentAimSection:Keybind({
    text = "Trigger Key",
    default = Enum.KeyCode.MouseButton2,
    callback = function(key)
        CheatSettings.Aimbot.TriggerKey = key.Name
    end
})

-- Visuals Tab
local ESPsection = VisualsTab:Tab({
    text = "ESP",
    icon = "rbxassetid://7999984136"
}):Section({
    text = "ESP Settings"
})

ESPsection:Toggle({
    text = "Enable ESP",
    state = false,
    callback = function(state)
        CheatSettings.ESP.Enabled = state
        UpdateESP()
    end
})

ESPsection:Toggle({
    text = "Skeletons",
    state = true,
    callback = function(state)
        CheatSettings.ESP.Skeletons = state
        UpdateESP()
    end
})

ESPsection:Toggle({
    text = "Boxes",
    state = true,
    callback = function(state)
        CheatSettings.ESP.Boxes = state
        UpdateESP()
    end
})

local VisualsSection = VisualsTab:Tab({
    text = "Visuals",
    icon = "rbxassetid://8008296380"
}):Section({
    text = "Camera"
})

VisualsSection:Toggle({
    text = "Third Person",
    state = false,
    callback = function(state)
        CheatSettings.Visuals.ThirdPerson = state
        UpdateThirdPerson()
    end
})

VisualsSection:Toggle({
    text = "Show FOV Circle",
    state = true,
    callback = function(state)
        CheatSettings.Visuals.FOVCircle = state
        UpdateFOVCircle()
    end
})

VisualsSection:Slider({
    text = "TP Distance",
    min = 5,
    max = 20,
    float = 1,
    callback = function(value)
        CheatSettings.Visuals.Distance = value
        UpdateThirdPerson()
    end
})

-- Misc Tab
local MovementSection = MiscTab:Tab({
    text = "Movement",
    icon = "rbxassetid://8023491332"
}):Section({
    text = "Movement"
})

MovementSection:Toggle({
    text = "Anti-Aim",
    state = false,
    callback = function(state)
        CheatSettings.Movement.AntiAim = state
        UpdateAntiAim()
    end
})

MovementSection:Slider({
    text = "Speed",
    min = 1,
    max = 5,
    float = 0.1,
    callback = function(value)
        CheatSettings.Movement.Speed = value
        UpdateSpeed()
    end
})

local ConfigSection = MiscTab:Tab({
    text = "Config",
    icon = "rbxassetid://8010116979"
}):Section({
    text = "Configuration"
})

ConfigSection:Button({
    text = "Save Config",
    callback = function()
        SaveConfig()
    end
})

ConfigSection:Button({
    text = "Load Config", 
    callback = function()
        LoadConfig()
    end
})

ConfigSection:Keybind({
    text = "Menu Keybind",
    default = Enum.KeyCode.RightShift,
    callback = function(key)
        Library:Toggle()
    end
})

-- Функции чита
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 50, 50)
FOVCircle.Filled = false
FOVCircle.Radius = CheatSettings.Aimbot.FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

function UpdateFOVCircle()
    FOVCircle.Visible = CheatSettings.Visuals.FOVCircle and (CheatSettings.Aimbot.Enabled or CheatSettings.Aimbot.SilentAim)
    FOVCircle.Radius = CheatSettings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Color = CheatSettings.Aimbot.SilentAim and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 170, 255)
end

-- Улучшенная проверка видимости
function IsVisible(targetPart)
    if not CheatSettings.Aimbot.WallCheck then return true end
    if not LocalPlayer.Character then return false end
    
    local origin = LocalPlayer.Character:FindFirstChild("Head")
    if not origin then return false end
    
    local direction = (targetPart.Position - origin.Position).Unit
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = workspace:Raycast(origin.Position, direction * 1000, raycastParams)
    
    if result then
        local hitPart = result.Instance
        -- Проверяем что попали в нужного игрока
        return hitPart:IsDescendantOf(targetPart.Parent)
    end
    
    return true
end

-- Проверка команды
function IsEnemy(player)
    if not CheatSettings.Aimbot.TeamCheck then return true end
    if not player.Team then return true end
    return player.Team ~= LocalPlayer.Team
end

-- Поиск цели
function FindTarget()
    local closestTarget = nil
    local closestDistance = CheatSettings.Aimbot.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and IsEnemy(player) then
            local targetPart = player.Character:FindFirstChild(CheatSettings.Aimbot.AimPart)
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
    
    return closestTarget
end

-- Обычный аимбот
local aimbotConnection
function StartAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not CheatSettings.Aimbot.Enabled then return end
        if not LocalPlayer.Character then return end
        
        local target = FindTarget()
        if target then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.lookAt(currentCF.Position, target.Position)
            Camera.CFrame = currentCF:Lerp(targetCF, CheatSettings.Aimbot.Smoothness)
        end
    end)
end

-- Silent Aim система
local silentAimTarget = nil

-- Перехват выстрелов для Silent Aim
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall

if setreadonly then setreadonly(mt, false) end

mt.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Перехватываем методы связанные с выстрелами
    if CheatSettings.Aimbot.SilentAim and (method == "FireServer" or method == "InvokeServer") then
        local remoteName = tostring(args[1])
        
        -- Проверяем что это выстрел (адаптируй под свою игру)
        if remoteName:find("Hit") or remoteName:find("Damage") or remoteName:find("Shoot") then
            -- Проверяем шанс попадания
            if math.random(1, 100) <= CheatSettings.Aimbot.HitChance then
                -- Проверяем нажата ли клавиша триггера
                local triggerKey = Enum.KeyCode[CheatSettings.Aimbot.TriggerKey]
                if UserInputService:IsKeyDown(triggerKey) then
                    local target = FindTarget()
                    if target then
                        -- Модифицируем аргументы чтобы попасть в цель
                        -- (это нужно адаптировать под конкретную игру)
                        if args[2] then -- обычно второй аргумент - позиция попадания
                            args[2] = target.Position
                        end
                    end
                end
            end
        end
    end
    
    return oldNamecall(unpack(args))
end)

if setreadonly then setreadonly(mt, true) end

-- ESP система
local ESPObjects = {}

function UpdateESP()
    -- Очистка старого ESP
    for _, drawings in pairs(ESPObjects) do
        for _, drawing in pairs(drawings) do
            drawing:Remove()
        end
    end
    ESPObjects = {}
    
    if not CheatSettings.ESP.Enabled then return end
    
    -- Создание ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and IsEnemy(player) then
            local drawings = {}
            
            -- Бокс
            if CheatSettings.ESP.Boxes then
                local box = Drawing.new("Square")
                box.Visible = false
                box.Thickness = 2
                box.Color = Color3.fromRGB(255, 50, 50)
                box.Filled = false
                drawings.Box = box
            end
            
            -- Скелет
            if CheatSettings.ESP.Skeletons then
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
                    line.Color = Color3.fromRGB(255, 50, 50)
                    drawings[bonePair[1].."_"..bonePair[2]] = line
                end
            end
            
            ESPObjects[player] = drawings
        end
    end
end

-- Third Person
function UpdateThirdPerson()
    if CheatSettings.Visuals.ThirdPerson then
        RunService:BindToRenderStep("ThirdPerson", Enum.RenderPriority.Camera.Value, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                Camera.CFrame = CFrame.new(
                    root.Position - root.CFrame.LookVector * CheatSettings.Visuals.Distance,
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
    if CheatSettings.Movement.AntiAim then
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

-- Speed
function UpdateSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 * CheatSettings.Movement.Speed
    end
end

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

-- Конфиги
function SaveConfig()
    local config = {
        Aimbot = CheatSettings.Aimbot,
        ESP = CheatSettings.ESP,
        Visuals = CheatSettings.Visuals,
        Movement = CheatSettings.Movement
    }
    
    if writefile then
        writefile("gothbreach_rage_config.json", game:GetService("HttpService"):JSONEncode(config))
        Library:Notify("Config", "Rage configuration saved!")
    else
        Library:Notify("Config", "Your exploit doesn't support file operations")
    end
end

function LoadConfig()
    if readfile then
        local success, config = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("gothbreach_rage_config.json"))
        end)
        
        if success then
            CheatSettings.Aimbot = config.Aimbot or CheatSettings.Aimbot
            CheatSettings.ESP = config.ESP or CheatSettings.ESP
            CheatSettings.Visuals = config.Visuals or CheatSettings.Visuals
            CheatSettings.Movement = config.Movement or CheatSettings.Movement
            
            -- Обновляем все функции
            StartAimbot()
            UpdateESP()
            UpdateThirdPerson()
            UpdateAntiAim()
            UpdateSpeed()
            
            Library:Notify("Config", "Rage configuration loaded!")
        else
            Library:Notify("Config", "No rage config file found")
        end
    else
        Library:Notify("Config", "Your exploit doesn't support file operations")
    end
end

-- Авто-запуск
StartAimbot()
UpdateESP()

print("🎯 Gothbreach RAGE v7.0 LOADED!")
print("Features: Silent Aim, WallCheck, TeamCheck, Huge FOV")
print("RightShift - Toggle Menu | MouseButton2 - Silent Aim")
