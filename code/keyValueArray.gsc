// example:
// tmp = new::keyValueArray();
// tmp keyValueArray::add( "test", "value" );
add( sKey, oValue ) {
    if ( !self.cancontainduplicates && isDefined( self.keys[ sKey ] ) )
        return;
        
    self.keys[ sKey ] = oValue;
    self.length++;
}

// tmp keyValueArray::remove( "test" );
remove( sKey ) {
    if ( !isDefined( self.keys[ sKey ] ) )
        return;
        
    self.keys[ sKey ] = undefined;
    self.length--;
}

// if ( tmp keyValueArray::contains( "test" ) ) { ...
contains( sKey, oValue ) {
    if ( !isDefined( self.keys[ sKey ] ) )
        return false;
        
    if ( isDefined( oValue ) && isDefined( self.keys[ sKey ] ) && self.keys[ sKeys ] == oValue )
        return true;
        
    return true;
}

// data = tmp keyValueArray::contents();
contents() {
    return self.keys;
}

// size = tmp keyValueArray::size();
size() {
    return self.length;
}