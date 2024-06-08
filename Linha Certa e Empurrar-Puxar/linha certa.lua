local function createLineBetweenPositions(pos_a, pos_b, n)
	n = n or getDistanceBetween(pos_a, pos_b)
	local posicoes = {}
	
	local diferencaX = pos_b.x - pos_a.x
	local diferencaY = pos_b.y - pos_a.y
	local distancia = getDistanceBetween(pos_a, pos_b)
	
	for i = 1, n do
		local posicao = {
			x = pos_a.x + math.floor(diferencaX * (i / distancia) + 0.5),
			y = pos_a.y + math.floor(diferencaY * (i / distancia) + 0.5),
			z = pos_a.z
		}
		table.insert(posicoes, posicao)
	end
	return posicoes
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

function formula(player, level, magicLevel)
	local min = level / 5 + magicLevel * 2
	local max = level / 5 + magicLevel * 4.5
	return -min, -max
end

function onTargetCreature(creature, target)
	local posicao_do_jogador = creature:getPosition()
	local posicao_do_alvo = target:getPosition()
	local distancia = getDistanceBetween(posicao_do_jogador, posicao_do_alvo)
	
	--Empurrar (distancia + 1), Puxar (distancia - 1)
	local posicoes = createLineBetweenPositions(posicao_do_jogador, posicao_do_alvo, distancia - 1)
	local ultima_posicao = posicoes[#posicoes]
	
	posicao_do_alvo:sendDistanceEffect(posicao_do_jogador, CONST_ANI_FIRE)
	
	local piso = Tile(ultima_posicao)
	if piso and piso:isWalkable() and piso:getCreatureCount() == 0 and not piso:hasFlag(TILESTATE_PROTECTIONZONE) and not piso:hasFlag(TILESTATE_FLOORCHANGE) then
		target:teleportTo(ultima_posicao, true)
	end
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUES, "formula")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Linha Certa")
spell:words("Linha Certa")
spell:group("attack")
spell:vocation("sorcerer", "master sorcerer")
spell:id(24)
spell:cooldown(40 * 1000)
spell:groupCooldown(4 * 1000)
spell:level(60)
spell:mana(1100)
spell:needTarget(true)
spell:isPremium(true)
spell:register()