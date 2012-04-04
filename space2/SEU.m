% Scott Gleason
%
% satellite simulation 1
%
% Copywrite: Gleason 2012, GPLv3
%

% secretly add data corruptions to data

% how many SEU's have there been?

time_seconds = 20*60;  % 20 minutes

num_SEUs = binornd(time_seconds,0.001)

for x = 1:num_SEUs

   % what data entry 
   seu_event = floor(events(1).count*rand(1)) + 1	
   seu_datapoint = floor(data_entry_size*rand(1)) + 1	

   corrupt_data = floor(100*rand)	

   % change a value in the data store	
   data_store(seu_event,seu_datapoint) = corrupt_data;

end

seu_count = seu_count + 1;
