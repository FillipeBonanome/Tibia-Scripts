local area = {
	{1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1},
	{1,1,1,1,3,1,1,1,1},
	{1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1},
}

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setArea(createCombatArea(area))

function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 8) + 50
	local max = (level / 5) + (magicLevel * 12) + 75
	return -min, -max
end

local function getManhattanDistance(pos_a, pos_b)
	if pos_a.z ~= pos_b.z then
		return 30
	end
	return math.abs(pos_a.x - pos_b.x) + math.abs(pos_a.y - pos_b.y)
end

local function getChebyshevDistance(pos_a, pos_b)
	if pos_a.z ~= pos_b.z then
		return 30
	end
	return math.max(math.abs(pos_a.x - pos_b.x), math.abs(pos_a.y - pos_b.y))
end

local function getEuclideanDistance(pos_a, pos_b)
	if pos_a.z ~= pos_b.z then
		return 30
	end
	return math.sqrt(math.pow((pos_b.x - pos_a.x), 2) + math.pow((pos_b.y - pos_a.y), 2))
end

function onTargetTile(cid, pos)
	local player_pos = cid:getPosition()
	local distance = getEuclideanDistance(player_pos, pos)
	addEvent(function()
		pos:sendMagicEffect(CONST_ME_FIREAREA)
		player_pos:sendDistanceEffect(pos, CONST_ANI_FIRE)
	end, distance * 150)
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local hits = 4
	for i = 1, hits do
		addEvent(function(c)
			if Creature(c) then
				local creature = Creature(c)
				local pokePos = creature:getPosition()
				--Soltar magia na posição do poke
			end
		end, (i - 1) * 200, creature:getId())
	end
	return combat:execute(creature, variant)
end

spell:name("dist")
spell:words("dist")
spell:group("attack")
spell:vocation("sorcerer", "master sorcerer")
spell:id(24)
spell:cooldown(40 * 1000)
spell:groupCooldown(4 * 1000)
spell:level(60)
spell:mana(1100)
spell:isSelfTarget(true)
spell:isPremium(true)
spell:register()