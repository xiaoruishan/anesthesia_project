function R= spikePhase_cross_4shank(experiment,bands,downsampling_factor,cross,threshold)
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
       experiment(iExperiment).chan_num{2}= experiment(iExperiment).PL(2);% for LFP
    end
    if strcmp(cross,'cb')
       experiment(iExperiment).chan_num{1}= experiment(iExperiment).PL(4);% for spike
       experiment(iExperiment).chan_num{2}= experiment(iExperiment).PL(2);% for LFP
    end
    % obtain LFPs , chan_num{2}
    ExtractModeArray = [];
    downsampling_factor = 32;
    save_data = 0;
    [~, signalRaw, fs, ~] = nlx_load_Opto(experiment, experiment(iExperiment).chan_num{2}, ExtractModeArray, downsampling_factor, save_data);
    fs=round(fs);
    signalRaw=signalRaw(100*fs:end-100*fs); % crop 100s data
    
    % Crop signal around sharpwaves
    
    [oscStart, oscEnd] = detection_discont_events(signalRaw, fs,2); % detect oscillations
    num_Oscs=length(oscStart);
    
    % obtain MUA, chan_num{1}
      File= strcat(experiment(iExperiment).path,filesep,experiment(iExperiment).name,'\CSC',num2str(experiment(iExperiment).chan_num{1}),'.ncs');
      [~, recordingRaw,samplingrate_MUA] = load_nlx(File,ExtractModeArray);               
       samplingrate_MUA = round(samplingrate_MUA);
         
       recordingRaw=recordingRaw(100*samplingrate_MUA:end-100*samplingrate_MUA); % crop 100s data
       recordingMUA = ZeroPhaseFilter(recordingRaw,samplingrate_MUA,[500 5000]);
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
            S=min(find(peakLoc>=oscStart(1,num_Osc)));
            E=max(find(peakLoc<=oscEnd(1,num_Osc)));
            
            spike_phase=Signal_phase(peakLoc(S:E));
            Spikephase=[Spikephase,spike_phase];
        end
        
        R.details{iExperiment,1}{num_band,1}= Spikephase;
        R.p{iExperiment,1}{num_band,1}=circ_rtest(Spikephase'); %Rayleigh test, small p indicates departure from uniformity
        R.phase_rad{iExperiment,1}{num_band,1}=circ_mean(Spikephase'); %mean resultant vector/preferred phase
        R.rvl{iExperiment,1}{num_band,1}= circ_r(Spikephase'); %resultant vector length/Spike_Phase
    end
end

       
        
        
 