function user_input()
	local mouse_x = stat(32)
	local mouse_y = stat(33)

	curr_mbtn = stat(34)

	if in_menu then
		if curr_mbtn == 1 and prev_mbtn == 0 then
			in_menu = false
			in_cycle = true
			buttons_disabled = false
			music(1)
		end
	else
		if 		mouse_x >= end_turn_top_left_x
			and mouse_x <= end_turn_bot_right_x
			and mouse_y >= end_turn_top_left_y
			and mouse_y <= end_turn_bot_right_y
		then
			et_mouse_over = true
		else
			et_mouse_over = false
		end

		if 		mouse_x >= capture_top_left_x
			and mouse_x <= capture_bot_right_x
			and mouse_y >= capture_top_left_y
			and mouse_y <= capture_bot_right_y
		then
			capture_mouse_over = true
		else
			capture_mouse_over = false
		end

		if 		mouse_x >= trace_top_left_x
			and mouse_x <= trace_bot_right_x
			and mouse_y >= trace_top_left_y
			and mouse_y <= trace_bot_right_y
		then
			trace_mouse_over = true
		else
			trace_mouse_over = false
		end

		if 		go_no_top_left_x ~= nil
			and go_yes_top_left_x ~= nil
			and game_over or victory
		then
			if 		mouse_x >= go_no_top_left_x
				and mouse_x <= go_no_bot_right_x
				and mouse_y >= go_no_top_left_y
				and mouse_y <= go_no_bot_right_y
			then
				go_no_mouse_over = true
			else
				go_no_mouse_over = false
			end

			if 		mouse_x >= go_yes_top_left_x
				and mouse_x <= go_yes_bot_right_x
				and mouse_y >= go_yes_top_left_y
				and mouse_y <= go_yes_bot_right_y
			then
				go_yes_mouse_over = true
			else
				go_yes_mouse_over = false
			end
		end
		
		if curr_mbtn == 1 and prev_mbtn == 0 then -- left click
			if 		mouse_x >= end_turn_top_left_x
				and mouse_x <= end_turn_bot_right_x
				and mouse_y >= end_turn_top_left_y
				and mouse_y <= end_turn_bot_right_y
				and not buttons_disabled
			then
				agent_to_capture = nil
				agent_to_trace = nil
				capturing = false
				tracing = false
				et_mouse_over = false
				in_cycle = true
				time_cycle = 100
				return
			end

			if		mouse_x >= capture_top_left_x
				and mouse_x <= capture_bot_right_x
				and mouse_y >= capture_top_left_y
				and mouse_y <= capture_bot_right_y
			then
				capturing = true
				tracing = false
				agent_to_trace = nil
			end

			if		mouse_x >= trace_top_left_x
				and mouse_x <= trace_bot_right_x
				and mouse_y >= trace_top_left_y
				and mouse_y <= trace_bot_right_y
			then
				capturing = false
				tracing = true
				agent_to_capture = nil
			end

			if capturing and agent_to_capture ~= nil then
				capture_cost = 5
				if curr_ap >= capture_cost then
					rand_x = flr(rnd(hall.bot_right_x - hall.top_left_x - 1)) + hall.top_left_x + 1
					rand_y = flr(rnd(hall.bot_right_y - hall.top_left_y - 1)) + hall.top_left_y + 1

					make_particle_line(
						agent_to_capture.x,
						agent_to_capture.y,
						rand_x,
						rand_y,
						3,
						9,
						10,
						1
					)
					sfx(21)

					make_exp_circle(
						rand_x,
						rand_y,
						0.6,
						8,
						10
					)

					agent_to_capture.x = rand_x
					agent_to_capture.y = rand_y
					agent_to_capture.is_captured = true
					curr_ap -= capture_cost
					agent_to_capture = nil
				end
			end

			if tracing and agent_to_trace ~= nil then
				trace_cost = 10
				if curr_ap >= trace_cost then
					agent_to_trace.trace_depth += 1

					local prev_snatcher, next_snatcher

					if agent_to_trace.snatched_by ~= nil then
						sfx(19)
						prev_snatcher = nil
						next_snatcher = agent_to_trace

						for i = 0, agent_to_trace.trace_depth do
							prev_snatcher = next_snatcher
							if next_snatcher.snatched_by == nil then
								next_snatcher = nil
								break
							end
							next_snatcher = next_snatcher.snatched_by
						end
					end

					if next_snatcher == nil then
						sfx(18)
						curr_ap -= trace_cost
						if not agent_to_trace.is_snatcher then
							make_particle_line(
								agent_to_trace.x,
								agent_to_trace.y,
								agent_to_trace.home_x,
								agent_to_trace.home_y,
								3,
								9,
								10,
								1
							)

							agent_to_trace.x = agent_to_trace.home_x
							agent_to_trace.y = agent_to_trace.home_y

							make_exp_circle(
								agent_to_trace.home_x,
								agent_to_trace.home_y,
								0.6,
								8,
								10
							)
						end
						agent_to_trace = nil
						return
					end

					make_particle_line(
						prev_snatcher.x,
						prev_snatcher.y,
						next_snatcher.x,
						next_snatcher.y,
						3,
						3,
						11,
						trace_particle_chance
					)
					add(trace_pairs, {prev_snatcher, next_snatcher})

					make_exp_circle(
						next_snatcher.x,
						next_snatcher.y,
						0.6,
						8,
						3
					)

					curr_ap -= trace_cost
					agent_to_trace = nil
				end
			end

			if 		go_no_top_left_x ~= nil
				and go_yes_top_left_x ~= nil
			then
				if 		mouse_x >= go_yes_top_left_x
					and mouse_x <= go_yes_bot_right_x
					and mouse_y >= go_yes_top_left_y
					and mouse_y <= go_yes_bot_right_y
					and (game_over or victory)
				then
					run("retry")
				end

				if 		mouse_x >= go_no_top_left_x
					and mouse_x <= go_no_bot_right_x
					and mouse_y >= go_no_top_left_y
					and mouse_y <= go_no_bot_right_y
					and (game_over or victory)
				then
					stop()
				end
			end
		elseif stat(34) == 2 then -- right click
			capturing = false
			tracing = false
		end
	end

	prev_mbtn = curr_mbtn
end

function is_game_over()
	for agent in all(agents) do
		if not agent.is_snatcher then
			return false
		end
	end
	return true
end

function is_victory()
	for agent in all(agents) do
		if agent.snatcher_zero and agent.is_captured then
			return true
		end
	end
	return false
end


function check_empty(x,y,a)
	if x <= min_x or x >= max_x then return false end
	if y <= min_y or y >= max_y then return false end
	return matrix[x][y] == "empty"
end

function valid_home_pos(x, y, a)
	local top_left_x = 0
	local top_left_y = 0
	local bot_right_x = 0
	local bot_right_y = 0

	top_left_x = x - dist -  (home_radius + 3)
	top_left_y = y - dist -  (home_radius + 3)
	bot_right_x = x + dist + (home_radius + 3)
	bot_right_y = y + dist + (home_radius + 3)

	if top_left_x <= min_x then return false end
	if top_left_y <= min_y then return false end
	if bot_right_x >= max_x then return false end
	if bot_right_y >= max_y then return false end

	for i = top_left_x, bot_right_x do
		for j = top_left_y, bot_right_y do
			if matrix[i][j] == "agent" or matrix[i][j] == "hall" or matrix[i][j] == "home" then
				if a ~= nil and i == a.x and j == a.y then
					goto continue_check_empty
				else
					return false
				end
			end
		end
		::continue_check_empty::
	end

	return true
end

function get_delta(x, y)
	dirs = {-1, 0, 1}

	local dx, dy = 0, 0

	chosen_dir = dirs[flr(rnd(3)) + 1]
	if x - dist <= min_x then dx = 1
	elseif x + dist >= max_x then dx = -1
	else dx = chosen_dir
	end

	chosen_dir = dirs[flr(rnd(3)) + 1]
	if y - dist <= min_y then dy = 1
	elseif y + dist >= max_y then dy = -1
	else dy = chosen_dir
	end

	return dx, dy
end

function act(a)
	if not a.is_snatcher then
		agent_get_snatched(a)
	end
	agent_move(a)
end

function circle_act(c)
	if c.r >= c.max_r then
		del(exp_circles, c)
	end
end

function particle_act(p)
	if 	p.life <= 0 then
		del(particles, p)
		p = nil
		return
	end

	if p.y + p.dy > p.floor_y then p.dy *= -0.8 end

	p.x += p.dx
	p.y += p.dy
	p.dy += 0.1

	p.life -= 1
end

function sign(x)
	if x < 0 then return -1 elseif x == 0 then return 0 else return 1 end
end

function move_dir(target, goal)
	return (target - goal)
end

function get_nearby_snatcher(agent)
	local result, coords

	top_left_x = agent.x - snatch_radius
	top_left_y = agent.y - snatch_radius
	bot_right_x = agent.x + snatch_radius
	bot_right_y = agent.y + snatch_radius

	if top_left_x < min_x then top_left_x = min_x end
	if top_left_y < min_y then top_left_y = min_y end
	if bot_right_x > max_x then bot_right_x = max_x end
	if bot_right_y > max_y then bot_right_y = max_y end

	for i = top_left_x, bot_right_x do
		for j = top_left_y, bot_right_y do
			if 		matrix[i][j] == "snatcher"
				and agent.x ~= i
				and agent.y ~= j
			then
				coords = {i, j}
				break
			end
		end
		if coords ~= nil then break end
	end

	if coords ~= nil then
		for agent in all(agents) do
			if 		agent.x == coords[1]
				and agent.y == coords[2]
			then
				result = agent
				break
			end
		end
	end

	return result
end

function agent_get_snatched(agent)
	snatcher = get_nearby_snatcher(agent)
	if snatcher ~= nil and not agent.is_captured then
		if snatch_chance > rnd(1) then
			agent.is_snatcher = true
			agent.snatched_by = snatcher
			-- prevent snatched agent from going home
			agent.hunger = 100
			agent.going_home = false
		end
	end
end

function agent_move(agent)
	if 		(agent.x <= hall.top_left_x or agent.x >= hall.bot_right_x)
		and (agent.y <= hall.top_left_y or agent.y >= hall.bot_right_y)
	then
		agent.is_captured = false
	end

	if not agent.is_captured and (agent.hunger < 0 or agent.going_home) then
		agent.going_home = true
		agent.is_captured = false

		if agent.x == agent.home_x and agent.y == agent.home_y then
			agent.going_home = false
			agent.emerg_dir_x = nil
			agent.emerg_dir_y = nil
			agent.hunger = flr(rnd(400)) + 100
		else
			matrix[agent.x][agent.y] = "empty"

			xdir = move_dir(agent.home_x, agent.x)
			ydir = move_dir(agent.home_y, agent.y)
			xdir = sign(xdir)
			ydir = sign(ydir)

			-- Can we move horizontal
			can_mov_hor = matrix[agent.x+xdir][agent.y] ~= "hall"
			-- Can we move vertical
			can_mov_ver = matrix[agent.x][agent.y+ydir] ~= "hall"

			moved = false
			outputfile = "output.txt"

			if not moved and xdir ~= 0 and can_mov_hor and agent.emerg_dir_x == nil then
				agent.x += xdir
				agent.emerg_dir_y = nil
				moved = true
			end

			if not moved and ydir ~= 0 and can_mov_ver and agent.emerg_dir_y == nil then
				agent.y += ydir
				agent.emerg_dir_x = nil
				moved = true
			end

			if not moved and agent.emerg_dir_y ~= nil then
				agent.y += agent.emerg_dir_y
				moved = true
			end

			if not moved and agent.emerg_dir_x ~= nil then
				agent.x += agent.emerg_dir_x
				moved = true
			end

			if not moved then
				if xdir ~= 0 and not can_mov_hor then
					agent.emerg_dir_y = 1
				else
					agent.emerg_dir_x = 1
				end
			end

			matrix[agent.x][agent.y] = "agent"

		end
		return
	end

	if not agent.snatcher and agent.trace_depth == 0 and not agent.is_captured then
		agent.hunger -= 1
	end
		
	if 	agent.prev_dx == nil
		or 	agent.prev_dy == nil
		or 	change_dir_chance > rnd(1)
	then
		dx, dy = get_delta(agent.x, agent.y)
	else
		dx = agent.prev_dx
		dy = agent.prev_dy
	end

	local empty_coord = false
	local attempt = 0
	local num_retries = 10
	while not empty_coord and attempt < num_retries do
		empty_coord = check_empty(agent.x + dx, agent.y + dy, agent)
		if empty_coord then
			matrix[agent.x][agent.y] = "empty"
			agent.x += dx
			agent.y += dy
			agent.prev_dx = dx
			agent.prev_dy = dy
			if agent.is_snatcher then
				matrix[agent.x][agent.y] = "snatcher"
			else
				matrix[agent.x][agent.y] = "agent"
			end
			break
		else
			attempt += 1
			dx, dy = get_delta(agent.x, agent.y)
		end
	end
end
