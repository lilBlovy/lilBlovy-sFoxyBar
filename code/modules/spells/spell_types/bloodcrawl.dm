/obj/effect/proc_holder/spell/bloodcrawl
	name = "Blood Crawl"
	desc = "Use pools of blood to phase out of existence."
	clothes_req = NONE
	//If you couldn't cast this while phased, you'd have a problem
	phase_allowed = 1
	selection_type = "range"
	range = 1
	cooldown_min = 0
	overlay = null
	action_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	action_icon_state = "bloodcrawl"
	action_background_icon_state = "bg_demon"
	var/phased = 0
	charge_max = 6

/obj/effect/proc_holder/spell/bloodcrawl/choose_targets(mob/user = usr)
	for(var/obj/effect/decal/cleanable/target in range(range, get_turf(user)))
		if(target.can_bloodcrawl_in())
			perform(target)
			return
	revert_cast()
	to_chat(user, span_warning("There must be a nearby source of blood!"))

/obj/effect/proc_holder/spell/bloodcrawl/perform(obj/effect/decal/cleanable/target, recharge = 1, mob/living/user = usr)
	if(istype(user))
		if(istype(user, /mob/living/simple_animal/slaughter))
			var/mob/living/simple_animal/slaughter/slaught = user
			slaught.current_hitstreak = 0
			slaught.wound_bonus = initial(slaught.wound_bonus)
			slaught.bare_wound_bonus = initial(slaught.bare_wound_bonus)
		if(phased)
			if(user.phasein(target))
				phased = 0
		else
			if(user.phaseout(target))
				phased = 1
		start_recharge()
		return
	revert_cast()
	to_chat(user, span_warning("I am unable to blood crawl!"))
