/*
	This is the virtual controller. It's an object that gets input for us. Any object that
	needs player input, like the player character or a menu, should add a member variable
	called "controller" or similar to reference this object and then grab input from here.
	
	The macros at the top are the default controls. If there ends up being control
	customization, the game would load these controls by default.
	
	After that, it sets the tracked values for up, down, left, right, "start," and three
	arbitrary inputs, "a," "b," and "c," which we use as general "action buttons."
	
	THESE DO NOT LITERALLY CORRESPOND TO THE A, B, AND C BUTTONS ON THE KEYBOARD!!
	
	Also, for our convenience, we track the normalized input directions as well as the last
	direction input by the player (as "facing").
*/
if (debug_mode) {
	show_debug_overlay(true);	
}


//designate default controls
#macro UP_DEFAULT				ord("W");
#macro DOWN_DEFAULT				ord("S");
#macro LEFT_DEFAULT				ord("A");
#macro RIGHT_DEFAULT			ord("D");
#macro START_DEFAULT			vk_space;
#macro A_DEFAULT				ord("J");
#macro B_DEFAULT				ord("K");
#macro C_DEFAULT				ord("L");

//set current scheme to default
up =							UP_DEFAULT;
down =							DOWN_DEFAULT;
left =							LEFT_DEFAULT;
right =							RIGHT_DEFAULT;
start =							START_DEFAULT;
a =								A_DEFAULT;
b =								B_DEFAULT;
c =								C_DEFAULT;

//track input direction and last direction input
input_rax_x = 0;
input_raw_y = 0;

input_normal_x = 0;
input_normal_y = 0;

facing_x = 0;
facing_y = 0;