--[[
	Aqui ficará as talkactions para teste!
]]--

local talkaction = TalkAction("!gathering")

function talkaction.onSay(player, words, param, type)
	player:say(player:getGatheringLevel() .. "/" .. player:getGatheringRemainingExp())
	return false
end

talkaction:register()

local talkaction = TalkAction("!gatheringxp")

function talkaction.onSay(player, words, param, type)
	player:addGatheringExp(5)
	return true
end

talkaction:register()