-- [ COMBAT SECTION ]
local c1 = CombatTab:CreateToggle({
   Name = "Kill Aura (Take weapon)",
   CurrentValue = false,
   Callback = function(Value)
       _G.KillAuraActive = Value
       if Value then
           task.spawn(function()
               while _G.KillAuraActive do
                   task.wait(0.05) -- Ускорили проверку для 999 стадс
                   local p = game.Players.LocalPlayer
                   local char = p.Character
                   local tool = char and char:FindFirstChildOfClass("Tool")
                   
                   -- Проверяем, есть ли меч и есть ли у него Handle
                   if tool and tool:FindFirstChild("Handle") then
                       -- Активируем меч (имитация удара), чтобы сервер засчитал урон
                       tool:Activate() 
                       
                       for _, v in pairs(game.Players:GetPlayers()) do
                           if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                               -- Проверяем, что цель жива
                               if v.Character.Humanoid.Health > 0 then
                                   local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                                   if dist <= _G.KillAuraRange then
                                       -- Бьем по голове (самая большая зона поражения)
                                       firetouchinterest(v.Character.Head, tool.Handle, 0)
                                       firetouchinterest(v.Character.Head, tool.Handle, 1)
                                   end
                               end
                           end
                       end
                   end
               end
           end)
       end
   end,
})

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Lucky Block BattleGrounds 📦",
   LoadingTitle = "by Iles_q",
   LoadingSubtitle = "Global Update v2.0",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false 
})

-- Переменные (Global)
_G.KillAuraActive = false
_G.KillAuraRange = 15

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

-- Создаем вкладки
local MainTab = Window:CreateTab("Blocks 🎁")
local CombatTab = Window:CreateTab("Combat ⚔️")
local PlayerTab = Window:CreateTab("Player ⚡")
local SettingsTab = Window:CreateTab("Settings ⚙️")

-- [ BLOCKS SECTION ]
local b1 = MainTab:CreateButton({Name = "Lucky Block 📦", Callback = function() SpawnBlock("Lucky") end})
local b2 = MainTab:CreateButton({Name = "Super Block ⭐", Callback = function() SpawnBlock("Super") end})
local b3 = MainTab:CreateButton({Name = "Diamond Block 💎", Callback = function() SpawnBlock("Diamond") end})
local b4 = MainTab:CreateButton({Name = "Rainbow Block 🌈", Callback = function() SpawnBlock("Rainbow") end})
local b5 = MainTab:CreateButton({Name = "Galaxy Block 🌠", Callback = function() SpawnBlock("Galaxy") end})

-- [ COMBAT SECTION ]
local c1 = CombatTab:CreateToggle({
   Name = "Kill Aura (Universal)",
   CurrentValue = false,
   Callback = function(Value)
       _G.KillAuraActive = Value
       if Value then
           task.spawn(function()
               while _G.KillAuraActive do
                   task.wait(0.1)
                   local p = game.Players.LocalPlayer
                   local tool = p.Character and p.Character:FindFirstChildOfClass("Tool")
                   if tool and tool:FindFirstChild("Handle") then
                       for _, v in pairs(game.Players:GetPlayers()) do
                           if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
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

local c2 = CombatTab:CreateSlider({
   Name = "Destruction Range",
   Range = {15, 999},
   Increment = 5,
   CurrentValue = 15,
   Callback = function(v) _G.KillAuraRange = v end,
})

-- [ PLAYER SECTION ]
local p1 = PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) 
       if game.Players.LocalPlayer.Character then 
           game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v 
       end 
   end,
})

local p2 = PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
       _G.InfJump = Value
       if Value then
           game:GetService("UserInputService").JumpRequest:Connect(function()
               if _G.InfJump and game.Players.LocalPlayer.Character then
                   game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
               end
           end)
       end
   end,
})

-- Локализация
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
    end
end

-- Settings
SettingsTab:CreateDropdown({
   Name = "Language / Язык",
   Options = {"English", "Русский"},
   CurrentOption = {"English"},
   Callback = function(Option) ApplyLang(Option[1]) end,
})

-- Приветствие и старт
Rayfield:Notify({
   Title = "Success!",
   Content = "Script loaded. v2.0 Global Update applied.",
   Duration = 5,
   Image = 4483362458,
})

ApplyLang("English")
