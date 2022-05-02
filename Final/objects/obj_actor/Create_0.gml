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
if(!instance_exists(obj_actor_tracker)) {
	instance_create_layer(x, y, layer, obj_actor_tracker);
}
ds_list_add(obj_actor_tracker.actor_list, id);

function collide_check(x_check, y_check){
	var solid_check = instance_place(x_check, y_check, obj_solid);
	if (solid_check==-4 or solid_check.collidable==false) {
		return false;
	}
	else return place_meeting(x_check, y_check, solid_check);
}
//override in child objects if they have some certain condition for riding a solid
is_riding = function(){
	return false;
}
function is_standing(){
	if (collide_check(x, y+1)){
		return true;
	}
	else return false;
}
facing_x = 0;
facing_y = 0;

default_move_action = function(){};
squish_move_action = function(){
	//moving solids will call this if they trap an actor out of bounds
}

function move_x(x_dis, action) {
	var remainder = x_dis;
	var move = round(remainder);
	var dir = sign(move);
	facing_x = dir;

	while (move != 0){
		if(!collide_check(x+dir,y)){
			x+=dir;
			move-=dir;
		}
		else {
			action();
			break;
		}
	}
}

function move_y(y_dis, action) {
	var remainder = y_dis;
	var move = round(remainder);
	var dir = sign(move);
	facing_y = dir;

	while (move != 0){
		if(!collide_check(x,y+dir)){
			y+=dir;
			move-=dir;
		}
		else {
			action();
			break;
		}
	}
}