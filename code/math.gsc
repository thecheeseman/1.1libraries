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
    int rand( int max )
    num = math::rand( 10 );
    
    Wrapper for randomint() providing more randomness
    Will always return value >=0
*/
rand( num ) {
    if ( !isDefined( num ) )
        num = 2147483648;

    temparr = [];
    for ( i = 0; i < 1024; i++ )
        temparr[ i ] = randomInt( num );

    thisint = temparr[ randomInt( temparr.size ) ];
    return thisint;
}

/*
    int rand_range( int min, int max )
    num = math::rand_range( 0, 10 );
    
    Returns a random int larger than <min> and smaller than <max>
*/
rand_range( min, max ) {
    if ( !isDefined( min ) || !isDefined( max ) )
        return false;
        
    temparr = [];
    for ( i = 0; i < 1024; i++ )
        temparr[ i ] = randomInt( max );

    goods = [];
    for ( i = 0; i < temparr.size; i++ ) {
        if ( temparr[ i ] < min )
            continue;
        goods[ goods.size ] = temparr[ i ];
    }

    thisint = goods[ randomInt( goods.size ) ];
    return thisint;
}

/*
    int abs( int num )
    num = math::abs( 1000 );
    
    Returns the absolute value of a number
    Will always return value >=0
*/
abs( val ) {
    if ( !isDefined( val ) )
        return false;
        
	if ( val < 0 )
		return val * -1;
	
	return val;
}

/*
    int sqrt( int num )
    root = math::sqrt( 2 )
    
    Returns the (estimated) square root of a number
    Will always return value >=0
    This prevents the game from attempting a divide by 0 or returning imaginary numbers :)
*/
sqrt( n ) {
    if ( !isDefined( n ) )
        return false;
        
    if ( n <= 0 )
        return 0;
        
	e = 1;
	
	for ( i = 0; i < 100; i++ ) {
		e = ( e + ( n / e ) ) / 2;
	}
	
	return e;
}

/*
    int pow( int num, int exponent )
    num = math::pow( 2, 2 )
    
    Returns <num> raised to power <exponent>
*/
pow( n, e ) {
    if ( !isDefined( n ) || !isDefined( e ) )
        return false;
        
    if ( e == 0 ) 
        return 1;
        
    r = n;
    
    for ( i = 1; i < e; i++ ) {
        r *= n;
    }
    
    return r;
}

/*
    int factorial( int num )
    num = math::factorial( 5 );
    
    Returns <num>! (i.e. if <num>=5, then 5x4x3x2x1)
*/
factorial( n ) {
    if ( !isDefined( n ) )
        return false;
        
    if ( n == 0 )
        return 1;
        
    if ( n < 0 )
        return -1;
    
    for ( i = n - 1; i > 0; i-- ) {
        n *= i;
    }
    
    return n;
}

/*
    int lshift( int num, int bits )
    shift = math::lshift( 2, 8 );
    
    Performs <num> << <bits> operation
*/
lshift( n, s ) {
    if ( !isDefined( n ) || !isDefined( s ) )
        return false;
        
    return ( n * pow( 2, s ) );
}

/*
    int rshift( int num, int bits )
    shift = math::rshift( 2, 8 );
    
    Performs <num> >> <bits> operation
*/
rshift( n, s ) {
    if ( !isDefined( n ) || !isDefined( s ) )
        return false;
        
    return ( n / pow( 2, s ) );
}

/*
    int round( int num, int places )
    num = math::round( 5.5457, 2 );
    
    Rounds <num> down/up <places> decimal places
    Will round up or down properly :)
*/
round( n, d ) {
    if ( !isDefined( n ) || !isDefined( d ) )
        return false;
        
    if ( ((int)(n * pow( 10, d )) % pow( 10, d )) >= ( pow( 10, d ) / 2 ) )
        return (((int)(n * pow( 10, d )) - ((int)(n * pow( 10, d )) % pow( 10, d ))) + (((int)(n * pow( 10, d )) % pow( 10, d )) - (((int)(n * pow( 10, d )) % pow( 10, d )))) + pow( 10, d )) / pow( 10, d );
    else
        return (int)n;
}

/*
    int floor( int num )
    num = math::floor( 5.5 );
    
    Rounds <num> down
*/
floor( n ) {
    if ( !isDefined( n ) )
        return false;
        
    return (int)n;
}

/*
    int bounds( int num, int lower, int upper )
    num = math::bounds( 100, 90, 110 );
    
    If <lower> is defined AND <num> is lesser than <lower>, return <lower>
    If <upper> is defined AND <num> is greater than <upper>, return <upper>
    Otherwise return <num>
*/
bounds( n, lower, upper ) {
    if ( !isDefined( n ) )
        return false;
        
    if ( isDefined( lower ) && n < lower )
        return lower;
    if ( isDefined( upper ) && n > upper )
        return upper;
    
    return n;
}