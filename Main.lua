-- Ожидание загрузки
if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Lucky Block BattleGrounds 📦",
   LoadingTitle = "by Iles_q",
   LoadingSubtitle = "Loading...", -- Оставил как просил
   ConfigurationSaving = {Enabled = false},
   KeySystem = false 
})

-- Глобальные переменные
_G.KillAuraActive = false
_G.KillAuraRange = 15
_G.InfJump = false

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
local PlayerTab = Window:CreateTab("Player ⚡")
local SettingsTab = Window:CreateTab("Settings ⚙️")

-- [ BLOCKS ]
local b1 = MainTab:CreateButton({Name = "Lucky Block 📦", Callback = function() SpawnBlock("Lucky") end})
local b2 = MainTab:CreateButton({Name = "Super Block ⭐", Callback = function() SpawnBlock("Super") end})
local b3 = MainTab:CreateButton({Name = "Diamond Block 💎", Callback = function() SpawnBlock("Diamond") end})
local b4 = MainTab:CreateButton({Name = "Rainbow Block 🌈", Callback = function() SpawnBlock("Rainbow") end})
local b5 = MainTab:CreateButton({Name = "Galaxy Block 🌠", Callback = function() SpawnBlock("Galaxy") end})

-- [ COMBAT - NO DASH VERSION ]
-- Кнопка самой Килл Ауры
CombatTab:CreateToggle({
   Name = "Kill Aura (Universal)",
   CurrentValue = false,
   Callback = function(Value)
       _G.KillAuraActive = Value
       if Value then
           task.spawn(function()
               while _G.KillAuraActive do
                   task.wait(0.03)
                   local p = game.Players.LocalPlayer
                   local char = p.Character
                   local tool = char and char:FindFirstChildOfClass("Tool")
                   
                   if tool and tool:FindFirstChild("Handle") then
                       for _, v in pairs(game.Players:GetPlayers()) do
                           -- Проверяем: не я, жив, персонаж на месте
                           if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                               -- ЛОГИКА ВАЙТЛИСТА
                               if _G.WhitelistedFriends and p:IsFriendsWith(v.UserId) then
                                   continue -- Пропускаем друга, не бьем его
                               end

                               local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                               if dist <= (_G.KillAuraRange or 999) then
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

-- НОВАЯ КНОПКА (Вайтлист) - ставь её СРАЗУ ПОСЛЕ кнопки Килл Ауры
CombatTab:CreateToggle({
   Name = "Whitelist Friends",
   CurrentValue = false,
   Callback = function(Value)
       _G.WhitelistedFriends = Value
       Rayfield:Notify({
          Title = "Whitelist",
          Content = Value and "Friends are now safe!" or "Friends are now targets!",
          Duration = 3
       })
   end,
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

SettingsTab:CreateDropdown({
   Name = "Language / Язык",
   Options = {"English", "Русский"},
   CurrentOption = {"English"},
   Callback = function(Option) ApplyLang(Option[1]) end,
})

-- Старт
Rayfield:Notify({Title = "Success!", Content = "Thank you for using my script!", Duration = 5})
ApplyLang("English")
