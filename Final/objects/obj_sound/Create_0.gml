music_priority = 100;
sfx_priority = 0;

music_volume = 1;
sfx_volume = 1;


audio_group_load(ag_sfx);
audio_group_load(ag_ost);

ost_current = ost_demo2;

function set_music_volume(value){
	music_volume = clamp(value, 0, 1);
	audio_group_set_gain(ag_ost, music_volume, 0);
}
function set_sfx_volume(value){
	sfx_volume = clamp(value, 0, 1);
	audio_group_set_gain(ag_sfx, sfx_volume, 0);
}

function stop_music(){
	ost_current = -1;
}

function set_music(ost_id){
	audio_stop_sound(ost_current);
	audio_play_sound(ost_id, music_priority, true);
	ost_current = ost_id;
}

function play_sfx(sfx_id){
	audio_play_sound(sfx_id, sfx_priority, false);
	
	sfx_priority = wrap(sfx_priority+1, 0, music_priority-1);
}
