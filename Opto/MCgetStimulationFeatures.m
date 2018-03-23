function MCgetStimulationFeatures(experiment,save_data,repeatCalc)
Path = get_path;
parameters=get_parameters;
clearvars -except experiment parameters Path save_data repeatCalc n_animal
if ~isempty(experiment.animal_ID)
    for CSC=1:32
        %check if plexon spikes are converted into format for JA calculations
        for stimulusType = parameters.stimulationTypes
            if ~isnan(experiment.(stimulusType{1}))
                if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
                    freq = parameters.stimFreq;
                elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
                    freq = 0;
                end
                for Frequency = freq
                    if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
                        savename = ['CSC' num2str(CSC) '_' stimulusType{1} num2str(Frequency)];
                    elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
                        savename = ['CSC' num2str(CSC) '_' stimulusType{1}];
                    end
                    %square check (for spike probability)
                    if strcmp(stimulusType{1}, 'square') && ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeProbability',filesep,experiment.name,filesep,savename,'.mat'))
                        squareCheck = 1;
                    else
                        squareCheck=0;
                    end
                    % check if all files are calculated, if not, calculated
                    % them
                    if repeatCalc==0 && ...
                            exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name,filesep,savename,'.mat')) && ...
                            exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name,filesep,savename,'.mat')) && ...
                            exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name,filesep,savename,'.mat'))
                        disp(['All done for: ' experiment.name ', ' savename])
                    else
                        clearvars stimStructure
                        stimStructure = getStimulusSignal(experiment,CSC,stimulusType{1},Frequency,1);
                        if ~isempty(stimStructure)
                            if repeatCalc == 1 || ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name,filesep,savename,'.mat'))
                                [~]=MCgetStimulationMUAspikes(stimStructure,experiment,save_data,repeatCalc);
                            end
                            if repeatCalc == 1|| ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name,filesep,savename,'.mat'))
                                [~]=MCgetStimulationMUASpikePhase(stimStructure,experiment,save_data,repeatCalc);
                            end
                            clearvars stimStructure
                            stimStructure = getStimulusSignal(experiment,CSC,stimulusType{1}, Frequency, 10);
                            if repeatCalc == 1 || ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name,filesep,savename,'.mat'))
                                [~]=getStimulationPower(stimStructure,experiment,save_data,repeatCalc);
                            end
                        end
                    end
                end
            end
        end
    end
    if any(experiment.ramp) && ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'ramp','.mat')) && ~isnan(experiment.ramp(1))
        [~,~,~]=MCgetRespondingRamp(experiment,save_data,repeatCalc);
    end
end