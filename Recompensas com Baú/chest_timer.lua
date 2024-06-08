--[[
	1 - Caso o jogador esteja em cooldown
		1 - Informar ao jogador o cooldown e falar que ele precisa esperar esse tempo
	2 - Caso o jogador nao esteja em cooldown
		1 - Informar o jogador os itens ganhos
		2 - Dar os itens ao jogador
		3 - Colocar cooldown no jogador
]]--

local config = {
	item = {id = 2498, quantidade = 1},
	storage = 12100,
	cooldown = 30,
}

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	--Caso o jogador esteja em cooldown
	if player:getStorageValue(config.storage) > os.time() then
		--Informar ao jogador o cooldown e falar que ele precisa esperar esse tempo
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Espere " .. player:getStorageValue(config.storage) - os.time() .. " segundos para fazer essa quest novamente!")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	
	--Caso o jogador nao esteja em cooldown
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ganhou um Royal Helmet!")
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
	
	--Dar os itens ao jogador
	player:addItem(config.item.id, config.item.quantidade)
	
	--Colocar cooldown no jogador
	player:setStorageValue(config.storage, os.time() + config.cooldown)
	return true
end

action:aid(18002)
action:register()