/datum/element/decal/femcum
	decal_trait = TRAIT_COVERED_IN_FEMCUM

/datum/element/decal/femcum/Attach(datum/target, _icon, _icon_state, _dir, _plane, _layer, _alpha, _color, _smoothing, _cleanable=CLEAN_TYPE_BLOOD, _description, mutable_appearance/_pic)
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	. = ..()
	RegisterSignal(target, COMSIG_ATOM_GET_EXAMINE_NAME, .proc/get_examine_name, TRUE)

/datum/element/decal/femcum/Detach(atom/source)
	UnregisterSignal(source, COMSIG_ATOM_GET_EXAMINE_NAME)
	return ..()

/datum/element/decal/femcum/generate_appearance(_icon, _icon_state, _dir, _plane, _layer, _color, _alpha, _smoothing, source)
	var/obj/item/I = source
	if(!_icon)
		_icon = 'icons/effects/femcum.dmi'
	if(!_icon_state)
		_icon_state = "itemfemcum"
	var/icon = I.icon
	var/icon_state = I.icon_state
	if(!icon || !icon_state)
		// It's something which takes on the look of other items, probably
		icon = I.icon
		icon_state = I.icon_state
	var/static/list/femcum_splatter_appearances = list()
	//try to find a pre-processed blood-splatter. otherwise, make a new one
	var/index = "[REF(icon)]-[icon_state]"
	pic = femcum_splatter_appearances[index]

	if(!pic)
		var/icon/item_icon = icon(I.icon, I.icon_state, , 1) //icon of the item that will become splattered
		var/icon/decal_icon = icon(_icon, _icon_state) //icon of the decal that we apply
		decal_icon.Scale(item_icon.Width(), item_icon.Height())
		item_icon.Blend("#fff", ICON_ADD) //fills the icon_state with white (except where it's transparent)
		item_icon.Blend(decal_icon, ICON_MULTIPLY) //adds cum and the remaining white areas become transparent
		pic = mutable_appearance(item_icon, I.icon_state)
		pic.color = COLOR_FEMCUM
		femcum_splatter_appearances[index] = pic
	return TRUE

/datum/element/decal/femcum/proc/get_examine_name(datum/source, mob/user, list/override)
	SIGNAL_HANDLER

	var/atom/A = source
	override[EXAMINE_POSITION_ARTICLE] = A.gender == PLURAL? "some" : "a"
	override[EXAMINE_POSITION_BEFORE] = " [span_color("<b>squirt-stained</b>", copytext(COLOR_FEMCUM, 1, -2))] " //remove the alpha
	return COMPONENT_EXAMINE_NAME_CHANGED
