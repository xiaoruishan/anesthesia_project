function getSecondPower(signal, fs, experiment, CSC, save_data)
Path=get_path;
window_size = 1;
overlap = 0;
nfft = fs;
n_windows = floor(length(signal) / fs);
signal = signal(1 : fs * n_windows);
signal = reshape(signal, n_windows, []);

for window = 1 : size(signal,1)
    
    [SecondPower(window,:), ~, ~] = pWelchSpectrum(signal(window,:), window_size, overlap, nfft, fs, 0.95, fs/2);
    
end
    
%% save data

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'SecondPower',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'SecondPower',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'SecondPower',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'SecondPower')
end