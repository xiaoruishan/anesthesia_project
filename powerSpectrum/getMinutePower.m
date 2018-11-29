function getMinutePower(signal, fs, experiment, CSC, save_data, median_power)

Path = get_path;
parameters = get_parameters;
if nargin < 6
    median_power = 0;
end

%% calc power on full signal
minute = fs * 60;
n_minutes = floor(length(signal) ./ minute);
pWelch = zeros(n_minutes, 3201);

if median_power == 0
    for periods = 1 : n_minutes
        signal_minute = signal(minute * (periods - 1) + 1 : minute * periods);
        [pWelch(periods, :), ~, ~] = pWelchSpectrum(signal_minute, 5, [], parameters.powerSpectrum.nfft, ...
            fs, 0.95, 250);
    end
else
    for periods = 1 : n_minutes
        signal_minute = signal(minute * (periods - 1) + 1 : minute * periods);
        [pWelch(periods, :), ~] = medianSpectrum(signal_minute, 5, [], parameters.powerSpectrum.nfft, ...
            fs, 250);
    end
end


if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data == 1
    % data structure
    if ~exist(strcat(Path.output, filesep, 'results', filesep, 'MinutePower', filesep, experiment.name))
        mkdir(strcat(Path.output, filesep,'results', filesep, 'MinutePower', filesep, experiment.name));
    end
    if median_power == 0
        save(strcat(Path.output, filesep, 'results', filesep, 'MinutePower', filesep, experiment.name, ...
            filesep, ['CSC' num2str(CSC)]), 'pWelch')
    else
        save(strcat(Path.output, filesep, 'results', filesep, 'MinutePower', filesep, experiment.name, ...
            filesep, ['CSC' num2str(CSC) 'median']), 'pWelch')
    end
end