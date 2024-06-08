--[[
	1 - Se o jogador já realizou a quest
		1 - Informar o jogador que ele já fez a quest (visualmente/por texto/ambos)
	2 - Se o jogador não realizou a quest
		1 - Informar o jogador das suas recompensas
		2 - Dar os itens para o jogador
		3 - Atualizar a quest para o jogador
]]--

local config = {
	item = {id = 2160, quantidade = 8},		--8x Crystal Coin
	storage = 10200,
}

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	--Se o jogador já realizou a quest
	if player:getStorageValue(config.storage) ~= -1 then
		--Informar o jogador que ele já fez a quest (visualmente/por texto/ambos)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja realizou essa quest!")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	
	--Se o jogador não realizou a quest
	--Informar o jogador das suas recompensas
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ganhou 8x Crystal Coin.")
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
	
	--Dar os itens para o jogador
	player:addItem(config.item.id, config.item.quantidade)
	
	--Atualizar a quest para o jogador
	player:setStorageValue(config.storage, 1)
	return true
end

action:aid(18000)
action:register()