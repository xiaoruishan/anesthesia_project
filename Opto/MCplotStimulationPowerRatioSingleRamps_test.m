function MCplotStimulationPowerRatioSingleRamps_test(experiments,expType,StimArea,RespArea,trim)
% by Mattia
stimulusType={'ramp'};
Path=get_path;
freqWindows = [4 12;12 30;30 100]; % add to param
Frequency = 0;
countAnimal=0;
PowerPre=[];
PowerStim=[];
% SpectrumStim=[];
% SpectrumPre=[];
% SpectrumRatio=[];
for n_animal = 1:length(experiments);
    experiment=experiments(n_animal);
    if ~isempty(experiment.animal_ID) && experiment.expression(1)==1 && strcmp(experiment.Exp_type,expType{1}) && strcmp(experiment.IUEarea,StimArea)
        if strcmp(RespArea, 'HP')
            CSC=experiment.HPreversal;
        elseif strcmp(RespArea, 'PFCL2')
            CSC=experiment.PL(1);
        elseif strcmp(RespArea, 'PFCL5')
            CSC=experiment.PL(4);
        end
        countAnimal=countAnimal+1;
        if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationPowerSingleRamps',filesep,experiment.name,filesep,'CSC',num2str(CSC),'_ramp.mat'))
            stimStructure = getStimulusSignal(experiment,CSC,stimulusType{1},Frequency,10);
            [StimulationPowerSingleRamps]=getStimulationPowerSingleRamps(stimStructure,experiment,1,0);
        else
            stimStructure.stimulusType=stimulusType{1};
            stimStructure.stimulusFrequency=Frequency;
            stimStructure.CSC=CSC;
            [StimulationPowerSingleRamps]=getStimulationPowerSingleRamps(stimStructure,experiment,1,0);
        end
        StimulationPowerSingleRamps.f_preStim=linspace(1,400,801);
        for FREQ = 1:length(freqWindows)
            freqWindow = [find(StimulationPowerSingleRamps.f_preStim >= freqWindows(FREQ,1),1,'first'), find(StimulationPowerSingleRamps.f_preStim >= freqWindows(FREQ,2),1,'first')];
            powerPre(:,FREQ)=sum(StimulationPowerSingleRamps.preStim(:,freqWindow(1):freqWindow(2)),2);
            powerStim(:,FREQ)=sum(StimulationPowerSingleRamps.StimLastHalf(:,freqWindow(1):freqWindow(2)),2); %pxx_stimLastHalf pxx_stim
        end
        PowerPre=vertcat(PowerPre,powerPre);
        PowerStim=vertcat(PowerStim,powerStim);
        medianPowerPre(countAnimal,:)=trimmean(powerPre,trim);
        medianPowerStim(countAnimal,:)=trimmean(powerStim,trim);
        clearvars StimStructure freqSpecStructure powerPre powerStim
    end
end

xvalues=vertcat(repmat(0.2,countAnimal,1),repmat(0.8,countAnimal,1));
figure;
subplot(1,3,1)
scatter(xvalues,reshape([medianPowerPre(:,1) medianPowerStim(:,1)],countAnimal*2,1),50,'s','filled','k')
p=signrank(medianPowerPre(:,1),medianPowerStim(:,1));
% scatter(xvalues,reshape([trimmedpowerPre(:,1) trimmedpowerStim(:,1)],countAnimal*2,1),50,'s','filled','k')
% p=signrank(trimmedpowerPre(:,1),trimmedpowerStim(:,1));
hold on
line(reshape(xvalues,length(xvalues)/2,2)',[medianPowerPre(:,1) medianPowerStim(:,1)]','linewidth',2)
title(strcat('theta 4-12 Hz p=',num2str(p)))
xlim([0 1])

subplot(1,3,2)
scatter(xvalues,reshape([medianPowerPre(:,2) medianPowerStim(:,2)],countAnimal*2,1),50,'s','filled','k')
p=signrank(medianPowerPre(:,2),medianPowerStim(:,2));
% scatter(xvalues,reshape([trimmedpowerPre(:,2) trimmedpowerStim(:,2)],countAnimal*2,1),50,'s','filled','k')
% p=signrank(trimmedpowerPre(:,2),trimmedpowerStim(:,2));
hold on
line(reshape(xvalues,length(xvalues)/2,2)',[medianPowerPre(:,2) medianPowerStim(:,2)]','linewidth',2)
title(strcat('beta 12-30 Hz p=',num2str(p)))
xlim([0 1])

subplot(1,3,3)
scatter(xvalues,reshape([medianPowerPre(:,3) medianPowerStim(:,3)],countAnimal*2,1),50,'s','filled','k')
p=signrank(medianPowerPre(:,3),medianPowerStim(:,3));
% scatter(xvalues,reshape([trimmedpowerPre(:,3) trimmedpowerStim(:,3)],countAnimal*2,1),50,'s','filled','k')
% p=signrank(trimmedpowerPre(:,3),trimmedpowerStim(:,3));
hold on
line(reshape(xvalues,length(xvalues)/2,2)',[medianPowerPre(:,3) medianPowerStim(:,3)]','linewidth',2)
title(strcat('gamma 30-100 Hz p=',num2str(p)))
xlim([0 1])

end