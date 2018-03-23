function mainGetStimulationBasicFeatures(experiment,save_data,repeatCalc)
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
                            exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name,filesep,savename,'.mat')) && ...%                                 exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower_individualStim',filesep,experiment.name,filesep,savename,'.mat')) && ...
                            strcmp(SUAcheck,'noSUAcalc') && ...
                            squareCheck == 0
                        disp(['All done for: ' experiment.name ', ' savename])
                    else
                        clearvars stimStructure
                        stimStructure = getStimulusSignal(experiment,CSC,stimulusType{1}, Frequency, 1);
                        if ~isempty(stimStructure)
                            if repeatCalc == 1 || ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name,filesep,savename,'.mat'))
                                [~]=getStimulationMUAspikeTimes(stimStructure,experiment,save_data,repeatCalc);
                            end
                            if repeatCalc == 1|| ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name,filesep,savename,'.mat'))
                                [~]=getStimulationMUASpikePhase(stimStructure,experiment,save_data,repeatCalc);
                            end
                            if strcmp(stimulusType{1},'square')
                                if repeatCalc ==1 || ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeProbability',filesep,experiment.name,filesep,savename,'.mat'))
                                    [~]=getStimulationMUAspikeProbability(stimStructure,experiment,save_data,repeatCalc);
                                end
                            end
                            if strcmp(SUAcheck,'SUAcalc')
                                %% NEED TO BE UPDATED TO NEW CALC STYLE
                                if ~exist(strcat(Path.output,filesep,'results',filesep,'stimulationSUAspikePhase',filesep,experiment.name,filesep,savename,'.mat'))
                                    disp(['Calculating SUA spike phases for Animal: ' experiment.name ', ' savename])
                                    getStimulationSUASpikePhase(stimStructure, experiment, save_data)
                                end
                                if strcmp(stimulusType{1},'square') && ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationSUAspikeProbability',filesep,experiment.name,filesep,savename,'.mat'))
                                    disp(['Calculating SUA spike probability for Animal: ' experiment.name ', ' savename])
                                    getStimulationSUAspikeProbability(stimStructure,experiment,save_data)
                                end
                            end
                            clearvars stimStructure
                            stimStructure = getStimulusSignal(experiment,CSC,stimulusType{1}, Frequency, 10);
                            if repeatCalc == 1 || ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name,filesep,savename,'.mat'))
                                [~]=getStimulationPower(stimStructure,experiment,save_data,repeatCalc);
                            end
                            %                                 if repeatCalc == 1 || ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower_individualStim',filesep,experiment.name,filesep,savename,'.mat'))
                            %                                     [~]=getStimulationPower_individualStim(stimStructure,experiment,save_data,repeatCalc);
                            %                                 end
                        end
                    end
                end
            end
        end
    end
    % spikeProbablity for square pulses / ramp stimulation, can only be run after all
    % squareProbablitys have been calculated.
    if any(experiment.square) && ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'square','.mat')) && ~isnan(experiment.square(1))
        [~,~,~,~] = getStimulationRespondingCSCsSquare(experiment,save_data,repeatCalc);
    end
    if any(experiment.ramp) && ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'ramp','.mat')) && ~isnan(experiment.ramp(1))
        [~,~,~]=MCgetRespondingRamp(experiment,save_data,repeatCalc);
    end
    if any(experiment.sine) && ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationRespondingCSCs',filesep,experiment.name,filesep,'sine','.mat')) && ~isnan(experiment.sine(1))
        [~,~,~,~] = getStimulationRespondingCSCsSine(experiment,save_data,repeatCalc);
    end
    %         if strcmp(experiment.Exp_type,'A1') || strcmp(experiment.Exp_type,'B1') || strcmp(experiment.Exp_type,'C1') || strcmp(experiment.Exp_type,'D1') || strcmp(experiment.Exp_type,'E1')
    %             getStimulationCoherence(experiment,parameters.stimulationTypes,save_data,repeatCalc);
    %         end
    %         if strcmp(experiment.Exp_type,'A2') || strcmp(experiment.Exp_type,'B2')
    %             getStimulationCoherence4shank(experiment,parameters.stimulationTypes(2),save_data,repeatCalc);
    %         end
    if strcmp(experiment.Exp_type,'A1') || strcmp(experiment.Exp_type,'B1') || strcmp(experiment.Exp_type,'C1') || strcmp(experiment.Exp_type,'D1') || strcmp(experiment.Exp_type,'E1')
        getStimulationMUASpikePhaseCrossRegion(experiment,[],[],save_data,repeatCalc);
    end
    if strcmp(experiment.Exp_type,'A1') || strcmp(experiment.Exp_type,'B1') || strcmp(experiment.Exp_type,'C1') || strcmp(experiment.Exp_type,'D1') || strcmp(experiment.Exp_type,'E1')
        getStimulationSUASpikePhaseCrossRegion(experiment,[],[], save_data,repeatCalc)
    end
end