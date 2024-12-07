/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items/implants.dmi'
	icon_state = "implanter0"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/inhands/equipment/medical_left.dmi',
		slot_r_hand_str = 'icons/mob/inhands/equipment/medical_right.dmi',
	)
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY
	var/obj/item/implant/internal_implant = null

/obj/item/implanter/Initialize(mapload, ...)
	. = ..()
	if(internal_implant)
		internal_implant = new internal_implant(src)
		update_icon()

/obj/item/implanter/Destroy()
	QDEL_NULL(internal_implant)
	return ..()

/obj/item/implanter/update_icon_state()
	. = ..()
	icon_state = "implanter[internal_implant?"1":"0"]"

/obj/item/implanter/examine(mob/user, distance, infix, suffix)
	. = ..()
	. += "it contains [internal_implant ? "a [internal_implant.name]" : "no implant"]!"

/obj/item/implanter/attack(mob/target, mob/user)
	. = ..()
	if(!can_implant(target, user))
		return

	user.visible_message(span_warning("[user] is attemping to implant [target]."), span_notice("You're attemping to implant [target]."))

	if(!do_after(user, 5 SECONDS, NONE, target, BUSY_ICON_GENERIC) || !internal_implant)
		to_chat(user, span_notice("You failed to implant [target]."))
		return

	if(internal_implant.try_implant(target, user))
		target.visible_message(span_warning("[target] has been implanted by [user]."))
		log_combat(user, target, "implanted", src)
		internal_implant = null
		update_icon()
		return TRUE
	to_chat(user, span_notice("You fail to implant [target]."))

/obj/item/implanter/proc/can_implant(mob/target, mob/user)
	if(!ishuman(target))
		return FALSE
	if(!internal_implant)
		to_chat(user, span_warning("There is no implant in the [src]!"))
		return FALSE
	return TRUE

/obj/item/implanter/neurostim
	name = "neurostim implanter"
	internal_implant = /obj/item/implant/neurostim

/obj/item/implanter/chem
	name = "chem implant implanter"
	internal_implant = /obj/item/implant/chem

/obj/item/implanter/chem/blood
	name = "blood recovery implant implanter"
	internal_implant = /obj/item/implant/chem/blood

/obj/item/implanter/cloak
	name = "cloak implant implanter"
	internal_implant = /obj/item/implant/cloak

/obj/item/implanter/blade
	name = "blade implant implanter"
	internal_implant = /obj/item/implant/deployitem/blade

/obj/item/implanter/suicide_dust
	name = "Self-Gibbing implant"
	internal_implant = /obj/item/implant/suicide_dust
