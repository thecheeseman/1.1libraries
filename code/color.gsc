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

vector_to_rgb( vVector ) {
    if ( !isDefined( vVector ) || !type::is_vector( vVector ) )
        return false;
        
    c1 = (int)( vVector[ 0 ] * 255 );
    c2 = (int)( vVector[ 1 ] * 255 );
    c3 = (int)( vVector[ 2 ] * 255 );
    
    return ( c1, c2, c3 );
}

rgb_to_vector( vRGB ) {
    if ( !isDefined( vRGB ) || !type::is_vector( vRGB ) )
        return false;
        
    c1 = ( vRGB[ 0 ] / 255 );
    c2 = ( vRGB[ 1 ] / 255 );
    c3 = ( vRGB[ 2 ] / 255 );
    
    return ( c1, c2, c3 );
}

parse( oObject ) {
    if ( !isDefined( oObject ) )
        return false;
        
    // is this an rgb/vector color?
    if ( type::is_vector( oObject ) ) {
        c1 = oObject[ 0 ];
        c2 = oObject[ 1 ];
        c3 = oObject[ 2 ];
        
        // vectors are only between 0 and 1
        if ( c1 <= 1 && c2 <= 1 && c3 <= 1 )
            return oObject;
            
        // otherwise, we need to convert to vector
        c1 = ( c1 / 255 );
        c2 = ( c2 / 255 );
        c3 = ( c3 / 255 );
        
        return ( c1, c2, c3 );
    }
    
    // otherwise, let's assume this is a string
    color = ( 0, 0, 0 );
    switch ( string::tolower( oObject ) ) {
        // 142 total colors can be parsed
        // all of these colors can be found here:
        // <http://www.rapidtables.com/web/color/RGB_Color.htm#color%20table>
        // basic colors
        case "black":                                                   break;
        case "white":                   color = ( 1, 1, 1 );            break;
        case "red":                     color = ( 1, 0, 0 );            break;
        case "lime":                    color = ( 0, 1, 0 );            break;
        case "blue":                    color = ( 0, 0, 1 );            break;
        case "yellow":                  color = ( 1, 1, 0 );            break;
        case "cyan":
        case "aqua":                    color = ( 0, 1, 1 );            break;
        case "magenta":
        case "fuchsia":                 color = ( 1, 0, 1 );            break;
        case "silver":                  color = ( 0.75, 0.75, 0.75 );   break;
        case "grey":
        case "gray":                    color = ( 0.5, 0.5, 0.5 );      break;
        case "maroon":                  color = ( 0.5, 0, 0 );          break;
        case "olive":                   color = ( 0.5, 0.5, 0 );        break;
        case "green":                   color = ( 0, 0.5, 0 );          break;
        case "purple":                  color = ( 0.5, 0, 0.5 );        break;
        case "teal":                    color = ( 0, 0.5, 0.5 );        break;
        case "navy":                    color = ( 0, 0, 0.5 );          break;
        
        // complex colors
        case "dark red":                color = ( 0.54, 0, 0 );         break;
        case "brown":                   color = ( 0.64, 0.16, 0.16 );   break;
        case "firebrick":               color = ( 0.69, 0.13, 0.13 );   break;
        case "crimson":                 color = ( 0.86, 0.07, 0.23 );   break;
        case "tomato":                  color = ( 1, 0.38, 0.27 );      break;
        case "coral":                   color = ( 1, 0.49, 0.31 );      break;
        case "indian red":              color = ( 0.8, 0.36, 0.36 );    break;
        case "light coral":             color = ( 0.94, 0.5, 0.5 );     break;
        case "dark salmon":             color = ( 0.91, 0.58, 0.47 );   break;
        case "salmon":                  color = ( 0.98, 0.5, 0.44 );    break;
        case "light salmon":            color = ( 1, 0.62, 0.47 );      break;
        case "orange red":              color = ( 1, 0.27, 0 );         break;
        case "dark orange":             color = ( 1, 0.54, 0 );         break;
        case "orange":                  color = ( 1, 0.64, 0 );         break;
        case "gold":                    color = ( 1, 0.84, 0 );         break;
        case "dark golden rod":         color = ( 0.72, 0.52, 0.04 );   break;
        case "golden rod":              color = ( 0.85, 0.64, 0.12 );   break;
        case "pale golden rod":         color = ( 0.93, 0.9, 0.66 );    break;
        case "dark khaki":              color = ( 0.74, 0.71, 0.41 );   break;
        case "khaki":                   color = ( 0.94, 0.9, 0.54 );    break;
        case "yellow green":            color = ( 0.6, 0.8, 0.19 );     break;
        case "dark olive green":        color = ( 0.33, 0.41, 0.18 );   break;
        case "olive drab":              color = ( 0.41, 0.55, 0.13 );   break;
        case "lawn green":              color = ( 0.48, 0.98, 0 );      break;
        case "chart reuse":             color = ( 0.49, 1, 0 );         break;
        case "green yellow":            color = ( 0.67, 1, 0.18 );      break;
        case "dark green":              color = ( 0, 0.39, 0 );         break;
        case "forest green":            color = ( 0.13, 0.54, 0.13 );   break;
        case "lime green":              color = ( 0.19, 0.8, 0.19 );    break;
        case "light green":             color = ( 0.56, 0.93, 0.56 );   break;
        case "pale green":              color = ( 0.59, 0.98, 0.59 );   break;
        case "dark sea green":          color = ( 0.56, 0.73, 0.56 );   break;
        case "medium spring green":     color = ( 0, 0.98, 0.6 );       break;
        case "spring green":            color = ( 0, 1, 0.49 );         break;
        case "sea green":               color = ( 0.18, 0.54, 0.34 );   break;
        case "medium aqua marine":      color = ( 0.4, 0.8, 0.66 );     break;
        case "medium sea green":        color = ( 0.23, 0.7, 0.44 );    break;
        case "light sea green":         color = ( 0.12, 0.69, 0.66 );   break;
        case "dark slate gray":         color = ( 0.18, 0.3, 0.3 );     break;
        case "dark cyan":               color = ( 0, 0.54, 0.54 );      break;
        case "light cyan":              color = ( 0.87, 1, 1 );         break;
        case "dark turquoise":          color = ( 0, 0.8, 0.81 );       break;
        case "turquoise":               color = ( 0.25, 0.87, 0.81 );   break;
        case "medium turquoise":        color = ( 0.28, 0.81, 0.8 );    break;
        case "pale turquoise":          color = ( 0.68, 0.93, 0.93 );   break;
        case "aqua marine":             color = ( 0.49, 1, 0.83 );      break;
        case "powder blue":             color = ( 0.69, 0.87, 0.90 );   break;
        case "cadet blue":              color = ( 0.37, 0.61, 0.62 );   break;
        case "steel blue":              color = ( 0.27, 0.5, 0.7 );     break;
        case "corn flower blue":        color = ( 0.39, 0.58, 0.92 );   break;
        case "deep sky blue":           color = ( 0, 0.74, 1 );         break;
        case "dodger blue":             color = ( 0.11, 0.56, 1 );      break;
        case "light blue":              color = ( 0.67, 0.84, 0.9 );    break;
        case "sky blue":                color = ( 0.52, 0.8, 0.92 );    break;
        case "light sky blue":          color = ( 0.52, 0.8, 0.98 );    break;
        case "midnight blue":           color = ( 0.09, 0.09, 0.43 );   break;
        case "dark blue":               color = ( 0, 0, 0.54 );         break;
        case "medium blue":             color = ( 0, 0, 0.8 );          break;
        case "royal blue":              color = ( 0.25, 0.41, 0.88 );   break;
        case "blue violet":             color = ( 0.54, 0.16, 0.88 );   break;
        case "indigo":                  color = ( 0.29, 0, 0.5 );       break;
        case "dark slate blue":         color = ( 0.28, 0.23, 0.54 );   break;
        case "slate blue":              color = ( 0.41, 0.35, 0.8 );    break;
        case "medium slate blue":       color = ( 0.48, 0.4, 0.93 );    break;
        case "medium purple":           color = ( 0.57, 0.43, 0.85 );   break;
        case "dark magenta":            color = ( 0.54, 0, 0.54 );      break;
        case "dark violet":             color = ( 0.58, 0, 0.82 );      break;
        case "dark orchid":             color = ( 0.6, 0.19, 0.8 );     break;
        case "medium orchid":           color = ( 0.72, 0.33, 0.82 );   break;
        case "thistle":                 color = ( 0.84, 0.74, 0.84 );   break;
        case "plum":                    color = ( 0.86, 0.62, 0.86 );   break;
        case "violet":                  color = ( 0.93, 0.5, 0.93 );    break;
        case "orchid":                  color = ( 0.85, 0.43, 0.83 );   break;
        case "medium violet red":       color = ( 0.78, 0.08, 0.52 );   break;
        case "pale violet red":         color = ( 0.85, 0.43, 0.57 );   break;
        case "hot pink":                color = ( 1, 0.41, 0.7 );       break;
        case "light pink":              color = ( 1, 0.71, 0.76 );      break;
        case "pink":                    color = ( 1, 0.75, 0.79 );      break;
        case "antique white":           color = ( 0.98, 0.92, 0.84 );   break;
        case "beige":                   color = ( 0.96, 0.96, 0.86 );   break;
        case "bisque":                  color = ( 1, 0.89, 0.76 );      break;
        case "blanched almond":         color = ( 1, 0.92, 0.8 );       break;
        case "wheat":                   color = ( 0.96, 0.87, 0.7 );    break;
        case "corn silk":               color = ( 1, 0.97, 0.86 );      break;
        case "lemon chiffon":           color = ( 1, 0.98, 0.8 );       break;
        case "light golden rod yellow": color = ( 0.98, 0.98, 0.82 );   break;
        case "light yellow":            color = ( 1, 1, 0.87 );         break;
        case "saddle brown":            color = ( 0.54, 0.27, 0.07 );   break;
        case "sienna":                  color = ( 0.62, 0.32, 0.17 );   break;
        case "chocolate":               color = ( 0.82, 0.41, 0.11 );   break;
        case "peru":                    color = ( 0.8, 0.52, 0.24 );    break;
        case "sandy brown":             color = ( 0.95, 0.64, 0.37 );   break;
        case "burly wood":              color = ( 0.87, 0.72, 0.52 );   break;
        case "tan":                     color = ( 0.82, 0.70, 0.54 );   break;
        case "rosy brown":              color = ( 0.73, 0.56, 0.56 );   break;
        case "navajo white":            color = ( 1, 0.87, 0.67 );      break;
        case "peach puff":              color = ( 1, 0.85, 0.72 );      break;
        case "misty rose":              color = ( 1, 0.89, 0.88 );      break;
        case "lavender blush":          color = ( 1, 0.94, 0.96 );      break;
        case "linen":                   color = ( 0.98, 0.94, 0.9 );    break;
        case "old lace":                color = ( 0.99, 0.96, 0.9 );    break;
        case "papaya whip":             color = ( 1, 0.93, 0.83 );      break;
        case "sea shell":               color = ( 1, 0.96, 0.93 );      break;
        case "mint cream":              color = ( 0.96, 1, 0.98 );      break;
        case "slate gray":              color = ( 0.43, 0.5, 0.56 );    break;
        case "light slate gray":        color = ( 0.46, 0.53, 0.6 );    break;
        case "light steel blue":        color = ( 0.69, 0.76, 0.87 );   break;
        case "lavender":                color = ( 0.9, 0.9, 0.98 );     break;
        case "floral white":            color = ( 1, 0.98, 0.94 );      break;
        case "alice blue":              color = ( 0.94, 0.97, 1 );      break;
        case "ghost white":             color = ( 0.97, 0.97, 1 );      break;
        case "honeydew":                color = ( 0.94, 1, 0.94 );      break;
        case "ivory":                   color = ( 1, 1, 0.94 );         break;
        case "azure":                   color = ( 0.94, 1, 1 );         break;
        case "snow":                    color = ( 1, 0.98, 0.98 );      break;
        case "dim grey":
        case "dim gray":                color = ( 0.41, 0.41, 0.41 );   break;
        case "dark grey":
        case "dark gray":               color = ( 0.66, 0.66, 0.66 );   break;
        case "light grey":
        case "light gray":              color = ( 0.82, 0.82, 0.82 );   break;
        case "gainsboro":               color = ( 0.86, 0.86, 0.86 );   break;
        case "white smoke":             color = ( 0.96, 0.96, 0.96 );   break;
        
        // couldn't parse color name :(
        default:                                                    break;
    }
    
    return color;
}