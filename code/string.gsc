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

explode(longStr, separator)  {
   sepcount = 0; //Seperation Counts    -1 default
   string = [];
   longStr += ""; // turn it into a string if it isn't  already   
   for(i = 0; i < longStr.size; i++){
      if(longStr[i] == separator) {
         sepcount++;
      } else {
         if(!isDefined(string[sepcount]))
            string[sepcount] = "";
            
         string[sepcount] += longStr[i];
      }
   }
   
   return string;
}


substring( sString, iStart, iEnd )
{
    if ( !isDefined( iStart ) )
        return sString;
        
    if ( !isDefined( iEnd ) )
        iEnd = sString.size;
        
    sNewString = "";
    
    for ( i = iStart; i < iEnd; i++ )
        sNewString += sString[ i ];

    return sNewString;
}

contains( sString, sOtherString )
{
     // loop through the string to check
    for ( i = 0; i < sString.size; i++ )
    {
		x = 0;
		tmp = "";
		
        // string to check against
        for ( j = 0; j < sOtherString.size; j++ )
        {
			cur = sOtherString[ j ];
			
			if ( ( i + j ) > sString.size )
				break;
				
			next = sString[ i + j ];
			
            if ( cur == next ) 
            {
				tmp += cur;
				x++;
                continue;
            }
			
			break;
        }
        
        // looped through entire string, found it
        if ( x == sOtherString.size && tmp == sOtherString )
            return true;
    }
    
    return false;
}

toupper( sString ) {
    return utilities::strreplacer( sString, "upper" );
}

tolower( sString ) {
    return utilities::strreplacer( sString, "lower" );
}

reverse( str )
{
    ret = "";
    for ( i = str.size - 1; i >= 0; i-- )
        ret += str[ i ];
    return ret;
}


strip(s) {
	if(s == "")
		return "";

	s2 = "";
	s3 = "";

	i = 0;
	while(i < s.size && s[i] == " ")
		i++;

	if(i == s.size)
		return "";
	
	for(; i < s.size; i++) {
		s2 += s[i];
	}

	i = s2.size-1;
	while(s2[i] == " " && i > 0)
		i--;

	for(j = 0; j <= i; j++) {
		s3 += s2[j];
	}
		
	return s3;
}