function getBaselineMUASpikePhase(baselineStructure,experiment,CSC,save_data)
%% calc oscTimes,Ampl,Duration, and occurence
Path = get_path;
parameters=get_parameters;
Filters = parameters.spikeanalysis.phaseFilters;
load(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name,filesep,['CSC' num2str(CSC)]));
%% calculate spikePhases
for FF = 1:length(Filters)
    clearvars signal spike_phase spike_indx
    spike_indx=round(MUAspikeTimes.(['baseline'])(1,:)*baselineStructure.samplingrate);
    signal=ZeroPhaseFilterZeroPadding(baselineStructure.signal(1,:),baselineStructure.samplingrate,parameters.FrequencyBands.(Filters{FF}));
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


% figure
% circ_plot(spike_phase','hist','k',10,true,true,'linewidth',5,'color','k');
%
% figure
% polar(spike_mean, spike_rv, 'o')
%
% figure
% circ_plot(spike_phase)

