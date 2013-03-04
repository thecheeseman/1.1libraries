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

/*
    object get( string name, string key )
    test = entity::get( "test" );
    
    Wrapper for getEnt()
    Returns false if entity is not defined
    Protects certain if statements from failing where the statement is executed even if ent = undefined:
        ent = getEnt( "asdf", "targetname" );
        if ( ent ) ...
            execute no matter what
*/
get( sName, sKey ) {
    if ( !isDefined( sName ) )
        return false;
        
    if ( !isDefined( sKey ) )
        sKey = "targetname";
        
    eEnt = getEnt( sName, sKey );
    if ( !isDefined( eEnt ) )
        return false;
    
    return eEnt;
}

/*
    object[] get_array( string name, string key )
    test = entity::get_array( "test" );
    
    Wrapper for getEntArray()
    Returns false if entities are not defined
    Same reasoning as 'get' from above
*/
get_array( sName, sKey ) {
    if ( !isDefined( sName ) )
        return false;
       
    if ( !isDefined( sKey ) )
        sKey = "targetname";
        
    eEnts = getEntArray( sName, sKey );
    if ( !isDefined( eEnts ) )
        return false;
    
    return eEnts;
}

/*
    object[] get_all( void )
    all = entity::get_all();
    
    Wrapper for getEntArray() with no args
    Returns false if there are no entities in the map (HIGHLY UNLIKELY)
    Same reasoning as 'get' from above
*/

get_all() {
    eEnts = getEntArray();
    if ( !isDefined( eEnts ) )
        return false;
        
    return eEnts;
}
