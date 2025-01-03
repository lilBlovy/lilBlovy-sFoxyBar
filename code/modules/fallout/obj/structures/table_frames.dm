/* Table Frames
 * Contains:
 *		Frames
 *		Wooden Frames
 */


/*
 * Normal Frames
 */

/obj/structure/table_frame
	name = "table frame"
	desc = "Four metal legs with four framing rods for a table. You could easily pass through this."
	icon = 'icons/obj/structures.dmi'
	icon_state = "table_frame"
/*	density = 0
	anchored = 0
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	obj_integrity = 100
	max_integrity = 100
	var/framestack = /obj/item/stack/rods
	var/framestackamount = 2

/obj/structure/table_frame/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		to_chat(user, span_notice("I start disassembling [src]..."))
		playsound(src.loc, I.usesound, 50, 1)
		if(do_after(user, 30*I.toolspeed, target = src))
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			deconstruct(TRUE)
	else if(istype(I, /obj/item/stack/sheet/plasteel))
		var/obj/item/stack/sheet/plasteel/P = I
		if(P.get_amount() < 1)
			to_chat(user, span_warning("I need one plasteel sheet to do this!"))
			return
		to_chat(user, span_notice("I start adding [P] to [src]..."))
		if(do_after(user, 50, target = src) && P.use(1))
			new /obj/structure/table/reinforced(src.loc)
			qdel(src)
	else if(istype(I, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = I
		if(M.get_amount() < 1)
			to_chat(user, span_warning("I need one metal sheet to do this!"))
			return
		to_chat(user, span_notice("I start adding [M] to [src]..."))
		if(do_after(user, 20, target = src) && M.use(1))
			new /obj/structure/table(src.loc)
			qdel(src)
	else if(istype(I, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/G = I
		if(G.get_amount() < 1)
			to_chat(user, span_warning("I need one glass sheet to do this!"))
			return
		to_chat(user, span_notice("I start adding [G] to [src]..."))
		if(do_after(user, 20, target = src) && G.use(1))
			new /obj/structure/table/glass(src.loc)
			qdel(src)
	else if(istype(I, /obj/item/stack/sheet/mineral/silver))
		var/obj/item/stack/sheet/mineral/silver/S = I
		if(S.get_amount() < 1)
			to_chat(user, span_warning("I need one silver sheet to do this!"))
			return
		to_chat(user, span_notice("I start adding [S] to [src]..."))
		if(do_after(user, 20, target = src) && S.use(1))
			new /obj/structure/table/optable(src.loc)
			qdel(src)
	else if(istype(I, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = I
		if(C.get_amount() < 1)
			to_chat(user, span_warning("I need one carpet sheet to do this!"))
			return
		to_chat(user, span_notice("I start adding [C] to [src]..."))
		if(do_after(user, 20, target = src) && C.use(1))
			new /obj/structure/table/wood/fancy(src.loc)
			qdel(src)
	else
		return ..()

/obj/structure/table_frame/deconstruct(disassembled = TRUE)
	new framestack(get_turf(src), framestackamount)
	qdel(src)

/obj/structure/table_frame/narsie_act()
	if(prob(20))
		new /obj/structure/table_frame/wood(src.loc)
		qdel(src)

/obj/structure/table_frame/ratvar_act()
	new /obj/structure/table_frame/brass(src.loc)
	qdel(src)

/*
 * Wooden Frames
 */
*/
/obj/structure/table_frame/wood
	name = "wooden table frame"
	desc = "Four wooden legs with four framing wooden rods for a wooden table. You could easily pass through this."
	icon_state = "wood_frame"
	framestack = /obj/item/stack/sheet/mineral/wood
	framestackamount = 2
	resistance_flags = FLAMMABLE
/*
/obj/structure/table_frame/wood/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/W = I
		if(W.get_amount() < 1)
			to_chat(user, span_warning("I need one wood sheet to do this!"))
			return
		to_chat(user, span_notice("I start adding [W] to [src]..."))
		if(do_after(user, 20, target = src) && W.use(1))
			new /obj/structure/table/wood(src.loc)
			qdel(src)
		return
	else if(istype(I, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = I
		if(C.get_amount() < 1)
			to_chat(user, span_warning("I need one carpet sheet to do this!"))
			return
		to_chat(user, span_notice("I start adding [C] to [src]..."))
		if(do_after(user, 20, target = src) && C.use(1))
			new /obj/structure/table/wood/poker(src.loc)
			qdel(src)
	else
		return ..()

/obj/structure/table_frame/brass
	name = "brass table frame"
	desc = "Four pieces of brass arranged in a square. It's slightly warm to the touch."
	icon_state = "brass_frame"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	framestack = /obj/item/stack/tile/brass
	framestackamount = 1

/obj/structure/table_frame/brass/New()
	change_construction_value(1)
	..()

/obj/structure/table_frame/brass/Destroy()
	change_construction_value(-1)
	return ..()

/obj/structure/table_frame/brass/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/tile/brass))
		var/obj/item/stack/tile/brass/W = I
		if(W.get_amount() < 1)
			to_chat(user, span_warning("I need one brass sheet to do this!"))
			return
		to_chat(user, span_notice("I start adding [W] to [src]..."))
		if(do_after(user, 20, target = src) && W.use(1))
			new /obj/structure/table/reinforced/brass(src.loc)
			qdel(src)
	else
		return ..()

/obj/structure/table_frame/brass/narsie_act()
	..()
	if(src) //do we still exist?
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)
		addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 8)
*/
