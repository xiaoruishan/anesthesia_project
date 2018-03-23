function MCplotStimulationPowerRatioSingleRamps(experiments,expType,StimArea,RespArea)
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
            powerPre(:,FREQ)=mean(StimulationPowerSingleRamps.preStim(:,freqWindow(1):freqWindow(2)),2);
            powerStim(:,FREQ)=mean(StimulationPowerSingleRamps.StimLastHalf(:,freqWindow(1):freqWindow(2)),2); % stimLastHalf stimFirstHalf stim
        end
        RelSpectrum(countAnimal,:)=median(StimulationPowerSingleRamps.StimLastHalf./StimulationPowerSingleRamps.preStim); % stimLastHalf stimFirstHalf stim
        PowerPre=vertcat(PowerPre,powerPre);
        PowerStim=vertcat(PowerStim,powerStim);
        PowerRatioStim(countAnimal,:)=median(powerStim./powerPre);
        clearvars StimStructure freqSpecStructure powerPre powerStim
        PowerRaw(countAnimal,:)=median(StimulationPowerSingleRamps.StimLastHalf);
        PowerRawPre(countAnimal,:)=median(StimulationPowerSingleRamps.preStim);
    end
end
PowerRatioPre=ones(countAnimal,FREQ);
xvalues=vertcat(repmat(0.2,length(PowerPre),1),repmat(0.8,length(PowerPre),1));
% xvalues([1:length(xvalues)/trim length(xvalues)-length(xvalues)/trim+1:length(xvalues)])=[];
% [ratio,index]=sort(PowerPre(:,1)./PowerStim(:,1));
% outliers=index([1:length(ratio)/trim length(ratio)-length(ratio)/trim+1:length(ratio)]);
% PowerPre(outliers,1)=[]; PowerStim(outliers,1)=[];
theta=vertcat(PowerPre(:,1),PowerStim(:,1));
% theta([outliers outliers+length(PowerPre)])=[];
p=signrank(PowerPre(:,1),PowerStim(:,1));
figure
subplot(1,3,1)
hold on
scatter(xvalues,log(theta),50,'s','filled','k')
theta4plot=log(reshape(theta,length(xvalues)/2,2)');
inhib=nnz(theta4plot(1,:)>theta4plot(2,:));
line(reshape(xvalues,length(xvalues)/2,2)',theta4plot,'linewidth',1,'color','k')
line([0.2 0.8],[median(theta4plot(1,:)) median(theta4plot(2,:))],'linewidth',3,'color','r')
line([0.2 0.8],[mean(theta4plot(1,:)) mean(theta4plot(2,:))],'linewidth',3,'color','b')
title(strcat('theta p=',num2str(p),' - ',num2str(inhib),'/',num2str(length(theta4plot))))
xlim([0 1])

% [ratio,index]=sort(PowerPre(:,2)./PowerStim(:,2));
% outliers=index([1:length(ratio)/trim length(ratio)-length(ratio)/trim+1:length(ratio)]);
beta=vertcat(PowerPre(:,2),PowerStim(:,2));
% beta([outliers outliers+length(PowerPre)])=[];
p=signrank(PowerPre(:,2),PowerStim(:,2));
subplot(1,3,2)
hold on
scatter(xvalues,log(beta),50,'s','filled','k')
beta4plot=log(reshape(beta,length(xvalues)/2,2)');
inhib=nnz(beta4plot(1,:)>beta4plot(2,:));
line(reshape(xvalues,length(xvalues)/2,2)',beta4plot,'linewidth',1,'color','k')
line([0.2 0.8],[median(beta4plot(1,:)) median(beta4plot(2,:))],'linewidth',3,'color','r')
line([0.2 0.8],[mean(beta4plot(1,:)) mean(beta4plot(2,:))],'linewidth',3,'color','b')
title(strcat('beta p=',num2str(p),' - ',num2str(inhib),'/',num2str(length(beta4plot))))
xlim([0 1])

% [ratio,index]=sort(PowerPre(:,3)./PowerStim(:,3));
% outliers=index([1:length(ratio)/trim length(ratio)-length(ratio)/trim+1:length(ratio)]);
gamma=vertcat(PowerPre(:,3),PowerStim(:,3));
% gamma([outliers outliers+length(PowerPre)])=[];
p=signrank(PowerPre(:,3),PowerStim(:,3));
subplot(1,3,3)
hold on
scatter(xvalues,log(gamma),50,'s','filled','k')
gamma4plot=log(reshape(gamma,length(xvalues)/2,2)');
inhib=nnz(gamma4plot(1,:)>gamma4plot(2,:));
line(reshape(xvalues,length(xvalues)/2,2)',gamma4plot,'linewidth',1,'color','k')
line([0.2 0.8],[median(gamma4plot(1,:)) median(gamma4plot(2,:))],'linewidth',3,'color','r')
line([0.2 0.8],[mean(gamma4plot(1,:)) mean(gamma4plot(2,:))],'linewidth',3,'color','b')
title(strcat('gamma p=',num2str(p),' - ',num2str(inhib),'/',num2str(length(gamma4plot))))
xlim([0 1])

clearvars theta beta gamma PowerPre PowerPost xvalues

xvalues=vertcat(repmat(0.2,countAnimal,1),repmat(0.8,countAnimal,1));
figure;
subplot(1,3,1)
scatter(xvalues,reshape([PowerRatioPre(:,1) PowerRatioStim(:,1)],countAnimal*2,1),50,'s','filled','k')
p=signrank(PowerRatioPre(:,1),PowerRatioStim(:,1));
% scatter(xvalues,reshape([trimmedpowerPre(:,1) trimmedpowerStim(:,1)],countAnimal*2,1),50,'s','filled','k')
% p=signrank(trimmedpowerPre(:,1),trimmedpowerStim(:,1));
hold on
line(reshape(xvalues,length(xvalues)/2,2)',[PowerRatioPre(:,1) PowerRatioStim(:,1)]','linewidth',1,'color','k')
line([0.2 0.8],[median(PowerRatioPre(:,1)) median(PowerRatioStim(:,1))],'linewidth',3,'color','r')
title(strcat('theta 4-12 Hz p=',num2str(p)))
xlim([0 1])
set(gca,'TickDir','out');
set(gca,'FontSize',12)

subplot(1,3,2)
scatter(xvalues,reshape([PowerRatioPre(:,2) PowerRatioStim(:,2)],countAnimal*2,1),50,'s','filled','k')
p=signrank(PowerRatioPre(:,2),PowerRatioStim(:,2));
% scatter(xvalues,reshape([trimmedpowerPre(:,2) trimmedpowerStim(:,2)],countAnimal*2,1),50,'s','filled','k')
% p=signrank(trimmedpowerPre(:,2),trimmedpowerStim(:,2));
hold on
line(reshape(xvalues,length(xvalues)/2,2)',[PowerRatioPre(:,2) PowerRatioStim(:,2)]','linewidth',1,'color','k')
line([0.2 0.8],[median(PowerRatioPre(:,2)) median(PowerRatioStim(:,2))],'linewidth',3,'color','r')
title(strcat('beta 12-30 Hz p=',num2str(p)))
xlim([0 1])
set(gca,'TickDir','out');
set(gca,'FontSize',12)

subplot(1,3,3)
scatter(xvalues,reshape([PowerRatioPre(:,3) PowerRatioStim(:,3)],countAnimal*2,1),50,'s','filled','k')
p=signrank(PowerRatioPre(:,3),PowerRatioStim(:,3));
% scatter(xvalues,reshape([trimmedpowerPre(:,3) trimmedpowerStim(:,3)],countAnimal*2,1),50,'s','filled','k')
% p=signrank(trimmedpowerPre(:,3),trimmedpowerStim(:,3));
hold on
line(reshape(xvalues,length(xvalues)/2,2)',[PowerRatioPre(:,3) PowerRatioStim(:,3)]','linewidth',1,'color','k')
line([0.2 0.8],[median(PowerRatioPre(:,3)) median(PowerRatioStim(:,3))],'linewidth',3,'color','r')
title(strcat('gamma 30-100 Hz p=',num2str(p)))
xlim([0 1])
set(gca,'TickDir','out');
set(gca,'FontSize',12)

% 
figure; boundedline(linspace(0,400,801),mean(RelSpectrum),std(RelSpectrum)./sqrt(size(RelSpectrum,1)),'r')
hold on
plot(get(gca,'xlim'),[1 1],'r','linewidth',3)
set(gca,'TickDir','out');
title('Relative Power Spectrum')
ylabel('Relative Power')
xlabel('Frequency (Hz)')
set(gca,'FontSize',12)
xlim([4 50])
end