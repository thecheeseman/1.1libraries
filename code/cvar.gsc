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
    sValue = getCvar( sName );
    if ( sValue == "" ) {
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
    return attempt_typecast( sValue );
}

get_global( sName, bSetIfBlank, oDefaultValue ) {
    if ( !isDefined( sName ) )
        return false;
        
    if ( !isDefined( bSetIfBlank ) ) {
        bSetIfBlank = false;
        oDefaultValue = undefined;
    }
    
    if ( !isDefined( level.aCvars ) )
        level.aCvars = [];
        
    if ( !isDefined( level.aCvars[ sName ] ) ) {
        oCvar = get( sName, bSetIfBlank, oDefaultValue );
        level.aCvars[ sName ] = oCvar;
        return oCvar;
    }
    
    return level.aCvars[ sName ];
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
    oCvar = set( sName, oValue, bCastType, sType );
    
    if ( !isDefined( level.aCvars ) )
        level.aCvars = [];
        
    level.aCvars[ sName ] = oCvar;
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
    aPlayers = entity::get_array( "player", "classname" );
    for ( i = 0; i < aPlayers.size; i++ )
        aPlayers[ i ] set_client( sName, oValue, bCastType, sType );
}

attempt_typecast( oValue, sType ) {
    if ( !isDefined( oValue ) )
        return false;
        
    if ( !isDefined( sType ) )
        sType = type::check( oValue );
        
    switch ( sType ) {
        case "int":     return type::atoi( oValue );
        case "double":
        case "float":   return type::atof( oValue );
        default:        return oValue;
    }
}