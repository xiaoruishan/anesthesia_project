 function getMinuteOscComponents(time, signal, thr, fs, experiment, CSC, save_data)
%% calc oscTimes,Ampl,Duration, and occurence
Path = get_path;


%% Detect osc & calculate power

minute = fs * 60;
n_minutes = floor(length(signal) ./ minute);
OscMatrix = zeros(n_minutes, 5);

for periods = 1 : n_minutes
    signal_minute = signal(minute * (periods - 1) + 1 : minute * periods);
    time_minute = time(minute * (periods - 1) + 1 : minute * periods);
    [oscStart, oscEnd] = detection_discont_events_awa(signal_minute, fs, thr);
    OscMatrix(periods, :) = getMinuteOscInformation(time_minute, signal_minute, fs, oscStart, oscEnd);
%     OscAmplDurOcc. = OscStructure;
end

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data == 1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'MinuteOscComponents',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'MinuteOscComponents',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'MinuteOscComponents',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'OscMatrix')
end
end