function plotStimulationMUASpikePhase(experiments,expTypes,stimulusTypes)
%% By Joachim.
% Plots phaselocking plots.
% Plots 3 figures:
% Figure1: Opsin vs opsinfree for all spikes, preStim, stim, and postStim
% Figure2: Opsin baseline vs opsinfree baseline.
% Figure3: Opsin Stim&postStim vs the baseline of the same CSC
% NOTE: Statistics used are circular statistics
Path = get_path;
parameters=get_parameters;
constructs = parameters.constructs;
for stimulusType=stimulusTypes
    if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
        Frequency = parameters.stimFreq;
    elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
        Frequency = 0;
    end
    for freq = Frequency
        for expType=expTypes
            countConstruct=0;
            for construct=constructs
                countConstruct=countConstruct+1;
                countCSC=0; % count number of CSC for responding CSCs (plot 1,3)
                countAnimal=0; % counts animals with respondingCSC (plot1,3)
                countAnimalExpr=0; % counts aniamls with expression (opsin vs opsinfree plot, plot2)
                for n_animal = 1:length(experiments);
                    clearvars CSCcalc
                    experiment=experiments(n_animal);
                    if ~isempty(experiment.animal_ID) && experiment.expression(1)==1 && strcmp(experiment.IUEconstruct,construct{1}) && strcmp(experiment.Exp_type,expType{1})
                        if strcmp(stimulusType{1}, 'square')
                            if strcmp(experiment.IUEconstruct,'CAG-ChR2ET/TC-2AtDimer2')
                                [CSCcalc,~,~,~] = getStimulationRespondingCSCsSquare(experiment,1,0); % load CSC
                            elseif strcmp(experiment.IUEconstruct,'CAG-2AtDimer2')
                                [~,~,CSCcalc,~] = getStimulationRespondingCSCsSquare(experiment,1,0); % load CSC
                                CSCcalc=CSCcalc(1); % if >1 max/median firing CSC, take first
                            end
                        elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
                            if strcmp(experiment.IUEconstruct,'CAG-ChR2ET/TC-2AtDimer2')
                                [CSCcalc,~,~,~] = getStimulationRespondingCSCsRamp(experiment,1,0); % load CSC
                            elseif strcmp(experiment.IUEconstruct,'CAG-2AtDimer2')
                                [~,~,CSCcalc,~] = getStimulationRespondingCSCsRamp(experiment,1,0); % load CSC
                                CSCcalc=CSCcalc(1); % if >1 max/median firing CSC, take first
                            end
                        elseif strcmp(stimulusType{1}, 'sine')
                            if strcmp(experiment.IUEconstruct,'CAG-ChR2ET/TC-2AtDimer2')
                                [CSCcalc,~,~,~] = getStimulationRespondingCSCsSine(experiment,1,0); % load CSC
                            elseif strcmp(experiment.IUEconstruct,'CAG-2AtDimer2')
                                [~,~,CSCcalc,~] = getStimulationRespondingCSCsSine(experiment,1,0); % load CSC
                                CSCcalc=CSCcalc(1); % if >1 max/median firing CSC, take first
                            end
                        end
                        if CSCcalc > 0
                            countAnimal=countAnimal+1;
                            %                                 disp([num2str(n_animal) ', ' num2str(CSCcalc)])
                            for CSC=CSCcalc
                                if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
                                    loadName = ['CSC' num2str(CSC) '_' stimulusType{1} num2str(freq)];
                                elseif strcmp(stimulusType,'ramp') || strcmp(stimulusType{1}, 'chirp')
                                    loadName = ['CSC' num2str(CSC) '_' stimulusType{1}];
                                end
                                clearvars MUAspikePhase baselinePhase
                                load(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name,filesep,loadName));
                                load(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name,filesep,loadName));
                                baselinePhase=load(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikePhase',filesep,experiment.name,filesep,['CSC' num2str(CSC)]));
                                baselinePhase=baselinePhase.MUAspikePhase.baseline1;
                                % generate vector with spiketimes
                                spikeTimes=[];
                                for ss=1:size(fieldnames(spikeTimeData),1)
                                    spikeTimes=[spikeTimes spikeTimeData.(['P' num2str(ss)])];
                                end
                                spikeTimes=spikeTimes(1,:);
                                if length(spikeTimes) >20; %control to ensure that enough spikes occurred, should become a parameter? Its kinda already controlled in the getRespondingCSC script. Obsolete here?
                                    disp(['Animal: ' experiment.name ', CSC' num2str(CSC) ', construct: ' experiment.IUEconstruct])
                                    countCSC=countCSC+1;
                                    % Calculate phase for each spike
                                    clearvars Tpre Tpost Tstim
                                    Tpre=spikeTimes<0;
                                    Tpost=spikeTimes>3;
                                    Tstim=spikeTimes<3 & spikeTimes>0;
                                    % All spikes
                                    for freqBands = 1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                                        clearvars Phases
                                        Phases = MUAspikePhase.(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands});
                                        spike_mean.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).AllSpikes(countCSC) =...
                                            circ_mean(Phases');
                                        spike_rv.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).AllSpikes(countCSC) =...
                                            circ_r(Phases');
                                    end
                                    % preStim
                                    for freqBands = 1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                                        clearvars Phases
                                        Phases = MUAspikePhase.(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands});
                                        Phases=Phases.*Tpre;
                                        Phases=Phases(Phases~=0);
                                        spike_mean.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).preStim(countCSC) =...
                                            circ_mean(Phases');
                                        spike_rv.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).preStim(countCSC) =...
                                            circ_r(Phases');
                                    end
                                    % stim
                                    for freqBands = 1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                                        clearvars Phases
                                        Phases = MUAspikePhase.(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands});
                                        Phases=Phases.*Tstim;
                                        Phases=Phases(Phases~=0);
                                        spike_mean.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).Stim(countCSC) =...
                                            circ_mean(Phases');
                                        spike_rv.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).Stim(countCSC) =...
                                            circ_r(Phases');
                                    end
                                    % postStim
                                    for freqBands = 1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                                        clearvars Phases
                                        Phases = MUAspikePhase.(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands});
                                        Phases=Phases.*Tpost;
                                        Phases=Phases(Phases~=0);
                                        spike_mean.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).postStim(countCSC) =...
                                            circ_mean(Phases');
                                        spike_rv.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).postStim(countCSC) =...
                                            circ_r(Phases');
                                    end
                                    % baseline responding CSC
                                    for freqBands = 1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                                        clearvars Phases
                                        Phases = baselinePhase.(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands});
                                        spike_mean.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline(countCSC) =...
                                            circ_mean(Phases');
                                        spike_rv.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline(countCSC) =...
                                            circ_r(Phases');
                                    end
                                end
                            end
                        end
                    end
                    if ~isempty(experiment.animal_ID) && experiment.expression(1)==1 && strcmp(experiment.IUEconstruct,construct{1}) && strcmp(experiment.Exp_type,expType{1})
                        clearvars MUAspikePhase
                        % baseline expressing animals
                                                CSC=experiment.HPreversal;
%                         [~,~,~,CSC] = getStimulationRespondingCSCsRamp(experiment,1,0); % [allRespondingCSC,bestRespondingCSC,maxBaselineCSC,medianBaselineCSC], for phasePlots median is best
                        load(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikePhase',filesep,experiment.name,filesep,['CSC' num2str(CSC(1))]));
                        if length(MUAspikePhase.baseline1.LFP) > 1
                            countAnimalExpr=countAnimalExpr+1;
                            for bb=1 % only do this for baseline 1
                                for freqBands = 1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                                    spike_mean.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baselineExpr(countAnimalExpr) =...
                                        circ_mean(MUAspikePhase.(['baseline' num2str(bb)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands})');
                                    spike_rv.(['construct' num2str(countConstruct)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baselineExpr(countAnimalExpr) =...
                                        circ_r(MUAspikePhase.(['baseline' num2str(bb)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands})');
                                end
                            end
                        end
                    end
                end
                disp(['Number of animals in respondingCSC group: ' num2str(countAnimal) ', ' construct{1}])
                disp(['Number of CSC in respondingCSC group: ' num2str(countCSC) ', ' construct{1}])
                disp(['Number of animals in expression group: ' num2str(countAnimalExpr) ', ' construct{1}])
            end
        end
        %% Plotting
%         figure1 opsin vs opsinfree during stim
        phasePlot1=figure;
        figure(phasePlot1)
        plotColors={'ob','or'};
        countPlot = 0;
        plotPos=[1,5,9,2,6,10,3,7,11,4,8,12];
        plotNames={'AllSpikes','preStim','Stim','postStim'};
        for PP=1:length(plotNames)
            for freqBands=1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                countPlot=countPlot+1;
                subplot(3,4,plotPos(countPlot))
                % hack for radius limit (not possible with xlim, ylim etc)
                t = 0 : .01 : 2 * pi;
                P = polar(t, 1 * ones(size(t)));
                set(P, 'Visible', 'off')
                % plot
                hold on
                
                polar(  spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}), ...
                    spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}),...
                    plotColors{1})
                
                polar(  spike_mean.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}), ...
                    spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}),...
                    plotColors{2})
                
                polar([0,circ_mean(spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')], ...
                    [0,circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')],...
                    'b')
                
                polar([0,circ_mean(spike_mean.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')], ...
                    [0,circ_mean(spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')],...
                    'r')
                hold off
                %                 if strcmp(plotNames(PP),'Stim') || strcmp(plotNames(PP),'postStim')
                %                 pVal_Phase=circ_cmtest(spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}),...
                %                     spike_mean.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}));
                %                 disp(['pVal_Phase: construct1 vs construct2: ', parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}, ', P=', num2str(pVal_Phase)])
                %
                %                 pVal_Strength = ranksum(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}), ...
                %                     spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}));
                %                 disp(['pVal_Strength: construct1 vs construct2: ', parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}, ', P=', num2str(pVal_Strength)])
                %                 end
            end
            figure(phasePlot1)
            subplot(3,4,1)
            hold on
            title('all Spikes')
            ylabel('theta - 4-12 Hz')
            hold off
            subplot(3,4,2)
            hold on
            title('preStim')
            hold off
            subplot(3,4,3)
            hold on
            title('stim')
            hold off
            subplot(3,4,4)
            hold on
            title('postStim')
            hold off
            subplot(3,4,5)
            hold on
            ylabel('beta - 12-30 Hz')
            hold off
            subplot(3,4,9)
            hold on
            ylabel('gamma - 30-100 Hz')
            hold off
        end
        
        % figure2 - opsin baseline vs opsinfree baseline
        phasePlot2=figure;
        figure(phasePlot2)
        plotColors={'ob','or'};
        countPlot = 0;
        plotPos=[1,3,5];
        plotNames={'baselineExpr'};
        for PP=1:length(plotNames)
            for freqBands=1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                countPlot=countPlot+1;
                subplot(3,2,plotPos(countPlot))
                % hack for radius limit (not possible with xlim, ylim etc)
                t = 0 : .01 : 2 * pi;
                P = polar(t, 1 * ones(size(t)));
                set(P, 'Visible', 'off')
                % plot
                hold on
                polar(  spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}), ...
                    spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}),...
                    plotColors{1})
                
                polar(  spike_mean.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}), ...
                    spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}),...
                    plotColors{2})
                
                polar([0,circ_mean(spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')], ...
                    [0,circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')],...
                    'b')
                
                polar([0,circ_mean(spike_mean.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')], ...
                    [0,circ_mean(spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')],...
                    'r')
                hold off
                % stats
                %                 pVal_Phase=circ_cmtest(spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}),...
                %                     spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline);
                %                 disp(['pVal_Phase: baseline vs ', parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}, ', P=', num2str(pVal_Phase)])
                pVal_Strength = ranksum(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}), ...
                    spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}));
                %                 disp(['pVal_Strength: baseline vs ', parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}, ', P=', num2str(pVal_Strength)])
                
                %bar plots
                subplot(3,2,plotPos(countPlot)+1)
                bar([1:2],[circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})'), circ_mean(spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')])
                hold on
                errorbar([1:2],...
                    [circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})'), circ_mean(spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')],...
                    [circ_std(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')/sqrt(countAnimalExpr), circ_std(spike_rv.(['construct' num2str(2)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')/sqrt(countAnimalExpr)],...
                    '.k')
                ylim([0 1])
                title(['strenght, pval=' num2str(pVal_Strength)])
                hold off
            end
        end
        figure(phasePlot2)
        subplot(3,2,1)
        hold on
        title('opsin baseline vs opsinfree baseline')
        ylabel('theta - 4-12 Hz')
        hold off
        subplot(3,2,3)
        hold on
        ylabel('beta - 12-30 Hz')
        hold off
        subplot(3,2,5)
        hold on
        ylabel('gamma - 30-100 Hz')
        hold off
        
        % figure3 - opsin stimulation vs opsin baseline
        phasePlot3=figure;
        figure(phasePlot3)
        plotColors={'ob','or'};
        countPlot = 0;
        plotPos=[1,5,9,3,7,11];
        plotNames={'Stim','postStim'};
        for PP=1:length(plotNames)
            for freqBands=1:length(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands)
                countPlot=countPlot+1;
                subplot(3,4,plotPos(countPlot))
                % hack for radius limit (not possible with xlim, ylim etc)
                t = 0 : .01 : 2 * pi;
                P = polar(t, 1 * ones(size(t)));
                set(P, 'Visible', 'off')
                % plot
                hold on
                polar(  spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}), ...
                    spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}),...
                    plotColors{1})
                
                polar(  spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline, ...
                    spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline,...
                    plotColors{2})
                
                polar([0,circ_mean(spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')], ...
                    [0,circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')],...
                    'b')
                
                polar([0,circ_mean(spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline')], ...
                    [0,circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline')],...
                    'r')
                hold off
                
                pVal_Phase=circ_cmtest(spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}),...
                    spike_mean.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline);
                disp(['pVal_Phase: baseline vs ', parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}, ', P=', num2str(pVal_Phase)])
                
                pVal_Strength = ranksum(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP}), ...
                    spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline);
                disp(['pVal_Strength: baseline vs ', parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}, ', P=', num2str(pVal_Strength)])
                
                subplot(3,4,plotPos(countPlot)+1)
                bar([1:2],[circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline'), circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')])
                hold on
                errorbar([1:2],...
                    [circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline'), circ_mean(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')],...
                    [circ_std(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).baseline')/sqrt(countCSC), circ_std(spike_rv.(['construct' num2str(1)]).(parameters.spikeanalysis.plotBaselineMUAPhase.freqBands{freqBands}).(plotNames{PP})')/sqrt(countCSC)],...
                    '.k')
                ylim([0 1])
                title(['strenght, pval=' num2str(pVal_Strength)])
                hold off
            end
        end
        figure(phasePlot3)
        subplot(3,4,1)
        hold on
        title('opsin stimulation vs opsin baseline')
        ylabel('theta - 4-12 Hz')
        hold off
        subplot(3,4,3)
        hold on
        title('opsin PostStim vs opsin baseline')
        %         ylabel('theta - 4-12 Hz')
        hold off
        subplot(3,4,5)
        hold on
        ylabel('beta - 12-30 Hz')
        hold off
        subplot(3,4,9)
        hold on
        ylabel('gamma - 30-100 Hz')
        hold off
    end
end