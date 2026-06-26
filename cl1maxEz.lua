--==[ SWINGER MOBILE FULL v3.0 ]==--
-- Для Roblox Mobile (Android/iOS)

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Проверка на мобильное устройство
if not uis.TouchEnabled then
    print("Этот скрипт только для телефона!")
    return
end

-- Ожидание персонажа
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Переменные состояний
local flyEnabled = false
local espEnabled = false
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false
local flyBodyVelocity = nil
local flyConnection = nil
local espObjects = {}

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SwingerMobile"
screenGui.Parent = player.PlayerGui

-- Затемнение фона
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.BackgroundTransparency = 0.6
background.Parent = screenGui

-- Основное меню
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0.9, 0, 0.55, 0)
menu.Position = UDim2.new(0.05, 0, 0.225, 0)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
menu.BackgroundTransparency = 0.1
menu.CornerRadius = UDim.new(0, 20)
menu.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.12, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "⚡ SWINGER MOBILE ⚡"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- Функция создания кнопки
local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0.13, 0)
    btn.Position = UDim2.new(0.075, 0, yPos, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 90)
    btn.BackgroundTransparency = 0.2
    btn.CornerRadius = UDim.new(0, 12)
    btn.Parent = menu
    
    -- Эффект нажатия
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 130)
        task.wait(0.1)
        btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 90)
    end)
    
    return btn
end

-- КНОПКИ
local speedBtn = createButton("🏃 Speed: OFF", 0.15, Color3.fromRGB(70, 130, 200))
local flyBtn = createButton("✈️ Fly: OFF", 0.30, Color3.fromRGB(200, 70, 70))
local espBtn = createButton("👁️ ESP: OFF", 0.45, Color3.fromRGB(70, 200, 70))
local noclipBtn = createButton("🌀 Noclip: OFF", 0.60, Color3.fromRGB(200, 200, 70))
local jumpBtn = createButton("🦘 Jump: OFF", 0.75, Color3.fromRGB(200, 70, 200))

-- ДОПОЛНИТЕЛЬНАЯ ПАНЕЛЬ (для телепортации)
local tpPanel = Instance.new("Frame")
tpPanel.Size = UDim2.new(0.4, 0, 0.35, 0)
tpPanel.Position = UDim2.new(0.55, 0, 0.6, 0)
tpPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
tpPanel.BackgroundTransparency = 0.1
tpPanel.CornerRadius = UDim.new(0, 15)
tpPanel.Visible = false
tpPanel.Parent = screenGui

local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1, 0, 0.2, 0)
tpTitle.Text = "🎯 Телепорт"
tpTitle.TextColor3 = Color3.new(1, 1, 1)
tpTitle.TextScaled = true
tpTitle.BackgroundTransparency = 1
tpTitle.Parent = tpPanel

local tpList = Instance.new("ScrollingFrame")
tpList.Size = UDim2.new(1, 0, 0.8, 0)
tpList.Position = UDim2.new(0, 0, 0.2, 0)
tpList.BackgroundTransparency = 1
tpList.CanvasSize = UDim2.new(0, 0, 0, 0)
tpList.Parent = tpPanel

-- Функция обновления списка игроков для телепорта
local function updateTPList()
    for _, v in pairs(tpList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    local y = 0
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextScaled = true
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            btn.Parent = tpList
            btn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    rootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    tpPanel.Visible = false
                end
            end)
            y = y + 32
        end
    end
    tpList.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Кнопка открытия телепорта
local tpOpenBtn = Instance.new("TextButton")
tpOpenBtn.Size = UDim2.new(0.12, 0, 0.07, 0)
tpOpenBtn.Position = UDim2.new(0.85, 0, 0.08, 0)
tpOpenBtn.Text = "📡"
tpOpenBtn.TextColor3 = Color3.new(1, 1, 1)
tpOpenBtn.TextScaled = true
tpOpenBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
tpOpenBtn.CornerRadius = UDim.new(1, 0)
tpOpenBtn.Parent = screenGui
tpOpenBtn.MouseButton1Click:Connect(function()
    tpPanel.Visible = not tpPanel.Visible
    if tpPanel.Visible then
        updateTPList()
    end
end)

-- ============ ФУНКЦИИ ============

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        humanoid.WalkSpeed = 75
        speedBtn.Text = "🏃 Speed: ON"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        humanoid.WalkSpeed = 16
        speedBtn.Text = "🏃 Speed: OFF"
        speedBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    end
end)

-- FLY
flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyBtn.Text = "✈️ Fly: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 50000
        flyBodyVelocity.Parent = rootPart
        
        flyConnection = runService.Heartbeat:Connect(function()
            if not flyEnabled or not rootPart.Parent then
                if flyBodyVelocity then flyBodyVelocity:Destroy() end
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            
            local moveDir = Vector3.new(0, 0, 0)
            if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + rootPart.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - rootPart.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - rootPart.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + rootPart.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            -- Для телефона: свайпы
            if uis:GetFingerPositions() and #uis:GetFingerPositions() > 0 then
                -- Здесь можно добавить управление через касания
            end
            
            if moveDir.Magnitude > 0 then
                flyBodyVelocity.Velocity = moveDir.Unit * 80
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        flyBtn.Text = "✈️ Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
    end
end)

-- ESP
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "👁️ ESP: ON"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        createESP()
    else
        espBtn.Text = "👁️ ESP: OFF"
        espBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
        removeESP()
    end
end)

function createESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                
                local box = Instance.new("BillboardGui")
                box.Size = UDim2.new(0, 100, 0, 30)
                box.AlwaysOnTop = true
                box.Adornee = hrp
                box.StudsOffset = Vector3.new(0, 2.5, 0)
                box.Parent = screenGui
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(1, 0, 0)
                frame.BackgroundTransparency = 0.5
                frame.BorderSizePixel = 0
                frame.Parent = box
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 15)
                label.Position = UDim2.new(0, 0, 1, 0)
                label.Text = p.Name
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextScaled = true
                label.BackgroundTransparency = 1
                label.Parent = box
                
                table.insert(espObjects, box)
            end
        end
    end
end

function removeESP()
    for _, v in pairs(espObjects) do
        v:Destroy()
    end
    espObjects = {}
end

-- NOCLIP
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipBtn.Text = "🌀 Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        runService.Stepped:Connect(function()
            if not noclipEnabled or not character then return end
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        noclipBtn.Text = "🌀 Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 70)
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- INFINITE JUMP
jumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        jumpBtn.Text = "🦘 Jump: ON"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        jumpBtn.Text = "🦘 Jump: OFF"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 200)
    end
end)

uis.JumpRequest:Connect(function()
    if jumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ОБНОВЛЕНИЕ ESP ПРИ ДОБАВЛЕНИИ ИГРОКА
game.Players.PlayerAdded:Connect(function(p)
    if espEnabled then
        task.wait(0.5)
        createESP()
    end
end)

-- ОБРАБОТКА СМЕРТИ ПЕРСОНАЖА
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if flyEnabled then
        flyBtn.MouseButton1Click:Connect(function() end)
        flyEnabled = false
        flyBtn.Text = "✈️ Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    end
end)

-- ЗАКРЫТИЕ МЕНЮ ПО ТАПУ ВНЕ ЕГО
background.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    tpPanel.Visible = false
end)

print("✅ SWINGER MOBILE FULL загружен!")
print("📱 Нажми на фон, чтобы скрыть/показать меню")
