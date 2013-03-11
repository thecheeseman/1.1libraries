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
    precache::object( "gfx/hud/hud@health_back.dds", "shader" );
    precache::object( "gfx/hud/hud@health_bar.dds", "shader" );
    
    // stolen from cod4 :D
    level.uiParent = spawnstruct();
	level.uiParent.alignX = "left";
	level.uiParent.alignY = "top";
	level.uiParent.x = 0;
	level.uiParent.y = 0;
	level.uiParent.width = 0;
	level.uiParent.height = 0;
	level.uiParent.children = [];
    
    level.fontHeight = 12;
}

message_init() {   
    titleSize = 2.5;
    textSize = 1.75;
    iconSize = 30;
    point = "top";
    relativePoint = "bottom";
    yOffset = 60;
    xOffset = 320;
	
	self.notifyTitle = self create_element( "text", titleSize );
	self.notifyTitle set_point( point, undefined, xOffset, yOffset );
	self.notifyTitle.archived = false;
	self.notifyTitle.alpha = 0;

	self.notifyText = self create_element( "text", textSize );
	self.notifyText set_parent( self.notifyTitle );
	self.notifyText set_point( point, relativePoint, 0, yOffset + 40 );
	self.notifyText.archived = false;
	self.notifyText.alpha = 0;

	self.notifyText2 = self create_element( "text", textSize );
	self.notifyText2 set_parent( self.notifyTitle );
	self.notifyText2 set_point( point, relativePoint, 0, 0 );
	self.notifyText2.archived = false;
	self.notifyText2.alpha = 0;

	self.notifyIcon = self create_element( "icon", "white", iconSize, iconSize );
	self.notifyIcon set_parent( self.notifyText2 );
	self.notifyIcon set_point( point, relativePoint, 0, 0 );
	self.notifyIcon.archived = false;
	self.notifyIcon.alpha = 0;

	self.doingNotify = false;
	self.notifyQueue = [];
}

create_notify( sTitle, sTitleLabel, sNotify, sNotifyLabel, sIcon, sSound, iDuration ) {
    data = spawnstruct();
    
    data.titletext = &"";
    data.titlelabel = &"";
    data.titleisstring = true;
    data.notifytext = &"";
    data.textlabel = &"";
    data.textisstring = true;
    data.icon = undefined;
    data.sound = undefined;
    data.duration = 4;
    
    if ( isDefined( sTitle ) )
        data.titletext = sTitle;
    if ( isDefined( sTitleLabel ) )
        data.titlelabel = sTitleLabel;
    if ( isDefined( sTitle ) && ( type::is_int( sTitle ) || type::is_float( sTitle ) ) )
        data.titleisstring = false;
    if ( isDefined( sNotify ) )
        data.notifytext = sNotify;
    if ( isDefined( sNotifyLabel ) )
        data.textlabel = sNotifyLabel;
    if ( isDefined( sNotify) && ( type::is_int( sNotify ) || type::is_float( sNotify ) ) )
        data.textisstring = false;
    if ( isDefined( sIcon ) )
        data.icon = sIcon;
    if ( isDefined( sSound ) )
        data.sound = sSound;
    if ( isDefined( iDuration ) )
        data.duration = iDuration;
    
    return data;
}

notify_message( data ) {
    self endon( "death" );
    self endon( "disconnect" );
    
    if ( !self.doingNotify ) {
        pthread::create( undefined, ::run_notify, self, data, true );
        return;
    }
    
    self.notifyQueue[ self.notifyQueue.size ] = data;
}

run_notify( data ) {
    self endon( "disconnect" );
    
    self.doingNotify = true;

    anchorelem = self.notifyTitle;
    
    if ( !isDefined( data.duration ) )
        data.duration = 4;
        
    if ( isDefined( data.sound ) )
        self playLocalSound( data.sound );
        
    if ( isDefined( data.titletext ) ) {
        self.notifyTitle fadeOverTime( 1.0 );
        
        if ( isDefined( data.titlelabel ) )
            self.notifyTitle.label = data.titlelabel;
        else
            self.notifyTitle.label = &"";
            
        if ( isDefined( data.titlelabel ) && !data.titleisstring ) 
            self.notifyTitle setValue( data.titletext );
        else 
            self.notifyTitle setText( data.titletext );

        self.notifyTitle.alpha = 1;
    }
    
    if ( isDefined( data.notifytext ) ) {
        self.notifyText fadeOverTime( 1.0 );
        
        if ( isDefined( data.textlabel ) )
            self.notifyText.label = data.textlabel;
        else
            self.notifyText.label = &"";
            
        if ( isDefined( data.textlabel ) && !data.textisstring )
            self.notifyText setValue( data.notifytext );
        else
            self.notifyText setText( data.notifytext );
        self.notifyText.alpha = 1;
    }
    
    if ( isDefined( data.icon ) ) {
        self.notifyIcon set_parent( anchorelem );
        self.notifyIcon setShader( data.icon, 60, 60 );
		self.notifyIcon.alpha = 0;
		self.notifyIcon fadeOverTime( 1.0 );
		self.notifyIcon.alpha = 1;
        
        wait ( data.duration );

		self.notifyIcon fadeOverTime( 0.75 );
		self.notifyIcon.alpha = 0;
    }
    else {
        wait ( data.duration );
        
        if ( isDefined( data.titletext ) ) {
            self.notifyTitle fadeOverTime( 0.75 );
            self.notifyTitle.alpha = 0;
        }
        if ( isDefined( data.notifytext ) ) {
            self.notifyText fadeOverTime( 0.75 );
            self.notifyText.alpha = 0;
        }
        
        wait ( 0.75 );
    }
    
    self.doingNotify = false;
    
    if ( self.notifyQueue.size > 0 ) {
        next = self.notifyQueue[ 0 ];

        for ( i = 1; i < self.notifyQueue.size; i++ ) 
            self.notifyQueue[ i - 1 ] = self.notifyQueue[ i ];
        self.notifyQueue[ i - 1 ] = undefined;

        pthread::create( undefined, ::run_notify, self, next, true );
    }
}

create_element( sType, oArg1, oArg2, oArg3 ) {
    if ( !isDefined( sType ) )
        return false;
        
    if ( quick_contains( sType, "server" ) )
        elem = newHudElem();
    else
        elem = newClientHudElem( self );
        
    elem.x = 0;
    elem.y = 0;
    elem.width = 0;
    elem.height = (int)( level.fontHeight * iFontScale );
    elem.xoffset = 0;
    elem.yoffset = 0;
    elem.children = [];
    elem set_parent( level.uiParent );
    elem.hidden = false;
    elem.alpha = 1;
        
    switch ( string::tolower( sType ) ) {
        case "bar":
        case "server bar":
            if ( !isDefined( oArg2 ) || !isDefined( oArg3 ) )
                return false;
            elem.elemtype = "bar";
            
            if ( quick_contains( sType, "server" ) ) {
                elemFill = newHudElem();
                elemFrame = newHudElem();
            }
            else {
                elemFill = newClientHudElem( self );
                elemFrame = newClientHudElem( self );
            }
            
            // elemFill
            elemFill.x = 0;
            elemFill.y = 0;
            elemFill.frac = 0;

            if ( !isDefined( oArg1 ) )
                oArg1 = color::parse( "white" );
            else
                oArg1 = color::parse( oArg1 );
                
            elemFill.color = oArg1;
            elemFill setShader( "gfx/hud/hud@health_bar.dds", oArg2, oArg3 );
            elemFill.sort = -1;
            elemFill.hidden = false;
            
            // elemFrame
            elemFrame.elemtype = "icon";
            elemFrame.x = 0;
            elemFrame.y = 0;
            elemFrame.width = oArg2;
            elemFrame.height = oArg3;
            elemFrame.xoffset = 0;
            elemFrame.xoffset = 0;
            elemFrame.bar = elemFill;
            elemFrame.barframe = elemFrame;
            elemFrame.children = [];
            elemFrame.sort = -2;
            elemFrame.color = color::parse( "white" );
            elemFrame set_parent( level.uiParent );
            elemFrame setShader( "gfx/hud/hud@health_back.dds", oArg2, oArg3 );
            elemFrame.hidden = false;
            
            // elem
            elem.width = oArg2;
            elem.height = oArg3;
            elem.bar = elemFill;
            elem.barframe = elemFrame;
            break;
        case "icon":
        case "server icon":
            elem.elemtype = "icon";
            
            if ( isDefined( oArg2 ) && isDefined( oArg3 ) ) {
                elem.width = oArg2;
                elem.height = oArg3;
                
                if ( isDefined( oArg1 ) )
                    elem setShader( oArg1, oArg2, oArg3 );
            }
            break;
        case "text":
        case "server text":
            elem.elemtype = "text";
            
            if ( !isDefined( oArg1 ) )
                elem.fontscale = 1;
            else
                elem.fontscale = oArg1;
            break;
        case "timer":
        case "server timer":
            elem.elemtype = "timer";
            break;
        default:
            return false;
            break;
    }
    
    return elem;
}

set_parent( element ) {
    if ( isDefined( self.parent ) && self.parent == element )
        return;
        
    if ( isDefined( self.parent ) )
        self.parent remove_child( self );
        
    self.parent = element;
    self.parent add_child( self );
}

get_parent() {
    return self.parent;
}

add_child( element ) {
    element.index = self.children.size;
    self.children[ self.children.size ] = element;
}

remove_child( element ) {
    element.parent = undefined;
    
    if ( self.children[ self.children.size - 1 ] != element ) {
        self.children[ element.index ] = self.children[ self.children.size - 1 ];
        self.children[ element.index ].index = element.index;
    }
    self.children[ self.children.size - 1 ] = undefined;
    
    element.index = undefined;
}

set_point( sPoint, sRelativePoint, iOffsetX, iOffsetY, iMoveTime ) {
    if ( !isDefined( sPoint ) )
        return false;
    
    if ( !isDefined( iOffsetX ) )
        iOffsetX = 0;
    self.xoffset = iOffsetX;
    
    if ( !isDefined( iOffsetY ) )
        iOffsetY = 0;    
    self.yoffset = iOffsetY;
    
    if ( !isDefined( iMoveTime ) )
        iMoveTime = 0;
    
    element = self get_parent();
    
    if ( iMoveTime )
        self moveOverTime( iMoveTime );
        
    self.point = sPoint;
    self.alignX = "center";
    self.alignY = "middle";
    
    if ( quick_contains( sPoint, "top" ) )
        self.alignY = "top";
    if ( quick_contains( sPoint, "bottom" ) )
        self.alignY = "bottom";
    if ( quick_contains( sPoint, "left" ) )
        self.alignX = "left";
    if ( quick_contains( sPoint, "right" ) )
        self.alignX = "right";

    if ( !isDefined( sRelativePoint ) )
        sRelativePoint = sPoint;
    
    self.relativepoint = sPoint;
    
    relativeX = "center";
    relativeY = "middle";

    if ( quick_contains( sRelativePoint, "top" ) )
        relativeY = "top";
    if ( quick_contains( sRelativePoint, "bottom" ) )
        relativeY = "bottom";
    if ( quick_contains( sRelativePoint, "left" ) )
        relativeX = "left";
    if ( quick_contains( sRelativePoint, "right" ) )
        relativeX = "right";   

    xFactor = 0;
    yFactor = 0;
        
    if ( relativeX == element.alignX ) {
        offsetX = 0;
        xFactor = 0;
    }
    else if ( relativeX == "center" || element.alignX == "center" ) {
        offsetX = (int)( element.width / 2 );
        if ( relativeX == "left" || element.alignX == "right" ) 
            xFactor = -1;
        else
            xFactor = 1;
    }
    else {
        offsetX = element.width;
        if ( relativeX == "left" )
            xFactor = -1;
        else
            xFactor = 1;
    }
    self.x = element.x + ( offsetX * xFactor );
    
    if ( relativeY == element.alignY ) {
        offsetY = 0;
        yFactor = 0;
    }
    else if ( relativeY == "middle" || element.alignY == "middle" ) {
        offsetY = (int)( element.height / 2 );
        if ( relativeY == "top" || element.alignY == "bottom" ) 
            yFactor = -1;
        else
            yFactor = 1;
    }
    else {
        offsetY = element.height;
        if ( relativeY == "top" )
            yFactor = -1;
        else
            yFactor = 1;
    }
    self.y = element.y + ( offsetY * yFactor );
    
    self.x += self.xoffset;
    self.y += self.yoffset;
    
    if ( self.elemtype == "bar" ) {
        set_point_bar( sPoint, sRelativePoint, iOffsetX, iOffsetY );
        self.barframe set_parent( self get_parent() );
        self.barframe set_point( sPoint, sRelativePoint, iOffsetX, iOffsetY );
    }
    
    self update_children();
}

set_point_bar( sPoint, sRelativePoint, iOffsetX, iOffsetY ) {
    self.bar.alignX = "left";
    self.bar.alignY = self.alignY;
    self.bar.y = self.y;
    
    	if ( self.alignX == "left" )
		self.bar.x = self.x;
	else if ( self.alignX == "right" )
		self.bar.x = self.x - self.width;
	else
		self.bar.x = self.x - (int)( self.width / 2 );
	
	if ( self.alignY == "top" )
		self.bar.y = self.y;
	else if ( self.alignY == "bottom" )
		self.bar.y = self.y;

	self update_bar( self.bar.frac );
}

update_bar( iBarFrac, iRateOfChange ) {
    width = (int)( self.width * iBarFrac + 0.5 );
    if ( !width )
        width = 1;
        
    self.bar.frac = iBarFrac;
    self.bar setShader( "gfx/hud/hud@health_bar.dds", width, self.height );
    
    if ( isDefined( iRateOfChange ) && width < self.width ) {
        if ( iRateOfChange > 0 )
            self.bar scaleOverTime( ( 1 - iBarFrac ) / iRateOfChange, self.width, self.height );
        else if ( iRateOfChange < 0 )
            self.bar scaleOverTime( iBarFrac / ( -1 * iRateOfChange ), 1, self.height );
    }
    
    self.bar.rateofchange = iRateOfChange;
	self.bar.lastupdatetime = getTime();
}

update_children() {
    for ( i = 0; i < self.children.size; i++ ) {
        child = self.children[ i ];
        child set_point( child.point, child.relativepoint, child.xoffset, child.yoffset );
    }
}

quick_contains( sString, sOtherString ) {
    tmp = string::explode( sString, " " );
    for ( i = 0; i < tmp.size; i++ ) {
        if ( tmp[ i ] == sOtherString ) {
            return true;
            break;
        }
    }
    
    return false;
}

hide_element() {
    if ( self.hidden )
        return;
        
    self.hidden = true;
    
    if ( self.alpha != 0 )
        self.alpha = 0;
}

show_element() {
    if ( !self.hidden ) 
        return;
     
    self.hidden = false;
    
    if ( self.alpha != 1 )
        self.alpha = 1;
}

destroy_element() {
    tempChildren = [];
    
    for ( i = 0; i < self.children.size; i++ ) {
        if ( isDefined( self.children[ i ] ) )
            tempChildren[ tempChildren.size ] = self.children[ i ];
    }
    
    for ( i = 0; i < tempChildren.size; i++ )
        tempChildren[ i ] set_parent( self get_parent() );
        
    self destroy();
}