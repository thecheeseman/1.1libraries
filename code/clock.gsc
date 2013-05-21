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
    level.timestamp = 0;
    level.unixtimestamp = 0;
    
    pthread::create( undefined, ::timestamp_runner, level, undefined, true );
}

update() {
    timestamp = getCvar( "unix_timestamp" );
    if ( timestamp != "" ) {
        level.unixtimestamp = getCvarInt( "unix_timestamp" );
        setCvar( "unix_timestamp", "" );
        return true;
    }
    
    return false;
}

timestamp_runner() {
    serverframes = getCvarInt( "sv_fps" );
    currentframe = 0;

    while ( true ) {
        if ( currentframe > serverframes ) {
            currentframe = 0;
            
            if ( !update() )
                level.unixtimestamp++;
        }
            
        level.timestamp = gettime();
        wait ( level.fFrameTime );
        currentframe++;
    }
}