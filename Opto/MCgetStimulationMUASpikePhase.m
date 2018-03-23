function [MUAspikePhase]=MCgetStimulationMUASpikePhase(stimStructure,experiment,save_data,repeatCalc)
%% by Mattia, adapted from Joachim's version of the script -- work in progress!
Path = get_path;
parameters=get_parameters;
if strcmp(stimStructure.stimulusType, 'square') || strcmp(stimStructure.stimulusType, 'sine')
    savename = ['CSC' num2str(stimStructure.CSC) '_' stimStructure.stimulusType num2str(stimStructure.stimulusFrequency)];
elseif strcmp(stimStructure.stimulusType,'ramp') || strcmp(stimStructure.stimulusType, 'chirp')
    savename = ['CSC' num2str(stimStructure.CSC) '_' stimStructure.stimulusType];
end
if repeatCalc == 0 && exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name,filesep,savename,'.mat'))
    load(strcat(Path.output, 'results', filesep, 'StimulationMUAspikePhase', filesep, experiment.name, filesep, savename))  
else
%     disp(['Calculating MUA spike phases for Animal: ' experiment.animal_ID ', ' savename])
    Filters=parameters.spikeanalysis.phaseFilters;
    Filters=Filters(2:4); % I only calculate the phase for theta-beta-gamma frequency band
    [spikeTimeData]=MCgetStimulationMUAspikes(stimStructure,experiment,0,0); % save_data & repeatCalc are set to 0
%     [stimStructure]=getStimulusSignal(experiment,stimStructure.CSC,stimStructure.stimulusType,stimStructure.stimulusFrequency,100);
    
    %% calculate spikePhases
    for FF = 1:length(Filters)
        spikePhases=[];
        for ss=1:size(stimStructure.signal,1)
            signal=ZeroPhaseFilterZeroPadding(stimStructure.signal(ss,:),stimStructure.samplingrate,parameters.FrequencyBands.(Filters{FF}));
            clearvars spike_phase spike_indx
            if numel(spikeTimeData.(['P' num2str(ss)]))>0
                spike_indx=round(spikeTimeData.(['P' num2str(ss)])(1,:)*stimStructure.samplingrate+abs(stimStructure.time(1)*stimStructure.samplingrate));
                spike_indx(spike_indx>length(signal))=[];
                spike_indx(spike_indx<=0)=[];
                spikePhase=getPhaseLocking(signal,spike_indx);
                spikePhases=[spikePhases spikePhase];
            end
        end
        MUAspikePhase.(Filters{FF})=spikePhases;
    end
    if save_data == 0
        %     disp('DATA NOT SAVED!');
    elseif save_data==1
        % data structure
        if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name));
            mkdir(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name));
        end
        save(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name,filesep,savename),'MUAspikePhase')
    end
end