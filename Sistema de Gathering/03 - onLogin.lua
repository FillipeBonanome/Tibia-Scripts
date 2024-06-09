--[[
	Aqui ficará as eventos de login!
]]--

local creatureevent = CreatureEvent("gatheringLogin")

function creatureevent.onLogin(player)
	if player:getGatheringLevel() < 0 then
		player:setStorageValue(gatheringInformations.storages.level, 0)
		player:setStorageValue(gatheringInformations.storages.remainingExp, calculateGatheringExp(player:getGatheringLevel()))
		player:say("Resetou!")
	end
	return true
end

creatureevent:register()