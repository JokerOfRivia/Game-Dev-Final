camera = view_camera[0];
player = obj_player;

smooth = 0.2;

width = camera_get_view_width(camera);
height = camera_get_view_height(camera);

anchor_x = 0;
anchor_y = 0;

function set_anchor(x, y){
	anchor_x = x;
	anchor_y = y;
}

#region //states
	function state_follow(){
		var player_x = player.x;
		var player_y = player.y;
		
		var x_off = width/2;
		var y_off = height/2;
		
		var new_x = lerp(camera_get_view_x(camera), player_x - x_off, smooth);
		var new_y = lerp(camera_get_view_y(camera), player_y - y_off, smooth);
		
		camera_set_view_pos(camera, new_x, new_y);
	}
	function state_anchor(){
		var x_off = width/2;
		var y_off = height/2;
		
		var new_x = lerp(camera_get_view_x(camera), anchor_x - x_off, smooth);
		var new_y = lerp(camera_get_view_y(camera), anchor_y - y_off, smooth);
		
		camera_set_view_pos(camera, new_x, new_y);
	}
#endregion 

state_machine = new StateMachine([state_follow, state_anchor], id);
state_machine.state_change(0);
