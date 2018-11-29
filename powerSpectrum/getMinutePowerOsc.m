function getMinutePowerOsc(signal, time, fs, experiment, CSC, save_data, median_power)

Path = get_path;
parameters = get_parameters;
if nargin < 6
    median_power = 0;
end

%% load oscillations

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes = round((OscAmplDurOcc.('baseline').OscTimes - time(1, 1)) * fs / 10^6);
oscTimes_minutes = ceil(oscTimes / (fs * 60));
        
%% calc power on full signal

n_osc = size(oscTimes, 2);
power = zeros(n_osc, 3201);
if median_power == 0
    for osc = 1 : n_osc
        signal_osc = signal(oscTimes(1, osc) : oscTimes(2, osc));
        [power(osc, :), ~, ~] = pWelchSpectrum(signal_osc, 1, [], parameters.powerSpectrum.nfft, fs, 0.95, 250);
    end
else
    for osc = 1 : n_osc
        signal_osc = signal(oscTimes(1, osc) : oscTimes(2, osc));
        [power(osc, :), ~] = medianSpectrum(signal_osc, 1, [], parameters.powerSpectrum.nfft, fs, 250);
    end
end

pWelchOsc = zeros(15, 3201);
for minute = 1 : 15
    pWelchOsc(minute, :) = nanmedian(power(oscTimes_minutes(1, :) == minute, :));
end

if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    if ~exist(strcat(Path.output,filesep,'results',filesep,'MinutePowerOsc',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'MinutePowerOsc',filesep,experiment.name));
    end
    if median_power == 0
        save(strcat(Path.output, filesep, 'results', filesep, 'MinutePowerOsc', filesep, ...
            experiment.name, filesep, ['CSC' num2str(CSC)]), 'pWelchOsc')
    else
        save(strcat(Path.output, filesep, 'results', filesep, 'MinutePowerOsc', filesep, ...
            experiment.name, filesep, ['CSC' num2str(CSC) 'median']), 'pWelchOsc')
    end
end