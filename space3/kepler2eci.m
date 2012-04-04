function [r_eci] = kepler2eci(a,e,w,i,raan,v)

%
% This function converts kepler elements to ECI pos and vel
%
% function [r_eci,rdot_eci] = kepler2eci(a,e,w,i,raan,v)
%
% r_eci = position vector in ECI, meters
%
% a = semimajor axis (m) 
% e = eccentricity
% w = omega (lower case), argument of perigee (radians)
% i = inclination (radians)
% raan = Omega (upper case), longitude of acending node (radians)
% v = true anomoly (radians)
%
% Copyright @2011 Scott Gleason 
% License: GNU GPLv3
%
% Reference: Montenbruck and Gill, Satellite Orbits, Section 2.2
%

misc_constants

w_rad = w;
i_rad = i;
raan_rad = raan;
v_rad = v;

% determine satelite position in orbital plane
r = a*(1-e^2)/(1+e*cos(v_rad));

% Transform to ECI coordinates

rx = r*(cos(raan_rad)*cos(w_rad+v_rad) - sin(raan_rad)*cos(i_rad)*sin(w_rad+v_rad));
ry = r*(sin(raan_rad)*cos(w_rad+v_rad) + cos(raan_rad)*cos(i_rad)*sin(w_rad+v_rad));
rz = r*(sin(i_rad)*sin(w_rad+v_rad));

% 3D position vector in ECI
r_eci = [rx ry rz];

