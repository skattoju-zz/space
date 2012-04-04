%
% Scott Gleason
% event execute  (in-line code)
% Copywrite: Gleason 2012, GPLv3
%

status = 0;
events(event_num).count = events(event_num).count + 1;

switch(event_num)
  case 1
	% EVENT 1: 5 Minute System Actions

  case 2
	% EVENT 2: 1 Minute System Telemetry Requests

	% Request Position Update From GPS Receiver
	XYZ = [7 8 9];
	LLH = [10 20 30];
	GPS_status = 11;
	GPS_ID = 100;

	% Request Attitude System Telemetry
	A=[1 0 0;0 1 0;0 0 1];
	RPY=[1 2 3];
	RPY_dot=[0.1 0.2 0.3];
	AOCS_status = 5;
	AOCS_ID = 101;

	% Request tlemetry from other subsystems 
	dt = events(2).interval;
	Array_Power=1;
	Battery_Charge=2;
	Load_Power=3;
	Power_status=4;
	POWER_ID = 102;

testx = testx+dt;
	% store information in telemetry logfile for downlink

	% write GPS telemetry
        fprintf(telemetryfile_GPS,'%i %i %i ', sim_current_duration_seconds, GPS_ID, GPS_status);
        fprintf(telemetryfile_GPS,'%f %f %f %f %f %f \n',XYZ(1),XYZ(2),XYZ(3),LLH(1),LLH(2),LLH(3));

	% write AOCS telemetry
        fprintf(telemetryfile_AOCS,'%i %i %i ', sim_current_duration_seconds, AOCS_ID, AOCS_status);
        fprintf(telemetryfile_AOCS,'%f %f %f %f %f %f \n',RPY(1),RPY(2),RPY(3),RPY_dot(1),RPY_dot(2),RPY_dot(3));

	% write Power telemetry
        fprintf(telemetryfile_Power,'%i %i %i ', sim_current_duration_seconds, POWER_ID, Power_status);
        fprintf(telemetryfile_Power,'%f %f %f \n',Array_Power,Battery_Charge,Load_Power);

  case 3
	% Downlink Events
	% every 10 seconds calculate Ground Station az el

	GS_azimuth = 0;
	GS_elevation = -200;
	if(exist('XYZ')==1)
		GS_azimuth = 1;
		GS_elevation = 12;
		dist = 3e6;
	end

	COMMS_ID = 103;
	if(GS_elevation > 10)

		if(comms_event == 0)   % write log first time only
	        	fprintf(logfile,'Comms event at %i %i %i %i %i %i %i %i\n', sim_current_duration_seconds, ymdhmss_data);
		end

		comms_event = 1;
		dtime = events(3).interval;
			
		% call communications script
		uplink=4;
		downlink=5;
		data_transmitted_total=6e6;
		Comms_status = 1;

		% write Comms telemetry
        	fprintf(telemetryfile_Comms,'%i %i %i ', sim_current_duration_seconds, COMMS_ID, Comms_status);
        	fprintf(telemetryfile_Comms,'%f %f %f %f %f %f \n',GS_azimuth,GS_elevation,dist,uplink,downlink,data_transmitted_total);

	else
        	fprintf(telemetryfile_Comms,'%i %i %i ', sim_current_duration_seconds, COMMS_ID, 0);
        	fprintf(telemetryfile_Comms,'%f %f %f %f %f %f \n',0,0,0,0,0,0);
		comms_event = 0;
	end

  case 4

	% Payload Event

	payload_event = 1;
	payload_event_duration_secs = 30*60;  % in seconds

        fprintf(logfile,'Payload event at %i %i %i %i %i %i %i %i\n', sim_current_duration_seconds, ymdhmss_data);

	events(4).active_flag = 1;   % re-activate event
	events(4).execute_time = events(4).execute_time + events(4).interval;  % set new time

  otherwise
        status = 99;

end

