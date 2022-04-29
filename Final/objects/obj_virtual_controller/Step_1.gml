//here is our big list of input checks!
//for our convenience, we check all possible inputs, every frame. that way,
//you dont have to worry about what objects are tracking which inputs.

#region checks
//any input
input_up =					keyboard_check(up);
input_down = 				keyboard_check(down);
input_left = 				keyboard_check(left);
input_right = 				keyboard_check(right);
input_start = 				keyboard_check(start);
input_a =					keyboard_check(a);
input_b =					keyboard_check(b);
input_c =					keyboard_check(c);

//if pressed
input_up_pressed = 			keyboard_check_pressed(up);
input_down_pressed = 		keyboard_check_pressed(down);
input_left_pressed = 		keyboard_check_pressed(left);
input_right_pressed = 		keyboard_check_pressed(right);
input_start_pressed = 		keyboard_check_pressed(start);
input_a_pressed =			keyboard_check_pressed(a);
input_b_pressed =			keyboard_check_pressed(b);
input_c_pressed =			keyboard_check_pressed(c);

//if released
input_up_released = 		keyboard_check_released(up);
input_down_released = 		keyboard_check_released(down);
input_left_released = 		keyboard_check_released(left);
input_right_released = 		keyboard_check_released(right);
input_start_released =		keyboard_check_released(start);
input_a_released =			keyboard_check_released(a);
input_b_released =			keyboard_check_released(b);
input_c_released =			keyboard_check_released(c);

#endregion

//get the normalized versions of the directional inputs
var x_axis = input_right - input_left;
var y_axis = input_down - input_up;
var magnitude = sqrt((x_axis*x_axis)+(y_axis*y_axis));

input_normal_x = x_axis/magnitude;
input_normal_y = y_axis/magnitude;

//keep the last direction inputted
if (input_up_pressed) {facing_x = 0; facing_y = -1;}
if (input_down_pressed) {facing_x = 0; facing_y = 1;}
if (input_left_pressed) {facing_x = -1; facing_y = 0;}
if (input_right_pressed) {facing_x = 1; facing_y = 0;}