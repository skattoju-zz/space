%
% Scott Gleason
% process_telemetry, ground station code
% Copywrite: Gleason 2012, GPLv3
%
clear all
close all

% Read in the downlink file
tlm_data_GPS = load('tlmfile_GPS.dat');
tlm_data_AOCS = load('tlmfile_AOCS.dat');
tlm_data_Comms = load('tlmfile_Comms.dat');
tlm_data_Power = load('tlmfile_Power.dat');

% now it is only GPS data, so no sorting needed
num_rows_GPS = size(tlm_data_GPS,1);
latitude = tlm_data_GPS(:,7);
longitude = tlm_data_GPS(:,8);

load('mapworld.mat')
figure(1)
hold on
plot(world_lon,world_lat)
plot(longitude,latitude,'g*')
xlabel('Longitude')
ylabel('Latitude')
title('Spacecraft Ground Track')
axis([-180 180 -90 90])

% Comms Telemetry
num_rows_Comms = size(tlm_data_Comms,1);
time_min = tlm_data_Comms(:,1)./60;
time_hrs = tlm_data_Comms(:,1)./3600;
GS_az = tlm_data_Comms(:,4);
GS_el = tlm_data_Comms(:,5);
dist_km = tlm_data_Comms(:,6)./1000;
data_tx = (tlm_data_Comms(:,9)./8)./1e6;  % Mbytes

figure(2)
hold on
plot(time_min,GS_az,'k*')
plot(time_min,GS_el,'g*')
xlabel('time (minutes)')
ylabel('Degrees')
legend('Azimuth','Elevation')
title('Spacecraft Azimuth and Elevation')

figure(3)
hold on
plot(time_min,dist_km,'k*')
xlabel('time (minutes)')
ylabel('range (km)')
title('Spacecraft Range')

figure(4)
hold on
plot(time_min,data_tx,'k*')
xlabel('time (minutes)')
ylabel('data received (MB)')
title('Data Downlinked From Spacecraft')

% Power Telemetry
num_rows_Power = size(tlm_data_Power,1);
time_min = tlm_data_Power(:,1)./60;
time_hrs = tlm_data_Power(:,1)./3600;
Array_Power = tlm_data_Power(:,4);
Battery_Charge = tlm_data_Power(:,5);
Battery_Charge_10 = Battery_Charge./10;
Load_Power = tlm_data_Power(:,6);

figure(5)
hold on
plot(time_min,Array_Power,'k*')
plot(time_min,Load_Power,'b*')
plot(time_min,Battery_Charge_10,'g*')
xlabel('time (minutes)')
ylabel('Watts/Percent Charge')
legend('Array Power','Load Power','Battery Charge/10')
title('Spacecraft Power Telemetry')

% AOCS Telemetry
time_min = tlm_data_AOCS(:,1)./60;
time_hrs = tlm_data_AOCS(:,1)./3600;
roll = tlm_data_AOCS(:,4);
pitch = tlm_data_AOCS(:,5);
yaw = tlm_data_AOCS(:,6);

figure(6)
hold on
plot(time_min,roll,'k*')
plot(time_min,pitch,'b*')
plot(time_min,yaw,'g*')
xlabel('time (minutes)')
ylabel('Degrees')
legend('Roll','Pitch','Yaw')
title('Spacecraft Attitude')


