%
% Copyright @2011 Scott Gleason 
% License: GNU GPLv3
%

radtodeg = 180/pi;
degtorad = pi/180;
seconds_in_hour = 60*60;
seconds_in_day = 60*60*24;

% constants_km_sec_rad
% constants in km sec rad

% eccentricity of earth
e_earth = 0.08182;
% rotational rate of the earth rad/sec
w_earth = 7.292115856e-5;
% radius of the earth
R_earth = 6378.145;

%% numbers from S/C Att Det and Control, Wertz, Appendix L
% Sun radius of Mercury km
SR_merc = 57.9e6;
% Sun radius of Venus km
SR_venus = 108.2e6;
% Sun radius of Earth km
SR_earth = 149.59965e6;
% Sun radius of Mars km
SR_mars = 227.9e6;
% Sun radius of Jupiter km
SR_jupiter = 778.3e6;
% Sun radius of Saturn km
SR_saturn = 1427.0e6;

% gravitational parameter km^3/sec^2
u = 3.986012e5;
% radius to the moon km
r_moon = 384400;
% moons gravitational parameter km^3/sec^2
u_moon = 4.902794e3;
% Suns gravitational parameter km^3/sec^2
u_sun = 1.3271544e11;
% Mars gravitational parameter km^3/sec^2
u_venus = 324858.8;
% Mars gravitational parameter km^3/sec^2
u_mars = 42828.29;
% venus radius km
R_venus = 6052;
% mars radius km
R_mars = 3410;
% earths J2 oblateness  term
J2_earth = 1.0827e-3;

%%

