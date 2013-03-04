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

object( sName, sType ) {
    if ( !isDefined( level.aPrecached ) )
		level.aPrecached = [];

	// will precache multiple items with the same name, but not with the same type. i.e.
	// precacheObject( "hud/icon", "headicon" );
	// precacheObject( "hud/icon", "statusicon" );
	// works, but if you try to precacheObject( "hud/icon", "headicon" ) again somewhere, it will not go through
	for ( i = 0; i < level.aPrecached.size; i++ )  {
		if ( isDefined( level.aPrecached[ i ] ) ) {
			sTempName = level.aPrecached[ i ].sName;
			sTempType = level.aPrecached[ i ].sType;
			if ( sTempName == sName && sTempType == sType ) {
                log::write( "tried to precache " + sType + " [" + sName + "] when it's already precached" );
				return;
			}
		}
	}
		
	switch ( sType ) {
		case "string":      precacheString( sName ); break;
		case "model":       precacheModel( sName ); break;
		case "shader":      precacheShader( sName ); break;
		case "menu":        precacheMenu( sName ); break;
		case "item":        precacheItem( sName ); break;
		case "shellshock":  precacheShellshock( sName ); break;
		case "headicon":    precacheHeadIcon( sName ); break;
		case "statusicon":  precacheStatusIcon( sName ); break;
		default: // TODO: log here
            return;
	}

	oStruct = spawnstruct();
    oStruct.sName = sName;
	oStruct.sType = sType;
	level.aPrecached[ level.aPrecached.size ] = oStruct;
}