function getBaselineCoherenceOsc(time,signal1,signal2,fs,experiment,save_data,CSC)
parameters=get_parameters;
Path = get_path;

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6)';

param.win_points=floor(parameters.coherence.windowSize.*fs);
param.minwindowN=1;
[CUTNGLUED] = CutNGlueXY(signal1,signal2,oscTimes,fs,param);
clearvars signal1 signal2

% shuffle signalLFPY and adjust signalLFPX signalLFPY to windowsize for fullsignal shuffledata
nWindowsn = floor(length(CUTNGLUED.xn)/(fs*parameters.coherence.windowSize));
signalXLFP = CUTNGLUED.xn(1:nWindowsn*parameters.coherence.windowSize*fs);
signalYLFP = CUTNGLUED.yn(1:nWindowsn*parameters.coherence.windowSize*fs);

clearvars signalX signalY

signalYLFPsegments = reshape(signalYLFP,[fs*parameters.coherence.windowSize,nWindowsn])';
randperm_idx = randperm(nWindowsn);
win_points = parameters.coherence.windowSize*fs;
for ii = 1:nWindowsn
    signalYLFPn((win_points*(ii-1)+1):(win_points*ii)) =  signalYLFPsegments(randperm_idx(ii),:);
end

% Imaginary Coherence (Guido Nolte)
[Cxy,freq]=ImCohere(signalXLFP,signalYLFP,parameters.coherence.windowSize,parameters.coherence.overlap,parameters.coherence.nfft,fs);
[Cxyn,~]=ImCohere(signalXLFP,signalYLFPn,parameters.coherence.windowSize,parameters.coherence.overlap,parameters.coherence.nfft,fs);
freq=freq(freq<=parameters.coherence.maxFreq);
Cxy=Cxy(1:length(freq));
Cxyn=Cxyn(1:length(freq));
ImCoh.freq=freq;
ImCoh.Coh=Cxy;
ImCoh.Dummy=Cxyn;
clearvars Cxy freq Cxyn freqn 

%% save data
if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineCoherence',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'BaselineCoherence',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'BaselineCoherence',filesep,experiment.name,filesep,'Osc',num2str(CSC)),'ImCoh')
end