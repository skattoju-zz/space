function [pos_ecef] = wgseci2ecef(pos_eci,sideangle)

% [pos_ecef] = wgseci2ecef(pos_eci,sideangle)
%
% Converts position vector from ECI to ECEF given 
% the Grenwich mean sidereal angle in radians
%
% input in columns
%
% Copyright @2012 Scott Gleason 
% License: GNU GPLv3
%

theta = sideangle;
rotation_rate = 7.2921151467E-5;		% Omega_e WGS84 Earth rotation rate, radians/sec

trans_matrix =    [ cos(theta)  sin(theta) 0
             -sin(theta)   cos(theta) 0 
                 0         0     1 ];

pos_ecef = trans_matrix*pos_eci;

%%%% end

