function [MUAspikePhase]=getStimulationMUASpikePhase(stimStructure,experiment,save_data,repeatCalc)
%% calc oscTimes,Ampl,Duration, and occurence
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
    disp(['Calculating MUA spike phases for Animal: ' experiment.name ', ' savename])
    Filters=parameters.spikeanalysis.phaseFilters;
    [spikeTimeData]=getStimulationMUAspikeTimes(stimStructure,experiment,save_data,repeatCalc);
    
    %% calculate spikePhases
    for FF = 1:length(Filters)
        spikePhases=[];
        for ss=1:size(stimStructure.signal,1)
            clearvars signal spike_phase spike_indx
            spike_indx=round(spikeTimeData.(['P' num2str(ss)])(1,:)*stimStructure.samplingrate+abs(stimStructure.time(1)*stimStructure.samplingrate));
            signal=ZeroPhaseFilterZeroPadding(stimStructure.signal(ss,:),stimStructure.samplingrate,parameters.FrequencyBands.(Filters{FF}));
            spike_indx(spike_indx>length(signal))=[];
            spike_indx(spike_indx<0)=[];
            spikePhase=getPhaseLocking(signal,spike_indx);
            spikePhases = [spikePhases spikePhase];
        end
        MUAspikePhase.(Filters{FF}) = spikePhases;
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


% figure
% circ_plot(spike_phase','hist','k',10,true,true,'linewidth',5,'color','k');
%
% figure
% polar(spike_mean, spike_rv, 'o')
%
% figure
% circ_plot(spike_phase)

