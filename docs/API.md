# 📚 Rainy Nights LoFi City - API Reference

Complete API documentation for all game systems.

---

## 🎮 Core Systems

### Main Game Script
**File:** `src/scripts/main.lua`

#### Functions

```lua
-- Initialize the game
Initialize()

-- Get location constant
local location = Locations.CitySquare

-- PlayerManager functions
PlayerManager:OnPlayerAdded(player)
PlayerManager:OnPlayerRemoving(player)
PlayerManager:LoadPlayerData(player)
PlayerManager:SavePlayerData(player)
PlayerManager:GiveVibePoints(player, amount, reason)
```

---

## 👥 Social System
**File:** `src/scripts/social.lua`

### Interaction Types
```lua
SocialSystem.InteractionTypes = {
	HUG = "hug",
	PIGGYBACK = "piggyback",
	HOLD_HANDS = "hold_hands",
	HIGH_FIVE = "high_five",
	CARRY = "carry",
	WAVE = "wave",
	DANCE = "dance",
	SIT_TOGETHER = "sit_together",
	GIVE_FLOWER = "give_flower",
	HEART_EMOTE = "heart_emote",
}
```

### Request System

```lua
-- Send interaction request
local success, requestId = SocialSystem:SendInteractionRequest(
	requesterPlayer,
	targetPlayer,
	"hug"
)

-- Accept request
SocialSystem:AcceptInteractionRequest(requestId)

-- Decline request
SocialSystem:DeclineInteractionRequest(requestId)
```

### Emote System

```lua
-- Play an emote
SocialSystem:PlayEmote(player, "wave")
SocialSystem:PlayEmote(player, "dance")
SocialSystem:PlayEmote(player, "heart")
```

### Friend System

```lua
-- Add friend
SocialSystem:AddFriend(player1, player2)

-- Remove friend
SocialSystem:RemoveFriend(player1, player2)

-- Get friends
local friends = SocialSystem:GetFriendList(player)
```

---

## 🌦️ Weather System
**File:** `src/scripts/weather.lua`

### Weather States
```lua
WeatherSystem.WeatherStates = {
	CLEAR_NIGHT = "clear_night",
	LIGHT_RAIN = "light_rain",
	HEAVY_RAIN = "heavy_rain",
	THUNDERSTORM = "thunderstorm",
	FOGGY_NIGHT = "foggy_night",
}
```

### Functions

```lua
-- Initialize weather
WeatherSystem:Initialize(lighting)

-- Set current weather
WeatherSystem:SetWeather("light_rain")

-- Get current weather
local weather = WeatherSystem:GetCurrentWeather()

-- Get weather configuration
local config = WeatherSystem:GetWeatherConfig("heavy_rain")

-- Force weather change (for testing)
WeatherSystem:ForceWeather("thunderstorm")
```

---

## 💰 Currency System
**File:** `src/scripts/currency.lua`

### Functions

```lua
-- Initialize currency system
CurrencySystem:Initialize()

-- Get player's Vibe Points
local points = CurrencySystem:GetVibePoints(player)

-- Add Vibe Points
CurrencySystem:AddVibePoints(player, 100, "Activity")

-- Remove Vibe Points
CurrencySystem:RemoveVibePoints(player, 50, "Purchase")
```

### Rewards

```lua
-- Daily login reward
CurrencySystem:GiveDailyReward(player)

-- Hanging out reward
CurrencySystem:RewardHangingOut(player, 10) -- 10 minutes

-- Music reward
CurrencySystem:RewardListeningToMusic(player, 1) -- 1 song

-- Location visit reward
CurrencySystem:RewardLocationVisit(player, "City Square")

-- Photo reward
CurrencySystem:RewardPhoto(player, 3) -- 3 photos

-- Quest completion reward
CurrencySystem:RewardQuestCompletion(player)
```

### Purchases

```lua
-- Purchase cosmetic
local success, message = CurrencySystem:PurchaseCosmetic(player, "Umbrella")

-- Purchase furniture
local success, message = CurrencySystem:PurchaseFurniture(player, "Bed")

-- Purchase emote
local success, message = CurrencySystem:PurchaseEmote(player, "DanceEmote")
```

### Leaderboard

```lua
-- Get top 10 players
local topPlayers = CurrencySystem:GetTopPlayers(10)

-- Get top 5 players
local top5 = CurrencySystem:GetTopPlayers(5)
```

---

## 🎵 Audio System
**File:** `src/scripts/audio.lua` (To be created)

*(Documentation coming soon)*

---

## 🎨 UI System
**File:** `src/scripts/ui.lua` (To be created)

*(Documentation coming soon)*

---

## 🛍️ Customization System
**File:** `src/scripts/customization.lua` (To be created)

*(Documentation coming soon)*

---

## 🎲 Usage Examples

### Example 1: Start Social Interaction

```lua
local SocialSystem = require(game.ServerScriptService.SocialSystem)

local player1 = game.Players:FindFirstChild("Player1")
local player2 = game.Players:FindFirstChild("Player2")

-- Player1 requests to hug Player2
local success, requestId = SocialSystem:SendInteractionRequest(
	player1,
	player2,
	"hug"
)

-- Simulate Player2 accepting
if success then
	SocialSystem:AcceptInteractionRequest(requestId)
end
```

### Example 2: Award Vibe Points

```lua
local CurrencySystem = require(game.ServerScriptService.CurrencySystem)

local player = game.Players:FindFirstChild("Player1")

-- Award points for various activities
CurrencySystem:AddVibePoints(player, 50, "Achievement Unlocked")
CurrencySystem:RewardHangingOut(player, 30) -- 30 minutes
CurrencySystem:RewardPhoto(player, 5) -- 5 photos
```

### Example 3: Change Weather

```lua
local WeatherSystem = require(game.ServerScriptService.WeatherSystem)

WeatherSystem:Initialize(game.Lighting)

-- Force thunderstorm
WeatherSystem:ForceWeather("thunderstorm")

-- Get current weather
local current = WeatherSystem:GetCurrentWeather()
print("Current weather: " .. current)
```

---

## 📊 Data Structures

### Player Data
```lua
{
	UserId = 123456,
	Name = "Player1",
	JoinTime = 1234567890,
	VibePoints = 500,
	CurrentLocation = "City_Square",
	Cosmetics = {
		Umbrella = "Red",
		Hoodie = "Purple",
	},
	Friends = { 789012, 345678 },
}
```

### Interaction Request
```lua
{
	Requester = playerObject,
	Target = playerObject,
	InteractionType = "hug",
	CreatedAt = 1234567890,
	Status = "pending", -- pending, accepted, declined
}
```

---

## 🔧 Development Notes

- All system scripts use Lua modules (returned via `return`)
- Timestamps use Roblox `tick()` function (seconds since epoch)
- UserIds are positive integers from Roblox
- All Vibe Point values are integers

---

**Last Updated:** June 2026
