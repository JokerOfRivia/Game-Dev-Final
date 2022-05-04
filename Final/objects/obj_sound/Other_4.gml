switch (room) {
	case rm_pre:
		set_music(ost_smalldarkroom);
	break;
	case rm_menu:
		stop_music();
		set_music(ost_smalldarkroom);
	break;
	case rm_1:
		stop_music();
		set_music(ost_antarctic);
	break;
}


