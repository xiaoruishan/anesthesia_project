function [R, Rsharp] = spikePhase_cross_4shank_total(experiment,bands,cross,threshold,path)
%written by Xiaxia, 06.01.2017
% use the full signal to detect MUA-LFP phase
% locking

% input:
%       bands--------------------------LFP frquency bands, for example [4 12;12 30;30 48; 52 100]
%       downsampling_factor------------for LFP
%       cross--------'aa','ab','bb','ba'
%       threshold---- for spike detection, for example 4

% output:
%      R--------------R.details, all the phases of the spike happens
%                     R.p, Reiley test
%                     R.phase_rad, mean phase
%                     R.rvl,resultant vector length

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
    if strcmp(cross,'cc')
        experiment(iExperiment).chan_num{1}= experiment(iExperiment).PL(4);% for spike
        experiment(iExperiment).chan_num{2}= experiment(iExperiment).PL(4);% for LFP
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
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
    if exist('sharptimepoints1')
        sharptimepoints = sharptimepoints1;
        clear sharptimepoints1
    end
    SharpStart = sharptimepoints-1.5*fs;
    SharpEnd = sharptimepoints+1.5*fs;
    num_Sharp=length(SharpStart);

%%
    [OscStart, OscEnd] = detection_discont_events_XiaXia(signalRaw, fs,2); % detect oscillations
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
    %peakLoc=round(peakLoc/fs); % change from samples to time
    peakLoc(find(peakLoc==0))=1;
    
    % obtain specific frequency
    for num_band=1:num_bands
        band=bands(num_band,:);
        Signal_filtered=ZeroPhaseFilter(signalRaw,fs,band);
        Signal_phase=angle(hilbert(Signal_filtered));
        
        Spikephase=[];
        for num_Osc=1:num_Oscs
            Rsharp=min(find(peakLoc>=SharpStart(1,num_Osc)));
            E=max(find(peakLoc<=SharpEnd(1,num_Osc)));
            
            spike_phase=Signal_phase(peakLoc(Rsharp:E));
            Spikephase=[Spikephase,spike_phase];
        end
        for num_Sharp=1:num_Oscs
            Ssharp=min(find(peakLoc>=SharpStart(1,num_Sharp)));
            Esharp=max(find(peakLoc<=SharpEnd(1,num_Sharp)));
            
            spike_phase_sharp=Signal_phase(peakLoc(Ssharp:Esharp));
            Spikephase_sharp=[Spikephase,spike_phase_sharp];
        end
        if numel(Spikephase) > 0
            R.details{iExperiment,1}{num_band,1}= Spikephase;
            R.p{iExperiment,1}{num_band,1}=circ_rtest(Spikephase'); %Rayleigh test, small p indicates departure from uniformity
            R.phase_rad{iExperiment,1}{num_band,1}=circ_mean(Spikephase'); %mean resultant vector/preferred phase
            R.rvl{iExperiment,1}{num_band,1}= circ_r(Spikephase'); %resultant vector length/Spike_Phase
        end
        if numel(Spikephase_sharp) > 0
            Rsharp.details{iExperiment,1}{num_band,1}= Spikephase;
            Rsharp.p{iExperiment,1}{num_band,1}=circ_rtest(Spikephase'); %Rayleigh test, small p indicates departure from uniformity
            Rsharp.phase_rad{iExperiment,1}{num_band,1}=circ_mean(Spikephase'); %mean resultant vector/preferred phase
            Rsharp.rvl{iExperiment,1}{num_band,1}= circ_r(Spikephase'); %resultant vector length/Spike_Phase
        end
    end
end




