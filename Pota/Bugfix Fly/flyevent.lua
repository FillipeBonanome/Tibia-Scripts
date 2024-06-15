function onMove(creature, toPosition, fromPosition)
	local player = Player(creature:getId())
	if not player:isOnFly() then return true end
	
	--Remover os tiles que não estão sendo usados (em volta do jogador)
	for i = -1, 1 do
		for j = -1, 1 do
			local newPosition = Position(fromPosition.x + i, fromPosition.y + j, fromPosition.z)
			if Tile(newPosition) then
				local flyItem = Tile(newPosition):getItemById(flyFloor)
				if flyItem and Tile(newPosition):getCreatureCount() == 0 and newPosition ~= toPosition then
					flyItem:remove()
				end
			end
		end
	end
	
	--Criar os novos pisos
	for i = -1, 1 do
		for j = -1, 1 do
			local newPosition = Position(toPosition.x + i, toPosition.y + j, toPosition.z)
			newPosition:createFlyFloor()
		end
	end
    return true
end
