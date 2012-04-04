function [execute_flag] = event_check(active_flag, type, timer, interval, execute_time)
%
% Scott Gleason
% satellite simulation 1
% Copywrite: Gleason 2012, GPLv3
%
global sim_time_seconds ymdhmss_data

execute_flag = 0;

% Is event ACTIVE
if(active_flag == 1)

    % Is event periodic
    if(type == 1)

        if(timer >= interval)
            % execute event
            execute_flag = 1;
        end
    
    end
    
    % Is event a timed execute
    if(type == 2)

        if(sim_time_seconds >=  execute_time)
            % execute event
            execute_flag = 1;
            
            sim_time_seconds;
            execute_time;
            ymdhmss_data;
            
        end
    end

end  % end if ACTIVE     

