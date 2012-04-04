function [mjd] = gregorian2mjd(gregorian)

%function [mjd] = gregorian2mjd(gregorian)
%
% Transformation From Gregorian Calender To Modified Julian Date
%
% Public Domain Code 
%
% Gregorian Format Should be YYMMDDHHmmSS.SSSS
%
%	if 20 Century   YY >= 50
%	if 21 Century   YY <= 49

EPS = 1.e-10;

year   = floor(gregorian/1.e10);
sec    = gregorian - year*1.e10;
month  = floor(sec/1.e8);

sec    = sec - month*1.e8;
day    = floor(sec/1.e6);

sec    = sec - day*1.e6;

if ((sec/1.e4) < EPS)
	hour    = 0;
else   
	hour   = floor(sec/1.e4);
	sec    = sec - hour*1.e4;
end

if ((sec/1.e2) < EPS)
	min = 0;
else   
	min    = floor(sec/1.e2);
	sec    = sec - min*1.e2;
end	    
	    
if (year >= 50)
	year = year + 1900;
else
	year = year + 2000;      
end	    


if (month >= 3)  
	year   = year  - 1900;
	month  = month - 3;
else   
	year   = year  - 1901;
	month  = month + 9;
end

day_mjd   = floor(15078 + 1461*year/4 + (153*month + 2)/5 + day);
mjd       = hour/24.e0 + min/1440.e0 + sec/86400.e0;
mjd       = mjd + day_mjd;

%%% end
