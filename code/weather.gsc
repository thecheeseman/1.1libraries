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

rain( intensity ) {
}

snow( intensity ) {
}

default_fog() {
    switch ( string::tolower( cvar::get_global( "mapname" ) ) ) {
        case "mp_brecourt":         setCullFog( 0, 13500, .32, .36, .40, 0 );   break;
        case "mp_carentan":         setCullFog( 0, 16500, 0.7, 0.85, 1.0, 0 );  break;
        case "mp_chateau":          setExpFog( 0.00001, 0, 0, 0, 0 );           break;
        case "mp_dawnville":        setCullFog( 0, 8000, .32, .36, .40, 0 );    break;
        case "mp_depot":            setCullFog( 0, 7500, .32, .36, .40, 0 );    break;
        case "mp_harbor":           setCullFog( 0, 6500, .8, .8, .8, 0 );       break;
        case "mp_hurtgen":          setCullFog( 0, 5000, .32, .36, .40, 0 );    break;
        case "mp_pavlov":           setCullFog( 0, 6000, 0.8, 0.8, 0.8, 0 );    break;
        case "mp_powcamp":          setCullFog( 0, 8000, .32, .36, .40, 0 );    break;
        case "mp_railyard":         setCullFog( 0, 8000, 0.8, 0.8, 0.8, 0 );    break;
        case "mp_rocket":           setCullFog( 0, 4500, .32, .36, .40, 0 );    break;
        case "mp_ship":             setCullFog( 0, 7500, .32, .36, .40, 0 );    break;
        default:                                                                break;
    }
}

set_fog( sType, nCloseDistance, nFarDistance, vColor, iTime ) {
    if ( !isDefined( sType ) || !isDefined( nCloseDistance ) || !isDefined( nFarDistance ) || !isDefined( vColor ) )
        return false;
        
/*** begin type checking ***/
    if ( ( !type::is_float( nCloseDistance ) && !type::is_int( nCloseDistance ) ) || ( !type::is_float( nFarDistance ) && !type::is_int( nFarDistance ) ) ) {
        throw::exception( "invalid type [excepted int/float]", "weather(49)" );
        return false;
    }
    
    if ( !isDefined( iTime ) )
        iTime = 0;
        
    // attempt to parse this color
    vColor = color::parse( vColor );
    
    switch ( string::tolower( sType ) ) {
        case "cullfog":
            setCullFog( nCloseDistance, nFarDistance, vColor[ 0 ], vColor[ 1 ], vColor[ 2 ], iTime );
            break;
        case "expfog":
            setExpFog( nFarDistance, vColor[ 0 ], vColor[ 1 ], vColor[ 2 ], iTime );
            break;
        default:
            return false;
            break;
    }
}