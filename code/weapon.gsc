/*
    1.1libraries - a collection of libraries for Call of Duty
    Copyright (C) 2013 DJ Hepburn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

add_info( sName, sFullName, sType, sClass, iClipSize, iStartAmmo, iMaxAmmo ) {
    if ( !isDefined( sName ) || !isDefined( sFullName ) || !isDefined( sType ) || !isDefined( sClass ) )
        return false;
    
    if ( !isDefined( iClipSize ) || !isDefined( iStartAmmo ) )
        return false;
        
    if ( !isDefined( iMaxAmmo ) )
        iMaxAmmo = iStartAmmo;
        
    if ( !isDefined( level.weapons ) )
        level.weapons = [];
        
    if ( exists( sName ) )
        return;
        
    id = level.weapons.size;
        
    info = spawnstruct();
    info.id = id;
    info.name = sName;
    info.longname = sFullName;
    info.clipsize = iClipSize;
    info.startammo = iStartAmmo;
    info.maxammo = iMaxAmmo;
    info.boltaction = false;
    info.grenade = false;
    info.pistol = false;
    info.projectile = false;
    info.semiauto = false;
    
    switch ( sType ) {
        case "grenade":     info.grenade = true; break;
        case "pistol":      info.pistol = true; break;
        case "rocket":      info.projectile = true; break;
        case "rifle":       info.boltaction = true; break;
    }
    
    if ( sType == "riflesemi" || sType == "smgsemi" || sType == "lmgsemi" )
        info.semiauto = true;
    
    info.type = sType;
    info.class = sClass;
    
    level.weapons[ id ] = info;
}

exists( oObject ) {
    if ( !isDefined( oObject ) )
        return false;
        
    if ( type::is_int( oObject ) ) {
        id = type::atoi( oObject );
        for ( i = 0; i < level.weapons.size; i++ ) {
            if ( level.weapons[ i ].id == id )
                return true;
        }
    }
    else {
        name = oObject;
        for ( i = 0; i < level.weapons.size; i++ ) {
            if ( level.weapons[ i ].name == name )
                return true;
        }
    }
    
    return false;
}

get_info( oObject ) {
    if ( !isDefined( oObject ) )
        return false;
        
    if ( type::is_int( oObject ) ) {
        id = type::atoi( oObject );
        for ( i = 0; i < level.weapons.size; i++ ) {
            if ( level.weapons[ i ].id == id )
                return level.weapons[ i ];
        }
    }
    else {
        name = oObject;
        for ( i = 0; i < level.weapons.size; i++ ) {
            if ( level.weapons[ i ].name == name )
                return level.weapons[ i ];
        }
    }
    
    //return undefined;
}

update_info( oObject, sData ) {
    if ( !isDefined( oObject ) || !isDefined( sData ) )
        return false;
        
    if ( !exists( oObject ) )
        return false;
        
    info = get_info( oObject );
    
    data = string::explode( sData, ";" );
    for ( i = 0; i < data.size; i++ ) {
        innerdata = string::explode( data[ i ], "," );
        if ( innerdata.size != 3 )
            continue;
            
        sKey = innerdata[ 0 ];
        sType = innerdata[ 1 ];
        oValue = innerdata[ 2 ];
        
        switch ( string::tolower( sType ) ) {
            case "int":     oValue = type::atoi( oValue );  break;
            case "double":
            case "float":   oValue = type::atof( oValue );  break;
            case "boolean": oValue = type::atob( oValue );  break;
            case "string":                                  break;
            default:                                        return;
        }

        switch ( string::tolower( sKey ) ) {
            case "name":        info.name = oValue;         break;
            case "longname":    info.longname = oValue;     break;
            case "clipsize":    info.clipsize = oValue;     break;
            case "startammo":   info.startammo = oValue;    break;
            case "maxammo":     info.maxammo = oValue;      break;
            case "boltaction":  info.boltaction = oValue;   break;
            case "grenade":     info.grenade = oValue;      break;
            case "pistol":      info.pistol = oValue;       break;
            case "projectile":  info.projectile = oValue;   break;
            case "semiauto":    info.semiauto = oValue;     break;
            case "type":        info.type = oValue;         break;
            case "class":       info.class = oValue;        break;
        }
    }
    
    level.weapons[ info.id ] = info;
}

// These settings reflect the default weapon files.
default_settings() {
    add_info( "bar_mp", "M1918 Browning Automatic Rifle", "lmg", "assault", 20, 200, 300 );
    add_info( "bar_slow_mp", "M198 Browning Automatic Rifle (slow)", "lmg", "assault", 20, 200, 300 );
    add_info( "bren_mp", "Bren", "lmg", "assault", 30, 240, 300 );
    add_info( "colt_mp", "Colt .45", "pistol", "pistol", 7, 35, 56 );
    add_info( "enfield_mp", "Lee-Enfield", "rifle", "rifle", 10, 100, 160 );
    add_info( "fg42_mp", "Fallschirmjaegergewehr 42", "lmg", "assault", 30, 160, 320 );
    add_info( "fg42_semi_mp", "Fallschirmjegergewehr 42 (semi)", "lmgsemi", "assault", 30, 160, 320 );
    add_info( "fraggrenade_mp", "MK2 Fragmentation Grenade", "grenade", "grenade", 3, 3, 3 );
    add_info( "kar98k_mp", "Karabiner 98 Kurz", "rifle", "rifle", 5, 60, 125 );
    add_info( "kar98k_sniper_mp", "Karabiner 98 Kurz w/ Scope", "rifle", "sniper", 5, 60, 150 );
    add_info( "luger_mp", "Luger", "pistol", "pistol", 8, 40, 64 );
    add_info( "m1carbine_mp", "M1A1 Carbine", "riflesemi", "rifle", 15, 300, 400 );
    add_info( "m1garand_mp", "M1 Garand", "riflesemi", "rifle", 8, 192, 240 );
    add_info( "mk1britishfrag_mp", "N23 MKII Mills Bomb", "grenade", "grenade", 3, 3, 3 );
    add_info( "mosin_nagant_mp", "Mosin-Nagant", "rifle", "rifle", 5, 60, 150 );
    add_info( "mosin_nagant_sniper_mp", "Mosin-Nagant w/ Scope", "rifle", "sniper", 5, 60, 150 );
    add_info( "mp40_mp", "Maschinenpistole 40", "smg", "assault", 32, 256, 320 );
    add_info( "mp44_mp", "Sturmgewehr 44", "lmg", "assault", 30, 180, 240 );
    add_info( "mp44_semi_mp", "Sturmgewehr 44 (semi)", "lmgsemi", "assault", 30, 180, 240 );
    add_info( "panzerfaust_mp", "Panzerfaust", "rocket", "rocket", 1, 1, 1 );
    add_info( "ppsh_mp", "PPSh-41", "smg", "assault", 71, 284, 355 );
    add_info( "ppsh_semi_mp", "PPSh-41 (semi)", "smgsemi", "assault", 71, 284, 355 );
    add_info( "rgd-33russianfrag_mp", "RGD-33 Fragmentation Grenade", "grenade", "grenade", 3, 3, 3 );
    add_info( "springfield_mp", "M1903 Springfield", "rifle", "sniper", 5, 100, 200 );
    add_info( "sten_mp", "Sten", "smg", "assault", 32, 224, 320 );
    add_info( "stielhandgranate_mp", "Model 24 Stielhandgranate", "grenade", "grenade", 3, 3, 3 );
    add_info( "thompson_mp", "M1A1 Thompson", "smg", "assault", 30, 270, 360 );
    add_info( "thompson_semi_mp", "M1A1 Thompson", "smgsemi", "assault", 30, 270, 360 );
}

default_loadout() {
    primary = self.pers[ "weapon" ];
    if ( !exists( primary ) )
        return false;
        
    self give( primary, "primary", true );
    info = get_info( primary );
    
    team = self.pers[ "team" ];
    if ( team == "axis" || game[ "allies" ] == "russian" )
        self give( "luger_mp", "pistol" );
    else
        self give( "colt_mp", "pistol" );
    
    grenadecount = 1;
    switch ( info.type ) {
        case "rifle":       
        case "riflesemi":   grenadecount = 3; break;
        case "lmg":
        case "lmgsemi":
        case "smg":
        case "smgsemi":     grenadecount = 2; break;
    }
    
    if ( team == "axis" )
        self give( "stielhandgranate_mp", "grenade" );
    else {
        switch ( game[ "allies" ] ) {
            case "american":    self give( "fraggrenade_mp", "grenade" );       break;
            case "british":     self give( "mk1britishfrag_mp", "grenade" );    break;
            case "russian":     self give( "rgd-33russianfrag_mp", "grenade" ); break;
        }
    }
    self setWeaponSlotAmmo( "grenade", grenadecount );
}

give( oObject, sSlot, bSpawnWeapon ) {
    if ( !isDefined( oObject ) )
        return false;
        
    if ( !exists( oObject ) )
        return false;
        
    weaponinfo = get_info( oObject );
        
    if ( !isDefined( sSlot ) )
        sSlot = "primary";
        
    if ( !isDefined( bSpawnWeapon ) )
        bSpawnWeapon = false;
        
    self setWeaponSlotWeapon( sSlot, oObject );
    self setWeaponSlotAmmo( sSlot, weaponinfo.startammo );
    self setWeaponSlotClipAmmo( sSlot, weaponinfo.clipsize );
    
    if ( bSpawnWeapon )
        self setSpawnWeapon( oObject );
}