PROCESSING_SUBSYSTEM_DEF(food_printer)
	wait = 1
	flags = SS_KEEP_TIMING
	name = "FoodPrinter"
	var/datum/food_menu/food_menu
	var/entries_per_page = 50
	var/max_food_print = 20
	var/list/food_printer_outputs = list()
	var/list/taglines = list(
		"Tasty food for tasty people!",
		"Food fit for a fox!",
		"Mit iodine!",
	)
	var/list/tips = list(
		"Tip 1: Did you know? Everything generated by the GekkerTec FoodFox 2000 is as ethically sourced as you want it to be!",
		"Tip 2: Watch what you eat! While the GekkerTec FoodFox 2000 has over 1000 recipes, not all of them are good for you, or even safe to eat!",
		"Tip 3: Want to impress a date? Print out the ingredients for a romantic dinner and cook it yourself! The GekkerTec FoodFox 2000 can be your sous chef!",
		"Tip 4: Did you know? The GekkerTec FoodFox 2000 can print out multiples of the same food item at once! Printing times will vary.",
		"Tip 5: The GekkerTec FoodFox 2000 may list recipes that may or may not actually be food. Please ensure that anything generated is, in fact, food.",
		"Tip 6: The GekkerTec FoodFox 2000 may list recipes that include ingredients that are unlawful in some jurisdictions. Please ensure that anything generated is legal. We won't tell though =3",
		"Tip 7: The GekkerTec FoodFox 2000 is not responsible for any food poisoning, allergic reactions, or other health issues that may arise from consuming food generated by it.",
		"Tip 8: The FoodFox DinnerDelivery Teleporter can lock on to Food Beacons at any range, even if they're in another dimension!",
		"Tip 9: Want more butter? The GekkerTec FoodFox 2000 can print as much butter as you want!",
		"Tip 10: Yes the Food Beacons work even while they're in your stomach, and no, it doesn't know when you're full, so be careful! =3",
		"Tip 11: If you have a Food Beacon in your backpack, any food teleported to it will be stored in your backpack! If there's room, that is.",
	)

/datum/controller/subsystem/processing/food_printer/Initialize()
	food_menu = new()
	. = ..()
	to_chat(world, span_boldnotice("Initialized [LAZYLEN(food_menu.foods)] FoodFox recipes!"))

//////////////////////////////////////////////////////////////////////
// Food Menu 2000 - The Menu of the Future ///////////////////////////
// Holds all the foods in existence, and categorizes them. ///////////
//////////////////////////////////////////////////////////////////////
/datum/food_menu
	var/list/foods = list()
	var/list/TGUI_chunk = list()
	var/list/full_TGUI_chunk = list()

/datum/food_menu/New()
	. = ..()
	InitFoodList()

/// goes through every single item in the game and checks IS IT FOOD? HEY ARE YOU FOOD? WHY DO I KEEP EATING MY FRIENDS
/datum/food_menu/proc/InitFoodList()
	foods = list()
	for(var/thing in subtypesof(/obj/item))
		var/obj/item/I = thing
		if(!initial(I.is_food))
			continue
		var/datum/food_menu_entry/entry = new /datum/food_menu_entry(I)
		foods += entry
	foods = sortList(foods, GLOBAL_PROC_REF(cmp_name_asc)) // the entries arent atoms, but! they have a var named 'name', which thanks to our good friend Pali who said never to do this, we can trick the game into using it anyway. thanks pali!
	var/list/coolfoods = list()
	for(var/datum/food_menu_entry/entry in foods)
		coolfoods["[entry.food_key]"] = entry
	foods = coolfoods
	InitTGUIChunk()

/datum/food_menu/proc/InitTGUIChunk()
	TGUI_chunk = list()
	full_TGUI_chunk = list()
	var/list/menus = list()
	var/list/working_menu = list()
	for(var/foodkey in foods)
		if(LAZYLEN(working_menu) >= SSfood_printer.entries_per_page)
			menus += list(working_menu)
			working_menu = list()
		var/datum/food_menu_entry/entry = foods[foodkey]
		working_menu += list(entry.data_for_tgui())
		full_TGUI_chunk += list(entry.data_for_tgui())
	if(LAZYLEN(working_menu))
		menus += list(working_menu)
	TGUI_chunk = menus // me-nus

//////////////////////////////////////////////////////////////////////
// Food Item - The Food of the Future ////////////////////////////////
// A single food item. ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/datum/food_menu_entry
	var/name = "Food"
	var/desc = "It's a food"
	var/list/categories = list()
	var/list/nut_facts = list()
	var/print_time = 5 SECONDS
	var/food_key
	var/obj/item/itempath

/datum/food_menu_entry/New(obj/item/thing)
	. = ..()
	if(!thing)
		qdel(src)
		CRASH("Food menu entry created with no item. ERROR CODE: WAIFU SPHERE SOFA FILLER")
	Initify(thing)

/// Spawns then unspawns a food item to get its data
/datum/food_menu_entry/proc/Initify(obj/item/thing)
	var/obj/item/I = new thing() // Lemme get a to-go order for nullspace
	food_key = "[I.type]"
	name = capitalize("[I.name]")
	desc = I.desc
	itempath = I.type
	// categories = Catagorize(I)
	nut_facts = Nutrify(I)
	qdel(I) // And then we just throw it in the trash

/// Categorizes a food item
/datum/food_menu_entry/proc/Catagorize(obj/item/thing)
	return // catabite me

/// Gets the nutritional facts of a food item
/datum/food_menu_entry/proc/Nutrify(obj/item/thing)
	nut_facts = list()
	var/calories = 0
	var/vitamins = 0
	var/sugars = 0
	var/list/everything_else = list()
	for(var/datum/reagent/R in thing.reagents?.reagent_list)
		if(istype(R, /datum/reagent/consumable))
			var/datum/reagent/consumable/C = R
			var/totnut = (C.volume * C.nutriment_factor) / C.metabolization_rate
			if(istype(C, /datum/reagent/consumable/nutriment/vitamin))
				vitamins += totnut
			else if(istype(C, /datum/reagent/consumable/nutriment))
				calories += totnut
			else if(istype(C, /datum/reagent/consumable/sugar) || \
				istype(C, /datum/reagent/consumable/sprinkles) || \
				istype(C, /datum/reagent/consumable/corn_syrup) || \
				istype(C, /datum/reagent/consumable/honey))
				var/sugs = totnut
				if(istype(C, /datum/reagent/consumable/corn_syrup))
					sugs *= 3
				if(istype(C, /datum/reagent/consumable/honey))
					sugs *= 3
				sugars += sugs
		everything_else["[R.name]"] = R.volume
	nut_facts["Calories"] = calories
	nut_facts["Vitamins"] = vitamins
	nut_facts["Sugars"] = sugars
	for(var/reagent in everything_else)
		nut_facts["[reagent]"] = everything_else[reagent]
	return nut_facts

/datum/food_menu_entry/proc/data_for_tgui()
	var/list/data = list()
	data["Name"] = name || "Food"
	data["Description"] = desc || "No description available."
	data["Categories"] = categories || list()
	data["NutritionalFacts"] = nut_facts || list()
	data["PrintTime"] = (print_time / 10) || 5
	data["FoodKey"] = food_key || "/datum/food_menu_entry/awful_food"
	return data






