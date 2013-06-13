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
    level.iTimeStamp = 0;
    level.iUnixTimeStamp = 0;
    
    pthread::create( undefined, ::timestamp_runner, level, undefined, true );
}

update() {
    sTimeStamp = getCvar( "unix_timestamp" );
    if ( sTimeStamp != "" ) {
        level.iUnixTimeStamp = getCvarInt( "unix_timestamp" );
        setCvar( "unix_timestamp", "" );
        return true;
    }
    
    return false;
}

timestamp_runner() {
    iServerFrames = getCvarInt( "sv_fps" );
    iCurrentFrame = 0;

    while ( true ) {
        if ( iCurrentFrame > iServerFrames ) {
            iCurrentFrame = 0;
            
            if ( !update() )
                level.iUnixTimeStamp++;
        }
            
        level.iTimeStamp = gettime();
        wait ( level.fFrameTime );
        iCurrentFrame++;
    }
}