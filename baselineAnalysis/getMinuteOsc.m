 function getMinuteOsc(time, fs, experiment, CSC, save_data)
%% calc oscTimes,Ampl,Duration, and occurence

path = get_path;
load(strcat(path.output, filesep, 'results\BaselineOscAmplDurOcc\', experiment.name,filesep, ...
    'CSC', num2str(CSC), '.mat'))

%% Detect osc & calculate power

minute = fs * 60;
oscTimes = round((OscAmplDurOcc.(['baseline']).OscTimes - time(1, 1)) * fs / 10^6);
try
    if oscTimes(1) == 0
        oscTimes(1) = 1;
    end
    signal = zeros(size(time));
    for event = 1 : size(oscTimes, 2)
        signal(oscTimes(1,event) : oscTimes(2, event)) = 1;
    end
catch
    signal = zeros(size(time));
end

minutes =  floor(length(signal) / minute);
signal = signal(1 : minute * minutes);
signal = mean(reshape(signal, minute, []));

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data == 1
    % data structure
    if ~exist(strcat(path.output,filesep,'results',filesep,'MinuteOsc',filesep,experiment.name));
        mkdir(strcat(path.output,filesep,'results',filesep,'MinuteOsc',filesep,experiment.name));
    end
    save(strcat(path.output,filesep,'results',filesep,'MinuteOsc',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'signal')
end
end