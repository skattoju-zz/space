% Scott Gleason
%
% satellite simulation 1
%
% Copywrite: Gleason 2012, GPLv3
%
clear all
close all
format long

% define globals
global sim_time_seconds ymdhmss_data

% Initialize a few things
sim_start_time.usec = 0;
sim_start_time.sec = 0;
sim_start_time.min = 0;
sim_start_time.hour = 19;
sim_start_time.mday = 4;
sim_start_time.mon = 0;
sim_start_time.year = 112;  % from 1900?
sim_start_time.zone = 'UTC';
sim_start_time_seconds = mktime(sim_start_time);   % takes local time, seconds from epoch
computer_start_time_seconds = time();  % seconds from epoch
sim_time_seconds = sim_start_time_seconds;

sim_time_ymdhmss = gmtime(sim_time_seconds)
ymdhmss_data = [sim_time_ymdhmss.year+1900 sim_time_ymdhmss.mon sim_time_ymdhmss.mday sim_time_ymdhmss.hour sim_time_ymdhmss.min  sim_time_ymdhmss.sec  sim_time_ymdhmss.usec]

diff1_hours= (sim_start_time_seconds - computer_start_time_seconds)/3600  % sanity check

local_time_diff = -5;
% Load input file
indata = load('simulation_1_input.dat');
downlink_time1.usec = indata(1,7);
downlink_time1.sec = indata(1,6);
downlink_time1.min = indata(1,5);
downlink_time1.hour = indata(1,4)+local_time_diff;   % need proper function!!!!!
downlink_time1.mday = indata(1,3);
downlink_time1.mon = indata(1,2);
downlink_time1.year = indata(1,1) - 1900;  % from 1900?
downlink_time1.zone = 'UTC';
downlink_time1_seconds = mktime(downlink_time1);   % takes local time, seconds from epoch
downlink_time2.usec = indata(2,7);
downlink_time2.sec = indata(2,6);
downlink_time2.min = indata(2,5);
downlink_time2.hour = indata(2,4)+local_time_diff;  % need proper function!!!!!!
downlink_time2.mday = indata(2,3);
downlink_time2.mon = indata(2,2);
downlink_time2.year = indata(2,1) - 1900;  % from 1900?
downlink_time2.zone = 'UTC';
downlink_time2_seconds = mktime(downlink_time2);   %  takes local time, seconds from epoch

diff1_min= (downlink_time1_seconds - sim_start_time_seconds)/60  % sanity check
diff2_min= (downlink_time2_seconds - sim_start_time_seconds)/60  % sanity check

% Open output files
logfile = fopen("logfile1.txt", "w");
downlinkfile = fopen("downlink.dat", "w");

% loop throught time
%simulation_seconds = 10;
%simulation_seconds = 7200;  % 2 hours
simulation_seconds = 86400;  % 1 day

%realtime_flag = 1;  % run in real time
realtime_flag = 0;  % run in accelerated time

%time_step = 1;  % seconds
time_step = 10;  % seconds

% Initialize Events, 10 max
for event_num = 1:10
    events(event_num).type = 0;     % 1 = periodic, 2 = time execute
    events(event_num).ID = 0;
    events(event_num).timer = 0;
    events(event_num).interval = 0;
    events(event_num).count = 0;
    events(event_num).active_flag = 0;   % 0 = OFF, 1 = ON
    events(event_num).execute_time = 0;
end

% Create Events, [Read from Uplink File]

events(1).type = 1;
events(1).ID = 1;
events(1).timer = 0;
events(1).interval = 5*60;  % 5 minutes in seconds
events(1).count = 0;
events(1).active_flag = 1;
events(1).execute_time = 0;

events(2).type = 1;
events(2).ID = 2;
events(2).timer = 0;
events(2).interval = 90*60;  % 90 minutes in seconds
events(2).count = 0;
events(2).active_flag = 1;
events(2).execute_time = 0;

events(3).type = 2;
events(3).ID = 3;
events(3).timer = 0;
events(3).interval = 0;
events(3).count = 0;
events(3).active_flag = 1;
events(3).execute_time = downlink_time1_seconds;

events(4).type = 2;
events(4).ID = 4;
events(4).timer = 0;
events(4).interval = 0;
events(4).count = 0;
events(4).active_flag = 1;
events(4).execute_time = downlink_time2_seconds;

number_of_events = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% intitalize data store
data_store = zeros(100,2);
data_checksum = zeros(100,1);

for x = 1:simulation_seconds

    % Check for events
    for event_num = 1:number_of_events

        % check event
        [execute_flag] = event_check(events(event_num).active_flag,
                                         events(event_num).type,
                                         events(event_num).timer,
                                         events(event_num).interval,
                                         events(event_num).execute_time);   % call function

        % update event time counter
        if(events(event_num).type == 1)
            events(event_num).timer = events(event_num).timer + time_step;
        end

        if(execute_flag == 1)

            % execute event
            event_execute   % run in-line script
            
            if(events(event_num).type == 1)
                events(event_num).timer = 0;
            end
            if(events(event_num).type == 2)
                events(event_num).active_flag = 0;  % turn OFF
            end

        end
    
    end
 
    % increment simulation time
    sim_time_seconds = sim_time_seconds + time_step;
    sim_time_ymdhmss = gmtime(sim_time_seconds);
    sim_current_duration_seconds = sim_time_seconds - sim_start_time_seconds;

    % convert time
    ymdhmss_data = [sim_time_ymdhmss.year+1900 sim_time_ymdhmss.mon sim_time_ymdhmss.mday sim_time_ymdhmss.hour sim_time_ymdhmss.min  sim_time_ymdhmss.sec  sim_time_ymdhmss.usec];

    if(realtime_flag == 1)
        sleep(time_step);  % pause for 1 second
    end 

    
end	% time loop

% close files
fclose(logfile);
fclose(downlinkfile);

%%%%%%
