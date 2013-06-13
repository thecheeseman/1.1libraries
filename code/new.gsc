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

integer( oValue ) {
    if ( !isDefined( oValue ) )
        return 0;
        
    // already an integer
    if ( type::is_int( oValue ) )
        return oValue;
        
    // cast to an integer if it's a float
    if ( type::is_float( oValue ) )
        return (int)oValue;

    // otherwise we'll treat this as a string
    return type::atoi( oValue );
}

double( oValue ) {
    if ( !isDefined( oValue ) )
        return (float)0.0;
        
    if ( type::is_double( oValue ) )
        return oValue;
        
    if ( type::is_float( oValue ) )
        return (float)math::round( (float)oValue * 100, 2 ) / 100;
        
    if ( type::is_int( oValue ) )
        return (float)oValue;
        
    return type::atod( oValue );
}

float( oValue ) {
    if ( !isDefined( oValue ) )
        return (float)0.0;
        
    if ( type::is_float( oValue ) )
        return oValue;
        
    if ( type::is_int( oValue ) || type::is_double( oValue ) )
        return (float)oValue;
        
    return type::atof( oValue );
}