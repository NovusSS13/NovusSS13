///A holiday lasting one day only that falls on the nth weekday in a month i.e. 3rd Wednesday of February.
/datum/holiday/nth_week
	///Nth weekday of type begin_weekday in begin_month to start on (1 to 5).
	var/begin_week = 1
	///Weekday of begin_week to start on.
	var/begin_weekday = MONDAY
	///Nth weekday of type end_weekday in end_month to end on (1 to 5, defaults to begin_week).
	var/end_week
	///Weekday of end_week to end on (defaults to begin_weekday).
	var/end_weekday

/datum/holiday/nth_week/shouldCelebrate(dd, mm, yy, ddd)
	// Does not support holidays across multiple years..
	if (!end_month)
		end_month = begin_month
	if (!end_week)
		end_week = begin_week
	if (!end_weekday)
		end_weekday = begin_weekday
	// check that it's not past the last day
	end_day = weekday_to_iso(end_weekday) - first_day_of_month(yy, end_month)
	if (end_day < 0)
		end_day += 7
	end_day += (end_week - 1) * 7 + 1
	// check that it's not past the first day
	begin_day = weekday_to_iso(begin_weekday) - first_day_of_month(yy, begin_month)
	if (begin_day < 0)
		begin_day += 7
	begin_day += (begin_week - 1) * 7 + 1
	return ..(dd, mm, yy, ddd)

/datum/holiday/nth_week/thanksgiving
	name = "Thanksgiving in the United States"
	timezones = list(TIMEZONE_EST, TIMEZONE_CST, TIMEZONE_MST, TIMEZONE_PST, TIMEZONE_AKST, TIMEZONE_HST)
	begin_week = 4
	begin_month = NOVEMBER
	begin_weekday = THURSDAY
	drone_hat = /obj/item/clothing/head/hats/tophat //This is the closest we can get to a pilgrim's hat

/datum/holiday/nth_week/thanksgiving/canada
	name = "Thanksgiving in Canada"
	begin_week = 2
	begin_month = OCTOBER
	begin_weekday = MONDAY

/datum/holiday/nth_week/mother
	name = "Mother's Day"
	begin_week = 2
	begin_month = MAY
	begin_weekday = SUNDAY

/datum/holiday/nth_week/mother/greet()
	return "Happy Mother's Day in most of the Americas, Asia, and Oceania!"

/datum/holiday/nth_week/father
	name = "Father's Day"
	begin_week = 3
	begin_month = JUNE
	begin_weekday = SUNDAY

/datum/holiday/nth_week/beer
	name = "Beer Day"
	begin_week = 1
	begin_month = AUGUST
	begin_weekday = FRIDAY

/datum/holiday/beer/getStationPrefix()
	return pick("Stout","Porter","Lager","Ale","Malt","Bock","Doppelbock","Hefeweizen","Pilsner","IPA","Lite") //I'm sorry for the last one
