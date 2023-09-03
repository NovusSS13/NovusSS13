/// Returns whether or not the client passed the age check
/client/proc/passed_age_check()
	SHOULD_NOT_SLEEP(TRUE)
	if(holder || !SSdbcore.IsConnected() || !CONFIG_GET(flag/age_gate))
		return TRUE
	return (prefs?.db_flags & DB_FLAG_AGE_VETTED)

/// Initiates the automated age verification process
/client/proc/perform_age_check()
	SHOULD_NOT_SLEEP(TRUE)
	age_gated = TRUE
	var/datum/age_gate/age_vetting = new(src)
	INVOKE_ASYNC(age_vetting, TYPE_PROC_REF(/datum, ui_interact), src.mob)
	return age_vetting
