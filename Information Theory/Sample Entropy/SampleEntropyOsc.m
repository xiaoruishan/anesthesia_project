function SampleEntropyOsc(experiment,signal,time,fs,CSC,save_data)

%% cut and glue signal

Path=get_path;
parameters=get_parameters;
load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);
signalGlued=CutNGlueX(signal,fs,oscTimes(1,:),oscTimes(2,:),parameters.powerSpectrum.windowSize);
if numel(signalGlued.xndetrend)==0
    signalOsc=signal;
    n_windows=floor(length(signalOsc)/(fs*parameters.powerSpectrum.windowSize));
    signalOsc=signalOsc(1:n_windows*fs*parameters.powerSpectrum.windowSize);
    signalOsc=reshape(signalOsc,n_windows,length(signalOsc)/n_windows);
else
    signalOsc=reshape(signalGlued.xndetrend,signalGlued.Nwindows,length(signalGlued.xndetrend)/signalGlued.Nwindows);
    n_windows=signalGlued.Nwindows;
end
clearvars signalGlued signal

%% compute SE
SE=zeros(n_windows,1);
for window=1:n_windows
    r=0.2*std(signalOsc(window,:));
    SE(window)=SampEn(2,r,signalOsc(window,:));
end

%% save data

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'SampleEntropy',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'SampleEntropy',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'SampleEntropy',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'SE')
end