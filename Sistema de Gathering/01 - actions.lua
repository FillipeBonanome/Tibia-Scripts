--[[
	Aqui ficará a ação do jogador (evento onUse)
]]--

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetId = target:getId()
	if not gatheringInformations.flowers[targetId] then
		return false
	end
	local info = gatheringInformations.flowers[targetId]
	if info.requiredLevel > player:getGatheringLevel() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa de nivel " .. info.requiredLevel .. " de gathering para realizar essa acao.")
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	
	--Transformar o item
	target:transform(info.transformId)
	toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:addGatheringExp(info.experience)
	player:addItem(info.loot, math.random(info.maxQuantity))
	
	addEvent(function()
		local tile = Tile(toPosition)
		if tile:getItemById(info.transformId) then
			tile:getItemById(info.transformId):remove()
			Game.createItem(targetId, 1, toPosition)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		end
	end, info.cooldown * 1000)
	
	return true
end

action:id(2405)
action:register()