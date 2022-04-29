/*
	Setting Up StateMachines

		StateMachines are concise, robust state machine managers. Use them for any object that
		needs to shift between multiple states! (Heads-up, this is basically everything!)
	
		The first argument in StateMachine is "states," which should be provided as an array
		of all of the functions that you want the state machine to run as states.
		Each state has an index, determined by the order in which they are put into the array.
	
		The second argument provides the state machine with a scope from which it should
		run the various states. This is almost always just going to be "id," so don't
		think about it too hard.
	
		Here's an example:
	
		new Statemachine([my_first_state, my_second_state], id)
	
		In this StateMachine, the index of my_first_state is 0 and the index of
		my_second_state is 1.
	
	
	Other Useful Things Tracked by StateMachines
		
		StateMachines have two other helpful variables attached to them: 'substate'
		and 'state_timer.' 
		
		state_timer goes up by 1 each time the state is run. state_timer resets to 0
		each time the state is changed.
		
		substate doesn't do anything on its own. If you want, you can set substate
		when you change a state. It's basically a free space. If you want to track
		some important detail about a state, you might use substate. 
		
		For instance, during "state_jump," you might have the player accelerate upward
		until they release the jump button. Then, you could also flip substate to a
		different number, say 2, and run different blocks of code accordingly. It's
		up to you!
	
	
	Using StateMachines

		StateMachines DO NOT automatically run their current state on every frame. To
		tell a StateMachine to run the current state, use execute(), as in:
		
		my_state_machine.execute()
		
		What about changing states? To change state, use state_change(). 
		state_change() takes two arguments: state and substate. "state" refers to
		the index of the function representing that state-- it should be an integer. 
		
		Substate is set to 0 by default, so if you don't care about setting a particular
		substate, you can just call state_machine with only one argument.
	
		Example:
			my_state_machine.state_change(0) (changes state to 0)
			my_state_machine.state_change(1, 2) (changes state to 1 and substate to 2)
*/

function StateMachine(states, object) constructor {
	self.states = states;
	self.state = 0;
	//use substate as an arbitrary conditional setting for ifs/switches in a state function
	self.substate = 0;
	self.state_timer = 0;
	//this makes it possible to create a state machine with one object but attach it to a different one
	self.object = object;
	
	static state_change = function(state, substate = 0) {
		self.state = state;
		self.substate = substate;
		self.state_timer = 0;
	}
	
	static execute = function() {
		var state_function = self.states[self.state];
		//this makes sure that the state function is bound to the attached object and not the state machine itself
		method(self.object, state_function)();
		self.state_timer++;
	}
}