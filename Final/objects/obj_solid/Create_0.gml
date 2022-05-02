if (debug_mode) {
	visible = true;
}
/*
	Welcome to the actor/solid system!
	
	In the actor/solid system, all actors collide with "Solids." Objects like platforms or 
	terrain should inherit from this object. Solids do not collide with each other, but 
	there's no rule saying they can't move!
	
	Also, you can place obj_solid in-game on its own as a way to create invisible walls.
*/

//HEY KATE IF YOURE READING THIS!!
//THIS IS HEAVILY BASED ON THE SYSTEM MADDIE THORSON USED IN CELESTE/TOWERFALL!
//REFER TO THIS FOR CREDIT! https://maddythorson.medium.com/celeste-and-towerfall-physics-d24bd2ae0fc5
collidable = true;

function move(x_dis, y_dis){
	collidable = false;
	
	var x_remainder = x_dis;
	var y_remainder = y_dis;
	
	var x_move = round(x_remainder);
	var y_move = round(y_remainder);
	
	var riding_list = ds_list_create();
	
	for (var i = 0; i < ds_list_size(obj_actor_tracker.actor_list); ++i) {
	    var actor = obj_actor_tracker.actor_list[|i ];
		
		if (actor.is_riding(id)) ds_list_add(riding_list, actor); 
	}
	
	if (x_move != 0) {
		x_remainder -= x_move;
		x+=x_move;
		
		if (x_move > 0) {
			for (var i = 0; i < ds_list_size(obj_actor_tracker.actor_list); ++i) {
			    var actor = obj_actor_tracker.actor_list[| i];
				
				if (place_meeting(x, y, actor)) {
					//push right
					actor.move_x(bbox_right - actor.bbox_left, actor.squish_move_action);
				}
				else if (ds_list_contains(riding_list, actor)) {
					//carry
					actor.move_x(x_move, actor.default_move_action);					
				}
			}
		}
		
		else {
			for (var i = 0; i < ds_list_size(obj_actor_tracker.actor_list); ++i) {
			    var actor = obj_actor_tracker.actor_list[| i];
				
				if (place_meeting(x, y, actor)) {
					//push right
					actor.move_x(bbox_left - actor.bbox_right, actor.squish_move_action);
				}
				else if (ds_list_contains(riding_list, actor)) {
					//carry
					actor.move_x(x_move, actor.default_move_action);					
				}
			}
		}
	}
	if (y_move != 0) {
		y_remainder -= y_move;
		y+=y_move;
		
		if (y_move > 0) {
			for (var i = 0; i < ds_list_size(obj_actor_tracker.actor_list); ++i) {
			    var actor = obj_actor_tracker.actor_list[| i];
				
				if (place_meeting(x, y, actor)) {
					//push down
					actor.move_y(bbox_bottom - actor.bbox_top, actor.squish_move_action);
				}
				else if (ds_list_contains(riding_list, actor)) {
					//carry
					actor.move_y(y_move, actor.default_move_action);					
				}
			}
		}
		
		else {
			for (var i = 0; i < ds_list_size(obj_actor_tracker.actor_list); ++i) {
			    var actor = obj_actor_tracker.actor_list[| i];
				
				if (place_meeting(x, y, actor)) {
					//push up
					actor.move_y(bbox_top - actor.bbox_bottom, actor.squish_move_action);
				}
				else if (ds_list_contains(riding_list, actor)) {
					//carry
					actor.move_y(y_move, actor.default_move_action);					
				}
			}
		}
	}
	
	ds_list_destroy(riding_list);
	collidable = true;
}


