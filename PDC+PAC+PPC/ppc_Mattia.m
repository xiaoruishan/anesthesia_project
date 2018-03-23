function PPC=ppc_Mattia(experiment,bands,cross,threshold,path)


[num_bands,~]=size(bands);


for iExperiment=1:length(experiment)
    
    if strcmp(cross,'aa')
        experiment(iExperiment).chan_num{1}= experiment(iExperiment).HPreversal; % for spike
        experiment(iExperiment).chan_num{2}= experiment(iExperiment).HPreversal; % for LFP
    end
    if strcmp(cross,'ab')
        experiment(iExperiment).chan_num{1}= experiment(iExperiment).HPreversal; % for spike
        experiment(iExperiment).chan_num{2}= experiment(iExperiment).PL(2); % for LFP
    end
    if strcmp(cross,'ba')
        experiment(iExperiment).chan_num{1}= experiment(iExperiment).PL(1);% for spike
        experiment(iExperiment).chan_num{2}= experiment(iExperiment).HPreversal;% for LFP
    end
    if strcmp(cross,'ca')
        experiment(iExperiment).chan_num{1}= experiment(iExperiment).PL(4);% for spike
        experiment(iExperiment).chan_num{2}= experiment(iExperiment).HPreversal;% for LFP
    end
    if strcmp(cross,'bb')
        experiment(iExperiment).chan_num{1}= experiment(iExperiment).PL(1);% for spike
        experiment(iExperiment).chan_num{2}= experiment(iExperiment).PL(1);% for LFP
    end
    if strcmp(cross,'cb')
        experiment(iExperiment).chan_num{1}= experiment(iExperiment).PL(4);% for spike
        experiment(iExperiment).chan_num{2}= experiment(iExperiment).PL(2);% for LFP
    end
        % obtain LFPs , chan_num{2}
    ExtractModeArray = [];
    downsampling_factor = 10;
    save_data = 0;
    load(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'));
    [~, signal, fs, ~] = nlx_load_Opto(experiment, experiment(iExperiment).chan_num{2}, ExtractModeArray, downsampling_factor, save_data);
    signal1 = signal(1,BaselineTimePoints(1):BaselineTimePoints(2));
    signal2 = signal(1,BaselineTimePoints(3):end-9600);
    clear signal
    signalRaw = horzcat(signal1, signal2);
    clear signal1 & signal2
    fs=round(fs);
    
    %% Crop signal around sharpwaves
    [OscStart, OscEnd] = detection_discont_events(signal, fs);
    num_Oscs=length(OscStart);
    
%% obtain MUA, chan_num{1}
    downsampling_MUA = 1;
    [~, recordingRaw, fs_MUA, ~] = nlx_load_Opto(experiment, experiment(iExperiment).chan_num{1}, ExtractModeArray, downsampling_MUA, save_data);
    fs_MUA = round(fs_MUA);   
    signalMUA1 = recordingRaw(1,BaselineTimePoints(1)*fs_MUA/fs:BaselineTimePoints(2)*fs_MUA/fs);
    signalMUA2 = recordingRaw(1,BaselineTimePoints(3)*fs_MUA/fs:end-9600*fs_MUA/fs);
    clear recordingRaw
    recordingRaw = horzcat(signalMUA1, signalMUA2);
    recordingMUA = ZeroPhaseFilter(recordingRaw,fs_MUA,[500 5000]);
    thr = std(recordingMUA)*threshold;
    [peakLoc, ~] = peakfinderOpto(recordingMUA,0 ,-thr,-1);
    peakLoc=round(peakLoc/downsampling_factor);
    peakLoc(find(peakLoc==0))=1;
    spike_number = length(peakLoc);
    
    % obtain specific frequency
    for num_band=1:num_bands
        band=bands(num_band,:);
        Signal_filtered=ZeroPhaseFilter(signalRaw,fs,band);
        Signal_phase=angle(hilbert(Signal_filtered));
        Spikephase=[];
        for num_Oscs=1:num_Oscs
            S=min(find(peakLoc>=OscStart(1,num_Oscs)));
            E=max(find(peakLoc<=OscEnd(1,num_Oscs)));
            
            spike_phase=Signal_phase(peakLoc(S:E));
            Spikephase=[Spikephase,spike_phase];
        end
        Spikephase = unique(Spikephase);
        SpikephaseMatrix = repmat(Spikephase,length(Spikephase),1);
        PopulationAngularDistance = sum(sum(mod(abs(SpikephaseMatrix-SpikephaseMatrix'),pi)))...
            /(length(Spikephase)*(length(Spikephase-1)));
        PPC(1,num_band) = (pi-2*PopulationAngularDistance)/pi;
    end
end
                    
        
        
        
        