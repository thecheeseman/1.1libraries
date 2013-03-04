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

name_fix(s, notplayer) {
  if(!isDefined(s))
    return "";
  
  allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!'#/&()=?+`^~*-.,;<>|$@:[]{}_ ";
  
  badName = false;
    
  for(i = 0; i < s.size; i++) {
    matchFound = false;
    
    for(z = 0; z < allowedChars.size; z++) {
      if(s[i] == allowedChars[z]) {
        matchFound = true;
        break;
      }
    }
    
    if(!matchFound) {
      badName = true;
      break;
    }
  }
  
  if(badName) {
    fixedName = "";
    
    for(i = 0; i < s.size; i++) {
      for(z = 0; z < allowedChars.size; z++) {
        if(s[i] == allowedChars[z]) {
          fixedName += s[i];
          break;
        }
      }
    }
    
    if ( !isDefined( notplayer ) || ( isDefined( notplayer ) && !notplayer ) )
    {
      self iPrintLnBold( "Unallowed characters in name!" );
      self setClientCvar("name", fixedName);
    }
    return fixedName;
  } else {
    return s;
  }
}

delete_entity(entity) {
	entities = getEntArray(entity, "classname");
	for(i = 0; i < entities.size; i++) {
    if(isDefined(entities[i]))
      entities[i] delete();
	}
}

array_remove(arr, str, r) {
  if(!isDefined(r))
    r = false;

  x = 0;
  _tmpa = [];
  for(i = 0; i < arr.size; i++) {    
    if(arr[i] != str) {
      _tmpa[x] = arr[i];
      x++;
    } else {
      if(r) {
        _tmpa[x - 1] = undefined;
        x--;
      }
    }
  }

  _tmp = _tmpa;

  if(r) { // If set to true, it will remove previous elemnts aswell, used in mapvote
    y = 0;
    _tmpb = [];
    for(i = 0; i < _tmpa.size; i++) {    
      if(isDefined(_tmpa[i])) {
        _tmpb[y] = _tmpa[i];
        y++;
      }
    }
    _tmp = _tmpb;
  }
  return _tmp;
}

in_array(arr, needle) {
  for(i = 0; i < arr.size; i++)
    if(arr[i] == needle)
      return true;
  
  return false;
}

array_shuffle(arr) {
  for(i = 0; i < arr.size; i++) {
    // Store the current array element in a variable
    _tmp = arr[i];
    
    // Generate a random number
    rN = randomInt(arr.size);
    
    // Replace the current with the random
    arr[i] = arr[rN];
    // Replace the random with the current
    arr[rN] = _tmp;
  }
  return arr;
}

get_server_setting( cvar, defaultvalue, type, min, max ) {
	temp = "";
    
    // cvar is blank/not set
    if ( getCvar( cvar ) == "" )
        return defaultvalue;
        
	switch ( type ) {
		case "int": temp = getCvarInt( cvar ); break;
		case "float": temp = getCvarFloat( cvar ); break;
		case "string":
		default: temp = getCvar( cvar ); break;
	}
		
	if ( type == "int" || type == "float" ) {
		if ( temp < min )
			temp = min;
		if ( temp > max )
			temp = max;
	}
	
	return temp;
}

is_numeric(n) {
  n = (string)n;
  for(i = 0; i < n.size; i++) {
    switch(n[i]) {
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
      case "0":
      break;
      
      default:
        return false;
    }
  }
  
  return true;
}

// object - function calling (required)
// string - what to put in the actual log (required)
// important - bool
log( object, string, important ) {
	logPrint( object + " - " + string + "\n" );
	if ( isDefined( important ) && important )
		iPrintLnBold( object + " - " + string );
}

get_plant() {
	start = self.origin + (0, 0, 10);

	range = 11;
	forward = anglesToForward(self.angles);
	forward = vector::scale(forward, range);

	traceorigins[0] = start + forward;
	traceorigins[1] = start;

	trace = bulletTrace(traceorigins[0], (traceorigins[0] + (0, 0, -18)), false, undefined);
	if(trace["fraction"] < 1) {
		temp = spawnstruct();
		temp.origin = trace["position"];
		temp.angles = orient_to_normal(trace["normal"]);
		return temp;
	}

	trace = bulletTrace(traceorigins[1], (traceorigins[1] + (0, 0, -18)), false, undefined);
	if(trace["fraction"] < 1) {
		temp = spawnstruct();
		temp.origin = trace["position"];
		temp.angles = orient_to_normal(trace["normal"]);
		return temp;
	}

	traceorigins[2] = start + (16, 16, 0);
	traceorigins[3] = start + (16, -16, 0);
	traceorigins[4] = start + (-16, -16, 0);
	traceorigins[5] = start + (-16, 16, 0);

	for(i = 0; i < traceorigins.size; i++) {
		trace = bulletTrace(traceorigins[i], (traceorigins[i] + (0, 0, -1000)), false, undefined);

		if(!isdefined(besttracefraction) || (trace["fraction"] < besttracefraction)) {
			besttracefraction = trace["fraction"];
			besttraceposition = trace["position"];
		}
	}
	
	if(besttracefraction == 1)
		besttraceposition = self.origin;
	
	temp = spawnstruct();
	temp.origin = besttraceposition;
	temp.angles = orient_to_normal(trace["normal"]);
	return temp;
}

orient_to_normal(normal) {
	hor_normal = (normal[0], normal[1], 0);
	hor_length = length(hor_normal);

	if(!hor_length)
		return (0, 0, 0);
	
	hor_dir = vectornormalize(hor_normal);
	neg_height = normal[2] * -1;
	tangent = (hor_dir[0] * neg_height, hor_dir[1] * neg_height, hor_length);
	plant_angle = vectortoangles(tangent);

	return plant_angle;
}

save_model() {
	info["model"] = self.model;
	info["viewmodel"] = self getViewModel();
	attachSize = self getAttachSize();
	
	for(i = 0; i < attachSize; i++) {
		info["attach"][i]["model"] = self getAttachModelName(i);
		info["attach"][i]["tag"] = self getAttachTagName(i);
	}
	
	return info;
}

load_model(info) {
	self detachAll();
	self setModel(info["model"]);
	self setViewModel(info["viewmodel"]);
	attachInfo = info["attach"];
	attachSize = attachInfo.size;
    
	for(i = 0; i < attachSize; i++)
		self attach(attachInfo[i]["model"], attachInfo[i]["tag"]);
}

play_sound_in_space (alias, origin) {
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	org playsound (alias);
	wait ( 10.0 );
	org delete();
}

get_player_from_id( iID ) {
	eGuy = undefined;
	ePlayers = getEntArray( "player", "classname" );
	for ( i = 0; i < ePlayers.size; i++ ) {
		if ( ePlayers[ i ] getEntityNumber() == iID ) {
			eGuy = ePlayers[ i ];
			break;
		}
	}
			
	return eGuy;
}

get_good_players( bIgnorePlaying ) {
	players = getEntArray( "player", "classname" );
	good = [];
	for ( i = 0; i < players.size; i++ ) {
        if ( players[ i ].sessionstate != "playing" && !isDefined( bIgnorePlaying ) )
            continue;
            
		if ( players[ i ].pers[ "team" ] != "spectator" )
			good[ good.size ] = players[ i ];
	}
	
	return good;
}

get_weapon_type( weapon )
{
    switch ( weapon )
    {
        case "fraggrenade_mp":
        case "stielhandgranate_mp":
        case "mk1britishfrag_mp":
        case "rgd-33russianfrag_mp":
            return "grenade";
        case "colt_mp":
        case "luger_mp":
            return "pistol";
        default:
            return "primary";
    }
}

error( msg )
{
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	println("^c*ERROR* ", msg);
	wait .05;	// waitframe

	if(getcvar("debug") != "1")
	{
		blah = getent("Time to Stop the Script!", "targetname");
			println(THIS_IS_A_FORCED_ERROR___ATTACH_LOG.origin);
	}
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
}

print( sMessage, bLarge )
{
    if ( !isDefined( bLarge ) || ( isDefined( bLarge ) && !bLarge ) ) {
        iPrintLn( name_fix( sMessage, true ) );
        logPrint( "iPrintLn: " + name_fix( sMessage, true ) );
    }
    
    if ( isDefined( bLarge ) && bLarge ) {
        iPrintLnBold( name_fix( sMessage, true ) );
        logPrint( "iPrintLnBold: " + name_fix( sMessage, true ) );
    }
}

set_team( sTeam )
{
    sRealTeam = "";
    
    switch ( sTeam )
    {
        case "hunters":     sRealTeam = "axis"; break;
        case "zombies":     sRealTeam = "allies"; break;
        case "spectator":
        case "intermission":
            sRealTeam = sTeam;
            break;
    }
    
    // this should never happen
    if ( sRealTeam == "" )
        return;
        
    if ( isAlive( self ) )
        self suicide();
        
    self.pers[ "team" ] = sRealTeam;
    
    if ( sRealTeam == "spectator" || sRealTeam == "intermission" )
    {
        self.pers[ "weapon" ] = undefined;
        self.pers[ "savedmodel" ] = undefined;
    }
}

remove_game_objects()
{
    allowed[ 0 ] = "tdm";
    
	entitytypes = getentarray();
	for(i = 0; i < entitytypes.size; i++)
	{
		if(isdefined(entitytypes[i].script_gameobjectname))
		{
			dodelete = true;
			
			for(j = 0; j < allowed.size; j++)
			{
				if(entitytypes[i].script_gameobjectname == allowed[j])
				{	
					dodelete = false;
					break;
				}
			}
			
			if(dodelete)
			{
				//println("DELETED: ", entitytypes[i].classname);
				entitytypes[i] delete();
			}
		}
	}
}

_spawn( sClassName, vOrigin )
{
    iID = level.aSpawnedObjects.size;
    
    oStruct = spawnstruct();
    oStruct.sClassName = sClassName;
    oStruct.vOrigin = vOrigin;
    oStruct.iID = iID;
    
    oObject = spawn( sClassName, vOrigin );
    oObject.iID = iID;
    
    level.aSpawnedObjects[ iID ] = oStruct;
    
    //iPrintLn( "added " + iID + " to spawnedobjects" );
    
    return oObject;
}

_delete()
{
    if ( isDefined( self.iID ) && isDefined( level.aSpawnedObjects[ self.iID ] ) )
        level.aSpawnedObjects = array_remove( level.aSpawnedObjects, level.aSpawnedObjects[ self.iID ] );
        
    //iPrintLn( "removed " + self.iID + " from spawnedobjects" );
        
    self delete();
}

convert_time( iTime )
{
    iSeconds = iTime % 60;
    iMinutes = ( iTime - iSeconds ) / 60;
    iMinutes2 = iMinutes % 60;
    iHours = ( iMinutes - iMinutes2 ) / 60;
    iHours2 = iHours % 24;
    iDays = ( iHours - iHours2 ) / 24;
    
    return iDays + ":" + iHours2 + ":" + iMinutes2 + ":" + iSeconds;
}

set_all_client_cvars( cvar, value )
{
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
		players[ i ] setClientCvar( cvar, value );
}

slowmo( length )
{
	if ( length <= 1 )
		return;
	newlength = length - 1;
	
	for ( i = 1.0; i > 0.5; i -= 0.05 )
	{
		setCvar( "timescale", i );
		set_all_client_cvars( "timescale", i );
		wait 0.05;
	}
	
	setCvar( "timescale", 0.5 );
	set_all_client_cvars( "timescale", 0.5 );
	
	wait ( newlength );
	
	for ( i = 0.5; i < 1.0; i += 0.05 )
	{
		setCvar( "timescale", i );
		set_all_client_cvars( "timescale", i );
		wait 0.05;
	}
	
	setCvar( "timescale", 1.0 );
	set_all_client_cvars( "timescale", 1.0 );
}

get_stance( returnValue )
{
    if ( !self isOnGround() && !isDefined( returnValue ) )
        return "in air";
 
    org = spawn( "script_model", self.origin );
    org linkto( self, "tag_helmet", ( 0, 0, 0 ), ( 0, 0, 0 ) );
    wait 0.03;  // this is required, or else the model will not move to tag_helmet by the time it's removed
 
    z = org.origin[ 2 ] - self.origin[ 2 ];
 
    org delete();
    
    if ( isDefined( returnValue ) && returnValue )
        return z;
 
    if ( z < 20 )   return "prone";
    if ( z < 50 )   return "crouch";
    if ( z < 70 )   return "stand";
}

scripted_radius_damage( origin, range, maxdamage, mindamage, attacker, ignore )
{
	players = get_good_players();
	inrange = [];
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( distance( origin, players[ i ].origin ) < range )
		{
			if ( isDefined( ignore ) && players[ i ] == ignore )
				continue;
				
			if ( players[ i ].sessionstate != "playing" )
				continue;
				
			inrange[ inrange.size ] = players[ i ];
		}
	}

	for ( i = 0; i < inrange.size; i++ )
	{
		damage = 0;
		
		dist = distance( origin, inrange[ i ].origin );
		
		dmult = ( range - dist ) / range;
		if ( dmult >= 1 ) dmult = 0.99;
		if ( dmult <= 0 ) dmult = 0.01;
			
		damage = maxdamage * dmult;

		trace = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 16 ), false, undefined );
		trace2 = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 40 ), false, undefined );
		trace3 = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 60 ), false, undefined );
		if ( trace[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace3[ "fraction" ] != 1 )
			continue;
			
		hitloc = "torso_upper";
		if ( trace3[ "fraction" ] != 1 && trace2[ "fraction" ] == 1 )
			hitloc = "torso_lower";
		if ( trace3[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace[ "fraction" ] == 1 )
		{
			s = "left";
			if ( math::rand( 100 ) > 50 )
				s = "right";
				
			hitloc = s + "_leg_upper";
		}
			
		inrange[ i ] [[ level.call ]]( "player_damage", attacker, attacker, damage, 0, "MOD_GRENADE_SPLASH", "defaultweapon_mp", origin, vectornormalize( inrange[ i ].origin - origin ), hitloc );
	}
}

// from singleplayer :p
waittill_any( string1, string2, string3, string4, string5 )
{
    level endon( "intermission" );
    
	ent = spawnstruct();

	if ( isdefined( string1 ) )    self thread waittill_string( string1, ent );
	if ( isdefined( string2 ) )    self thread waittill_string( string2, ent );
	if ( isdefined( string3 ) )    self thread waittill_string( string3, ent );
	if ( isdefined( string4 ) )    self thread waittill_string( string4, ent );
	if ( isdefined( string5 ) )    self thread waittill_string( string5, ent );

	ent waittill( "returned" );
	ent notify( "die" );
}


waittill_string (msg, ent)
{
	level endon( "intermission" );
	ent endon( "die" );
	self waittill( msg );
	ent notify( "returned" );
}

int_to_hex( i )
{
    if ( i < 10 ) return (string)i;
    if ( i == 10 ) return "A";
    if ( i == 11 ) return "B";
    if ( i == 12 ) return "C";
    if ( i == 13 ) return "D";
    if ( i == 14 ) return "E";
    if ( i == 15 ) return "F";
}

char_to_dec( c )
{
    if ( c == "A" ) return 10;
    if ( c == "B" ) return 11;
    if ( c == "C" ) return 12;
    if ( c == "D" ) return 13;
    if ( c == "E" ) return 14;
    if ( c == "F" ) return 15;
    if ( (int)c < 10 ) return (int)c;
}

atohex( i )
{
    hex = "" + int_to_hex( i % 16 );
    temp = (int)( i / 16 );
    
    while ( temp > 0 )
    {
        hex += "" + int_to_hex( temp % 16 );
        temp = (int)( temp / 16 );
    }
              
    return string::reverse( hex );
}

hextoa( hex )
{
    tmp = string::reverse( hex );
    realnum = 0;
    for ( i = 0; i < tmp.size; i++ )
    {
        n = char_to_dec( tmp[ i ] );
        realnum += ( n * math::pow( 16, i ) );
    }
    
    return realnum;
}

strreplacer( sString, sType ) {
    switch ( sType ) {
        case "lower":
            out = "abcdefghijklmnopqrstuvwxyz";
            in = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            bIgnoreExtraChars = false;
            break;
        case "upper":
            in = "abcdefghijklmnopqrstuvwxyz";
            out = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            bIgnoreExtraChars = false;
            break;
        case "numeric":
            in = "0123456789.-";
            out = "0123456789.-";
            bIgnoreExtraChars = true;
            break;
        case "vector":
            in = "0123456789.-,()";
            out = "0123456789.-,()";
            bIgnoreExtraChars = true;
            break;
        default:
            return sString;
            break;
    }
        
    sOut = "";
    for ( i = 0; i < sString.size; i++ ) {
        bFound = false;
        cChar = sString[ i ];
        for ( j = 0; j < in.size; j++ ) {
            if ( in[ j ] == cChar ) {
                sOut += out[ j ];
                bFound = true;
                break;
            }
        }
        
        if ( !bFound && !bIgnoreExtraChars )
            sOut += cChar;
    }
    
    return sOut;
}

wait_until_frame_end() {
    wait ( level.fFrameTime );
}