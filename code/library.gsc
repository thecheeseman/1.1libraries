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

load_all() {
    level.fFrameTime = ( 1 / getCvarInt( "sv_fps" ) );
    level.libraries = [];
    
    // run all the necessary functions so that the libraries run properly :D
    load( "defines" );
    load( "color" );
    load( "hud" );
    load( "weapon" );
    load( "weather" );
}

load( sLibrary ) {
    if ( !isDefined( sLibrary ) )
        return false;
        
    // already loaded library?
    if ( isDefined( level.libraries[ sLibrary ] ) )
        return true;
        
    switch ( sLibrary ) {
        case "color":       color::init();              break;
        case "defines":     defines::init();            break;
        case "hud":         hud::init();                break;
        case "weapon":      weapon::default_settings(); break;
        case "weather":     weather::init();            break;
        default:            return false;               break;
    }
    
    level.libraries[ sLibrary ] = true;
}