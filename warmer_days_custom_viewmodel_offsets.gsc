#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_load;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_weap_blundersplat;
#include maps\mp\zombies\_zm_magicbox_prison;
#include maps\mp\zm_prison_ffotd;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\ombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_sq;
#include maps\mp\zm_transit_distance_tracking;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zm_prison;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\_createfx;
#include maps\mp\_music;
#include maps\mp\_script_gen;
#include maps\mp\_busing;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_tweakables;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\_demo;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\zm_run;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_blockers;
#include maps\p\animscripts\zm_shared;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_server_throttle;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zm_transit;
#include maps\mp\createart\zm_transit_art;
#include maps\mp\createfx\zm_transit_fx;
#include maps\mp\zombies\_zm_ai_dogs;
#include codescripts\character;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zm_transit_buildables;
#include maps\mp\zombies\_zm_magicbox_lock;
#include maps\mp\zombies\_zm_ffotd;
#include maps\mp\zm_transit_lava;





init()
{
    level thread for_joining_players();
}

for_joining_players()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", player );
        //player thread lerp_from_offset_to_offset();
        player thread on_spawn();
    }
}

on_spawn()
{
    self waittill( "spawned_player" );
    self thread do_weapon_change_offsets();
} 


do_weapon_change_offsets()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    wait 1;
    if( level.dev_time ){ iprintlnbold( "DOING OFFSETTER THREAD" ); }
    //initial spawn m1911 offset
    self thread while_ads( 0.8, 1.6, -1.8 );
    wait 2;
    while( true )
    {
        self waittill( "weapon_change", weapon );
        xw = get_weapon_offsetter_x( weapon );
        xy = get_weapon_offsetter_y( weapon );
        xz = get_weapon_offsetter_z( weapon );
        self thread while_ads( xw, xy, xz );
        self setClientDvar( "cg_gun_x", xw );
        self setclientdvar( "cg_gun_y", xy );
        self setclientdvar( "cg_gun_z", xz );
    }
}

while_ads( x, y, z )
{
    self endon( "end_ads_thread" );
    self endon( "disconnect" );
    self endon( "weapon_change" );
    level endon( "end_game" );
    self.is_adsing = false;
    while( true )
    {
        if( self adsButtonPressed() )
        {
            self.is_adsing = true;
            self setclientdvar( "cg_gun_x", 0 );
            self setclientdvar( "cg_gun_y", 0 );
            self setclientdvar( "cg_gun_z", 0 );
            while( self adsButtonPressed() )
            {
                wait 0.05;
            }
            self.is_adsing = false;
        }
        else if( !self adsbuttonpressed() && !self.is_adsing )
        {
            if( getDvar( "cg_gun_x" ) != x ) { self setclientdvar( "cg_gun_x", x );}// if( level.dev_time ){ iprintln( "SETTING NEW OFFSET FOR WEAPON" ); }  }
            if( getDvar( "cg_gun_y" ) != y ) { self setclientdvar( "cg_gun_y", y );}// if( level.dev_time ){ iprintln( "SETTING NEW OFFSET FOR WEAPON" ); } }
            if( getDvar( "cg_gun_z" ) != z ) { self setclientdvar( "cg_gun_z", z );} //if( level.dev_time ){ iprintln( "SETTING NEW OFFSET FOR WEAPON" ); } }
        }
        wait 0.05;
    }
}
lerp_weapon_offsets( x_target, y_target, z_target )
{
    self endon( "weapon_change" );
    self endon( "disconnect" );
    self endon( "death" );

    x_goal = false;
    y_goal = false;
    z_goal = false;
    self.lerper = true;
    x_dvar_current = getDvar( "cg_gun_x" );
    y_dvar_current = getdvar( "cg_gun_y" );
    z_dvar_current = getdvar( "cg_gun_z" );

    iprintln( "OFFSETS CURRENT : : : " + x_dvar_current + "  " + y_dvar_current + "  " + z_dvar_current );
    iprintln( "OFFSETS TARGET : : : " + x_target + "  " + y_target + "  " + z_target );

    first_up = false;
    second_up = false;
    third_up = false;
    while( true )
    {

    }
    if( !first_up )
    {
        if( x_dvar_current > x_target )
        {
            first_up = false;
        }
        else { first_up = true; }
    }

    if( !second_up )
    {
        if( y_dvar_current > y_target )
        {
            second_up = false;
        }
        else { second_up = true; }
    }

    if( !third_up )
    {
        if( z_dvar_current > z_target )
        {
            third_up = false;
        }
        else { third_up = true; }
    }
    while( self.lerper )
    {
        //if dvars are currently higher than the target value
        if( !first_up && !x_goal )
        {
            get_current = getdvar( "cg_gun_x" );
            get_current -= 0.1;
            self setclientdvar( "cg_gun_x", get_current );
            if( get_current == x_target )
            {
                x_goal = true;
            }
        }

        if( first_up && !x_goal )
        {
            get_current = getdvar( "cg_gun_x" );
            get_current += 0.1;
            self setclientdvar( "cg_gun_x", get_current );
            if( get_current == x_target )
            {
                x_goal = true;
            }
        }

        //if dvars are currently higher than the target value
        if( !second_up && !y_goal )
        {
            get_current = getdvar( "cg_gun_y" );
            get_current -= 0.1;
            self setclientdvar( "cg_gun_y", get_current );
            if( get_current == y_target )
            {
                y_goal = true;
            }
        }

        if( second_up && !y_goal )
        {
            get_current = getdvar( "cg_gun_y" );
            get_current += 0.1;
            self setclientdvar( "cg_gun_y", get_current );
            if( get_current == y_target )
            {
                y_goal = true;
            }
        }

        //if dvars are currently higher than the target value
        if( !third_up && !z_goal )
        {
            get_current = getdvar( "cg_gun_z" );
            get_current -= 0.1;
            self setclientdvar( "cg_gun_z", get_current );
            if( get_current == z_target )
            {
                z_goal = true;
            }
        }

        if( third_up && !z_goal )
        {
            get_current = getdvar( "cg_gun_z" );
            get_current += 0.1;
            self setclientdvar( "cg_gun_z", get_current );
            if( get_current == z_target )
            {
                z_goal = true;
            }
        }

        if( first_up && second_up && third_up && self.lerper )
        {
            wait 1;
            iprintlnbold( "WEAPON LERPING COMPLETE" );
            wait 0.05;
            self.lerper = false;
            break;
        }


        wait 0.05;
    }
}


get_weapon_offsetter_x( weapon_type )
{
    switch( weapon_type )
    {
        case "m1911_zm":
            return 0.8;

        case "mp5k_zm":
            return -0.3;
        
        case "m14_zm":
            return -2.3;
    
        default:
            return 0;
    }
}
get_weapon_offsetter_y( weapon_type )
{
    switch( weapon_type )
    {
        case "m1911_zm":
            return  1.6;
        case "mp5k_zm":
            return 2.4;
        
        case "m14_zm":
            return 3;
        
        default:
            return 0;
    }
}
get_weapon_offsetter_z( weapon_type )
{
    switch( weapon_type )
    {
        case "m1911_zm":
            return -1.8;
        case "mp5k_zm":
            return -1.3;
        case "m14_zm":
            return 0.3 ;
        default:
            return 0;
    }
}

