function [allRespondingCSC, bestRespondingCSC,maxFiringBaselineCSC,medianFiringBaselineCSC]=getStimulationRespondingCSCsSquare(experiment,save_data,repeatCalc)
Path=get_path;
if repeatCalc == 0 && exist(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'square','.mat'));
    load(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'square'));
else
    parameters=get_parameters;
    CSCs.allRespondingCSC = NaN;
    CSCs.bestRespondingCSC = NaN;
    CSCs.maxFiringBaselineCSC = NaN;
    CSCs.medianFiringBaselineCSC = NaN;
    % get spikeProb for all CSC
    for CSC=1:32
        countFreq=0;
        for freq=parameters.stimFreq
            countFreq=countFreq+1;
            Filename = ['CSC' num2str(CSC) '_square' num2str(freq)];
            if repeatCalc==1 || ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeProbability',filesep,experiment.name,filesep,Filename,'.mat'))
                stimStructure = getStimulusSignal(experiment,CSC,'square',freq,1);
                [MUAspikeProbability]=getStimulationMUAspikeProbability(stimStructure,experiment,save_data,repeatCalc);
                dataProb(CSC,countFreq)= MUAspikeProbability.meanProbability;
            else
                stimStructure.CSC=CSC;
                stimStructure.stimulusType='square';
                stimStructure.stimulusFrequency=freq;
                [MUAspikeProbability]=getStimulationMUAspikeProbability(stimStructure,experiment,save_data,repeatCalc);
                dataProb(CSC,countFreq)= MUAspikeProbability.meanProbability;
            end
        end
        % load baseline spiking, picks the highest spiking CSC during
        % baseline for opsinfree group
        if repeatCalc==1 || ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name,filesep,['CSC' num2str(CSC)],'.mat'))
            [baselineStructure] = getBaselineSignal(experiment, CSC, 1);
            [MUAspikeTimes]=getBaselineMUASpikeTimes(baselineStructure,experiment,CSC,save_data,repeatCalc);                
            nBaselineSpikes(CSC) = length(MUAspikeTimes.baseline);
        else
            baselineStructure=NaN;
            [MUAspikeTimes]=getBaselineMUASpikeTimes(baselineStructure,experiment,CSC,save_data,repeatCalc);  
            nBaselineSpikes(CSC) = length(MUAspikeTimes.baseline);
        end
    end
    % find spiking CSCs according to thr for 2Hz stimulation
    spikingCSC = find(dataProb(:,1)>parameters.getStimulationFiringChannelsSquare.spikeProbThr);
    % load CSC to use for further analysis (e.g. throw away CSC with too big
    % artifact for proper analysis)
    if strcmp(experiment.IUEarea,'dorCA1') || strcmp(experiment.IUEarea,'intmCA1')
        %         CSCcalc = parameters.CSCHP;
        CSCcalc=[experiment.HPreversal-3:experiment.HPreversal+3];
        CSCerror = experiment.ERRORchannels;
        if ~isnan(CSCerror) % remove error CSCs from respondingCSCs
            for CSCerrorX=CSCerror
                CSCcalc=CSCcalc(find(CSCerrorX~=CSCcalc));
            end
        end
    elseif strcmp(experiment.IUEarea,'PFC_L2/3') || strcmp(experiment.IUEarea,'PFC_L5')
        CSCcalc = parameters.CSCPFC;
        CSCerror = experiment.ERRORchannels;
        if ~isnan(CSCerror) % remove error CSCs from respondingCSCs
            for CSCerrorX=CSCerror
                CSCcalc=CSCcalc(find(CSCerrorX~=CSCcalc));
            end
        end
    end
    % pick out the channels that are in the window for proper analysis and pick
    % out the best CSC
    if any(spikingCSC(ismember(spikingCSC,CSCcalc))')
        CSCs.allRespondingCSC = spikingCSC(ismember(spikingCSC,CSCcalc))';
        CSCs.bestRespondingCSC = find(dataProb(:,1) == max(dataProb(CSCs.allRespondingCSC,1)));
    end
    CSCs.maxFiringBaselineCSC = CSCcalc(find(nBaselineSpikes(CSCcalc) == max(nBaselineSpikes(CSCcalc))));
    XX = sort(nBaselineSpikes(CSCcalc));
    CSCs.medianFiringBaselineCSC = CSCcalc(find(nBaselineSpikes(CSCcalc) == XX(floor(length(XX)/2))));
    if save_data == 0
        disp('DATA NOT SAVED!');
    elseif save_data==1
        if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name));
            mkdir(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name));
        end
        save(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'square'),'CSCs')
    end
end
allRespondingCSC = CSCs.allRespondingCSC;
bestRespondingCSC= CSCs.bestRespondingCSC;
maxFiringBaselineCSC=CSCs.maxFiringBaselineCSC(1);
medianFiringBaselineCSC=CSCs.medianFiringBaselineCSC(1);