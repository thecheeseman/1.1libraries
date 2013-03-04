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
    A lot of the thread functions/ideas here are based heavily on *nix's pthread concept.
    The reason I based it on that is because it's a very organized system and CoD's built-in
    system is very disorganized. It's extremely hard to pin down problems with threads because
    there's no way to track them. This way lets you track threads and gives you manual control
    over them. Plus it's more organized. :)
*/

/*
    struct create( int threadID, void *func, entity owner, void *arg, boolean quickCreate )
    thr = pthread::create( undefined, ::test, undefined, 1, false );
    
    Builds a thread and returns it
*/
create( iThreadID, pFunc, oOwner, oArg, bQuickCreate ) {
    if ( !isDefined( pFunc ) )
        return false;
        
    if ( !isDefined( iThreadID ) )
        iThreadID = gettime() + randomInt( 65536 );
    
    if ( !isDefined( bQuickCreate ) )
        bQuickCreate = false;
        
    if ( !isDefined( level.iThreadsCreated ) )
        level.iThreadsCreated = 0;
        
/*** begin type checking ***/
    if ( !type::is_int( iThreadID ) ) {
        throw::exception( "invalid type [expected int]", "thread::create(47)" );
        return false;
    }
        
    if ( !type::is_boolean( bQuickCreate ) ) {
        throw::exception( "invalid type [expected boolean]", "thread::create(52)" );
        return false;
    }
/*** end type checking ***/
        
    tThread = spawnstruct();
    tThread.id = iThreadID;
    tThread.starttime = gettime();
    tThread.started = false;
    tThread.running = false;
    tThread.endtime = gettime();
    tThread.killed = false;
    tThread.once = false;
    tThread.func = pFunc;
    tThread.owner = oOwner;
    tThread.arg = oArg;
    
    log::write( "created thread [" + iThreadID + "]" );
    
    if ( bQuickCreate )
        tThread start();
        
    level.iThreadsCreated++;
    
    return tThread;
}

/*
    void start()
    thr start();
    
    Wrapper for start_runner()
*/
start() {
    self thread start_runner( self.func, self.owner, self.arg );
}

/*
    void start_runner( void *func, entity owner, void *arg )
    thr start();
    
    Called from start
    This is our actual thread runner, running inside of a CoD thread
    This way, we can keep track of some information pertaining to each individual thread (start & stop time for example)
*/
start_runner( pFunc, oOwner, oArg ) {
    log::write( "started thread [" + self.id + "]" );

    self endon( "thread killed" );
    
    self.started = true;
    self.running = true;
       
    if ( isDefined( oOwner ) ) {
        if ( isDefined( oArg ) )
            oOwner [[ pFunc ]]( oArg );
        else
            oOwner [[ pFunc ]]();
    }
    else {
        if ( isDefined( oArg ) )
            level [[ pFunc ]]( oArg );
        else
            level [[ pFunc ]]();
    }
    
    self.endtime = gettime();
    self.running = false;
    
    log::write( "ended thread [" + self.id + "]" );
}

/*
    void kill()
    thr kill();
    
    Kills (stops) the thread executing
*/
kill() {
    log::write( "killed thread [" + self.id + "]" );
    
    self.killed = true;
    self.running = false;
    self.endtime = gettime();
    self notify( "thread killed" );
}

/*
    void join()
    thr join();
    
    Waits for this thread to stop before continuing
*/
join() {
    if ( !self.started )
        return;
        
    self endon( "thread killed" );
    
    while ( self.running ) {
        wait 0.05;
    }
}

/*
    void once( void *func, entity owner )
    thr once( ::init, undefined );
    
    Wrapper for once_runner()
*/
once( pFunc, oOwner ) {
    if ( self.once )
        return;
        
    self thread once_runner( pFunc, oOwner );
}

/*
    void once_runner( void *func, entity owner )
    thr once( ::init, undefined );
    
    Called from once_runner
    This allows the thread to execute an initializing function prior to actual start
    This function ONLY RUNS ONCE, no matter how many times you call it
*/
once_runner( pFunc, oOwner ) {
    if ( !isDefined( pFunc ) )
        return;
        
    self.once = true;
    
    if ( isDefined( oOwner ) )
        oOwner [[ pFunc ]]();
    else
        level [[ pFunc ]]();
}
