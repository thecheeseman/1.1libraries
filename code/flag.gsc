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
    level.aFlags = [];
    
    create( "game started" );
    create( "game over" );
    create( "intermission" );
}

create( sFlag ) {
    if ( !isDefined( sFlag ) )
        return false;
        
    if ( isDefined( level.aFlags[ sFlag ] ) )
        return false;
        
    level.aFlags[ sFlag ] = false;
}

remove( sFlag ) {
    if ( !isDefined( sFlag ) || !isDefined( level.aFlags[ sFlag ] ) )
        return false;
        
    level.aFlags[ sFlag ] = undefined;
}

set( sFlag ) {
    if ( !isDefined( sFlag ) || !isDefined( level.aFlags[ sFlag ] ) )
        return false;
        
    level.aFlags[ sFlag ] = true;
    level notify( sFlag );
}

get( sFlag ) {
    if ( !isDefined( sFlag ) || !isDefined( level.aFlags[ sFlag ] ) )
        return false;
        
    if ( !level.aFlags[ sFlag ] )
        return false;
        
    return true;
}

// only here because flag::isset looks better than flag::get when
// it's used in an if statement :D
isset( sFlag ) {
    return get( sFlag );
}

waitfor( sFlag ) {
    if ( !isDefined( sFlag ) || !isDefined( level.aFlags[ sFlag ] ) )
        return false;
        
    while ( !level.aFlags[ sFlag ] )
        level waittill( sFlag );
}

clear( sFlag ) {
    if ( !isDefined( sFlag ) || !isDefined( level.aFlags[ sFlag ] ) )
        return false;
        
    if ( level.aFlags[ sFlag ] ) {
        level.aFlags[ sFlag ] = false;
        level notify( sFlag );
    }
}