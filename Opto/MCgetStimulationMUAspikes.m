function [spikeTimeData]=MCgetStimulationMUAspikes(stimStructure,experiment,save_data,repeatCalc)
% by Mattia, based on Joachim's function
parameters  = get_parameters;
Path = get_path;

if strcmp(stimStructure.stimulusType, 'square') || strcmp(stimStructure.stimulusType, 'sine')
    savename = ['CSC' num2str(stimStructure.CSC) '_' stimStructure.stimulusType num2str(stimStructure.stimulusFrequency)];
elseif strcmp(stimStructure.stimulusType,'ramp') || strcmp(stimStructure.stimulusType, 'chirp')
    savename = ['CSC' num2str(stimStructure.CSC) '_' stimStructure.stimulusType];
end
if repeatCalc == 0 && exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name,filesep,savename,'.mat'))
    load(strcat(Path.output, 'results', filesep, 'StimulationMUAspikeTimes', filesep, experiment.name, filesep, savename))  
else
%     disp(['Calculating MUA spike times for Animal: ' experiment.name ', ' savename])
    %% locate spikes
    for pp = 1:size(stimStructure.signalD,1)
        signalMUA = ZeroPhaseFilter(stimStructure.signal(pp,:),stimStructure.samplingrate, parameters.FrequencyBands.MUA);
        thr=std(signalMUA*parameters.spikeanalysis.spikeDetection.threshold);
        clearvars peakLoc Ampl spikeData
        %% detect all spikes in period window
        [peakLoc,Ampl]=peakfinderOpto(signalMUA,thr/2,-thr,-1,false); 
        peakLoc=(peakLoc/stimStructure.samplingrate)+parameters.(['Window_' stimStructure.stimulusType])(1); % correct so 0 = stim Start
        spikeData=[peakLoc;Ampl];
        spikeTimeData.(['P' num2str(pp)]) = spikeData;
    end
    clearvars signalMUA
    if save_data == 0
        disp('DATA NOT SAVED!');
    elseif save_data==1
        if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name));
            mkdir(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name));
        end
        save(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name,filesep,savename),'spikeTimeData')
    end
end