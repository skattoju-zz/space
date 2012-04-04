%
% Scott Gleason
% event execute  (in-line code)
% Copywrite: Gleason 2012, GPLv3
%

% Read in the downlink file
downlink_data = load('downlink.dat');

num_rows = size(downlink_data,1);
valid_checksum_count = 0;
bad_checksum_count = 0;
bad_time_count = 0;

start_time = downlink_data(1,1);

new_data_index = 1;
for entry = 1:num_rows

   entry_time = downlink_data(entry,1);
   if(entry_time >= start_time)
	
	data_sum = sum(downlink_data(entry,2:6));
	checksum = downlink_data(entry,7);

	if(data_sum == checksum)
		% save the data, its good
		new_data(new_data_index,:) = downlink_data(entry,:);
		new_data_index = new_data_index + 1;
		valid_checksum_count = valid_checksum_count + 1;
	else
		% don't save the data, its bad
		bad_checksum_count = bad_checksum_count + 1;
		disp('checksum error data entry')
		entry
	end

   else	
	% bad entry time
	disp('time error data entry')
	bad_time_count = bad_time_count + 1;
	entry
   end

end

total_data_entries = num_rows
valid_checksum_count
bad_checksum_count
bad_time_count
