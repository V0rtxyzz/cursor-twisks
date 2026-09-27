--// =========================================================
--// CURSOR TWISKS - Personalização de Cursor
--// by clautxyz
--// CapsLock = trava fixa | Botão direito = padrão do Roblox
--// F5 = abrir/fechar menu | Correção de tela sempre ativa
--// =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =========================================================
-- CONFIG
-- =========================================================

local DEFAULT_CURSOR_SIZE = 32
local MIN_CURSOR_SIZE = 12
local MAX_CURSOR_SIZE = 100

local APENAS_PRIMEIRA_PESSOA = false -- true = trava sempre, ignora CapsLock
local TOGGLE_KEY = Enum.KeyCode.CapsLock
local MENU_KEY = Enum.KeyCode.F5

local Sensibilidade = 100 -- 0 a 100
local mouseLockedFixo = false

-- =========================================================
-- GUI PARENT
-- =========================================================

local GUIParent

pcall(function()
    if gethui then GUIParent = gethui() end
end)
if not GUIParent then
    pcall(function() GUIParent = game:GetService("CoreGui") end)
end
if not GUIParent then
    GUIParent = PlayerGui
end

pcall(function()
    local old = GUIParent:FindFirstChild("CURSOR_TWISKS")
    if old then old:Destroy() end
end)

-- =========================================================
-- HELPERS
-- =========================================================

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() obj[k] = v end)
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, parent)
end

local function Stroke(parent, color, thickness)
    return New("UIStroke", { Color = color or Color3.fromRGB(45,45,45), Thickness = thickness or 1 }, parent)
end

-- =========================================================
-- CORES
-- =========================================================

local BG = Color3.fromRGB(10, 11, 15)
local TOP = Color3.fromRGB(18, 20, 26)
local PANEL = Color3.fromRGB(24, 26, 33)
local ELEMENT = Color3.fromRGB(29, 32, 40)
local TEXT = Color3.fromRGB(235, 235, 240)
local SUBTEXT = Color3.fromRGB(155, 158, 170)
local ACCENT = Color3.fromRGB(82, 215, 166)

-- =========================================================
-- GUI PRINCIPAL (começa escondida)
-- =========================================================

local ScreenGui = New("ScreenGui", {
    Name = "CURSOR_TWISKS",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999999
}, GUIParent)

local Main = New("Frame", {
    Size = UDim2.new(0, 340, 0, 320),
    Position = UDim2.new(0.5, -170, 0.5, -160),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    Visible = false
}, ScreenGui)

Corner(Main, 14)
Stroke(Main, Color3.fromRGB(42,45,54), 1)

if UIS.TouchEnabled then
    Main.Size = UDim2.new(0.8, 0, 0.55, 0)
    Main.Position = UDim2.new(0.1, 0, 0.22, 0)
end

local Topbar = New("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = TOP,
    BorderSizePixel = 0
}, Main)
Corner(Topbar, 14)

New("TextLabel", {
    Size = UDim2.new(1, -100, 0, 26),
    Position = UDim2.new(0, 16, 0, 6),
    BackgroundTransparency = 1,
    Text = "CURSOR TWISKS",
    TextColor3 = TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left
}, Topbar)

New("TextLabel", {
    Size = UDim2.new(1, -100, 0, 18),
    Position = UDim2.new(0, 17, 0, 32),
    BackgroundTransparency = 1,
    Text = "Personalização de Cursor",
    TextColor3 = SUBTEXT,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, Topbar)

-- BOTÃO X (fechar painel)
local CloseBtn = New("TextButton", {
    Size = UDim2.fromOffset(36, 32),
    Position = UDim2.new(1, -46, 0, 13),
    BackgroundColor3 = ELEMENT,
    Text = "×",
    TextColor3 = TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 20
}, Topbar)
Corner(CloseBtn, 9)

CloseBtn.Activated:Connect(function()
    Main.Visible = false
end)

-- arrastar pelo topo
local dragging, dragStart, startPos = false, nil, nil
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end)

-- =========================================================
-- CONTEÚDO: SÓ CURSOR
-- =========================================================

local Content = New("Frame", {
    Size = UDim2.new(1, -20, 1, -70),
    Position = UDim2.new(0, 10, 0, 66),
    BackgroundTransparency = 1
}, Main)

New("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, Content)

local Cursor = New("ImageLabel", {
    BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromOffset(DEFAULT_CURSOR_SIZE, DEFAULT_CURSOR_SIZE),
    Visible = false, ZIndex = 999999
}, ScreenGui)

local cursorActive = false
local cursorSize = DEFAULT_CURSOR_SIZE

local function cleanID(text)
    if not text then return nil end
    text = tostring(text):gsub("%s+", "")
    local id = text:match("rbxassetid://(%d+)") or text:match("[?&]id=(%d+)") or text:match("(%d+)")
    return id
end

local function loadCursorAsset(input)
    local id = cleanID(input)
    if not id then return false end
    Cursor.Image = "rbxassetid://" .. id
    Cursor.Visible = true
    cursorActive = true
    return true
end

local InputBox = New("TextBox", {
    Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = PANEL, ClearTextOnFocus = false,
    PlaceholderText = "Cole o ID do Decal aqui...", Text = "", TextColor3 = TEXT,
    PlaceholderColor3 = SUBTEXT, Font = Enum.Font.Gotham, TextSize = 13
}, Content)
Corner(InputBox, 9)
New("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, InputBox)

local ApplyBtn = New("TextButton", {
    Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = ACCENT, Text = "APLICAR CURSOR",
    TextColor3 = Color3.fromRGB(10,25,20), Font = Enum.Font.GothamBold, TextSize = 13
}, Content)
Corner(ApplyBtn, 9)

ApplyBtn.Activated:Connect(function()
    if InputBox.Text == "" then return end
    if loadCursorAsset(InputBox.Text) then
        pcall(function() UIS.MouseIconEnabled = false end)
        ApplyBtn.Text = "APLICADO ✓"
        task.delay(1.2, function()
            if ApplyBtn and ApplyBtn.Parent then ApplyBtn.Text = "APLICAR CURSOR" end
        end)
    end
end)

-- slider genérico
local function Slider(parent, text, min, max, default, callback)
    local Frame = New("Frame", { Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = PANEL }, parent)
    Corner(Frame, 9)
    local Label = New("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 12, 0, 5), BackgroundTransparency = 1,
        Text = text .. ": " .. default, TextColor3 = TEXT, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
    }, Frame)
    local Bar = New("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 32), BackgroundColor3 = ELEMENT }, Frame)
    Corner(Bar, 3)
    local Fill = New("Frame", { Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = ACCENT }, Bar)
    Corner(Fill, 3)
    local dragging = false
    local function setFromX(x)
        local rel = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * rel)
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        Label.Text = text .. ": " .. value
        callback(value)
    end
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return Frame
end

Slider(Content, "Tamanho do Cursor", MIN_CURSOR_SIZE, MAX_CURSOR_SIZE, cursorSize, function(value)
    cursorSize = value
    Cursor.Size = UDim2.fromOffset(value, value)
end)

Slider(Content, "Sensibilidade", 0, 100, Sensibilidade, function(value)
    Sensibilidade = value
    UIS.MouseDeltaSensitivity = value / 100
end)

local ResetBtn = New("TextButton", {
    Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = ELEMENT, Text = "RESTAURAR CURSOR PADRÃO",
    TextColor3 = SUBTEXT, Font = Enum.Font.GothamMedium, TextSize = 12
}, Content)
Corner(ResetBtn, 9)

ResetBtn.Activated:Connect(function()
    cursorActive = false
    Cursor.Visible = false
    Cursor.Image = ""
    InputBox.Text = ""
    pcall(function() UIS.MouseIconEnabled = true end)
end)

RunService.RenderStepped:Connect(function()
    if cursorActive and Cursor.Visible then
        pcall(function() UIS.MouseIconEnabled = false end)
        local mousePos = UIS:GetMouseLocation()
        Cursor.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
    end
end)

-- =========================================================
-- MENU: ABRIR/FECHAR COM F5 (ou botão X)
-- =========================================================

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == MENU_KEY then
        Main.Visible = not Main.Visible
    end
end)

-- =========================================================
-- CÂMERA / LIMITE DE TELA
-- CapsLock = trava fixa | Botão direito = comportamento padrão do Roblox
-- =========================================================

if APENAS_PRIMEIRA_PESSOA then
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if UIS:GetFocusedTextBox() then return end

    if input.KeyCode == TOGGLE_KEY then
        mouseLockedFixo = not mouseLockedFixo

        if APENAS_PRIMEIRA_PESSOA then
            return -- nesse modo a câmera já fica sempre travada
        end

        UIS.MouseBehavior = mouseLockedFixo
            and Enum.MouseBehavior.LockCenter
            or Enum.MouseBehavior.Default
    end
end)

-- =========================================================
-- AVISO DE ATIVAÇÃO (canto inferior direito, 3s)
-- =========================================================

local function ShowToast(text, duration)
    local Toast = New("Frame", {
        Size = UDim2.fromOffset(220, 44),
        Position = UDim2.new(1, -232, 1, -60),
        BackgroundColor3 = PANEL,
        BackgroundTransparency = 1,
    }, ScreenGui)
    Corner(Toast, 9)
    Stroke(Toast, Color3.fromRGB(45,45,45), 1)

    local Label = New("TextLabel", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = TEXT,
        TextTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextWrapped = true
    }, Toast)

    TweenService:Create(Toast, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()

    task.delay(duration, function()
        TweenService:Create(Toast, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(Label, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
        task.delay(0.4, function()
            if Toast and Toast.Parent then Toast:Destroy() end
        end)
    end)
end

task.spawn(function()
    task.wait(1)
    ShowToast("Limite de tela ativo ✓", 3)
end)

print("[CURSOR TWISKS] by clautxyz — carregado")