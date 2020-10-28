deathswap = {}
deathswap.players = {}

minetest.register_on_prejoinplayer(function()
	if #deathswap.players == 2 then
		return "Deathswap is full!"
	end
end)

minetest.register_on_joinplayer(function(player)
	deathswap.players[#deathswap.players + 1] = player
	if #deathswap.players == 2 then
		deathswap.start_swap()
	end
end)

minetest.register_on_leaveplayer(function(player)
	if player == deathswap.players[1] then
		table.remove(deathswap.players, 1)
	elseif player == deathswap.players[2] then
		table.remove(deathswap.players, 2)
	end
end)

minetest.register_on_dieplayer(function(player)
	minetest.kick_player(player:get_player_name(), "You died :-)")
end)

function deathswap.swap(seconds)
	if #deathswap.players < 2 then
		return
	end
	if seconds == 0 then
		minetest.chat_send_all(minetest.colorize("#FF7300", "Swapping"))
		local pos1 = deathswap.players[1]:get_pos()
		local pos2 = deathswap.players[2]:get_pos()
		deathswap.players[1]:set_pos(pos2)
		deathswap.players[2]:set_pos(pos1)
		deathswap.start_swap()
	else
		minetest.chat_send_all(minetest.colorize("#FF7300", "Swapping in " .. seconds .. " seconds"))
		minetest.after(1, deathswap.swap, seconds - 1)
	end
end

function deathswap.start_swap()
	minetest.after(5 * 60, deathswap.swap, 10)
end
