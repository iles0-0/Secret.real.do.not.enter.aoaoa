-- [[ Iles_q - Thx for using | v3.2 JUSTICE ]] --
if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Глобальные переменные
_G.KillAuraActive = false
_G.KillAuraRange = 15
_G.InfJump = false
_G.WhitelistedFriends = false
_G.AntiFlingActive = false
local selectedTargets = {} 
local multiLoopKill = false
local flingActive = false

local Window = Rayfield:CreateWindow({
   Name = "Lucky Block BattleGrounds 📦 | v3.2",
   LoadingTitle = "by Iles_q",
   LoadingSubtitle = "Justice & Protection Active",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false 
})

local function SpawnBlock(name)
    local rs = game:GetService("ReplicatedStorage")
    local events = {"Spawn" .. name .. "Block", "Spawn" .. name, "SpawnBlock"}
    for _, e in pairs(events) do
        local r = rs:FindFirstChild(e)
        if r then
            if r.Name == "SpawnBlock" then r:FireServer(name) else r:FireServer() end
            break
        end
    end
end

-- Вкладки
local MainTab = Window:CreateTab("Blocks 🎁")
local CombatTab = Window:CreateTab("Combat ⚔️")
local TargetTab = Window:CreateTab("Target 🎯") 
local AntiFlingTab = Window:CreateTab("Anti-Fling 🛡️")
local PlayerTab = Window:CreateTab("Player ⚡")
local SettingsTab = Window:CreateTab("Settings ⚙️")

-- [ BLOCKS ]
local b1 = MainTab:CreateButton({Name = "Lucky Block 📦", Callback = function() SpawnBlock("Lucky") end})
local b2 = MainTab:CreateButton({Name = "Super Block ⭐", Callback = function() SpawnBlock("Super") end})
local b3 = MainTab:CreateButton({Name = "Diamond Block 💎", Callback = function() SpawnBlock("Diamond") end})
local b4 = MainTab:CreateButton({Name = "Rainbow Block 🌈", Callback = function() SpawnBlock("Rainbow") end})
local b5 = MainTab:CreateButton({Name = "Galaxy Block 🌠", Callback = function() SpawnBlock("Galaxy") end})

-- [ TARGET SYSTEM ]
local function getPlayerNames()
    local names = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then table.insert(names, v.Name) end
    end
    return names
end

local TargetDropdown = TargetTab:CreateDropdown({
   Name = "Select Targets",
   Options = getPlayerNames(),
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
      selectedTargets = Options
   end,
})

TargetTab:CreateButton({
   Name = "Refresh List",
   Callback = function() TargetDropdown:Refresh(getPlayerNames()) end,
})

local t1 = TargetTab:CreateToggle({
   Name = "Mass Kill (Need Weapon)",
   CurrentValue = false,
   Callback = function(Value)
       multiLoopKill = Value
       task.spawn(function()
           while multiLoopKill do
               task.wait(0.01)
               local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
               if tool and tool:FindFirstChild("Handle") then
                   for _, name in pairs(selectedTargets) do
                       local target = game.Players:FindFirstChild(name)
                       if target and target.Character and target.Character:FindFirstChild("Head") then
                           firetouchinterest(target.Character.Head, tool.Handle, 0)
                           firetouchinterest(target.Character.Head, tool.Handle, 1)
                       end
                   end
               end
           end
       end)
   end,
})

local t2 = TargetTab:CreateToggle({
   Name = "Target Fling (Launch)",
   CurrentValue = false,
   Callback = function(Value)
       flingActive = Value
       if flingActive then
           task.spawn(function()
               while flingActive do
                   task.wait()
                   local lp = game.Players.LocalPlayer
                   if #selectedTargets > 0 then
                       for _, name in pairs(selectedTargets) do
                           local target = game.Players:FindFirstChild(name)
                           if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                               local hrp = lp.Character.HumanoidRootPart
                               local targetHrp = target.Character.HumanoidRootPart
                               local oldCFrame = hrp.CFrame
                               hrp.Velocity = Vector3.new(500000, 500000, 500000)
                               hrp.CFrame = targetHrp.CFrame
                               task.wait(0.1)
                               hrp.CFrame = oldCFrame
                           end
                       end
                   end
               end
           end)
       end
   end,
})

TargetTab:CreateButton({
   Name = "Teleport to First Target",
   Callback = function()
       if #selectedTargets > 0 then
           local target = game.Players:FindFirstChild(selectedTargets[1])
           if target and target.Character then
               game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
           end
       end
   end,
})

-- [ ANTI-FLING ]
local af1 = AntiFlingTab:CreateToggle({
   Name = "Enable Anti-Fling Protection",
   CurrentValue = false,
   Callback = function(Value)
       _G.AntiFlingActive = Value
       if Value then
           task.spawn(function()
               game:GetService("RunService").Stepped:Connect(function()
                   if _G.AntiFlingActive and game.Players.LocalPlayer.Character then
                       pcall(function()
                           for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                               if v:IsA("BasePart") then
                                   v.CanCollide = false
                                   v.Velocity = Vector3.new(0, 0, 0)
                                   v.RotVelocity = Vector3.new(0, 0, 0)
                               end
                           end
                       end)
                   end
               end)
           end)
       end
   end,
})

-- [ COMBAT ]
local c1 = CombatTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Callback = function(Value)
       _G.KillAuraActive = Value
       if Value then
           task.spawn(function()
               while _G.KillAuraActive do
                   task.wait(0.03)
                   local p = game.Players.LocalPlayer
                   local tool = p.Character and p.Character:FindFirstChildOfClass("Tool")
                   if tool and tool:FindFirstChild("Handle") then
                       for _, v in pairs(game.Players:GetPlayers()) do
                           if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                               if _G.WhitelistedFriends and p:IsFriendsWith(v.UserId) then continue end
                               local dist = (p.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                               if dist <= _G.KillAuraRange then
                                   firetouchinterest(v.Character.Head, tool.Handle, 0)
                                   firetouchinterest(v.Character.Head, tool.Handle, 1)
                               end
                           end
                       end
                   end
               end
           end)
       end
   end,
})

CombatTab:CreateToggle({
   Name = "Whitelist Friends",
   CurrentValue = false,
   Callback = function(Value) _G.WhitelistedFriends = Value end,
})

local c2 = CombatTab:CreateSlider({
   Name = "Destruction Range",
   Range = {15, 999},
   Increment = 5,
   CurrentValue = 15,
   Callback = function(v) _G.KillAuraRange = v end,
})

-- [ PLAYER ]
local p1 = PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) 
       if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
           game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
       end
   end,
})

local p2 = PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) _G.InfJump = Value end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and game.Players.LocalPlayer.Character then
        local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)

-- [ SETTINGS & LANG ]
local function ApplyLang(mode)
    if mode == "Русский" then
        b1:Set("Обычный блок 📦")
        b2:Set("Супер блок ⭐")
        b3:Set("Алмазный блок 💎")
        b4:Set("Радужный блок 🌈")
        b5:Set("Галактический блок 🌠")
        c1:Set("Килл Аура (Универсальная)")
        c2:Set("Радиус уничтожения")
        p1:Set("Скорость бега")
        p2:Set("Бесконечный прыжок")
        t1:Set("Масс Килл (Нужно оружие)")
        t2:Set("Флинг (Запуск в небо)")
        af1:Set("Активировать Анти-Флинг")
    else
        b1:Set("Lucky Block 📦")
        b2:Set("Super Block ⭐")
        b3:Set("Diamond Block 💎")
        b4:Set("Rainbow Block 🌈")
        b5:Set("Galaxy Block 🌠")
        c1:Set("Kill Aura (Universal)")
        c2:Set("Destruction Range")
        p1:Set("Walk Speed")
        p2:Set("Infinite Jump")
        t1:Set("Mass Kill (Need Weapon)")
        t2:Set("Target Fling (Launch)")
        af1:Set("Enable Anti-Fling Protection")
    end
end

SettingsTab:CreateDropdown({
   Name = "Language / Язык",
   Options = {"English", "Русский"},
   CurrentOption = {"English"},
   Callback = function(Option) ApplyLang(Option[1]) end,
})

Rayfield:Notify({Title = "Success!", Content = "Iles_q Hub v3.2 Loaded", Duration = 5})
ApplyLang("English") 
