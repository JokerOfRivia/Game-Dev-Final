function instance_create_hurtbox(local_x, local_y, width, height, time, parent, target, damage, knockback_x, knockback_y){
	var hurtbox = instance_create_layer(0, 0, layer, obj_hurtbox);
	hurtbox.init(local_x, local_y, width, height, time, parent, target, damage, knockback_x, knockback_y);
}
function instance_create_explosion(x, y, radius, time, target, damage, knockback){
	var explosion = instance_create_layer(0, 0, layer, obj_explosion);
	explosion.init(x, y, radius, time, parent, target, damage, knockback);
}
