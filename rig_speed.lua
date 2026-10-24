-- RIG SPEED // CORE
-- Changes how fast your rig's animations play (1 = normal).
-- Accepts numbers up to one googol (1e100). You can also type "googol".
-- DESTROY button removes the GUI, stops the loop, and resets your rig speed.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- If the script is run twice, remove the old copy first
local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("RigSpeed")
if old then old:Destroy() end

local MAX_SPEED = 1e100 -- one googol
local DEFAULT_SPEED = 1
local speed = DEFAULT_SPEED

-- Colors
local BG = Color3.fromRGB(10, 12, 20)
local PANEL = Color3.fromRGB(18, 22, 36)
local ACCENT = Color3.fromRGB(0, 230, 255)
local ACCENT2 = Color3.fromRGB(150, 80, 255)
local TEXT = Color3.fromRGB(230, 240, 255)
local DIM = Color3.fromRGB(120, 135, 165)

local gui = Instance.new("ScreenGui")
gui.Name = "RigSpeed"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 232)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = BG
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = ACCENT
stroke.Thickness = 1.5
stroke.Transparency = 0.2
stroke.Parent = frame

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new(BG, Color3.fromRGB(20, 14, 38))
grad.Rotation = 45
grad.Parent = frame

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 0, 3)
bar.BorderSizePixel = 0
bar.BackgroundColor3 = Color3.new(1, 1, 1)
bar.Parent = frame
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 12)
local barGrad = Instance.new("UIGradient")
barGrad.Color = ColorSequence.new(ACCENT, ACCENT2)
barGrad.Parent = bar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 14, 0, 10)
title.BackgroundTransparency = 1
title.Text = "RIG SPEED // CORE"
title.TextColor3 = ACCENT
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local readout = Instance.new("TextLabel")
readout.Size = UDim2.new(1, -28, 0, 20)
readout.Position = UDim2.new(0, 14, 0, 40)
readout.BackgroundTransparency = 1
readout.Text = "RIG SPEED: 1x"
readout.TextColor3 = DIM
readout.Font = Enum.Font.Code
readout.TextSize = 13
readout.TextXAlignment = Enum.TextXAlignment.Left
readout.TextTruncate = Enum.TextTruncate.AtEnd
readout.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -28, 0, 36)
box.Position = UDim2.new(0, 14, 0, 68)
box.BackgroundColor3 = PANEL
box.TextColor3 = TEXT
box.PlaceholderColor3 = DIM
box.PlaceholderText = "rig speed (e.g. 5, 1e100, googol)"
box.Text = ""
box.ClearTextOnFocus = false
box.Font = Enum.Font.Code
box.TextSize = 14
box.BorderSizePixel = 0
box.Parent = frame
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
local boxStroke = Instance.new("UIStroke")
boxStroke.Color = Color3.fromRGB(45, 55, 85)
boxStroke.Thickness = 1
boxStroke.Parent = box

box.Focused:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.2), {Color = ACCENT}):Play()
end)
box.FocusLost:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 55, 85)}):Play()
end)

local function makeButton(text, color)
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.25}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    return b
end

local setBtn = makeButton("APPLY", Color3.fromRGB(0, 140, 200))
setBtn.Size = UDim2.new(0.62, -20, 0, 34)
setBtn.Position = UDim2.new(0, 14, 0, 116)

local resetBtn = makeButton("RESET", Color3.fromRGB(70, 60, 120))
resetBtn.Size = UDim2.new(0.38, -22, 0, 34)
resetBtn.Position = UDim2.new(0.62, 8, 0, 116)

local destroyBtn = makeButton("DESTROY", Color3.fromRGB(190, 40, 70))
destroyBtn.Size = UDim2.new(1, -28, 0, 34)
destroyBtn.Position = UDim2.new(0, 14, 0, 158)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -28, 0, 18)
status.Position = UDim2.new(0, 14, 0, 202)
status.BackgroundTransparency = 1
status.Text = "STATUS: READY"
status.TextColor3 = DIM
status.Font = Enum.Font.Code
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

-- Logic
local function format(n)
    if n >= 1e15 then
        return string.format("%.3e", n)
    end
    return tostring(n)
end

local function setStatus(msg, color)
    status.Text = "STATUS: " .. msg
    status.TextColor3 = color or DIM
end

local function parse(text)
    text = text:lower():gsub("%s+", "")
    if text == "googol" then return MAX_SPEED end
    return tonumber(text)
end

local function getTracks()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return {} end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        return animator:GetPlayingAnimationTracks()
    end
    return hum:GetPlayingAnimationTracks()
end

local function resetTracks()
    for _, track in ipairs(getTracks()) do
        pcall(function()
            track:AdjustSpeed(1)
        end)
    end
end

-- Apply rig speed to every playing animation, every frame
local loop = RunService.Heartbeat:Connect(function()
    if speed == DEFAULT_SPEED then return end
    for _, track in ipairs(getTracks()) do
        pcall(function()
            track:AdjustSpeed(speed)
        end)
    end
end)

local function submit()
    local n = parse(box.Text)
    if n and n == n then
        speed = math.clamp(n, 0, MAX_SPEED)
        readout.Text = "RIG SPEED: " .. format(speed) .. "x"
        setStatus("APPLIED", Color3.fromRGB(80, 255, 160))
    else
        setStatus("INVALID NUMBER", Color3.fromRGB(255, 90, 110))
    end
end

setBtn.MouseButton1Click:Connect(submit)
box.FocusLost:Connect(function(enter)
    if enter then submit() end
end)

resetBtn.MouseButton1Click:Connect(function()
    speed = DEFAULT_SPEED
    box.Text = ""
    resetTracks()
    readout.Text = "RIG SPEED: 1x"
    setStatus("RESET TO 1x", ACCENT)
end)

-- Destroy: stop the loop, put the rig back to normal, remove the GUI
destroyBtn.MouseButton1Click:Connect(function()
    speed = DEFAULT_SPEED
    loop:Disconnect()
    resetTracks()
    gui:Destroy()
end)
