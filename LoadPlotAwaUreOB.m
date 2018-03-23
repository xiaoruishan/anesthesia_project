%% same old scripts

clear all

path=get_path;
experiments=get_experiment_list;
animal=101:142;

%% initialize a gazillion variables

FR = zeros(3,length(animal)); complexity = FR; complexity1 = FR; duration = zeros(3,length(animal));
amplitude = duration; occurrence = duration; theta = duration; beta = duration; gamma = duration;
PowerPlot = zeros(3201,4, length(animal)/2); PPC_Spec = zeros(50,3,length(animal)); entropy = duration;

%% load stuff 

for n=1:length(animal)
    experiment=experiments(animal(n));
    CSC=experiment.IL;% Cg IL       Cg STAYS FOR LEC; IL FOR OB
    if strcmp(experiment.Exp_type,'AWA')
        repetitions=1;
    else
        repetitions=1:3;
    end
    for period=repetitions
        canale=0;
        try
            experiment.PL = str2num(experiment.PL); % experiment.nameDead PL   PL = LEC dead = OB
        catch
        end
        for channel=experiment.nameDead % experiment.nameDead you might wanna insert ISI in here, for the moment it is not being loaded
            canale=canale+1;
            load(strcat(path.output,filesep,'results\MUAfiringrate\',experiment.name,filesep,'MUAfiringrate15',num2str(channel),num2str(period),'.mat'))
%             load(strcat(path.output,filesep,'results\Lempel-Ziv\',experiment.name,filesep,'Lempel-Ziv15',num2str(channel),num2str(period),'.mat'))
%             load(strcat(path.output,filesep,'results\ISI\',experiment.name,filesep,'ISI15',num2str(channel),num2str(period),'.mat'))
%             try
%                 load(strcat(path.output,filesep,'results\PPC_Spectrum\',experiment.name,filesep,'PPC_Spectrum15',num2str(channel),num2str(period),'.mat'))
%             catch
%             end
            fr(canale)=MUAfiringrate;
%             comp(canale)=numel(LZ.NumRepBin)./LZ.inputLength;
%             comp1(canale)=LZ.compRatio;
%             ppc(:,canale) = PPC_Spectrum;
        end
        FR(period, n) = nanmedian(fr);
%         complexity(period, n) = nanmedian(comp);
%         complexity1(period, n) = nanmedian(comp1);
%         PPC_Spec(:, period, n) = nanmedian(ppc,2);
        load(strcat(path.output,filesep,'results\BaselineOscAmplDurOcc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        duration(period,n)=OscAmplDurOcc.baseline.meanDurOsc(1);
%         amplitude(period,n)=OscAmplDurOcc.baseline.meanAmplOsc_max(1);
        occurrence(period,n)=OscAmplDurOcc.baseline.occurrenceOsc(1);
%         load(strcat(path.output,filesep,'results\baselinePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         theta(period,n)=baselinePower.baseline.thetaOsc;
%         beta(period,n)=baselinePower.baseline.betaOsc;
%         gamma(period,n)=baselinePower.baseline.gammaOsc;
%         if strcmp(experiment.Exp_type,'AWA')
%             PowerPlot(:,period,(n+1)/2)=baselinePower.baseline.pxxWelchFull;
%         else
%             PowerPlot(:,period+1,n/2)=baselinePower.baseline.pxxWelchFull;
%         end
%         load(strcat(path.output,filesep,'results\SampleEntropy\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         entropy(period,n)=nanmean(SE);
%         load(strcat(path.output,filesep,'results\MinutePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         if size(pWelch,1)<15
%             pWelch(size(pWelch,1):15,:)=NaN;
%         end
%         if n<35
%             if strcmp(experiment.Exp_type,'AWA')
%                 minutePower(15*(period-1)+1:15*period,:,(n+1)/2)=pWelch;
%             else
%                 minutePower(15*(period)+1:15*(period+1),:,n/2)=pWelch;
%             end
%         end
%         load(strcat(path.output,filesep,'results\BaselineCoherence\',experiment.name,filesep,'15',num2str(experiment.Cg),num2str(period),'.mat'))
%         if strcmp(experiment.Exp_type,'AWA')
%             Coherence(:,period,(n+1)/2)=ImCoh.Coh;
%             Dummy(:,period,(n+1)/2)=ImCoh.Dummy;
%         else
%             Coherence(:,period+1,n/2)=ImCoh.Coh;
%             Dummy(:,period+1,n/2)=ImCoh.Dummy;
%         end
%         load(strcat(path.output,filesep,'results\EntropyStuff\',experiment.name,filesep,'15',num2str(experiment.Cg),num2str(period),'.mat'))
%         if strcmp(experiment.Exp_type,'AWA')
%             CondEnt(:,period,(n+1)/2)=ImCoh.Coh;
%             Dummy(:,period,(n+1)/2)=ImCoh.Dummy;
%         else
%             Coherence(:,period+1,n/2)=ImCoh.Coh;
%             Dummy(:,period+1,n/2)=ImCoh.Dummy;
%         end
    end
end


%% reshape so that you attach the urethane data to the awake of the same animal

FR=reshape(FR,size(FR,1)*2,size(FR,2)/2); FR(2:3,:)=[];
duration=reshape(duration,size(duration,1)*2,size(duration,2)/2); duration(2:3,:)=[];
amplitude=reshape(amplitude,size(amplitude,1)*2,size(amplitude,2)/2); amplitude(2:3,:)=[];
occurrence=reshape(occurrence,size(occurrence,1)*2,size(occurrence,2)/2); occurrence(2:3,:)=[];
theta=reshape(theta,size(theta,1)*2,size(theta,2)/2); theta(2:3,:)=[];
beta=reshape(beta,size(beta,1)*2,size(beta,2)/2); beta(2:3,:)=[];
gamma=reshape(gamma,size(gamma,1)*2,size(gamma,2)/2); gamma(2:3,:)=[];
osc_time=duration.*occurrence./60*100;
entropy=reshape(entropy,size(entropy,1)*2,size(entropy,2)/2); entropy(2:3,:)=[];
complexity=reshape(complexity,size(complexity,1)*2,size(complexity,2)/2); complexity(2:3,:)=[];
complexity1=reshape(complexity1,size(complexity1,1)*2,size(complexity1,2)/2); complexity1(2:3,:)=[];
PPC_Spec = reshape(PPC_Spec,size(PPC_Spec,1),size(PPC_Spec,2)*2,size(PPC_Spec,3)/2); PPC_Spec(:,2:3,:) = [];
ppc_delta = squeeze(nanmean(PPC_Spec(1:2,:,:)));
ppc_theta = squeeze(nanmean(PPC_Spec(3:6,:,:)));
ppc_beta = squeeze(nanmean(PPC_Spec(7:15,:,:)));
ppc_gamma = squeeze(nanmean(PPC_Spec(16:50,:,:)));

%% plot 1st versus last oscillations

xvalues=vertcat(linspace(1,1,length(FR)),linspace(2,2,length(FR)));
figure; scatter(xvalues(1,:),log10(FR(1,:)./(60*15)),'s','filled','k'); hold on; scatter(xvalues(2,:),log10(FR(2,:)./(60*15)),'s','filled','k')
plot(xvalues,vertcat(log10(FR(1,:)./(60*15)),log10(FR(2,:)./(60*15))),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[]); set(gca,'TickDir','out')
scatter(xvalues(:,1),median(log10(FR(1:2,:)./(60*15)),2)','s','filled','r'); plot(xvalues(:,1),median(log10(FR(1:2,:)./(60*15)),2)','r','linewidth',3);
title(strcat('Firing Rate p=',num2str(signrank(FR(1,:),FR(2,:))))); ylabel('Log firing rate (spikes/s)'); xlabel('Pre vs Post'); set(gca,'FontSize',20); ylim([-3 2]);

xvalues=vertcat(linspace(1,1,length(amplitude)),linspace(2,2,length(amplitude)));
figure; scatter(xvalues(1,:),amplitude(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),amplitude(2,:),'s','filled','k')
plot(xvalues,vertcat(amplitude(1,:),amplitude(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('Amplitude p=',num2str(signrank(amplitude(1,:),amplitude(2,:))))); ylabel('Amplitude (µV)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
figure; scatter(xvalues(1,:),osc_time(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),osc_time(2,:),'s','filled','k')
plot(xvalues,vertcat(osc_time(1,:),osc_time(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('% of FullTime p=',num2str(signrank(osc_time(1,:),osc_time(2,:))))); ylabel('% of FullTime'); xlabel('Pre vs Post'); set(gca,'FontSize',20)

% figure; scatter(xvalues(1,:),duration(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),duration(2,:),'s','filled','k')
% plot(xvalues,vertcat(duration(1,:),duration(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('Duration p=',num2str(signrank(duration(1,:),duration(2,:))))); ylabel('Duration (s)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% figure; scatter(xvalues(1,:),occurrence(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),occurrence(2,:),'s','filled','k')
% plot(xvalues,vertcat(occurrence(1,:),occurrence(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('Occurrence p=',num2str(signrank(occurrence(1,:),occurrence(2,:))))); ylabel('Occurrence (osc/min)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)


%% plot 1st versus last power

xvalues=vertcat(linspace(1,1,length(theta)),linspace(2,2,length(theta)));

figure; boundedline(linspace(1,400,3201),mean(PowerPlot(:,1,:)./PowerPlot(:,2,:),3), ...
    std(PowerPlot(:,1,:)./PowerPlot(:,2,:),0,3)./sqrt(size(PowerPlot,3)))
xlim([4 50]); ylim([0.5 6]); title('Relative Power Spectrum'); ylabel('Power (µV^2)'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)

figure; scatter(xvalues(1,:),theta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),theta(2,:),'s','filled','k')
plot(xvalues,vertcat(theta(1,:),theta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('Theta p=',num2str(signrank(theta(1,:),theta(2,:))))); ylabel('4-12 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
figure; scatter(xvalues(1,:),beta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),beta(2,:),'s','filled','k')
plot(xvalues,vertcat(beta(1,:),beta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('Beta p=',num2str(signrank(beta(1,:),beta(2,:))))); ylabel('12-30 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
figure; scatter(xvalues(1,:),gamma(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),gamma(2,:),'s','filled','k')
plot(xvalues,vertcat(gamma(1,:),gamma(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('Gamma p=',num2str(signrank(gamma(1,:),gamma(2,:))))); ylabel('30-100 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)


%% plot 1st versus last PPC

figure; boundedline(linspace(1,100,50),nanmean(PPC_Spec(:,1,:),3),nanstd(PPC_Spec(:,1,:),0,3)./sqrt(size(PPC_Spec,3)));
hold on; boundedline(linspace(1,100,50),nanmean(PPC_Spec(:,2,:),3),nanstd(PPC_Spec(:,2,:),0,3)./sqrt(size(PPC_Spec,3)),'r')
xlim([1 100]); title('PPC Spectrum'); ylabel('PPC'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20); set(gca,'TickDir','out')

xvalues=vertcat(linspace(1,1,length(ppc_gamma)),linspace(2,2,length(ppc_gamma)));

figure; scatter(xvalues(1,:),ppc_delta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),ppc_delta(2,:),'s','filled','k')
plot(xvalues,vertcat(ppc_delta(1,:),ppc_delta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('PPC Delta p=',num2str(signrank(ppc_delta(1,:),ppc_delta(2,:))))); ylabel('PPC Delta'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
figure; scatter(xvalues(1,:),ppc_theta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),ppc_theta(2,:),'s','filled','k')
plot(xvalues,vertcat(ppc_theta(1,:),ppc_theta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('PPC Theta p=',num2str(signrank(ppc_theta(1,:),ppc_theta(2,:))))); ylabel('PPC Theta'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
figure; scatter(xvalues(1,:),ppc_beta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),ppc_beta(2,:),'s','filled','k')
plot(xvalues,vertcat(ppc_beta(1,:),ppc_beta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('PPC Beta p=',num2str(signrank(ppc_beta(1,:),ppc_beta(2,:))))); ylabel('PPC Beta'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
figure; scatter(xvalues(1,:),ppc_gamma(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),ppc_gamma(2,:),'s','filled','k')
plot(xvalues,vertcat(ppc_gamma(1,:),ppc_gamma(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('PPC Gamma p=',num2str(signrank(ppc_gamma(1,:),ppc_gamma(2,:))))); ylabel('PPC Gamma'); xlabel('Pre vs Post'); set(gca,'FontSize',20)

%% complexity

xvalues=vertcat(linspace(1,1,length(entropy)),linspace(2,2,length(entropy)));
figure; scatter(xvalues(1,:),entropy(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),entropy(2,:),'s','filled','k')
plot(xvalues,vertcat(entropy(1,:),entropy(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('Entropy p=',num2str(signrank(entropy(1,:),entropy(2,:))))); ylabel('Sample Entropy'); xlabel('Pre vs Post'); set(gca,'FontSize',20)

xvalues=vertcat(linspace(1,1,length(complexity)),linspace(2,2,length(complexity)));
figure; scatter(xvalues(1,:),complexity(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),complexity(2,:),'s','filled','k')
plot(xvalues,vertcat(complexity(1,:),complexity(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
title(strcat('Lempel-Ziv complexity p=',num2str(signrank(complexity(1,:),complexity(2,:))))); ylabel('Complexity'); xlabel('Pre vs Post'); set(gca,'FontSize',20)


%% plot minute power

m1=nanmean(minutePower,3);
m2=nanmean(mean(minutePower,3));
standard=std(nanmean(minutePower,3));
zscore=bsxfun(@rdivide,bsxfun(@minus,m1,m2),standard);
figure; imagesc(linspace(1,60,60),linspace(1,250,501),zscore',[-1 2]); axis xy; ylim([0 50])
hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3)
title('Minute by minute power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)

%% plot coherence & gPDC

figure; boundedline(linspace(1,100,2001),mean(Coherence(:,1,:),3),std(Coherence(:,1,:),0,3)./sqrt(size(Coherence,3)))
hold on; boundedline(linspace(1,100,2001),mean(mean(Coherence(:,2,:),2),3),std(mean(Coherence(:,2,:),2),0,3)./sqrt(size(Coherence,3)),'r')
xlim([0 45]); title('Coherency - OB and LEC'); ylabel('Coherency'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)