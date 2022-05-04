camera = view_camera[0];
player = obj_player;

smooth = 0.3;

deadzone = 24;
deadzone_smooth = 0.1;

width = camera_get_view_width(camera);
height = camera_get_view_height(camera);

anchor_x = 0;
anchor_y = 0;

shake = -1;

function screenshake(duration, intensity) constructor{
	self.duration = duration;
	self.intensity = intensity;
	
	function get_displacement(){
		var displace_x = 0;
		var displace_y = 0;
		
		if (duration==0) {
			return [0, 0];
		}
		else {
			displace_x = choose(intensity, -intensity);
			displace_y = choose(intensity, -intensity);
		}
		duration--;
		return [displace_x, displace_y];
	}
}

function do_screenshake(duration, intensity){
	shake = new screenshake(duration, intensity);
}

function set_anchor(x, y){
	anchor_x = x;
	anchor_y = y;
}

#region //states
	function state_follow(){
		var player_x = player.x;
		var player_y = player.y;
		
		var off_x = width/2;
		var off_y = height/2;
		
		//do screenshake
		if (shake!=-1){
			var displacement = shake.get_displacement();
			if (displacement[0] == 0) {
				delete shake;
				shake = -1;
			}
			else {
				off_x+=displacement[0];
				off_y+=displacement[1];
			}
		}
		
		var diff_x = abs(camera_get_view_x(camera) - (player_x - off_x));
		var diff_y = abs(camera_get_view_y(camera) - (player_y - off_y));
		
		var settle = (diff_x > deadzone or diff_y > deadzone)? deadzone_smooth: 1;
		var new_x = lerp(camera_get_view_x(camera), player_x - off_x, smooth * settle);
		var new_y = lerp(camera_get_view_y(camera), player_y - off_y, smooth * settle);
		
		camera_set_view_pos(camera, new_x, new_y);
		
	}
	function state_anchor(){
		var off_x = width/2;
		var off_y = height/2;
		
		//do screenshake
		if (shake!=-1){
			var displacement = shake.get_displacement();
			if (displacement[0] == 0) {
				delete shake;
				shake = -1;
			}
			else {
				off_x+=displacement[0];
				off_y+=displacement[1];
			}
		}
		
		var new_x = lerp(camera_get_view_x(camera), anchor_x - off_x, smooth);
		var new_y = lerp(camera_get_view_y(camera), anchor_y - off_y, smooth);
		
		camera_set_view_pos(camera, new_x, new_y);
	}
#endregion 

state_machine = new StateMachine([state_follow, state_anchor], id);
state_machine.state_change(0);
