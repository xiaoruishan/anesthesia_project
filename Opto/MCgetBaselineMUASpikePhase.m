function MCgetBaselineMUASpikePhase(experiment,CSC,save_data)
%% calc oscTimes,Ampl,Duration, and occurence
Path = get_path;
parameters=get_parameters;
Filters=parameters.spikeanalysis.phaseFilters;
Filters=Filters(2:4);
load(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name,filesep,['CSC' num2str(CSC)]));
[baselineStructure]=getBaselineSignal(experiment,CSC,100);
%% calculate spikePhases
for FF = 1:length(Filters)
    clearvars signal spike_phase spike_indx
    spike_indx=round(MUAspikeTimes.(['baseline'])(1,:)*baselineStructure.samplingrate);
    spike_indx(1)=[];
    signal=ZeroPhaseFilterZeroPadding(baselineStructure.signal,baselineStructure.samplingrate,parameters.FrequencyBands.(Filters{FF}));
    spikePhase=getPhaseLocking(signal,spike_indx);
    MUAspikePhase.(['baseline']).(Filters{FF}) = spikePhase;
end
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikePhase',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikePhase',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikePhase',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'MUAspikePhase')
end
end