function [MUAspikeProbability]=getStimulationMUAspikeProbability(stimStructure,experiment,save_data,repeatCalc)
Path = get_path;
parameters=get_parameters;
savename = ['CSC' num2str(stimStructure.CSC) '_' stimStructure.stimulusType num2str(stimStructure.stimulusFrequency)];
if repeatCalc == 0 && exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeProbability',filesep,experiment.name,filesep,savename,'.mat'))
    load(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeProbability',filesep,experiment.name,filesep,savename));
else
    disp(['Calculating MUA spike probablility for Animal: ' experiment.name ', ' savename])
    spikeWindow = round(parameters.getStimSpikeProbability.spikeWindow*stimStructure.samplingrate);
    [spikeTimeData]=getStimulationMUAspikeTimes(stimStructure,experiment,save_data,repeatCalc);
    % stimulationSUA=stimulationSUA.SUAspikePhase;
    for pp = 1:length(stimStructure.Periods)
        % Detect pulse on/off
        stimStart = find(diff(stimStructure.signalD(pp,:))==1)+round(parameters.(['Window_' stimStructure.stimulusType])(1)*stimStructure.samplingrate)+1;
        clearvars spikeTimeAll
        spikeTimeAll = round(spikeTimeData.(['P' num2str(pp)])(1,:)*stimStructure.samplingrate);
        for ss = 1:length(stimStart)
            clearvars X
            X=find(spikeTimeAll >= stimStart(ss)+spikeWindow(1) & spikeTimeAll <= stimStart(ss)+spikeWindow(2));
            n_spikes(pp,ss) = length(X);
        end
        MUAspikeProbability.rawProbability(1,pp) = nnz(n_spikes(pp,:))/length(stimStart);
    end
    MUAspikeProbability.rawSpikeNumber=n_spikes>0==1;
    MUAspikeProbability.rawSpikeNumberTimeVector=stimStart/stimStructure.samplingrate;
    MUAspikeProbability.meanProbability = mean(MUAspikeProbability.rawProbability,2);
    if save_data == 0
        disp('DATA NOT SAVED!');
    elseif save_data==1
        if ~exist(strcat(Path.temp,filesep,'results',filesep,'StimulationMUAspikeProbability',filesep,experiment.name));
            mkdir(strcat(Path.temp,filesep,'results',filesep,'StimulationMUAspikeProbability',filesep,experiment.name));
        end
        save(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeProbability',filesep,experiment.name,filesep,savename),'MUAspikeProbability')
    end
end