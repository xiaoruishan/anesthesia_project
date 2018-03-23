function [CSCcalcSpiking,CSCcalcBest]=getCSCcalcSpikingAnalysis(experiment,IUEarea, construct, stimulusType,Frequency)

%% NOTE: THIS SCRIPTS NEED MAJOR UPDATING FOR PICKING PROPER CSC!!!!!!!
Path=get_path;
parameters=get_parameters;
if Frequency > 1
    Filename = [stimulusType{1} num2str(Frequency)];
elseif strcmp(stimulusType{1}, 'ramp') || strcmp(stimulusType{1},'chirp')
    Filename = stimulusType{1};
end
if strcmp(stimulusType{1}, 'square')
    if strcmp(IUEarea{1},'PFCL_2/3') || strcmp(IUEarea{1}, 'PFC_L5')
        spikeFiringStructure = load(strcat(Path.output,filesep,'results',filesep,'spikeProbability',filesep,experiment.name,filesep,'square'));
        spikeFiringStructure = spikeFiringStructure.spikeProbabilityStructure;
        CSCcalcSpiking=spikeFiringStructure.spikingCSC;
        CSCcalcBest=spikeFiringStructure.bestCSC;
        if strcmp(construct{1},'CAG-2AtDimer2')
            CSCcalcSpiking=22:28; %% todo. add some script that picks out which opsinFree CSC to use
        end
    elseif strcmp(IUEarea{1},'intmCA1') || strcmp(IUEarea{1}, 'dorCA1')
        % TO BE REPLACED
        load(strcat(Path.output,filesep,'results',filesep,'StimulationFiringChannels',filesep,experiment.name,filesep,Filename));
        CSCcalcSpiking=spikeFiringStructure.spikingCSC;
                CSCcalcBest=spikeFiringStructure.bestCSC;

        if strcmp(construct{1},'CAG-2AtDimer2')
            % CSCcalc=20:28;%% todo. add some script that picks out which opsinFree CSC to use
        end
    end
elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp') || strcmp(stimulusType{1}, 'sine')
    if strcmp(IUEarea{1},'PFC_L2/3') || strcmp(IUEarea{1}, 'PFC_L5')
        load(strcat(Path.output,filesep,'results',filesep,'StimFiringChannels',filesep,experiment.name,filesep,Filename));
%         load(strcat(Path.output,filesep,'results',filesep,'StimulationFiringChannels',filesep,experiment.name,filesep,Filename));
        CSCcalcSpiking=spikeFiringStructure.spikingCSC;
                CSCcalcBest=spikeFiringStructure.bestCSC;
        if strcmp(construct{1},'CAG-2AtDimer2')
            CSCcalcSpiking=20:28;%% todo. add some script that picks out which opsinFree CSC to use
        end
    elseif strcmp(IUEarea{1},'intmCA1') || strcmp(IUEarea{1}, 'dorCA1')
        load(strcat(Path.output,filesep,'results',filesep,'StimulationFiringChannels',filesep,experiment.name,filesep,Filename));
        CSCcalcSpiking=spikeFiringStructure.spikingCSC;
                CSCcalcBest=spikeFiringStructure.bestCSC;

        if strcmp(construct{1},'CAG-2AtDimer2')
            % CSCcalc=20:28;%% todo. add some script that picks out which opsinFree CSC to use
        end
    end
end
end