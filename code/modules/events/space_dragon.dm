/datum/round_event_control/space_dragon
	name = "Spawn Space Dragon"
	typepath = /datum/round_event/ghost_role/space_dragon
	weight = 8
	max_occurrences = 0 //GS13 - no antags, thanks
	min_players = 25
	dynamic_should_hijack = TRUE
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawns a space dragon, which will try to take over the station."

/datum/round_event/ghost_role/space_dragon
	minimum_required = 1
	role_name = "Space Dragon"
	announce_when = 10

/datum/round_event/ghost_role/space_dragon/announce(fake)
	priority_announce("A large organic energy flux has been recorded near of [station_name()], please stand-by.", "Lifesign Alert", has_important_message = TRUE)

/datum/round_event/ghost_role/space_dragon/spawn_role()
	var/list/spawn_locs = list()
	for(var/obj/effect/landmark/carpspawn/carp_spawn in GLOB.landmarks_list)
		if(!isturf(carp_spawn.loc))
			stack_trace("Carp spawn found not on a turf: [carp_spawn.type] on [isnull(carp_spawn.loc) ? "null" : carp_spawn.loc.type]")
			continue
		spawn_locs += carp_spawn.loc
	if(!spawn_locs.len)
		message_admins("No valid spawn locations found, aborting...")
		return MAP_ERROR

	var/list/candidates = get_candidates(ROLE_SPACE_DRAGON, null, ROLE_SPACE_DRAGON)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)

	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = TRUE

	var/mob/living/simple_animal/hostile/space_dragon/S = new(pick(spawn_locs))
	player_mind.transfer_to(S)
	player_mind.assigned_role = "Space Dragon"
	player_mind.special_role = "Space Dragon"
	player_mind.add_antag_datum(/datum/antagonist/space_dragon)
	playsound(S, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	message_admins("[ADMIN_LOOKUPFLW(S)] has been made into a Space Dragon by an event.")
	log_game("[key_name(S)] was spawned as a Space Dragon by an event.")
	spawned_mobs += S
	return SUCCESSFUL_SPAWN
