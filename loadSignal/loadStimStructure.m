function [StimStructure] = loadStimStructure(experiment, CSC, Period, downsampling_factor, signalWindow)

STIM = experiment.STIMchannels;
Path = get_path;

if strcmp(experiment.Exp_type,'yellow')
    load(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected2'));
    StimProperties_all = StimulationProperties_raw;
elseif  exist(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected','.mat'));
%     disp(['Loading StimProperties for ' experiment.name]);
    load(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected'));
    StimProperties_all = StimulationProperties_corrected;
else
    disp('STIM PROPERTIES NOT FOUND');
end
StimProperties={};

%% get STIM names
stimAnalog = ['STIM' num2str(STIM) 'A'];
stimDigital = ['STIM' num2str(STIM) 'D'];
count = 0;
for pp = Period
    count = count + 1;
%     disp(['Converting period ' num2str(count) '/' num2str(length(Period))]);

    %% get stimulus window parameters
    P_start = cell2mat(StimProperties_all(pp,1));
    P_dur = cell2mat(StimProperties_all(pp,3));
    ExtractModeArray(1) = P_start-(signalWindow(1)+0.1)*10^6;
    ExtractModeArray(2) = P_start+(P_dur+signalWindow(2)+0.1)*10^6;

    %% signal, time, fs
    [time, signalX,fs,~] = nlx_load_Opto_JA(experiment,CSC,ExtractModeArray,downsampling_factor,0);
    stimpoint = find(time>=P_start & time<(P_start+mode(diff(time)))); %Finds exact stimulation timepoint for this trial
    signalX = signalX((stimpoint-(signalWindow(1)*fs)):(stimpoint+(P_dur+signalWindow(2))*fs));
    signal(count,:) = signalX;
    
    %% signalD
    [~, signalDX,~,~] = nlx_load_Opto_JA(experiment,stimDigital,ExtractModeArray,downsampling_factor,0);
    signalDX = signalDX((stimpoint-(signalWindow(1)*fs)):(stimpoint+(P_dur+signalWindow(2))*fs));
    signalDX = digital2binary(signalDX);
    signalD(count,:) = signalDX;
    
    %% signalA
    [~, signalAX,~,~] = nlx_load_Opto_JA(experiment,stimAnalog,ExtractModeArray,downsampling_factor,0);
    signalAX = signalAX((stimpoint-(signalWindow(1)*fs)):(stimpoint+(P_dur+signalWindow(2))*fs));
    powerCorrection = analogCorrection(signalAX);
    signalAX = signalAX*powerCorrection;
    signalA(count,:) = signalAX;
    
    %% stimProperties
    StimProperties(count,:) = StimProperties_all(pp,:);
end

time = (time((stimpoint-(signalWindow(1)*fs)):(stimpoint+(P_dur+signalWindow(2))*fs))-P_start)/10^6;

StimStructure=[];
StimStructure = setfield(StimStructure, 'time', time);
StimStructure = setfield(StimStructure, 'signal', signal);
StimStructure = setfield(StimStructure, 'signalA', signalA);
StimStructure = setfield(StimStructure, 'signalD', signalD);
StimStructure = setfield(StimStructure, 'samplingrate', fs);
StimStructure = setfield(StimStructure, 'StimProperties', StimProperties);
StimStructure = setfield(StimStructure, 'CSC', CSC);
end