clear all
close all
save_data=1;
repeatCalc=0; 
experiments = get_experiment_list;
experiments=experiments(523:535);
experiments=experiments([2016 2013]);


%% subfunction 1 - getStimProperties
getStimulationProperties(experiments,save_data,repeatCalc)
correctStimulationProperties(experiments,save_data,repeatCalc)

%% Calculate basic features for baseline and stimulation (spiketime, spikephase, LFPpower... )
for n=2:length(experiments)
    experiment=experiments(n);
    if n<2
        mainGetBaselineProperties(experiment,save_data,repeatCalc)
    end
    mainGetStimulationBasicFeatures(experiment,save_data,repeatCalc)
%     [allRespondingCSC{n},~]=getRespondingRampCM(experiment,save_data,repeatCalc);
%     display(strcat('mancano', num2str(length(experiments)-n),' animali'))
end

%% plot stuff
stimulusTypes={'ramp'};
CSC=23;
plotStimulationRasterPlot(experiment, stimulusTypes, CSC)

convertSUA2matlab(experiments,save_data)

clear all
% for multiple experiments
% Baseline

% plotBaselineCoherence(experiments,1)
% plotBaselinePower(experiments,1)
expTypes={'B1'};
plotBaselineOscProperties(experiments,expTypes)
plotBaselinePowerArea(experiments,expTypes)
plotDevelopmentalMilestones(experiments,expTypes)
% plotSharpWaveProperties(experiments,expTypes)

plotBaselineOscPropertiesGroupComparison(experiments,expTypes)

% MUA
plotBaselineMUAPhase(experiments,expTypes)


% SUA

% Stimulation
% plotStimulationPower(experiments)

expTypes={'IN'};

expTypes={'B1'};
expTypes={'E1'};

plotStimulationMUAspikeProbabiliy(experiments,expTypes); % I AM WORKING
stimulusTypes={'ramp'};
stimulusTypes={'square'};
stimulusTypes={'sine'};
plotStimulationMUAISI(experiments,expTypes,stimulusTypes) % I AM WORKING
[dataMatrixSPSS]=plotStimulationMUAFiringRate(experiments,expTypes,stimulusTypes); % I AM WORKING
plotStimulationMUASpikePhase(experiments,expTypes,stimulusTypes) % I AM WORKING


2001 2006 2007
2002 2005 2009
2003 2004 2008
plotStimulationPowerRatio(experiments([2012]),expTypes,stimulusTypes) % I AM WORKING



plotStimulationCoherence(experiments,stimulusTypes,expTypes)
plotStimulationMUAwaveform(experiments,expTypes)
plotStimulationCrossRegionPhaselocking(experiments,expTypes,stimulusTypes)


% SUA
plotStimulationSUAFiringRate(experiments,expTypes,stimulusTypes)
plotStimulationSUAspikePhase(experiments,expTypes)
plotStimulationSUAISI(experiments,expTypes)
plotStimulationSUAspikeProbability(experiments,expTypes)

% for single experiment
close all
expTypes={'A1'};
expTypes={'E1'};

stimulusTypes={'square'};
stimulusTypes={'ramp'};
stimulusTypes={'sine'};
stimulusTypes={'chirp'};

for nExp=[1100:1200]
    if ~isempty(experiments(nExp).name)
    experiment=experiments(nExp);
%      plotSWraster(experiment,save_data,repeatCalc)
%     [A]=plotStimulationMUAspikeProbabiliy(experiments(nExp),expTypes);
%     plotStimulationCSD(experiments(nExp),2,1:16)
%     plotStimulationCoherence(experiments(nExp),stimulusTypes,expTypes)
%         plotStimulationMUAwaveform(experiments(nExp),expTypes)
            [A,~,~,~] = getStimulationRespondingCSCsRamp(experiment,1,0);
%             A=17:32
        if A >0
            for CSC=A
                plotStimulationRasterPlot(experiment, stimulusTypes, CSC)
            end
        end
% disp(experiment.name)
%             [B,~,~,~] = getStimulationRespondingCSCsRamp(experiment,1,0)
%             [C,~,~,~] = getStimulationRespondingCSCsSine(experiment,0,0)
%             disp([num2str(A) '_' num2str(B)])
    end
end


for nExp=920
   experiment=experiments(nExp);
    if ~isempty(experiments(nExp).name)
        plotDetectedUnits(experiment) 
        
    end
end




% SUAreCalc!

nExp=706;
CSCs=[27];
experiment=experiments(nExp);
for CSC=CSCs
    SUARECALC(experiment,CSC)
end


% end
% CSC = 8;
% stimulusTypes={'ramp'};
% plotStimulationRasterPlot(experiments(nExp), stimulusTypes, CSC)
% plotStimulationMUAwaveform(experiment,CSC)
% TO-DO
% Rasterplot
% stimViewer
% powerEst
% opsinVsOpsinFree plots






for nExp = 1:length(experiments);
    if ~isempty(experiments(nExp).animal_ID)
        experiment = experiments(nExp);
        if strcmp(experiment.Exp_type,'A1') || strcmp(experiment.Exp_type,'B1') || strcmp(experiment.Exp_type,'C1') || strcmp(experiment.Exp_type,'D1')
            %         getBaselineSUAPPC(experiment,[],[],1,0)´
            getBaselineSWSUAfiringRate(experiment,1,0)        
%             getBaselineSWWaveletPower(experiment,1,0)
%             getBaselineOscPowerKaksi(experiment,save_data,repeatCalc)
%             getBaselineCoherence(experiment,save_data,repeatCalc)
%             getBaselineSUAspikeSpectrum(experiment, save_data, repeatCalc)
% 
        end
    end
end


