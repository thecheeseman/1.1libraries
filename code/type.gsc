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
    int atoi( string str )
    iValue = type::atoi( "1234" );
    
    Attempts to convert string <str> to an integer
*/
atoi( sString ) {
    sString = utilities::strreplacer( sString, "numeric" );
    if ( sString == "" )
        return 0;
    return (int)sString;
}

/*
    double atod( string str )
    dValue = type::atod( "12.34" );
    
    Attemps to convert string <str> to a double
*/
atod( sString ) {
    sString = utilities::strreplacer( sString, "numeric" );
    if ( sString == "" )
        return 0.0;
    return (float)math::round( (float)sString * 100, 2 ) / 100;
}

/*
    float atof( string str )
    fValue = type::atof( "12.3456789" );
    
    Attemps to convert string <str> to a float
*/
atof( sString ) {
    sString = utilities::strreplacer( sString, "numeric" );
    if ( sString == "" )
        return 0.0;
    return (float)sString;
}

/*
    boolean atob( string str )
    bValue = type::atob( "true" );
    
    Attemps to convert string <str> to a boolean
*/
atob( sString ) {
    sString = string::strip( string::tolower( sString ) );      
    tmp = utilities::strreplacer( sString, "numeric" );
    
    // we don't contain any numbers
    if ( tmp == "" ) { 
        if ( sString == "false" )
            return false;
        else
            return true;
    }
    
    // we do contain numbers, let's check
    if ( (int)tmp == 0 )
        return false;
        
    return true;    
}

/*
    vector atov( string str )
    vVector = type::atov( "( 0, 0, 0 )" );
    
    Attempts to convert string <str> to a vector
*/
atov( sString ) {
    sString = utilities::strreplacer( sString, "vector" );
    if ( sString == "" )
        return ( 0, 0, 0 );
    
    firstChar = sString[ 0 ];
    lastChar = sString[ sString.size - 1 ];
    
    // strings -> vectors MUST have ()'s, otherwise
    // we'll consider it invalid
    if ( firstChar != "(" || lastChar != ")" )
        return false;
        
    vecs = string::substring( sString, 1, sString.size - 1 );
    arr = string::explode( vecs, "," );
    
    // vectors must have 3 parts
    if ( arr.size != 3 )
        return false;
        
    x = type::atof( arr[ 0 ] );
    y = type::atof( arr[ 1 ] );
    z = type::atof( arr[ 2 ] );
    
    return ( x, y, z );
}

/*
    boolean is_string( string str )
    if ( type::is_string( "test" ) ) { ... }
    
    Returns true if <str> is a string, false otherwise
*/
is_string( sString ) {
    if ( !isDefined( sString ) )
        return false;
        
    if ( is_int( sString ) || is_float( sString ) || is_vector( sString ) || is_entity( sString ) )
        return false;
        
    // main problem with strings + arrays is they both have .sizes
    if ( !isDefined( sString.size ) )
        return false;
        
    return true;
}

/*
    boolean is_vector( vector vec )
    if ( type::is_vector( ( 0, 0, 0 ) ) ) { ... }
    
    Returns true if <vec> is a vector, false otherwise
*/
is_vector( vVector ) {
    if ( !isDefined( vVector ) )
        return false;
        
    if ( !isDefined( vVector[ 0 ] ) || !isDefined( vVector[ 1 ] ) || !isDefined( vVector[ 2 ] ) )
        return false;
        
    // all three values SHOULD be floats, but as we know
    // floats & ints are treated pretty much the same in cod :>
    if ( !is_float( vVector[ 0 ] ) && !is_int( vVector[ 0 ] ) )
        return false;
    if ( !is_float( vVector[ 1 ] ) && !is_int( vVector[ 1 ] ) )
        return false;
    if ( !is_float( vVector[ 2 ] ) && !is_int( vVector[ 2 ] ) )
        return false;
        
    // at this point, we could just have an array of numbers
    // but since the vector type does not have a .size attached, we'll sort it here
    if ( isDefined( vVector.size ) )
        return false;
    
    return true;
}

/*
    boolean is_double( double db )
    if ( type::is_double( 12.34 ) ) { ... }
    
    Returns true if <db> is a float, otherwise false
    CoD handles doubles as floats, so no point in trying to force it otherwise
*/
is_double( dDouble ) {
    if ( !isDefined( dDouble ) )
        return false;
        
    if ( !is_float( dDouble ) )
        return false;
        
    return true;
}

/*
    boolean is_float( float fl )
    if ( type::is_float( 12.34 ) ) { ... }
    
    Returns true if <fl> is a float, otherwise false
*/
is_float( fFloat ) {
    if ( !isDefined( fFloat ) )
        return false;
        
     // floats must have decimal places :>
    if ( is_int( fFloat ) ) 
        return false;
        
    sTemp = string::strip( (string)fFloat );
    bContainsPeriod = false;
    for ( i = 0; i < sTemp.size; i++ ) {
        switch ( sTemp[ i ] ) {
            case "0":   case "1":   case "2":   case "3":
            case "4":   case "5":   case "6":   case "7":
            case "8":   case "9":
                break;
            case ".":
                bContainsPeriod = true; break;
            default:
                return false; break;
        }
    }

    // we can't compare modulus for floats because fFloat % 1 > 0 doesn't work properly
    // so we'll just check if it has a period :)
    if ( !bContainsPeriod )
        return false;
        
    return true;
}

/*
    boolean is_int( int i )
    if ( type::is_int( 1 ) ) { ... }
    
    Returns true if <i> is an integer, otherwise false
*/
is_int( iInt ) {
    if ( !isDefined( iInt ) )
        return false;
        
    sTemp = string::strip( (string)iInt );
    for ( i = 0; i < sTemp.size; i++ ) {
        switch ( sTemp[ i ] ) {
            case "0":   case "1":   case "2":   case "3":
            case "4":   case "5":   case "6":   case "7":
            case "8":   case "9":
                continue; break;
            default:
                return false; break;
        }
    }

    // at this point, we could have been handed a string with only numbers in it
    // i.e. "1234", so let's try and modulus it
    // (anything % 1 == 0), so if it's false, it's not an int
    if ( (int)iInt % 1 != 0 )
        return false;
    
    return true;
}

/*
    boolean is_boolean( boolean bool )
    if ( type::is_boolean( true ) ) { ... }
    
    Returns true if <bool> is an integer AND is either 1 or 0, otherwise false
*/
is_boolean( bBool ) {
    if ( !isDefined( bBool ) )
        return false;
        
    if ( !is_int( bBool ) )
        return false;
        
    if ( bBool == 0 || bBool == 1 )
        return true;        
        
    return false;
}

/*
    boolean is_array( object arr[] )
    if ( type::is_array( arr ) ) { ... }
    
    Returns true if <arr> is an array that has '.size' assigned, otherwise false
*/
is_array( aArray ) {
    if ( !isDefined( aArray ) )
        return false;
        
    if ( !isDefined( aArray.size ) )
        return false;
        
    return true;
}

/*
    boolean is_entity( entity ent )
    if ( type::is_entity( ent ) ) { ... }
    
    Returns true if <ent> is a valid entity, otherwise false
*/
is_entity( eEntity ) {
    if ( !isDefined( eEntity ) )
        return false;
        
    iNum = eEntity getEntityNumber();
    if ( !isDefined( iNum ) )
        return false;
        
    return true;
}

/*
    string check( object o )
    type = type::check( "asdf" );
    
    Returns a string containing the type of the variable
*/
check( oObject ) {
    if ( !isDefined( oObject ) )    return "undefined";
    if ( is_int( oObject ) )        return "int";
    if ( is_float( oObject ) )      return "float";
    if ( is_vector( oObject ) )     return "vector";
    if ( is_entity( oObject ) )     return "entity";
    if ( is_string( oObject ) )     return "string";
    //if ( is_array( oObject ) )      return "array";
    else                            return "object";
}

/*
    boolean compare( object o, string type )
    if ( type::compare( "test", "string" ) ) { ... }
    
    Returns true if <o>'s type is equal to <type>, otherwise false
*/
compare( oObject, sType ) {
    if ( !isDefined( oObject ) || !isDefined( sType ) )
        return false;
        
    type = check( oObject );
    
    if ( type != sType )
        return false;
        
    return true;
}