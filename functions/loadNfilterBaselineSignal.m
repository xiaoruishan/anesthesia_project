function [signal_filt,time_to_subtract] = loadNfilterBaselineSignal(experiment,CSC,fs,frequencies_to_filter)

path = get_path;
load(strcat(path.output, 'results', filesep, 'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints'));
security_factor = 9600;

for ii = 1 : length(CSC);
    
    filename = strcat(path.signal, filesep, experiment.name, filesep, strcat('CSC', num2str(CSC(ii)), '.mat'));
    data = matfile(filename);
    if ii == 2 
        signal1 = data.signal(1, BaselineTimePoints(1,1):BaselineTimePoints(1,2));
        signal2 = data.signal(1, BaselineTimePoints(1,3):end-security_factor);
        signal = horzcat(signal1, signal2);
        signal_filt(ii,:) = ZeroPhaseFilter(signal,fs,frequencies_to_filter);
    else
        signal = downsample(data.signal,10);
        signal1 = signal(1, BaselineTimePoints(1,1):BaselineTimePoints(1,2));
        signal2 = signal(1, BaselineTimePoints(1,3):end-security_factor);
        clearvars signal
        signal = horzcat(signal1, signal2);
        signal_filt(ii,:) = ZeroPhaseFilter(signal,fs,frequencies_to_filter);
    end
    
    if ii < 2
        time_to_subtract = data.time(1,1);
    end
    
    clearvars data & signal1 & signal2 & signal3
end
end