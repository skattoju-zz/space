% Orbits assignment
% assignment_solution_part_a
% 
% Write a Octave/Matlab scipt to simulate the NORAD two-line elements below for 100 minutes.
% Starting at Midnight January 18th 2012
%
% Copyright @2012 Scott Gleason 
% License: GNU GPLv3
%
%AAU CUBESAT  (Aalborg University)             
%1 27846U 03031G   12013.00100966  .00000212  00000-0  11743-3 0  1843
%2 27846  98.6960  24.2001 0008665 295.4793  64.5490 14.21225585442823
%

close all
clear all
misc_constants

% The orbital elements for the above TLE are,
i = 98.6960*deg2rad;                % inclination
raan = 24.2001*deg2rad;            % right ascension of the ascending node (upper case omerga)
e = 0.0008665;                       % eccentricity
w = 295.4793*deg2rad;                % argument of perigee (lower case omega)
M0 = 64.5490*deg2rad;              % Mean anomaly reference point
NORAD_year = 2012;
NORAD_dayno = 13.00100966;

n = 14.21225585;                     % mean motion in REVOLUTIONS PER DAY!
% convert to radians per second
n_rads_per_s = (2*pi*n)/seconds_in_day;
% calculate orbital period
T = (2*pi)/n_rads_per_s;    % in seconds
T_minutes = T/60;           % gives us a reference for checking results, should perform 1 orbit in this time

% calculate a from T
a = T2a(T);                         % semi-major axis

% Simulation Start Time: January 18th 2012, 00:00:00
% calculate start_time_delta, difference between TLE time and simulation start time
start_time_dayno = 18;
start_time_delta = (start_time_dayno - NORAD_dayno)*(86400);  % seconds

% create a time loop of 100 minutes, in 10 second steps
% keep everyting in radians
index = 1;
sim_duration_minutes = 100;
for dt = start_time_delta:10:start_time_delta+sim_duration_minutes*60

    % find the mean anomaly at this time, i.e. at M0 plus start_time_delta + elapsed time
    M = M0 + n_rads_per_s*dt;

    % calculate eccentric anomaly from mean anomaly
    E = M2E(M,e);

    % calculate true anomaly from eccentric anomaly
    v = E2v(E,e);

    % convert elements to ECI
    [r_eci] = kepler2eci(a,e,w,i,raan,v);    % km

    % calculate sidereal hour angle
    [sidereal_angle] = norad2sideang(NORAD_year,NORAD_dayno);

    % rotate to ECEF
    [r_ecef] = wgseci2ecef(r_eci',sidereal_angle);   % r_eci as a column in km

    % convert to Latitude and Longitude
    [lat,lon,alt] = wgsxyz2lla(r_ecef.*1000);   % output in degrees

    % save a few things
    v_save(index) = v*rad2deg;
    dtime_save(index) = dt;
    lat_save(index) = lat;   % degrees
    lon_save(index) = lon;   % degrees

index = index + 1;

end

figure(1);clf
plot(dtime_save,v_save,'k')
xlabel('Time (seconds)')
ylabel('True Anomaly (degrees)')
title('True Anomaly Over 100 Minutes')

load('mapworld.mat')
figure(2)
hold on
plot(world_lon,world_lat)
plot(lon_save,lat_save,'g*')
xlabel('Longitude')
ylabel('Latitude')
title('Spacecraft Ground Track')
axis([-180 180 -90 90])

