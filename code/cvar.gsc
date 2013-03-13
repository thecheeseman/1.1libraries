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

get( sName, bSetIfBlank, oDefaultValue ) {
    if ( !isDefined( sName ) )
        return false;
        
    if ( !isDefined( bSetIfBlank ) ) {
        bSetIfBlank = false;
        oDefaultValue = undefined;
    }
    
    // first let's check if the cvar is blank
    temp = getCvar( sName );
    if ( temp == "" ) {
        // if it is, most likely it's not been defined already
        // so shall we set it?
        if ( bSetIfBlank ) {
            set( sName, oDefaultValue );
            return oDefaultValue;
        }
        
        // nope
        return "";
    }
    
    // if this cvar has a value, let's try and grab it
    // this eliminates the need to call getCvarFloat/getCvarInt
    // as we can actually return types with one function
    return attempt_typecast( temp );
}

get_global( sName, bSetIfBlank, oDefaultValue ) {
    if ( !isDefined( sName ) )
        return false;
        
    if ( !isDefined( bSetIfBlank ) ) {
        bSetIfBlank = false;
        oDefaultValue = undefined;
    }
    
    if ( !isDefined( level.cvars ) )
        level.cvars = [];
        
    if ( !isDefined( level.cvars[ sName ] ) ) {
        var = get( sName, bSetIfBlank, oDefaultValue );
        level.cvars[ sName ] = var;
        return var;
    }
    
    return level.cvars[ sName ];
}    

set( sName, oValue, bCastType, sType ) {
    if ( !isDefined( sName ) || !isDefined( oValue ) )
        return false;
        
    if ( !isDefined( bCastType ) )
        bCastType = false;
    
    if ( !isDefined( sType ) )
        sType = "string";
        
    if ( bCastType )
        oValue = attempt_typecast( oValue, sType );
        
    setCvar( sName, oValue );
    return oValue;
}

set_global( sName, oValue, bCastType, sType ) {
    val = set( sName, oValue, bCastType, sType );
    
    if ( !isDefined( level.cvars ) )
        level.cvars = [];
        
    level.cvars[ sName ] = val;
}

set_client( sName, oValue, bCastType, sType ) {
    if ( !isDefined( sName ) || !isDefined( oValue ) )
        return false;
        
    if ( !isDefined( bCastType ) )
        bCastType = false;
    
    if ( !isDefined( sType ) )
        sType = "string";
        
    if ( bCastType )
        oValue = attempt_typecast( oValue, sType );
        
    self setClientCvar( sName, oValue );
}

set_all_client( sName, oValue, bCastType, sType ) {
    players = entity::get_array( "player", "classname" );
    for ( i = 0; i < players.size; i++ )
        players[ i ] set_client( sName, oValue, bCastType, sType );
}

attempt_typecast( temp, type ) {
    if ( !isDefined( temp ) )
        return false;
        
    if ( !isDefined( type ) )
        type = type::check( temp );
        
    switch ( type ) {
        case "int":     return type::atoi( temp );
        case "double":
        case "float":   return type::atof( temp );
        default:        return temp;
    }
}