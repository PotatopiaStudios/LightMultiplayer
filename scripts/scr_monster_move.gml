#define scr_monster_move
///scr_monster_move(sprint, dir);
var r = argument1;
var b = argument0;
var secconds_passed = delta_time/1000000;
if(!keyboard_check(global.sprint)){
    b = 1;
}
var mspd = spd*secconds_passed*1;

xaxis = (keyboard_check(global.right) - keyboard_check(global.left));
yaxis = (keyboard_check(global.down) - keyboard_check(global.up));

var moving = (xaxis!=0||yaxis!=0);
var rot = point_direction(0, 0, xaxis, yaxis);
if(moving){
    image_speed = 7;
    var dir = point_direction(0, 0, xaxis, yaxis);
    var xtarg = x+lengthdir_x(mspd, rot);
    var ytarg = y+lengthdir_y(mspd, rot);
    if(!place_meeting(xtarg, y, obj_solid)){
        x = xtarg;
    }
    if(!place_meeting(x, ytarg, obj_solid)){
        y = ytarg;
    }
    return sin(degtorad(rot - r))*tecstat.mrspd*gamemode.delta;
}else{
    image_speed = 0;
}
return 0;




#define scr_monster_item
///scr_monster_item();
///scr_player_item();
if(drop_timer > 0){
 drop_timer -= gamemode.delta;
}
if(instance_exists(obj_monster_item)){
                if(place_meeting(x, y, obj_monster_item)){
                            var inst = instance_place(x, y, obj_item);
                            var item = inst.item_id;
                            if(mtotal_items*ITEM_WEIGHT < ITEM_LIMIT && drop_timer <= 0){
                                minv[item-1]++;
                                mtotal_items++;
                                instance_destroy(inst);
                                with(client){
                                    buffer_seek(send_buffer, buffer_seek_start, 0);
                                    buffer_write(send_buffer, buffer_u8, M_ITEM_OBTAINED);
                                    buffer_write(send_buffer, buffer_u16, inst.itemID);
                                    network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
                                }
                            }  

                    
                    
                        
                }
                }
                
if(keyboard_check_released(global.drop)){
    if(minv[selected] > 0){
        minv[selected]--;
        mtotal_items--;
        drop_timer = 1;
        var item = instance_create(x, y, obj_monster_item);
        item.image_angle = dir-90;
        item.item_id = selected+1;
        item.image_index = selected+1;
        with(client){
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, M_MONSTER_ITEM_DROPPED);
            buffer_write(send_buffer, buffer_u8, item.item_id);
            buffer_write(send_buffer, buffer_u16, round(item.x));
            buffer_write(send_buffer, buffer_u16, round(item.y));
            buffer_write(send_buffer, buffer_u16, round(item.image_angle));
            network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
        }
    }
}

#define scr_monster_melee
///scr_monster_melee();
if(mouse_check_button_pressed(mb_left)){
    if(attack_timer <= 0){
        draw_sprite(spr_attack, 0,  x + lengthdir_x(8, dir), y + lengthdir_y(8, dir));
        var inst = collision_circle(x + lengthdir_x(8, dir), y + lengthdir_y(8, dir), 4, obj_other_client, true, true);
        if(inst != noone){
            with(client){
                buffer_seek(send_buffer, buffer_seek_start, 0);
                buffer_write(send_buffer, buffer_u8, M_MELEE);
                buffer_write(send_buffer, buffer_u8, damage);
                buffer_write(send_buffer, buffer_u8, inst.clientID);
                network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
            }
            attack_timer = basestat.attack_speed;
        }
    }
}
if(attack_timer > 0){
    attack_timer-= gamemode.delta;
}
