--made  by disprrt

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🐱‍👤Arsenal🐱‍👤",
   LoadingTitle = "Arsenal Hub",
   LoadingSubtitle = "by Disprrt",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Arsenal Hub"
   },
   Discord = {
      Enabled = true,
      Invite = "https://discord.gg/3k7ZV5PGnf", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Arsenal key",
      Subtitle = "KeySystem in discord",
      Note = "https://discord.gg/3k7ZV5PGnf",
      FileName = "Disprrt", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://pastebin.com/raw/4hVEeXHu"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Combat", nil) -- Title, Image
local Section = MainTab:CreateSection("Main")
Section:Set("menu")

Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Successfully Loaded",
   Duration = 6.5,
   Image = nil,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})

local Toggle = MainTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value) local Rayfield = loadstring(game:HttpGet('https://pastebin.com/raw/xwhGWM40'))()
   -- The function that takes place when the toggle is pressed
   -- The variable (Value) is a boolean on whether the toggle is true or false
   end,
})

local Toggle = MainTab:CreateToggle({
   Name = "Silent Aim",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value) local Rayfield = loadstring(game:HttpGet('https://pastebin.com/raw/SkFKRQ1p'))()
   -- The function that takes place when the toggle is pressed
   -- The variable (Value) is a boolean on whether the toggle is true or false
   end,
})
