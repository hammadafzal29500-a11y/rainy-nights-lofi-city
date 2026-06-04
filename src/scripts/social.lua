-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║              SOCIAL INTERACTION SYSTEM                            ║
-- ║   Handles all player-to-player interactions with request/accept   ║
-- ╚═══════════════════════════════════════════════════════════════════╝

local SocialSystem = {}

-- Interaction Types
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

-- Interaction Configuration
local InteractionConfig = {
	hug = {
		Duration = 3,
		AnimationId = "rbxassetid://PLACEHOLDER_HUG_ANIM",
		VibePointsReward = 5,
	},
	piggyback = {
		Duration = 0, -- Until dismount
		AnimationId = "rbxassetid://PLACEHOLDER_PIGGYBACK_ANIM",
		VibePointsReward = 0,
	},
	hold_hands = {
		Duration = 0, -- Until release
		AnimationId = "rbxassetid://PLACEHOLDER_HAND_HOLD_ANIM",
		VibePointsReward = 0,
	},
	high_five = {
		Duration = 1,
		AnimationId = "rbxassetid://PLACEHOLDER_HIGH_FIVE_ANIM",
		VibePointsReward = 3,
	},
	carry = {
		Duration = 0, -- Until drop
		AnimationId = "rbxassetid://PLACEHOLDER_CARRY_ANIM",
		VibePointsReward = 0,
	},
	wave = {
		Duration = 1.5,
		AnimationId = "rbxassetid://PLACEHOLDER_WAVE_ANIM",
		VibePointsReward = 2,
	},
	dance = {
		Duration = 5,
		AnimationId = "rbxassetid://PLACEHOLDER_DANCE_ANIM",
		VibePointsReward = 5,
	},
	sit_together = {
		Duration = 0, -- Until stand
		AnimationId = "rbxassetid://PLACEHOLDER_SIT_ANIM",
		VibePointsReward = 10,
	},
	give_flower = {
		Duration = 1,
		AnimationId = "rbxassetid://PLACEHOLDER_FLOWER_ANIM",
		VibePointsReward = 15,
	},
	heart_emote = {
		Duration = 2,
		AnimationId = "rbxassetid://PLACEHOLDER_HEART_ANIM",
		VibePointsReward = 3,
	},
}

-- Pending Interaction Requests
local PendingRequests = {}

-- ═════════════════════════════════════════════════════════════════
-- REQUEST SYSTEM
-- ═════════════════════════════════════════════════════════════════

function SocialSystem:SendInteractionRequest(requesterPlayer, targetPlayer, interactionType)
	-- Validate interaction type
	if not InteractionConfig[interactionType] then
		return false, "Invalid interaction type"
	end
	
	-- Check if target player exists
	if not targetPlayer:FindFirstChild("HumanoidRootPart") then
		return false, "Target player not found"
	end
	
	-- Create request ID
	local requestId = requesterPlayer.UserId .. "_" .. targetPlayer.UserId .. "_" .. tick()
	
	-- Store request
	PendingRequests[requestId] = {
		Requester = requesterPlayer,
		Target = targetPlayer,
		InteractionType = interactionType,
		CreatedAt = tick(),
		Status = "pending",
	}
	
	-- Notify target player
	self:NotifyPlayer(targetPlayer, requesterPlayer.Name .. " wants to " .. interactionType)
	
	-- TODO: Send request to client to display UI
	
	return true, requestId
end

function SocialSystem:AcceptInteractionRequest(requestId)
	local request = PendingRequests[requestId]
	if not request then
		return false, "Request not found"
	end
	
	request.Status = "accepted"
	
	-- Execute the interaction
	self:ExecuteInteraction(request.Requester, request.Target, request.InteractionType)
	
	-- Clean up request
	PendingRequests[requestId] = nil
	
	return true
end

function SocialSystem:DeclineInteractionRequest(requestId)
	local request = PendingRequests[requestId]
	if not request then
		return false, "Request not found"
	end
	
	request.Status = "declined"
	
	-- Notify requester
	self:NotifyPlayer(request.Requester, request.Target.Name .. " declined your request")
	
	-- Clean up request
	PendingRequests[requestId] = nil
	
	return true
end

-- ═════════════════════════════════════════════════════════════════
-- INTERACTION EXECUTION
-- ═════════════════════════════════════════════════════════════════

function SocialSystem:ExecuteInteraction(requesterPlayer, targetPlayer, interactionType)
	local config = InteractionConfig[interactionType]
	if not config then
		return false
	end
	
	-- Get characters
	local requesterChar = requesterPlayer.Character
	local targetChar = targetPlayer.Character
	
	if not requesterChar or not targetChar then
		return false
	end
	
	-- Play animations
	self:PlayAnimation(requesterChar, config.AnimationId)
	
	-- Some interactions are mutual (both players animate)
	if interactionType == "hug" or interactionType == "high_five" or interactionType == "hold_hands" or interactionType == "sit_together" then
		self:PlayAnimation(targetChar, config.AnimationId)
	end
	
	-- Award Vibe Points
	if config.VibePointsReward > 0 then
		-- TODO: Award Vibe Points to both players
	end
	
	-- Handle special interactions
	self:HandleSpecialInteraction(interactionType, requesterPlayer, targetPlayer)
	
	return true
end

function SocialSystem:HandleSpecialInteraction(interactionType, requesterPlayer, targetPlayer)
	-- Handle special logic for certain interactions
	if interactionType == "give_flower" then
		-- TODO: Add flower to target player's inventory
		self:NotifyPlayer(targetPlayer, requesterPlayer.Name .. " gave you a flower!")
	elseif interactionType == "piggyback" then
		-- TODO: Make target player sit on requester
		self:NotifyPlayer(targetPlayer, "You're on " .. requesterPlayer.Name .. "'s back!")
	elseif interactionType == "carry" then
		-- TODO: Make target player be carried by requester
		self:NotifyPlayer(targetPlayer, requesterPlayer.Name .. " is carrying you!")
	end
end

-- ═════════════════════════════════════════════════════════════════
-- ANIMATION SYSTEM
-- ═════════════════════════════════════════════════════════════════

function SocialSystem:PlayAnimation(character, animationId)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return false
	end
	
	-- Create animation object
	local animation = Instance.new("Animation")
	animation.AnimationId = animationId
	
	-- Load and play animation
	local animationTrack = humanoid:LoadAnimation(animation)
	if animationTrack then
		animationTrack:Play()
		return true
	end
	
	return false
end

-- ═════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═════════════════════════════════════════════════════════════════

function SocialSystem:NotifyPlayer(player, message)
	-- TODO: Send notification to player's client
	print("[NOTIFICATION] " .. player.Name .. ": " .. message)
end

-- ═════════════════════════════════════════════════════════════════
-- EMOTE SYSTEM
-- ═════════════════════════════════════════════════════════════════

SocialSystem.AvailableEmotes = {
	wave = { AnimationId = "rbxassetid://PLACEHOLDER_WAVE", Cost = 0 },
	dance = { AnimationId = "rbxassetid://PLACEHOLDER_DANCE", Cost = 0 },
	heart = { AnimationId = "rbxassetid://PLACEHOLDER_HEART", Cost = 0 },
}

function SocialSystem:PlayEmote(player, emoteType)
	if not self.AvailableEmotes[emoteType] then
		return false, "Emote not found"
	end
	
	local character = player.Character
	if not character then
		return false, "Character not found"
	end
	
	-- Check if player owns emote
	-- TODO: Check inventory
	
	-- Play emote animation
	self:PlayAnimation(character, self.AvailableEmotes[emoteType].AnimationId)
	
	return true
end

-- ═════════════════════════════════════════════════════════════════
-- FRIEND SYSTEM
-- ═════════════════════════════════════════════════════════════════

function SocialSystem:AddFriend(player1, player2)
	-- TODO: Add player2 to player1's friend list
	-- TODO: Send friend request notification
	return true
end

function SocialSystem:RemoveFriend(player1, player2)
	-- TODO: Remove from friend list
	return true
end

function SocialSystem:GetFriendList(player)
	-- TODO: Return player's friends
	return {}
end

return SocialSystem
