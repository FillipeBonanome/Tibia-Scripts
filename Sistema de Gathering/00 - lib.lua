--[[
	
	Descrição do Sistema
		1 - Jogador será capaz de usar o item Sickle (2405) para colher algumas flores do chão
		2 - Cada flor precisará de um nível mínimo de Gathering para poder ser usada
		3 - Ao colher uma flor com sucesso o jogador ganhará tries (XP) de gathering, assim como outras skills
		4 - A flor se transformará e depois de um tempo voltará ao normal
		5 - Terá Talkactions para o jogador poder ver a sua skill/porcentagem.
	
	Lista de Ids
		2743 --> 5921 / 6216
		4017 --> 7249 / 4014
		2742 --> 7476 / 6216
		2762 --> 2746 / 6216
		2763 --> 2744 / 6216
		2764 --> 2745 / 6216
		
	-- Pegar LV
	-- Pegar XP Faltante
	-- Calcular XP para o próximo nível
	-- Atribuir XP ao jogador
	-- Level Up!
	
]]--

gatheringInformations = {
	storages = {
		level = 131000,
		remainingExp = 131001,
	},
	flowers = {
		[2743] = {transformId = 6216, requiredLevel = 0, cooldown = 6, experience = 10, loot = 5921, maxQuantity = 3},
		[4017] = {transformId = 4014, requiredLevel = 5, cooldown = 60, experience = 20, loot = 7249, maxQuantity = 3},
	}
}

--Formula geral de experiencia
function calculateGatheringExp(level)
	return 10 * (level + 1)
end

--Pegar o nivel de gathering do jogador
function Player.getGatheringLevel(self)
	return self:getStorageValue(gatheringInformations.storages.level)
end

--Pegar a experiencia faltante do jogador
function Player.getGatheringRemainingExp(self)
	return self:getStorageValue(gatheringInformations.storages.remainingExp)
end

--Dar experiencia de gathering para o jogador
function Player.addGatheringExp(self, value)
	local remainingExp = self:getGatheringRemainingExp()
	self:setStorageValue(gatheringInformations.storages.remainingExp, remainingExp - value)
	self:sendTextMessage(MESSAGE_EXPERIENCE, "Voce ganhou " .. value .. " de experiencia em Gathering.", self:getPosition(), value, 215)
	
	--Verificar se o jogador upou um nível
	if value >=  remainingExp then
		--Aumentar o nível do jogador
		self:setStorageValue(gatheringInformations.storages.level, self:getGatheringLevel() + 1)
		--Recalcular a xp faltante
		local newRemainingExp = self:getGatheringRemainingExp()
		self:setStorageValue(gatheringInformations.storages.remainingExp, newRemainingExp + calculateGatheringExp(self:getGatheringLevel()))
		--Avisar o jogador que ele upou!
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce aumentou o seu nivel de gathering para " .. self:getGatheringLevel())
		self:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
	end
	
	return true
end