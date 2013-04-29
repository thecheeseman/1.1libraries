/*
    Called like this:
    
        stats = new::keyValueArray();
        
    :DDD
*/

keyValueArray( bContainDuplicates ) {
    if ( !isDefined( bContainDuplicates ) )
        bContainDuplicates = false;
        
    tmp = spawnstruct();
    tmp.cancontainduplicates = bContainDuplicates;
    tmp.keys = [];
    tmp.length = 0;
    return tmp;
}