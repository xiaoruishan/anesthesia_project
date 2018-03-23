function [RespondingCSC,spikingCSC,spikes]=MCgetRespondingRamp(experiment,save_data,repeatCalc)
Path=get_path;
if repeatCalc == 0 && exist(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'ramp','.mat'));
    load(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'ramp'));
    load(strcat(Path.output,filesep,'results',filesep,'StimulationSpikingCSCs',filesep,experiment.name,filesep,'ramp'));
else
    parameters=get_parameters;
    binsize=parameters.getStimulationFiringChannels.binsize; %sec
    minNspikes=parameters.getStimulationFiringChannels.MinNspikes; %Minimum number of spikes that must occur in all periods
    spikeratio=parameters.getStimulationFiringChannels.spikeratio; % stim/prestim ratio that must be present to include
    dataWindow=[parameters.(['Window_ramp'])(1) parameters.(['Window_ramp'])(4)];
    edges=dataWindow(1):binsize:dataWindow(2);
    edges_ratio=[-3 0 3];
    
    CSCs.allRespondingCSC = NaN;
    CSCs.bestRespondingCSC = NaN;
    CSCs.maxFiringBaselineCSC = NaN;
    CSCs.medianFiringBaselineCSC = NaN;
    spikingCSCs.CSC = NaN;
    spikingCSCs.spikes = NaN;
    % get spikeProb for all CSC
    respondingCSC=[];
    spikingCSC=[];
    for CSC = 1:32
        if ~ismember(CSC,experiment.ERRORchannels)
%             stimStructure = getStimulusSignal(experiment,CSC,'ramp',0,1);
            stimStructure.CSC=CSC;
            stimStructure.stimulusType='ramp';
            [spikeTimeData]=MCgetStimulationMUAspikes(stimStructure,experiment,0,0);
            timevectorConstruct = [];
            for pp = 1:length(fieldnames(spikeTimeData))
                % append all timestamps
                timevectorConstruct = [timevectorConstruct spikeTimeData.(['P' num2str(pp)])];
            end
            timevectorConstruct(2,:)=[];
            timevectorConstruct=timevectorConstruct(timevectorConstruct<2.99 | timevectorConstruct>3.01);
            if numel(timevectorConstruct)>1
                nspikes(CSC,:) = size(timevectorConstruct,2);
                nElementsBinned(CSC,:) = histc(timevectorConstruct(1,:),edges)/length(fieldnames(spikeTimeData));
                nElementsRatio(CSC,:) = nElementsBinned(CSC,1+length(dataWindow(1):-1):dataWindow(2))./mean(nElementsBinned(CSC,1:length(dataWindow(1):-1)));
                PrePostSpikes(CSC,:)=histc(timevectorConstruct(1,:),edges_ratio);
                if nspikes(CSC) > minNspikes
                    spikingCSC = [spikingCSC CSC];
                    if any(nElementsRatio(CSC,:)>=spikeratio)
                        respondingCSC =[respondingCSC CSC];
                    end
                end
            end
        end
    end
    if any(respondingCSC)
        CSCs.allRespondingCSC = respondingCSC;
        CSCs.bestRespondingCSC = CSCs.allRespondingCSC(find(max(nElementsRatio(CSCs.allRespondingCSC,:)') == max(max(nElementsRatio(CSCs.allRespondingCSC,:)'))));
    end
    if any(spikingCSC)
        spikingCSCs.CSC = spikingCSC;
        PrePostSpikes(:,3)=[];
        spikingCSCs.spikes = PrePostSpikes(spikingCSC,:);
    end
    if save_data == 0
        disp('DATA NOT SAVED!');
    elseif save_data==1
        if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name));
            mkdir(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name));
        end
        if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationSpikingCSCs',filesep,experiment.name));
            mkdir(strcat(Path.output,filesep,'results',filesep,'StimulationSpikingCSCs',filesep,experiment.name));
        end
        save(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'ramp'),'CSCs')
        save(strcat(Path.output,filesep,'results',filesep,'StimulationSpikingCSCs',filesep,experiment.name,filesep,'ramp'),'spikingCSCs')
    end
end
RespondingCSC=CSCs.allRespondingCSC;
spikes=spikingCSCs.spikes;
spikingCSC=spikingCSCs.CSC;
