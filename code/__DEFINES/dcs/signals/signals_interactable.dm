//Interactable component
///from base of datum/component/interactable/try_interact(): (atom/source, mob/living/user)
#define COMSIG_INTERACTABLE_TRY_INTERACT "interactable_try_interact"
	/// Successfully opened the interaction UI
	#define COMPONENT_CAN_INTERACT (1<<0)
	/// Other components can hijack the signal and prevent interactions
	#define COMPONENT_NO_INTERACT (1<<1)
///from base of datum/component/interactable/try_interact(): (atom/source, mob/living/user)
#define COMSIG_INTERACTABLE_TRYING_INTERACT "interactable_trying_interact"
