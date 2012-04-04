%
% Scott Gleason
% event execute  (in-line code)
% Copywrite: Gleason 2012, GPLv3
%

status = 0;
events(event_num).count = events(event_num).count + 1;

switch(event_num)
  case 1
	% generate data and calculate checksum
        checksum = 0;
	for x = 1:5
	   raw_data = floor(rand(1)*100);
           checksum = checksum + raw_data;
	   tempdata(x) = raw_data;
	end

	data_entry = [sim_time_seconds tempdata checksum];

        % store data entry, data points plus checksum
        data_store(events(1).count,:) = data_entry;

  case 2
	% open
  case 3
        for x = 1:events(1).count
	        for y = 1:data_entry_size
            		fprintf(downlinkfile, '%i ',data_store(x,y));
		end
      		fprintf(downlinkfile,'\n');
        end
        data_store = zeros(100,data_entry_size);

        fprintf(logfile,'%i %i %i %i %i %i %i %i\n', sim_current_duration_seconds, ymdhmss_data);
        fprintf(logfile,'executed event 3\n');
        fprintf(logfile, '%i \n',events(1).count);
        events(1).count = 0;

  case 4
        for x = 1:events(1).count
	        for y = 1:data_entry_size
            		fprintf(downlinkfile, '%i ',data_store(x,y));
		end
      		fprintf(downlinkfile,'\n');
        end
        data_store = zeros(100,data_entry_size);

        fprintf(logfile,'%i %i %i %i %i %i %i %i\n', sim_current_duration_seconds, ymdhmss_data);
        fprintf(logfile,'executed event 4\n');
        fprintf(logfile, '%i \n',events(1).count);
        events(1).count = 0;

  otherwise
        status = 99;

end

