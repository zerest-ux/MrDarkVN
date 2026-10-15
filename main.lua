-- =====================================================================
-- MR DARK VN - ULTIMATE ACCOUNT GRINDING HUB (UPDATED VERSION)
-- Optimized for Low-End Devices & 24/7 AFK Grinding
-- =====================================================================

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- =====================================================================
-- CẤU HÌNH API & FILE CONFIG
-- =====================================================================
local CHECK_API = "http://mrdarkvn.x10.mx/checkkey.php?key="
local GET_API = "http://mrdarkvn.x10.mx/getkey.php"
local CONFIG_FILE = "MrDarkVN_GrindConfig.json"

-- Bảng dữ liệu cấu hình (Lưu mọi trạng thái người dùng bấm)
local ConfigData = {
    AutoFarmLevel = false,
    SelectedSea = "Sea 1 (Level 1 - 700)",
    SelectedWeapon = "Melee",
    FastAttack = false,
    AutoSkills = false, -- Tự động dùng chiêu Z, X, C, V
    AutoStats = false,
    StatType = "Melee",
    AutoFruits = false,
    AntiAdmin30s = true,
    AutoExecute = true
}

-- Hàm lưu cấu hình vào File trên Executor
local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(ConfigData))
        end
    end)
end

-- Hàm đọc cấu hình từ File để khôi phục trạng thái cũ
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

-- Cơ chế Auto Execute (Tự động nạp lại script khi đổi server hoặc teleport sang Sea khác)
pcall(function()
    if syn and syn.queue_on_teleport then
        syn.queue_on_teleport([[loadstring(game:HttpGet("LINK_SCRIPT_CUA_ONG"))()]])
    elseif queueteleport then
        queueteleport([[loadstring(game:HttpGet("LINK_SCRIPT_CUA_ONG"))()]])
    end
end)

-- Xóa UI cũ nếu tồn tại tránh xung đột gây lag máy
if LocalPlayer.PlayerGui:FindFirstChild("MrDarkGrindTool") then
    LocalPlayer.PlayerGui.MrDarkGrindTool:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MrDarkGrindTool"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

-- =====================================================================
-- 1. GIAO DIỆN ĐĂNG NHẬP & XÁC THỰC KEY (LOGIN SYSTEM)
-- =====================================================================
local LoginOverlay = Instance.new("Frame")
LoginOverlay.Name = "LoginOverlay"
LoginOverlay.Parent = ScreenGui
LoginOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
LoginOverlay.Size = UDim2.new(1, 0, 1, 0)

local LoginCard = Instance.new("Frame")
LoginCard.Parent = LoginOverlay
LoginCard.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
LoginCard.Position = UDim2.new(0.5, -180, 0.5, -135)
LoginCard.Size = UDim2.new(0, 360, 0, 270)
Instance.new("UICorner", LoginCard).CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = LoginCard
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1.2

local Title = Instance.new("TextLabel")
Title.Parent = LoginCard
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 12)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ MR DARK VN - GRINDING TOOL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = LoginCard
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 38)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "● SERVER: CHECKING..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusLabel.TextSize = 11

-- Kiểm tra trạng thái Server Online / Offline thực tế
task.spawn(function()
    local success = pcall(function() game:HttpGet(GET_API) end)
    if success then
        StatusLabel.Text = "● SERVER: ONLINE"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        StatusLabel.Text = "● SERVER: OFFLINE"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

local KeyBox = Instance.new("TextBox")
KeyBox.Parent = LoginCard
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyBox.Position = UDim2.new(0.1, 0, 0, 70)
KeyBox.Size = UDim2.new(0, 288, 0, 38)
KeyBox.Font = Enum.Font.Gotham
KeyBox.PlaceholderText = "Nhập Key bản quyền..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 13
KeyBox.ClearTextOnFocus = false
KeyBox.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = LoginCard
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 136, 204)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0, 122)
GetKeyBtn.Size = UDim2.new(0, 138, 0, 34)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Text = "🔑 GET KEY"
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.TextSize = 12
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)

GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(GET_API)
    pcall(function() syn.request({Url = GET_API, Method = "GET"}) end)
    GetKeyBtn.Text = "Đã Copy Link!"
    task.wait(2)
    GetKeyBtn.Text = "🔑 GET KEY"
end)

local PasteBtn = Instance.new("TextButton")
PasteBtn.Parent = LoginCard
PasteBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
PasteBtn.Position = UDim2.new(0.52, 0, 0, 122)
PasteBtn.Size = UDim2.new(0, 138, 0, 34)
PasteBtn.Font = Enum.Font.GothamBold
PasteBtn.Text = "📋 DÁN KEY"
PasteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PasteBtn.TextSize = 12
Instance.new("UICorner", PasteBtn).CornerRadius = UDim.new(0, 6)

PasteBtn.MouseButton1Click:Connect(function()
    local success, text = pcall(function() return getclipboard() end)
    if success and text then KeyBox.Text = text end
end)

local LoginBtn = Instance.new("TextButton")
LoginBtn.Parent = LoginCard
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
LoginBtn.Position = UDim2.new(0.1, 0, 0, 170)
LoginBtn.Size = UDim2.new(0, 288, 0, 40)
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.Text = "ĐĂNG NHẬP MR DARK VN"
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.TextSize = 13
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 6)

-- =====================================================================
-- 2. GIAO DIỆN CHÍNH (MAIN TOOL INTERFACE - ĐA TAB NÂNG CẤP)
-- =====================================================================
local function OpenMainHub()
    LoginOverlay:Destroy()

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    MainFrame.Size = UDim2.new(0, 520, 0, 380)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(0, 170, 255)
    MainStroke.Thickness = 1.2

    local TopBar = Instance.new("TextLabel")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.Font = Enum.Font.GothamBold
    TopBar.Text = "   MR DARK VN HUB | Ultimate Blox Fruits & Grinding Edition"
    TopBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TopBar.TextSize = 11
    TopBar.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

    -- Thanh Tab Phân Loại Chức Năng
    local TabBar = Instance.new("Frame")
    TabBar.Parent = MainFrame
    TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    TabBar.Position = UDim2.new(0, 10, 0, 42)
    TabBar.Size = UDim2.new(1, -20, 0, 32)
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 6)

    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 10, 0, 82)
    ContentArea.Size = UDim2.new(1, -20, 1, -92)

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
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        btn.Position = UDim2.new(posX, 0, 0, 2)
        btn.Size = UDim2.new(0, 120, 0, 28)
        btn.Font = Enum.Font.GothamBold
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

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
    CreateTabButton("⚙️ Settings & Safe", 0.76, TabSettings)

    -- =====================================================================
    -- TAB 1: AUTO FARM (NÂNG CẤP TOÀN DIỆN CHO BLOX FRUITS)
    -- =====================================================================
    
    -- 1. Nút Bật/Tắt Auto Farm Cấp Độ
    local FarmBtn = Instance.new("TextButton")
    FarmBtn.Parent = TabFarm
    FarmBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    FarmBtn.Position = UDim2.new(0, 0, 0, 10)
    FarmBtn.Size = UDim2.new(0, 475, 0, 40)
    FarmBtn.Font = Enum.Font.GothamBold
    FarmBtn.Text = ConfigData.AutoFarmLevel and "⏹ ĐANG CÀY CẤP (AUTO FARM)" or "⚡ BẬT AUTO FARM CẤP ĐỘ"
    FarmBtn.TextColor3 = ConfigData.AutoFarmLevel and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    FarmBtn.TextSize = 12
    Instance.new("UICorner", FarmBtn).CornerRadius = UDim.new(0, 6)

    if ConfigData.AutoFarmLevel then
        task.spawn(function()
            while ConfigData.AutoFarmLevel do
                task.wait(0.15)
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
        FarmBtn.Text = ConfigData.AutoFarmLevel and "⏹ ĐANG CÀY CẤP (AUTO FARM)" or "⚡ BẬT AUTO FARM CẤP ĐỘ"
        FarmBtn.TextColor3 = ConfigData.AutoFarmLevel and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
        
        if ConfigData.AutoFarmLevel then
            task.spawn(function()
                while ConfigData.AutoFarmLevel do
                    task.wait(0.15)
                    pcall(function()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    end)
                end
            end)
        end
    end)

    -- 2. Chọn Sea (Khu vực cày cấp)
    local SeaBtn = Instance.new("TextButton")
    SeaBtn.Parent = TabFarm
    SeaBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    SeaBtn.Position = UDim2.new(0, 0, 0, 60)
    SeaBtn.Size = UDim2.new(0, 475, 0, 35)
    SeaBtn.Font = Enum.Font.GothamBold
    SeaBtn.Text = "🌊 Khu Vực Cày (Sea): " .. ConfigData.SelectedSea
    SeaBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
    SeaBtn.TextSize = 11
    Instance.new("UICorner", SeaBtn).CornerRadius = UDim.new(0, 6)

    local seas = {"Sea 1 (Level 1 - 700)", "Sea 2 (Level 700 - 1500)", "Sea 3 (Level 1500 - 2550+)"}
    local seaIndex = 1
    SeaBtn.MouseButton1Click:Connect(function()
        seaIndex = seaIndex + 1
        if seaIndex > #seas then seaIndex = 1 end
        ConfigData.SelectedSea = seas[seaIndex]
        SeaBtn.Text = "🌊 Khu Vực Cày (Sea): " .. ConfigData.SelectedSea
        SaveConfig()
    end)

    -- 3. Chọn Vũ Khí (Weapon Select)
    local WeaponBtn = Instance.new("TextButton")
    WeaponBtn.Parent = TabFarm
    WeaponBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    WeaponBtn.Position = UDim2.new(0, 0, 0, 105)
    WeaponBtn.Size = UDim2.new(0, 232, 0, 35)
    WeaponBtn.Font = Enum.Font.GothamBold
    WeaponBtn.Text = "⚔️ Vũ Khí: " .. ConfigData.SelectedWeapon
    WeaponBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
    WeaponBtn.TextSize = 11
    Instance.new("UICorner", WeaponBtn).CornerRadius = UDim.new(0, 6)

    local weapons = {"Melee", "Sword", "Gun", "Blox Fruit"}
    local wIndex = 1
    WeaponBtn.MouseButton1Click:Connect(function()
        wIndex = wIndex + 1
        if wIndex > #weapons then wIndex = 1 end
        ConfigData.SelectedWeapon = weapons[wIndex]
        WeaponBtn.Text = "⚔️ Vũ Khí: " .. ConfigData.SelectedWeapon
        SaveConfig()
    end)

    -- 4. Nút bật Fast Attack
    local FastAtkBtn = Instance.new("TextButton")
    FastAtkBtn.Parent = TabFarm
    FastAtkBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    FastAtkBtn.Position = UDim2.new(0.51, 0, 0, 105)
    FastAtkBtn.Size = UDim2.new(0, 233, 0, 35)
    FastAtkBtn.Font = Enum.Font.GothamBold
    FastAtkBtn.Text = ConfigData.FastAttack and "⚡ Fast Attack: BẬT" or "⚡ Fast Attack: TẮT"
    FastAtkBtn.TextColor3 = ConfigData.FastAttack and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
    FastAtkBtn.TextSize = 11
    Instance.new("UICorner", FastAtkBtn).CornerRadius = UDim.new(0, 6)

    FastAtkBtn.MouseButton1Click:Connect(function()
        ConfigData.FastAttack = not ConfigData.FastAttack
        SaveConfig()
        FastAtkBtn.Text = ConfigData.FastAttack and "⚡ Fast Attack: BẬT" or "⚡ Fast Attack: TẮT"
        FastAtkBtn.TextColor3 = ConfigData.FastAttack and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
    end)

    -- 5. Nút Tự động dùng Skill (Z, X, C, V)
    local SkillBtn = Instance.new("TextButton")
    SkillBtn.Parent = TabFarm
    SkillBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    SkillBtn.Position = UDim2.new(0, 0, 0, 150)
    SkillBtn.Size = UDim2.new(0, 475, 0, 35)
    SkillBtn.Font = Enum.Font.GothamBold
    SkillBtn.Text = ConfigData.AutoSkills and "🔮 Auto Skills (Z X C V): BẬT" or "🔮 Auto Skills (Z X C V): TẮT"
    SkillBtn.TextColor3 = ConfigData.AutoSkills and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
    SkillBtn.TextSize = 11
    Instance.new("UICorner", SkillBtn).CornerRadius = UDim.new(0, 6)

    SkillBtn.MouseButton1Click:Connect(function()
        ConfigData.AutoSkills = not ConfigData.AutoSkills
        SaveConfig()
        SkillBtn.Text = ConfigData.AutoSkills and "🔮 Auto Skills (Z X C V): BẬT" or "🔮 Auto Skills (Z X C V): TẮT"
        SkillBtn.TextColor3 = ConfigData.AutoSkills and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
    end)


    -- =====================================================================
    -- TAB 2: AUTO STATS (CỘNG ĐIỂM TIỀM NĂNG TỰ ĐỘNG)
    -- =====================================================================
    
    local StatsToggle = Instance.new("TextButton")
    StatsToggle.Parent = TabStats
    StatsToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    StatsToggle.Position = UDim2.new(0, 0, 0, 10)
    StatsToggle.Size = UDim2.new(0, 475, 0, 40)
    StatsToggle.Font = Enum.Font.GothamBold
    StatsToggle.Text = ConfigData.AutoStats and "⏹ ĐANG TỰ ĐỘNG CỘNG ĐIỂM" or "📊 BẬT AUTO CỘNG ĐIỂM TIỀM NĂNG"
    StatsToggle.TextColor3 = ConfigData.AutoStats and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    StatsToggle.TextSize = 12
    Instance.new("UICorner", StatsToggle).CornerRadius = UDim.new(0, 6)

    StatsToggle.MouseButton1Click:Connect(function()
        ConfigData.AutoStats = not ConfigData.AutoStats
        SaveConfig()
        StatsToggle.Text = ConfigData.AutoStats and "⏹ Đang tự động cộng điểm" or "📊 Bật Auto cộng điểm tiềm năng"
        StatsToggle.TextColor3 = ConfigData.AutoStats and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    end)


    -- =====================================================================
    -- TAB 3: ITEMS & FRUIT (GOM VÀ NHẬT TRÁI CÂY RƠI RA)
    -- =====================================================================
    
    local FruitBtn = Instance.new("TextButton")
    FruitBtn.Parent = TabItems
    FruitBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    FruitBtn.Position = UDim2.new(0, 0, 0, 10)
    FruitBtn.Size = UDim2.new(0, 475, 0, 40)
    FruitBtn.Font = Enum.Font.GothamBold
    FruitBtn.Text = ConfigData.AutoFruits and "⏹ ĐANG NHẬT TRÁI CÂY..." or "🍎 BẬT AUTO NHẬT / GOM TRÁI CÂY"
    FruitBtn.TextColor3 = ConfigData.AutoFruits and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    FruitBtn.TextSize = 12
    Instance.new("UICorner", FruitBtn).CornerRadius = UDim.new(0, 6)

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
    -- TAB 4: SETTINGS & SAFE (ANTI-BAN & TỐI ƯU MÁY YẾU)
    -- =====================================================================
    
    -- 1. Nút Anti-Ban / Anti-Admin kiểm tra mỗi 30s
    local AntiBanBtn = Instance.new("TextButton")
    AntiBanBtn.Parent = TabSettings
    AntiBanBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    AntiBanBtn.Position = UDim2.new(0, 0, 0, 10)
    AntiBanBtn.Size = UDim2.new(0, 475, 0, 38)
    AntiBanBtn.Font = Enum.Font.GothamBold
    AntiBanBtn.Text = ConfigData.AntiAdmin30s and "🛡️ Anti-Ban / Anti-Admin (30s Check): BẬT" or "🛡️ Anti-Ban / Anti-Admin (30s Check): TẮT"
    AntiBanBtn.TextColor3 = ConfigData.AntiAdmin30s and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
    AntiBanBtn.TextSize = 11
    Instance.new("UICorner", AntiBanBtn).CornerRadius = UDim.new(0, 6)

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
        AntiBanBtn.TextColor3 = ConfigData.AntiAdmin30s and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
    end)

    -- 2. Nút Tối ưu máy yếu chống văng game khi treo 24/7
    local BoostBtn = Instance.new("TextButton")
    BoostBtn.Parent = TabSettings
    BoostBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    BoostBtn.Position = UDim2.new(0, 0, 0, 55)
    BoostBtn.Size = UDim2.new(0, 475, 0, 38)
    BoostBtn.Font = Enum.Font.GothamBold
    BoostBtn.Text = "🚀 BẬT TỐI ƯU MÁY YẾU (TREO ACC 24/7)"
    BoostBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
    BoostBtn.TextSize = 11
    Instance.new("UICorner", BoostBtn).CornerRadius = UDim.new(0, 6)

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

    -- 3. Nút Telegram Hỗ Trợ Chính Thức
    local TeleBtn = Instance.new("TextButton")
    TeleBtn.Parent = TabSettings
    TeleBtn.BackgroundColor3 = Color3.fromRGB(0, 136, 204)
    TeleBtn.Position = UDim2.new(0, 0, 0, 100)
    TeleBtn.Size = UDim2.new(0, 475, 0, 38)
    TeleBtn.Font = Enum.Font.GothamBold
    TeleBtn.Text = "💬 Hỗ Trợ Telegram: @ZerestMods"
    TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleBtn.TextSize = 11
    Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0, 6)

    TeleBtn.MouseButton1Click:Connect(function()
        setclipboard("https://t.me/ZerestMods")
        TeleBtn.Text = "✅ Đã Copy Link Telegram Admin!"
        task.wait(2)
        TeleBtn.Text = "💬 Hỗ Trợ Telegram: @ZerestMods"
    end)
end

-- =====================================================================
-- XỬ LÝ SỰ KIỆN KẾT NỐI API CHECKKEY
-- =====================================================================
LoginBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then
        LoginBtn.Text = "Vui lòng không để trống Key!"
        task.wait(1.5)
        LoginBtn.Text = "ĐĂNG NHẬP MR DARK VN"
        return
    end

    LoginBtn.Text = "Đang kiểm tra Key..."
    
    local success, response = pcall(function()
        return game:HttpGet(CHECK_API .. tostring(key))
    end)

    if success then
        if string.find(response:lower(), "true") or string.find(response:lower(), "success") or string.len(response) > 2 then
            LoginBtn.Text = "Thành công!"
            task.wait(0.5)
            OpenMainHub()
        else
            LoginBtn.Text = "Key không đúng hoặc hết hạn!"
            task.wait(1.5)
            LoginBtn.Text = "ĐĂNG NHẬP MR DARK VN"
        end
    else
        LoginBtn.Text = "Lỗi kết nối Server API!"
        task.wait(1.5)
        LoginBtn.Text = "ĐĂNG NHẬP MR DARK VN"
    end
end)
