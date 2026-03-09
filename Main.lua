local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Lucky Block BattleGrounds",
   LoadingTitle = "by Iles_q",
   LoadingSubtitle = "Loading...",
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

-- Создаем вкладки
local MainTab = Window:CreateTab("Blocks 🎁")
local PlayerTab = Window:CreateTab("Player ⚡")
local SettingsTab = Window:CreateTab("Settings ⚙️")

-- Кнопки блоков
local b1 = MainTab:CreateButton({Name = "Lucky Block 📦", Callback = function() SpawnBlock("Lucky") end})
local b2 = MainTab:CreateButton({Name = "Super Block ⭐", Callback = function() SpawnBlock("Super") end})
local b3 = MainTab:CreateButton({Name = "Diamond Block 💎", Callback = function() SpawnBlock("Diamond") end})
local b4 = MainTab:CreateButton({Name = "Rainbow Block 🌈", Callback = function() SpawnBlock("Rainbow") end})
local b5 = MainTab:CreateButton({Name = "Galaxy Block 🌠", Callback = function() SpawnBlock("Galaxy") end})

-- Элементы Игрока (сохраняем их в переменные p1, p2)
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

-- Функция смены языка
local function ApplyLang(mode)
    if mode == "Русский" then
        -- Обновляем блоки
        b1:Set("Обычный блок 📦")
        b2:Set("Супер блок ⭐")
        b3:Set("Алмазный блок 💎")
        b4:Set("Радужный блок 🌈")
        b5:Set("Галактический блок 🌠")
        -- Обновляем игрока (теперь через переменные p1 и p2)
        p1:Set("Скорость бега")
        p2:Set("Бесконечный прыжок")
    else
        b1:Set("Lucky Block 📦")
        b2:Set("Super Block ⭐")
        b3:Set("Diamond Block 💎")
        b4:Set("Rainbow Block 🌈")
        b5:Set("Galaxy Block 🌠")
        p1:Set("Walk Speed")
        p2:Set("Infinite Jump")
    end
end

-- Настройки
SettingsTab:CreateDropdown({
   Name = "Language / Язык",
   Options = {"English", "Русский"},
   CurrentOption = {"English"},
   Callback = function(Option)
      ApplyLang(Option[1])
   end,
})

-- Запуск с задержкой, чтобы UI не завис
task.wait(1.5)
ApplyLang("Русский")
