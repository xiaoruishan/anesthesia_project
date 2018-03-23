function getBaselinePDC(signal_sup, signal_deep, time, windowSize, fs, experiment, CSC1, CSC2, save_data)
Path=get_path;
%% load oscillation vectors, and cut and glue the signal

% load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC17'));% num2str(CSC)]));
% oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);
% PFC = arrayfun(@colon, oscTimes(1,:), oscTimes(2,:),'Uniform', false);
% PFC = cell2mat(PFC);
% load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,...
%     filesep,strcat('CSC',num2str(experiment.HPreversal))));% num2str(CSC)]));
% HPoscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);
% HP = arrayfun(@colon, HPoscTimes(1,:), HPoscTimes(2,:),'Uniform', false);
% HP = cell2mat(HP);
% IntSecSamples = intersect(PFC,HP);
% difference1 = diff(IntSecSamples);
% oscEnd = IntSecSamples(difference1>1);
% oscEnd(1,end+1) = IntSecSamples(1,end);
% FlipInt = flip(IntSecSamples);
% difference2 = diff(FlipInt);
% oscStart(1,1) = IntSecSamples(1,1);
% oscStart(1,2:length(oscEnd)) = flip(FlipInt(difference2<-1));

load(strcat(Path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharptimepoints1'));% num2str(CSC)]));
sharptimepoints = sharptimepoints/10; % these timepoints were computed with fs=3200
sharptimepoints = sharptimepoints(sharptimepoints+0.5*fs<length(signal_sup));
oscStart = sharptimepoints-0.5*fs;
oscEnd = sharptimepoints+0.5*fs-1;

[signal_sup, ~]=CutNGlueX(signal_sup,fs, oscStart,oscEnd,windowSize);
[signal_deep, ~]=CutNGlueX(signal_deep,fs, oscStart,oscEnd,windowSize);
signal_sup = reshape(signal_sup.xndetrend,fs,length(signal_sup.xn)/fs);
signal_deep = reshape(signal_deep.xndetrend,fs,length(signal_deep.xn)/fs);

%% compute PAC
nFreqs=1024;
metric='diag'; % 'euc'; 'info'
maxIP=50;
alg=1;
alpha=0.05;
criterion=1;

for segment = 1:size(signal_sup,2)
    signal1=DeNoiseWavelet(signal_sup(:,segment));
    signal2=DeNoiseWavelet(signal_deep(:,segment));
    signal=[signal1 signal2];
    pdc=PDC_computation(signal,nFreqs,metric,maxIP,alg,alpha,criterion);
    if numel(pdc)>0
        PDC{segment}=pdc;
    end
end


%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'PDC',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'PDC',filesep,experiment.name));
    end
    %     save(strcat(Path.output,filesep,'results',filesep,'Coherence',filesep,experiment.name,filesep, ...
    %         ['CSC' num2str(CSC1) num2str(CSC2)]),'ImCoherence')
    save(strcat(Path.output,filesep,'results',filesep,'PDC',filesep,experiment.name,filesep, ...
        ['sharpPDC' num2str(CSC1) num2str(CSC2)]),'PDC')
end
end