-- Аимбот + ESP скрипт для Gothbreach
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Настройки аимбота
local AimSettings = {
    Enabled = true,
    TeamCheck = true,
    WallCheck = true,
    FOV = 50,
    Smoothness = 0.1,
    AimPart = "Head"
}

-- Настройки ESP
local ESPSettings = {
    Enabled = true,
    TeamCheck = true,
    ShowName = true,
    ShowDistance = true,
    Boxes = true,
    Tracers = true
}

-- ESP хранилище
local ESPObjects = {}

-- Функция проверки видимости через луч
function isVisible(targetPart)
    if not AimSettings.WallCheck then return true end
    
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

-- Функция проверки команды
function isEnemy(player)
    if not AimSettings.TeamCheck then return true end
    if game.Teams then
        return player.Team ~= LocalPlayer.Team
    end
    return player ~= LocalPlayer
end

-- Поиск цели для аимбота
function findTarget()
    local closestTarget = nil
    local closestDistance = AimSettings.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimSettings.AimPart) then
            if isEnemy(player) then
                local targetPart = player.Character[AimSettings.AimPart]
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

-- Аимбот
local aimbotConnection
function startAimbot()
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not AimSettings.Enabled then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return end
        
        local target = findTarget()
        if target then
            local camera = workspace.CurrentCamera
            local targetPosition = target.Position
            
            -- Плавное наведение
            local currentCamera = camera.CFrame
            local targetCamera = CFrame.lookAt(currentCamera.Position, targetPosition)
            camera.CFrame = currentCamera:Lerp(targetCamera, AimSettings.Smoothness)
        end
    end)
end

-- ESP функции
function createESP(player)
    if ESPObjects[player] then return end
    
    local esp = {
        Box = nil,
        Name = nil,
        Distance = nil
    }
    
    -- Создание бокса
    if ESPSettings.Boxes then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Adornee = nil
        box.Size = Vector3.new(4, 6, 1)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 1
        box.Parent = player.Character
        esp.Box = box
    end
    
    -- Создание имени
    if ESPSettings.ShowName then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPName"
        billboard.Adornee = nil
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
        
        esp.Name = billboard
    end
    
    -- Создание дистанции
    if ESPSettings.ShowDistance then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPDistance"
        billboard.Adornee = nil
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 1.5, 0)
        billboard.AlwaysOnTop = true
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        distanceLabel.TextStrokeTransparency = 0
        distanceLabel.Font = Enum.Font.GothamBold
        distanceLabel.TextSize = 12
        distanceLabel.Parent = billboard
        
        esp.Distance = billboard
    end
    
    ESPObjects[player] = esp
end

function updateESP()
    for player, esp in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local isEnemyPlayer = isEnemy(player)
            
            -- Обновление цвета в зависимости от команды
            local color = isEnemyPlayer and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            
            if esp.Box then
                esp.Box.Adornee = rootPart
                esp.Box.Color3 = color
                esp.Box.Parent = player.Character
            end
            
            if esp.Name then
                esp.Name.Adornee = rootPart
                esp.Name.Parent = player.Character
            end
            
            if esp.Distance then
                esp.Distance.Adornee = rootPart
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    esp.Distance:FindFirstChildOfClass("TextLabel").Text = math.floor(distance) .. " studs"
                    esp.Distance:FindFirstChildOfClass("TextLabel").TextColor3 = color
                end
                esp.Distance.Parent = player.Character
            end
        else
            -- Удаление ESP если игрок умер
            if esp.Box then esp.Box:Destroy() end
            if esp.Name then esp.Name:Destroy() end
            if esp.Distance then esp.Distance:Destroy() end
            ESPObjects[player] = nil
        end
    end
end

-- Запуск ESP
local espConnection
function startESP()
    -- Создание ESP для существующих игроков
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
    
    -- Обработка новых игроков
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            createESP(player)
        end)
    end)
    
    -- Обновление ESP
    espConnection = RunService.RenderStepped:Connect(updateESP)
end

-- Горячие клавиши
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        AimSettings.Enabled = not AimSettings.Enabled
        print("Aimbot: " .. (AimSettings.Enabled and "ON" or "OFF"))
    end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        ESPSettings.Enabled = not ESPSettings.Enabled
        if ESPSettings.Enabled then
            startESP()
        else
            if espConnection then
                espConnection:Disconnect()
                -- Очистка ESP объектов
                for player, esp in pairs(ESPObjects) do
                    if esp.Box then esp.Box:Destroy() end
                    if esp.Name then esp.Name:Destroy() end
                    if esp.Distance then esp.Distance:Destroy() end
                end
                ESPObjects = {}
            end
        end
        print("ESP: " .. (ESPSettings.Enabled and "ON" or "OFF"))
    end
end)

-- Запуск
startAimbot()
startESP()

print("✅ Aimbot + ESP loaded!")
print("RightShift - Toggle Aimbot")
print("Insert - Toggle ESP")
