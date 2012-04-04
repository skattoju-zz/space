function [GS_azimuth,GS_elevation,dist] = GS_azel(GS_lla,Sat_ECEF)

% function [GS_azimuth,GS_elevation,dist] = GS_azel(GS_llh,Sat_ECEF)
%
% Calculate satellite azimuth and elevation w.r.t. ground station (GS)
%
% Inputs: GS_lla = [lat lon altitude];
% 	  Sat_ECEF = Satellite position in ECEF [X Y Z];
% 
% Outputs: GS_azimuth,GS_elevation (in degress)
%
% Copyright @2012 Scott Gleason 
% License: GNU GPLv3
%
misc_constants

Sat_enu = wgsxyz2enu(Sat_ECEF,GS_lla(1),GS_lla(1),GS_lla(1));


Sat_enu_unit = Sat_enu./norm(Sat_enu);

if(Sat_enu_unit(3) < 0)
	GS_azimuth = 0;
	GS_elevation = 0;
	dist = 0;
else
	GS_azimuth = atan2(Sat_enu_unit(1),Sat_enu_unit(2))*radtodeg;
	GS_elevation = asin(Sat_enu_unit(3))*radtodeg;
	dist = norm(Sat_enu);
end

