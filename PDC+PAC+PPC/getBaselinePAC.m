function getBaselinePAC(signal1, signal2, time, windowSize, fs, experiment, CSC1, CSC2, save_data)
Path=get_path;
%% load oscillation vectors, and cut and glue the signal

if CSC1>100
    load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC1)));
else
    load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC2)));
end
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);
% load(strcat(Path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharptimepoints1'));% num2str(CSC)]));
% sharptimepoints = sharptimepoints/10; % these timepoints were computed with fs=3200
% sharptimepoints = sharptimepoints(sharptimepoints+0.5*fs<length(signal_sup));
% oscTimes(1,:) = sharptimepoints-0.5*fs;
% oscTimes(2,:) = sharptimepoints+0.5*fs-1;
[signal1, ~]=CutNGlueX(signal1,fs, oscTimes(1,:),oscTimes(2,:),windowSize);
[signal2, ~]=CutNGlueX(signal2,fs, oscTimes(1,:),oscTimes(2,:),windowSize);
signal_freq = reshape(signal1.xn,fs,length(signal1.xn)/fs)';
signal_amp = reshape(signal2.xn,fs,length(signal2.xn)/fs)';

%% compute PAC
rangePhase=[1:1:30];
rangeAmplitude=[30:1:100];
fs=320;
cross='ab'; 
measure='mi';
Merge_num=40;

PAC=PAC_computation(signal_freq,signal_amp,rangePhase,rangeAmplitude,cross,measure,fs,Merge_num);

%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'PAC',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'PAC',filesep,experiment.name));
    end
      save(strcat(Path.output,filesep,'results',filesep,'PAC',filesep,experiment.name,filesep, ...
        ['PAC' num2str(CSC1) num2str(CSC2)]),'PAC')
end