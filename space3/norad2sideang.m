function [sidang] = norad2sideang(year,dayno)

% function [sidereal_angle] = norad2sidang(year,dayno)
%
% Finds mean sidereal angle for conversions from ECI to ECEF
% Input: NORAD year and day number
% Output: angle from equinox to Greenwich Meridian in radians
%
% Public Domain Code
%

seconds_in_day = 86400;
year    = year - 1900 - 1;
g0101 = year*1.e10 + 1231235959.999e0;

%  1 msec before 1st of Jan. of this Year (response predictable)

m0101 = gregorian2mjd (g0101);
m0101 = m0101 + (1.0E-3/seconds_in_day);	% Add millisecond back

% grego[1] = MJD of 1st of Jan. of this Year

mjd = m0101 + dayno - 1.e0;
%mjd = 5.204605092592620e+004

% NORAD Defined Day Number of 1st Jan 0:00 UTC = 1 Not 0 */

sidang = 0.0;
S2 = 0.092;		% Seconds / Century^2 - 2nd order sidereal motion
S1 = 8640184.542;	% Seconds / Century  - 1st order   "          " 
S0 = 23925.836;		% Seconds - sidereal offset 
Dc = 36525.0;		% solar days in century
T1900m = 15019.5;	% Mod.Julian date for noon Jan 0th 1900 (Dec 31 1899)
We84 = 7.2921151467e-5;	% Earth Ang rot. rate WGS84, rad/sec
	    
mjd0 = floor(mjd);	% MJD of preceding midnight GMT
Td = mjd - mjd0;	% Time since last midnight, days 
Tu = (mjd0 - T1900m)/Dc;	% Midnight: Time since 1900 in centuries

% Find sidereal angle last midnight (reference angle)
sidang0 = (S0 + S1*Tu + S2*Tu*Tu)*2*pi/seconds_in_day;

% Finally return sidereal angle at desired time (radians)
sidang = sidang0 + We84 * Td * seconds_in_day;                   
sidang = mod(sidang,(2*pi));
    
% NB, sidang0 actually only needs updating once every day
% If tight for processing, could remove from loop

