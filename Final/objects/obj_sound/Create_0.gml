music_priority = 10;
sfx_priority = 0;

ost_current = -1;

function stop_music(){
	audio_stop_sound(ost_current);
	ost_current = -1;
}

function set_music(ost_id){
	stop_music();
	audio_play_sound(ost_id, music_priority, true);
	ost_current = ost_id;
}

function play_sfx(sfx_id){
	audio_play_sound(sfx_id, sfx_priority, false);
	
	sfx_priority = wrap(sfx_priority+1, 0, music_priority-1);
}
