/datum/element/decal/cum
	decal_trait = TRAIT_COVERED_IN_CUM

/datum/element/decal/cum/Attach(datum/target, _icon, _icon_state, _dir, _plane, _layer, _alpha, _color, _smoothing, _cleanable=CLEAN_TYPE_BLOOD, _description, mutable_appearance/_pic)
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	. = ..()
	RegisterSignal(target, COMSIG_ATOM_GET_EXAMINE_NAME, .proc/get_examine_name, TRUE)

/datum/element/decal/cum/Detach(atom/source)
	UnregisterSignal(source, COMSIG_ATOM_GET_EXAMINE_NAME)
	return ..()

/datum/element/decal/cum/generate_appearance(_icon, _icon_state, _dir, _plane, _layer, _color, _alpha, _smoothing, source)
	var/obj/item/I = source
	if(!_icon)
		_icon = 'icons/effects/cum.dmi'
	if(!_icon_state)
		_icon_state = "itemcum"
	var/icon = I.icon
	var/icon_state = I.icon_state
	if(!icon || !icon_state)
		// It's something which takes on the look of other items, probably
		icon = I.icon
		icon_state = I.icon_state
	var/static/list/cum_splatter_appearances = list()
	//try to find a pre-processed blood-splatter. otherwise, make a new one
	var/index = "[REF(icon)]-[icon_state]"
	pic = cum_splatter_appearances[index]

	if(!pic)
		var/icon/item_icon = icon(I.icon, I.icon_state, , 1) //icon of the item that will become splattered
		var/icon/decal_icon = icon(_icon, _icon_state) //icon of the decal that we apply
		decal_icon.Scale(item_icon.Width(), item_icon.Height())
		item_icon.Blend("#fff", ICON_ADD) //fills the icon_state with white (except where it's transparent)
		item_icon.Blend(decal_icon, ICON_MULTIPLY) //adds cum and the remaining white areas become transparent
		pic = mutable_appearance(item_icon, I.icon_state)
		pic.color = COLOR_CUM
		cum_splatter_appearances[index] = pic
	return TRUE

/datum/element/decal/cum/proc/get_examine_name(datum/source, mob/user, list/override)
	SIGNAL_HANDLER

	var/atom/A = source
	override[EXAMINE_POSITION_ARTICLE] = A.gender == PLURAL? "some" : "a"
	override[EXAMINE_POSITION_BEFORE] = " [span_color("<b>cum-stained</b>", COLOR_CUM)] "
	return COMPONENT_EXAMINE_NAME_CHANGED
