/*
	Welcome to the actor/solid system!
	
	In the actor/solid system, everything that collides with other objects is an "Actor"
	and it inherits from this object.
	
	All actors have a move_x and a move_y which are called to move them a certain distance,
	checking for collision with a "Solid" along the way. If one is encountered, the Actor
	stops, then performs the function provided in the second argument, "action," of move_x/move_y.
	
	default_move_action serves as a nice default input for this second argument. Use it whenever
	you don't want anything in particular to happen upon collision.
	
	For something like a bullet, you might want "action" to destroy the object and create an
	explosion. You can even combine this feature with the State Machine, calling a state
	change upon collision. It's pretty handy!
*/
function collideCheck(x_check, y_check){
	if place_meeting(x_check, y_check, obj_solid){
		return true;
	}
}
facing_x = 0;
facing_y = 0;
function default_move_action(){};
function move_x(x_dis, action){
	var remainder = x_dis;
	var move = round(remainder);
	var dir = sign(move);
	facing_x = dir;

	while (move != 0){
		if(!collideCheck(x+dir,y)){
			x+=dir;
			move-=dir;
		}
		else {
			action();
			break;
		}
	}
}

function move_y(y_dis, action){
	var remainder = y_dis;
	var move = round(remainder);
	var dir = sign(move);
	facing_y = dir;

	while (move != 0){
		if(!collideCheck(x,y+dir)){
			y+=dir;
			move-=dir;
		}
		else {
			action();
			break;
		}
	}
}