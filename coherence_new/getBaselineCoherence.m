function getBaselineCoherence(signal1,signal2,fs,experiment,save_data,CSC)
parameters=get_parameters;
Path = get_path;

% shuffle signalLFPY and adjust signalLFPX signalLFPY to windowsize for fullsignal shuffledata
nWindowsn = floor(length(signal1)/(fs*parameters.coherence.windowSize));
signalXLFP = signal1(1:nWindowsn*parameters.coherence.windowSize*fs);
signalYLFP = signal2(1:nWindowsn*parameters.coherence.windowSize*fs);
clearvars signal1 signal 2
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
    save(strcat(Path.output,filesep,'results',filesep,'BaselineCoherence',filesep,experiment.name,filesep,num2str(CSC)),'ImCoh')
end