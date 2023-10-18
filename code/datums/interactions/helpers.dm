/// I have no comment, this entire proc is just fucking hilarious
/proc/do_fucking_animation(mob/fucker, fuckdir = NONE)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	if(!fuckdir)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
	else
		fucker.setDir(fuckdir)
		if(fuckdir & NORTH)
			pixel_y_diff = 8
		else if(fuckdir & SOUTH)
			pixel_y_diff = -8

		if(fuckdir & EAST)
			pixel_x_diff = 8
		else if(fuckdir & WEST)
			pixel_x_diff = -8

	animate(fucker, pixel_x = pixel_x_diff, pixel_y = pixel_y_diff, time = 2, flags = ANIMATION_RELATIVE)
	animate(pixel_x = -pixel_x_diff, pixel_y = -pixel_y_diff, time = 2, flags = ANIMATION_RELATIVE)
