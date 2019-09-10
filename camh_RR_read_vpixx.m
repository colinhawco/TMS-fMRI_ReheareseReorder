function out = camh_RR_read_vpixx(file, run)
% out: run type onset_times dur(0) resp resp_RT
fid = fopen(file);

stop = 0;
trial = 0;
resp=1;
while stop == 0
    
    ln = textscan(fid, '%s', 1, 'Delimiter', '\n');
    
    %find stat point
    if findstr(ln{1}{1}, 'start') ~= 0
        tt = strsplit(ln{1}{1});
        start = str2num(tt{3});
        ln = textscan(fid, '%s', 1, 'Delimiter', '\n');
    end
    
    if findstr(ln{1}{1}, 'trial') ~= 0
        tstart = 1; 
    end
    
    % trial type
    if findstr(ln{1}{1}, 'rehearse') ~= 0
        type = 1;
    end
    if findstr(ln{1}{1}, 'reorder') ~= 0
        type = 2;
    end
    
    if findstr(ln{1}{1}, 'End Trial') ~= 0
        nr=0;
        if resp == 0
            nr=1;
            trialendtime = trons-trialtime+2.1;
        end
    end
    
    
    % TMS onset time. The trial acrually starts 2.5 seconds before the TMS
    if findstr(ln{1}{1}, 'TMS ') ~= 0
        trial = trial+1;
        out(trial,1) = run;
        out(trial,2) = type;
        tt = strsplit(ln{1}{1});
        out(trial,3) = (str2num(tt{4})- start)-2.5;
        out(trial,4) = 0;
        trialtime = str2num(tt{3})-2.5;
        resp = 0; %will record the next button press as the response
        nr=0;
    end
    
    if findstr(ln{1}{1}, 'Keyboard') ~= 0
        tt = strsplit(ln{1}{1});
        if (str2num(tt{2}) < 5) && (resp==0);
            if nr ==1 
                RT = str2num(tt{3}) + trialendtime - 8 - trial_delay; % RT
                if RT > 0.1
                    out(trial,6) = RT;
                    out(trial,5) = str2num(tt{2}); % response button
                    resp = 1;
                end
            else
                RT =  str2num(tt{3}) - trialtime -8; % RT
                 if RT > 0.1
                    out(trial,6) = RT;
                    out(trial,5) = str2num(tt{2}); % response button
                    resp = 1;
                end
            end
            
        elseif (str2num(tt{2}) == 5)
            trons = str2num(tt{3});
            if tstart==1
                trial_delay = trons;
                tstart=0; 
            end
        end
    end
    
    if findstr(ln{1}{1}, 'SORTED ') ~= 0
        stop = 1;
    end
end

fclose(fid);




