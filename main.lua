-- =====================================================================
-- MR DARK VN - ULTIMATE MASTER GRINDING HUB (FULL RENEWED UI & LOGIC)
-- =====================================================================

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

-- Lấy HWID thiết bị thực tế để gửi kèm API checkkey.php
local successHwid, hwid = pcall(function()
    return RbxAnalyticsService:GetClientId()
end)
if not successHwid or not hwid then
    hwid = "unknown_device_id"
end

-- =====================================================================
-- CẤU HÌNH API & FILE CONFIG
-- =====================================================================
local CHECK_API = "http://mrdarkvn.x10.mx/checkkey.php?key="
local GET_API = "http://mrdarkvn.x10.mx/getkey.php"
local CONFIG_FILE = "MrDarkVN_MasterConfig.json"

local ConfigData = {
    AutoFarmLevel = false,
    SelectedSea = "Sea 1 (Level 1 - 700)",
    SelectedWeapon = "Melee",
    FastAttack = false,
    AutoSkills = false,
    AutoStats = false,
    AutoFruits = false,
    AntiAdmin30s = true
}

local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(ConfigData))
        end
    end)
end

local function LoadConfig()
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k, v in pairs(data) do
                ConfigData[k] = v
            end
        end
    end)
end
LoadConfig()

-- Xóa UI cũ nếu tồn tại
if LocalPlayer.PlayerGui:FindFirstChild("MrDarkMasterHub") then
    LocalPlayer.PlayerGui.MrDarkMasterHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MrDarkMasterHub"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

-- =====================================================================
-- 1. LOGIN SYSTEM (GIAO DIỆN ĐĂNG NHẬP SANG TRỌNG)
-- =====================================================================
local LoginOverlay = Instance.new("Frame")
LoginOverlay.Name = "LoginOverlay"
LoginOverlay.Parent = ScreenGui
LoginOverlay.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
LoginOverlay.Size = UDim2.new(1, 0, 1, 0)

local LoginCard = Instance.new("Frame")
LoginCard.Parent = LoginOverlay
LoginCard.BackgroundColor3 = Color3.fromRGB(18, 15, 25)
LoginCard.Position = UDim2.new(0.5, -190, 0.5, -140)
LoginCard.Size = UDim2.new(0, 380, 0, 280)
Instance.new("UICorner", LoginCard).CornerRadius = UDim.new(0, 14)

local LoginStroke = Instance.new("UIStroke")
LoginStroke.Parent = LoginCard
LoginStroke.Color = Color3.fromRGB(138, 43, 226) -- Sắc tím Neon cao cấp
LoginStroke.Thickness = 1.8

local Title = Instance.new("TextLabel")
Title.Parent = LoginCard
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 15)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "🔮 MR DARK VN - PREMIUM AUTH"
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.TextSize = 15

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = LoginCard
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 45)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "● SERVER: CHECKING..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusLabel.TextSize = 11

task.spawn(function()
    local success = pcall(function() game:HttpGet(GET_API) end)
    if success then
        StatusLabel.Text = "● SERVER: ONLINE"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
    else
        StatusLabel.Text = "● SERVER: OFFLINE"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

local KeyBox = Instance.new("TextBox")
KeyBox.Parent = LoginCard
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
KeyBox.Position = UDim2.new(0.1, 0, 0, 80)
KeyBox.Size = UDim2.new(0, 304, 0, 42)
KeyBox.Font = Enum.Font.Gotham
KeyBox.PlaceholderText = "Nhập Key bản quyền của bạn..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 13
KeyBox.ClearTextOnFocus = false
KeyBox.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = LoginCard
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(90, 30, 160)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0, 135)
GetKeyBtn.Size = UDim2.new(0, 146, 0, 38)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Text = "🔑 GET KEY"
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.TextSize = 12
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(GET_API)
    pcall(function() syn.request({Url = GET_API, Method = "GET"}) end)
    GetKeyBtn.Text = "Đã Copy Link!"
    task.wait(2)
    GetKeyBtn.Text = "🔑 GET KEY"
end)

local PasteBtn = Instance.new("TextButton")
PasteBtn.Parent = LoginCard
PasteBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 60)
PasteBtn.Position = UDim2.new(0.52, 0, 0, 135)
PasteBtn.Size = UDim2.new(0, 146, 0, 38)
PasteBtn.Font = Enum.Font.GothamBold
PasteBtn.Text = "📋 DÁN KEY"
PasteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PasteBtn.TextSize = 12
Instance.new("UICorner", PasteBtn).CornerRadius = UDim.new(0, 8)

PasteBtn.MouseButton1Click:Connect(function()
    local success, text = pcall(function() return getclipboard() end)
    if success and text then KeyBox.Text = text end
end)

local LoginBtn = Instance.new("TextButton")
LoginBtn.Parent = LoginCard
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
LoginBtn.Position = UDim2.new(0.1, 0, 0, 185)
LoginBtn.Size = UDim2.new(0, 304, 0, 45)
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.Text = "XÁC THỰC & ĐĂNG NHẬP"
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.TextSize = 13
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

-- =====================================================================
-- 2. MAIN HUB INTERFACE & NÚT TRÒN DI CHUYỂN LINH HOẠT
-- =====================================================================
local function OpenMainHub()
    LoginOverlay:Destroy()

    -- Nút tròn nổi (Floating Ball) kéo thả mọi hướng trên/dưới/trái/phải
    local ToggleBall = Instance.new("TextButton")
    ToggleBall.Parent = ScreenGui
    ToggleBall.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    ToggleBall.Position = UDim2.new(0, 30, 0.5, -25)
    ToggleBall.Size = UDim2.new(0, 52, 0, 52)
    ToggleBall.Font = Enum.Font.GothamBold
    ToggleBall.Text = "MR"
    ToggleBall.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBall.TextSize = 14
    Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)

    local BallStroke = Instance.new("UIStroke")
    BallStroke.Parent = ToggleBall
    BallStroke.Color = Color3.fromRGB(255, 255, 255)
    BallStroke.Thickness = 2

    local dragging, dragInput, dragStart, startPos
    ToggleBall.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleBall.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    ToggleBall.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            ToggleBall.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 20)
    MainFrame.Position = UDim2.new(0.5, -270, 0.5, -195)
    MainFrame.Size = UDim2.new(0, 540, 0, 390)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(138, 43, 226)
    MainStroke.Thickness = 1.8

    local menuVisible = true
    ToggleBall.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        MainFrame.Visible = menuVisible
    end)

    local TopBar = Instance.new("TextLabel")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 16, 30)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.Font = Enum.Font.GothamBold
    TopBar.Text = "   🔮 MR DARK VN HUB | Master Grinding Edition"
    TopBar.TextColor3 = Color3.fromRGB(220, 150, 255)
    TopBar.TextSize = 12
    TopBar.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local TabBar = Instance.new("Frame")
    TabBar.Parent = MainFrame
    TabBar.BackgroundColor3 = Color3.fromRGB(18, 14, 26)
    TabBar.Position = UDim2.new(0, 12, 0, 48)
    TabBar.Size = UDim2.new(1, -24, 0, 34)
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 12, 0, 90)
    ContentArea.Size = UDim2.new(1, -24, 1, -100)

    local TabFarm = Instance.new("ScrollingFrame")
    local TabStats = Instance.new("ScrollingFrame")
    local TabItems = Instance.new("ScrollingFrame")
    local TabSettings = Instance.new("ScrollingFrame")

    for _, tab in ipairs({TabFarm, TabStats, TabItems, TabSettings}) do
        tab.Parent = ContentArea
        tab.Size = UDim2.new(1, 0, 1, 0)
        tab.BackgroundTransparency = 1
        tab.BorderSizePixel = 0
        tab.ScrollBarThickness = 3
        tab.Visible = false
    end
    TabFarm.Visible = true

    local function CreateTabButton(name, posX, targetTab)
        local btn = Instance.new("TextButton")
        btn.Parent = TabBar
        btn.BackgroundColor3 = Color3.fromRGB(28, 22, 40)
        btn.Position = UDim2.new(posX, 0, 0, 3)
        btn.Size = UDim2.new(0, 121, 0, 28)
        btn.Font = Enum.Font.GothamBold
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(180, 170, 200)
        btn.TextSize = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            TabFarm.Visible = false
            TabStats.Visible = false
            TabItems.Visible = false
            TabSettings.Visible = false
            targetTab.Visible = true
        end)
    end

    CreateTabButton("⚔️ Auto Farm", 0.01, TabFarm)
    CreateTabButton("📊 Auto Stats", 0.26, TabStats)
    CreateTabButton("🍎 Items & Fruit", 0.51, TabItems)
    CreateTabButton("⚙️ Settings", 0.76, TabSettings)

    -- =====================================================================
    -- TAB 1: AUTO FARM
    -- =====================================================================
    local FarmBtn = Instance.new("TextButton")
    FarmBtn.Parent = TabFarm
    FarmBtn.BackgroundColor3 = Color3.fromRGB(32, 25, 48)
    FarmBtn.Position = UDim2.new(0, 0, 0, 10)
    FarmBtn.Size = UDim2.new(0, 492, 0, 42)
    FarmBtn.Font = Enum.Font.GothamBold
    FarmBtn.Text = ConfigData.AutoFarmLevel and "⏹ ĐANG CÀY CẤP (AUTO FARM ON)" or "⚡ BẬT AUTO FARM CẤP ĐỘ"
    FarmBtn.TextColor3 = ConfigData.AutoFarmLevel and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
    FarmBtn.TextSize = 12
    Instance.new("UICorner", FarmBtn).CornerRadius = UDim.new(0, 8)

    if ConfigData.AutoFarmLevel then
        task.spawn(function()
            while ConfigData.AutoFarmLevel do
                task.wait(0.12)
                pcall(function()
                    if not ConfigData.AntiAdmin30s then
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    end
                end)
            end
        end)
    end

    FarmBtn.MouseButton1Click:Connect(function()
        ConfigData.AutoFarmLevel = not ConfigData.AutoFarmLevel
        SaveConfig()
        FarmBtn.Text = ConfigData.AutoFarmLevel and "⏹ ĐANG CÀY CẤP (AUTO FARM ON)" or "⚡ BẬT AUTO FARM CẤP ĐỘ"
        FarmBtn.TextColor3 = ConfigData.AutoFarmLevel and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
        
        if ConfigData.AutoFarmLevel then
            task.spawn(function()
                while ConfigData.AutoFarmLevel do
                    task.wait(0.12)
                    pcall(function()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    end)
                end
            end)
        end
    end)

    local SeaBtn = Instance.new("TextButton")
    SeaBtn.Parent = TabFarm
    SeaBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    SeaBtn.Position = UDim2.new(0, 0, 0, 62)
    SeaBtn.Size = UDim2.new(0, 492, 0, 38)
    SeaBtn.Font = Enum.Font.GothamBold
    SeaBtn.Text = "🌊 Khu Vực Cày (Sea): " .. ConfigData.SelectedSea
    SeaBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
    SeaBtn.TextSize = 11
    Instance.new("UICorner", SeaBtn).CornerRadius = UDim.new(0, 8)

    local seas = {"Sea 1 (Level 1 - 700)", "Sea 2 (Level 700 - 1500)", "Sea 3 (Level 1500 - 2550+)"}
    local seaIndex = 1
    SeaBtn.MouseButton1Click:Connect(function()
        seaIndex = seaIndex + 1
        if seaIndex > #seas then seaIndex = 1 end
        ConfigData.SelectedSea = seas[seaIndex]
        SeaBtn.Text = "🌊 Khu Vực Cày (Sea): " .. ConfigData.SelectedSea
        SaveConfig()
    end)

    local WeaponBtn = Instance.new("TextButton")
    WeaponBtn.Parent = TabFarm
    WeaponBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    WeaponBtn.Position = UDim2.new(0, 0, 0, 112)
    WeaponBtn.Size = UDim2.new(0, 240, 0, 38)
    WeaponBtn.Font = Enum.Font.GothamBold
    WeaponBtn.Text = "⚔️ Vũ Khí: " .. ConfigData.SelectedWeapon
    WeaponBtn.TextColor3 = Color3.fromRGB(255, 220, 0)
    WeaponBtn.TextSize = 11
    Instance.new("UICorner", WeaponBtn).CornerRadius = UDim.new(0, 8)

    local weapons = {"Melee", "Sword", "Gun", "Blox Fruit"}
    local wIndex = 1
    WeaponBtn.MouseButton1Click:Connect(function()
        wIndex = wIndex + 1
        if wIndex > #weapons then wIndex = 1 end
        ConfigData.SelectedWeapon = weapons[wIndex]
        WeaponBtn.Text = "⚔️ Vũ Khí: " .. ConfigData.SelectedWeapon
        SaveConfig()
    end)

    local FastAtkBtn = Instance.new("TextButton")
    FastAtkBtn.Parent = TabFarm
    FastAtkBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    FastAtkBtn.Position = UDim2.new(0.51, 0, 0, 112)
    FastAtkBtn.Size = UDim2.new(0, 241, 0, 38)
    FastAtkBtn.Font = Enum.Font.GothamBold
    FastAtkBtn.Text = ConfigData.FastAttack and "⚡ Fast Attack: BẬT" or "⚡ Fast Attack: TẮT"
    FastAtkBtn.TextColor3 = ConfigData.FastAttack and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(180, 180, 180)
    FastAtkBtn.TextSize = 11
    Instance.new("UICorner", FastAtkBtn).CornerRadius = UDim.new(0, 8)

    FastAtkBtn.MouseButton1Click:Connect(function()
        ConfigData.FastAttack = not ConfigData.FastAttack
        SaveConfig()
        FastAtkBtn.Text = ConfigData.FastAttack and "⚡ Fast Attack: BẬT" or "⚡ Fast Attack: TẮT"
        FastAtkBtn.TextColor3 = ConfigData.FastAttack and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(180, 180, 180)
    end)

    local SkillBtn = Instance.new("TextButton")
    SkillBtn.Parent = TabFarm
    SkillBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    SkillBtn.Position = UDim2.new(0, 0, 0, 162)
    SkillBtn.Size = UDim2.new(0, 492, 0, 38)
    SkillBtn.Font = Enum.Font.GothamBold
    SkillBtn.Text = ConfigData.AutoSkills and "🔮 Auto Skills (Z X C V): BẬT" or "🔮 Auto Skills (Z X C V): TẮT"
    SkillBtn.TextColor3 = ConfigData.AutoSkills and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(180, 180, 180)
    SkillBtn.TextSize = 11
    Instance.new("UICorner", SkillBtn).CornerRadius = UDim.new(0, 8)

    SkillBtn.MouseButton1Click:Connect(function()
        ConfigData.AutoSkills = not ConfigData.AutoSkills
        SaveConfig()
        SkillBtn.Text = ConfigData.AutoSkills and "🔮 Auto Skills (Z X C V): BẬT" or "🔮 Auto Skills (Z X C V): TẮT"
        SkillBtn.TextColor3 = ConfigData.AutoSkills and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(180, 180, 180)
    end)

    -- =====================================================================
    -- TAB 2: AUTO STATS
    -- =====================================================================
    local StatsToggle = Instance.new("TextButton")
    StatsToggle.Parent = TabStats
    StatsToggle.BackgroundColor3 = Color3.fromRGB(32, 25, 48)
    StatsToggle.Position = UDim2.new(0, 0, 0, 10)
    StatsToggle.Size = UDim2.new(0, 492, 0, 42)
    StatsToggle.Font = Enum.Font.GothamBold
    StatsToggle.Text = ConfigData.AutoStats and "⏹ ĐANG TỰ ĐỘNG CỘNG ĐIỂM" or "📊 BẬT AUTO CỘNG ĐIỂM TIỀM NĂNG"
    StatsToggle.TextColor3 = ConfigData.AutoStats and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
    StatsToggle.TextSize = 12
    Instance.new("UICorner", StatsToggle).CornerRadius = UDim.new(0, 8)

    StatsToggle.MouseButton1Click:Connect(function()
        ConfigData.AutoStats = not ConfigData.AutoStats
        SaveConfig()
        StatsToggle.Text = ConfigData.AutoStats and "⏹ Đang tự động cộng điểm" or "📊 Bật Auto cộng điểm tiềm năng"
        StatsToggle.TextColor3 = ConfigData.AutoStats and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
    end)

    -- =====================================================================
    -- TAB 3: ITEMS & FRUIT
    -- =====================================================================
    local FruitBtn = Instance.new("TextButton")
    FruitBtn.Parent = TabItems
    FruitBtn.BackgroundColor3 = Color3.fromRGB(32, 25, 48)
    FruitBtn.Position = UDim2.new(0, 0, 0, 10)
    FruitBtn.Size = UDim2.new(0, 492, 0, 42)
    FruitBtn.Font = Enum.Font.GothamBold
    FruitBtn.Text = ConfigData.AutoFruits and "⏹ ĐANG NHẬT TRÁI CÂY..." or "🍎 BẬT AUTO NHẬT / GOM TRÁI CÂY"
    FruitBtn.TextColor3 = ConfigData.AutoFruits and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
    FruitBtn.TextSize = 12
    Instance.new("UICorner", FruitBtn).CornerRadius = UDim.new(0, 8)

    if ConfigData.AutoFruits then
        task.spawn(function()
            while ConfigData.AutoFruits do
                task.wait(1)
                pcall(function()
                    for _, v in pairs(Workspace:GetChildren()) do
                        if v:IsA("Tool") and string.find(v.Name:lower(), "fruit") then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                v.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end)
            end
        end)
    end

    FruitBtn.MouseButton1Click:Connect(function()
        ConfigData.AutoFruits = not ConfigData.AutoFruits
        SaveConfig()
        FruitBtn.Text = ConfigData.AutoFruits and "⏹ Đang nhặt trái cây..." or "🍎 Bật Auto nhặt / gom trái cây"
    end)

    -- =====================================================================
    -- TAB 4: SETTINGS & SAFE (ANTI-BAN 30s)
    -- =====================================================================
    local AntiBanBtn = Instance.new("TextButton")
    AntiBanBtn.Parent = TabSettings
    AntiBanBtn.BackgroundColor3 = Color3.fromRGB(32, 25, 48)
    AntiBanBtn.Position = UDim2.new(0, 0, 0, 10)
    AntiBanBtn.Size = UDim2.new(0, 492, 0, 40)
    AntiBanBtn.Font = Enum.Font.GothamBold
    AntiBanBtn.Text = ConfigData.AntiAdmin30s and "🛡️ Anti-Ban / Anti-Admin (30s Check): BẬT" or "🛡️ Anti-Ban / Anti-Admin (30s Check): TẮT"
    AntiBanBtn.TextColor3 = ConfigData.AntiAdmin30s and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(180, 180, 180)
    AntiBanBtn.TextSize = 11
    Instance.new("UICorner", AntiBanBtn).CornerRadius = UDim.new(0, 8)

    task.spawn(function()
        while true do
            task.wait(30)
            if ConfigData.AntiAdmin30s then
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and (p:GetRankInGroup(0) > 0 or string.find(p.Name:lower(), "admin") or string.find(p.Name:lower(), "mod")) then
                            ConfigData.AutoFarmLevel = false
                            task.wait(5)
                        end
                    end
                end)
            end
        end
    end)

    AntiBanBtn.MouseButton1Click:Connect(function()
        ConfigData.AntiAdmin30s = not ConfigData.AntiAdmin30s
        SaveConfig()
        AntiBanBtn.Text = ConfigData.AntiAdmin30s and "🛡️ Anti-Ban / Anti-Admin (30s Check): BẬT" or "🛡️ Anti-Ban / Anti-Admin (30s Check): TẮT"
        AntiBanBtn.TextColor3 = ConfigData.AntiAdmin30s and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(180, 180, 180)
    end)

    local BoostBtn = Instance.new("TextButton")
    BoostBtn.Parent = TabSettings
    BoostBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
    BoostBtn.Position = UDim2.new(0, 0, 0, 60)
    BoostBtn.Size = UDim2.new(0, 492, 0, 40)
    BoostBtn.Font = Enum.Font.GothamBold
    BoostBtn.Text = "🚀 BẬT TỐI ƯU MÁY YẾU (TREO ACC 24/7)"
    BoostBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
    BoostBtn.TextSize = 11
    Instance.new("UICorner", BoostBtn).CornerRadius = UDim.new(0, 8)

    BoostBtn.MouseButton1Click:Connect(function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Part") or v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                end
            end
        end)
        BoostBtn.Text = "✅ ĐÃ TỐI ƯU MÁY TREO HOÀN TẤT!"
    end)

    local TeleBtn = Instance.new("TextButton")
    TeleBtn.Parent = TabSettings
    TeleBtn.BackgroundColor3 = Color3.fromRGB(0, 136, 204)
    TeleBtn.Position = UDim2.new(0, 0, 0, 110)
    TeleBtn.Size = UDim2.new(0, 492, 0, 40)
    TeleBtn.Font = Enum.Font.GothamBold
    TeleBtn.Text = "💬 Hỗ Trợ Telegram: @ZerestMods"
    TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleBtn.TextSize = 11
    Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0, 8)

    TeleBtn.MouseButton1Click:Connect(function()
        setclipboard("https://t.me/ZerestMods")
        TeleBtn.Text = "✅ Đã Copy Link Telegram Admin!"
        task.wait(2)
        TeleBtn.Text = "💬 Hỗ Trợ Telegram: @ZerestMods"
    end)
end

-- =====================================================================
-- XỬ LÝ SỰ KIỆN XÁC THỰC API CHECKKEY CHUẨN XÁC TỪ FILE PHP
-- =====================================================================
LoginBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then
        LoginBtn.Text = "Vui lòng không để trống Key!"
        task.wait(1.5)
        LoginBtn.Text = "XÁC THỰC & ĐĂNG NHẬP"
        return
    end

    LoginBtn.Text = "Đang xác thực HWID với Server..."
    
    local apiURL = CHECK_API .. tostring(key) .. "&hwid=" .. tostring(hwid)
    local success, response = pcall(function()
        return game:HttpGet(apiURL)
    end)

    if success and response then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)

        if decodeSuccess and data then
            -- Kiểm tra nghiêm ngặt thông tin phản hồi từ file checkkey.php
            if data.success == true and data.valid == true then
                LoginBtn.Text = "Thành công! Đang vào Hub..."
                task.wait(0.5)
                OpenMainHub()
            else
                local errorMsg = data.message or "Key không hợp lệ!"
                LoginBtn.Text = errorMsg
                task.wait(2.5)
                LoginBtn.Text = "XÁC THỰC & ĐĂNG NHẬP"
            end
        else
            LoginBtn.Text = "Lỗi phản hồi từ Server!"
            task.wait(2)
            LoginBtn.Text = "XÁC THỰC & ĐĂNG NHẬP"
        end
    else
        LoginBtn.Text = "Lỗi kết nối API Server!"
        task.wait(2)
        LoginBtn.Text = "XÁC THỰC & ĐĂNG NHẬP"
    end
end)
