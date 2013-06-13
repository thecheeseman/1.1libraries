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

init() {
    level._effect[ "lowlevelburst" ] = loadfx( "fx/atmosphere/lowlevelburst.efx" );
    
    entities = entity::get_all();
    xmin = entities[ 0 ].origin[ 0 ];
    xmax = xmin;
    ymin = entities[ 0 ].origin[ 1 ];
    ymax = ymin;
    zmin = entities[ 0 ].origin[ 2 ];
    zmax = zmin;
    
    for ( i = 0; i < entities.size; i++ ) {
        e = entities[ i ];
        if ( e.origin[ 0 ] > xmax )
            xmax = e.origin[ 0 ];
        if ( e.origin[ 1 ] > ymax )
            ymax = e.origin[ 2 ];
        if ( e.origin[ 2 ] > zmax )
            zmax = e.origin[ 2 ];
            
        if ( e.origin[ 0 ] < xmin )
            xmin = e.origin[ 0 ];
        if ( e.origin[ 1 ] < ymin )
            ymin = e.origin[ 2 ];
        if ( e.origin[ 2 ] < zmin )
            zmin = e.origin[ 2 ];    
    }
    
    x = (int)( xmax + xmin ) / 2;
    y = (int)( ymax + ymin ) / 2;
    z = (int)( zmax + zmin ) / 2;
    
    endz = z + 65536;
    trace = bullettrace( ( x, y, z ), ( x, y, endz ), false, undefined );
    if ( trace[ "fraction" ] != 1 )
        z = endz - ( 65536 * trace[ "fraction" ] ) - 100;
        
    level.center = ( x, y, z );
    
    level.weatherEvent = false;
    level.weatherQueue = [];

    default_fog();
}

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

create_weather_event( sType, iTransitionTime, iLength ) {
    if ( !isDefined( sType ) || !isDefined( iTransitionTime ) || !isDefined( iLength ) )
        return false;
        
    event = spawnstruct();
    event.type = sType;
    event.starttime = iTransitionTime;
    event.length = iLength;
    event.haslightning = false;
        
    switch ( sType ) {
        case "haboob":
            event.fogtype = "expfog";
            event.fogcolor = color::parse( "dust" );
            event.fogdistfar = 0.001;
            event.fogdistclose = 0.009;
            event.fogdistrandom = false;
            break;
        case "blizzard":
            event.fogtype = "expfog";
            event.fogcolor = color::parse( "white" );
            event.fogdistfar = 0.001;
            event.fogdistclose = 0.008;
            event.fogdistrandom = false;
            break;
        case "stormy":
            event.fogtype = "expfog";
            event.fogcolor = color::parse( "bluegrey" );
            event.fogdistfar = 0.001;
            event.fogdistclose = 0.005;
            event.fogdistrandom = false;
            event.haslightning = true;
            break;
        default:
            event.type = "blank";
            return false;
            break;
    }
    
    return event;
}

start_weather_event( event ) {
    if ( !isDefined( event ) || ( isDefined( event.type ) && event.type == "blank" ) )
        return false;
        
    if ( !isDefined( event.fogtype ) )
        event.fogtype = "cullfog";
        
    if ( !isDefined( level.weatherQueue ) )
        level.weatherQueue = [];
        
    if ( !isDefined( level.weatherEvent ) )
        level.weatherEvent = false;
        
    if ( !level.weatherEvent ) {        
        pthread::create( undefined, ::weather_event_runner, level, event, true );
        return;
    }
    
    level.weatherQueue[ level.weatherQueue.size ] = event;
}

weather_event_runner( event ) {
    level.weatherEvent = true;
    
    // transition to event's starting point
    set_fog( event.fogtype, 0, event.fogdistfar, event.fogcolor, event.starttime );
    wait ( event.starttime );
    
    if ( event.haslightning )
        pthread::create( undefined, ::lightning_runner, level, event, true );
    
    // transition to event itself
    set_fog( event.fogtype, 0, event.fogdistclose, event.fogcolor, event.starttime );
    wait ( event.starttime );

    // wait until event is over
    wait ( event.length );

    // transition back to start point
    set_fog( event.fogtype, 0, event.fogdistfar, event.fogcolor, event.starttime );
    wait ( event.starttime );
    
    level.weatherEvent = false;
    
    if ( level.weatherQueue.size > 0 ) {
        next = level.weatherQueue[ 0 ];
        
        for ( i = 1; i < level.weatherQueue.size; i++ )
            level.weatherQueue[ i - 1 ] = level.weatherQueue[ i ];
        level.weatherQueue[ i - 1 ] = undefined;
        
        pthread::create( undefined, ::weather_event_runner, level, next, true );
    }
}

lightning_runner( event ) {
    runtime = 0;
    waittime = 0;
    // transition in and out and the total length
    totaltime = ( event.starttime * 2 ) + event.length;
    while ( runtime < totaltime ) {
        if ( waittime == 0 ) {
            // lightning
            playfx( level._effect[ "lowlevelburst" ], level.center );
            waittime = math::rand_range( 10, 30 );
        }
        
        wait 1;
        
        waittime--;
        runtime++;
    }
}