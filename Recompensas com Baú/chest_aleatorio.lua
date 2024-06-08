--[[
	1 - Caso que o jogador ja fez a quest
		1 - Informar o jogador que a quest ja foi feita
	2 - Caso o jogador nao tenha feito a quest
		1 - Sortear um item da lista
		2 - Informar o jogador sobre a recompensa
		3 - Dar os itens ao jogador
		4 - Atualizar a quest para o jogador
]]--

local config = {
	itens = {
		{id = 2160, quantidade = 2, chance = 0},
		{id = 2498, quantidade = 1, chance = 0},
		{id = 2528, quantidade = 1, chance = 35},
		{id = 2645, quantidade = 1, chance = 35},
	},
	storage = 11200,
}

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	--Caso que o jogador ja fez a quest
	--[[
	if player:getStorageValue(config.storage) ~= -1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja realizou essa quest!")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	]]--
	--Caso o jogador nao tenha feito a quest
	--Sortear um item da lista
	local total_chance = 0
	for i = 1, #config.itens do
		total_chance = total_chance + config.itens[i].chance
	end
	
	local valor_aleatorio = math.random(total_chance)
	local soma_total = 0
	local indice = 1
	
	for i = 1, #config.itens do
		soma_total = soma_total + config.itens[i].chance
		if valor_aleatorio <= soma_total then
			indice = i
			break
		end
	end
	
	local item_aleatorio = config.itens[indice]
	
	-- Informar o jogador sobre a recompensa
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce recebeu " .. item_aleatorio.quantidade .. "x " .. getItemNameById(item_aleatorio.id))
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
	
	--Dar os itens ao jogador
	player:addItem(item_aleatorio.id, item_aleatorio.quantidade)
	
	--Atualizar a quest para o jogador
	player:setStorageValue(config.storage, 1)
	return true
end

action:aid(18001)
action:register()

function Container.getDeckInfo(self)
	local deck = {}
	for k, v in pairs(self:getItems()) do
		deck[v:getId()] = deck[v:getId()] and (deck[v:getId()] + v:getCount()) or v:getCount()
	end
	return deck
end

allrunes = {
	[2498] = {toId = 23766, count = 3},
	[2643] = {toId = 23766, count = 3},
	[2645] = {toId = 23766, count = 3},
	[2671] = {toId = 23766, count = 3}
}

function Container.isDeckValid(self, player)
	local deck = self:getDeckInfo()
	local quantity = 0
	--Verificações carta por carta
	for k, v in pairs(deck) do
		--Verifica se é uma runa
		if not allrunes[k] then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "You can't battle. You have a non rune item in your container: " .. getItemNameById(k))
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
		--Verifica se a quantidade de runa é valida (aqui vc muda pra checar a tabela que quiser)
		if v > allrunes[k].count then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "You can't battle. Your rune " .. getItemNameById(k) .. " have a higher count than accepted: " .. allrunes[k].count)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
		quantity = quantity + v
		if quantity > 40 then break end
	end
	--Verificações de quantidades finais
	--Verifica se tem menos que 30 itens no deck
	if quantity < 30 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You can't battle. You deck have less than 30 runes.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	--Verifica se tem mais que 40 itens
	if quantity > 40 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You can't battle. Your deck have more than 40 runes.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	return true
end

local talkaction = TalkAction("!testecontainer")

function talkaction.onSay(player, words, param, type)
	local container = player:getSlotItem(CONST_SLOT_BACKPACK)
	container:isDeckValid(player)
	return true
end

talkaction:register()