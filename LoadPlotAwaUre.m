%% same old scripts

clear all
tic
path = get_path;
experiments = get_experiment_list;
animal = 1 : 38;

%% initialize a gazillion variables

% ISIure=[]; ISIawa=[];
% FR = zeros(2, 1, length(animal)/2); complexity = FR; complexity1 = FR; PPC_awa = zeros(50,4); PPC_ure = PPC_awa; duration = zeros(3,length(animal));
% amplitude = duration; occurrence = duration; theta = duration; beta = duration; gamma = duration; ppc_theta = duration;
% ppc_beta = duration; ppc_gamma = duration; PowerPlot = zeros(3201,4, length(animal)/2); PPC_Spec = zeros(50,4,length(animal)/2);
% entropy = duration;
% spikes_over_time = zeros(length(animal)/2, 5); edges = linspace(0, 900, 6);

%% load stuff 

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = experiment.HPreversal(1); % PL(1) PL(4) HPreversal
    if strcmp(experiment.Exp_type, 'AWA')
        repetitions = 1;
    else
        repetitions = 1 : 3;
    end
    for period = repetitions
%         canale = 0;
%         for channel = [experiment.HPreversal-1 : experiment.HPreversal+1]
%             canale = canale+1;
%             load(strcat(path.output,filesep,'results\MUAfiringrate\',experiment.name,filesep,'MUAfiringrate15',num2str(channel),num2str(period),'.mat'))
%             load(strcat(path.output,filesep,'results\Lempel-Ziv\',experiment.name,filesep,'Lempel-Ziv15',num2str(channel),num2str(period),'.mat'))
%             load(strcat(path.output,filesep,'results\ISI\',experiment.name,filesep,'ISI15',num2str(channel),num2str(period),'.mat'))
%             try
%                 load(strcat(path.output,filesep,'results\PPC_Spectrum\',experiment.name,filesep,'PPC_Spectrum15',num2str(channel),num2str(period),'.mat'))
%                 if isnan(PPC_Spectrum)
%                     PPC(canale, :) = nan(1, 50);
%                 else
%                     PPC(canale, :) = PPC_Spectrum;
%                 end
%             catch
%                 PPC(canale, :) = nan(1, 50);
%             end 
%             load(strcat(path.output,filesep,'results\MUAtimestamps\',experiment.name,filesep,'MUAtimestamps15',num2str(channel),num2str(period),'.mat'))
%             timestamps = floor(peakLoc./(32000));
%             spike_count(canale, :) = histcounts(timestamps, edges);
%             MUA(canale, :) = MUAfiringrate;
%             clear PPC_Spectrum
%         end
%         spikes_count = sum(spike_count);
%         if strcmp(experiment.Exp_type,'AWA')
%                 spikes_over_time((n+1)/2, 1:5) = median(spike_count, 1);
%                 FR(period, (n+1)/2) = nanmedian(MUA);
%                 complexityy(period,canale,(n+1)/2)=numel(LZ.NumRepBin)./LZ.inputLength;
%                 complexity1(period,canale,(n+1)/2)=LZ.compRatio;
%                 ISIawa=[ISIawa ISI];
%                 PPC_awa = nanmean(PPC, 1);
%         elseif strcmp(experiment.Exp_type,'URE') %&& period==1
%                 spikes_over_time(n/2, (1:5) + 5 * period) = median(spike_count, 1);
%                 FR(period+1, n/2) = nanmedian(MUA);
%                 complexityy(period+1,canale,n/2)=numel(LZ.NumRepBin)./LZ.inputLength;
%                 complexity1(period+1,canale,n/2)=LZ.compRatio;
%                 ISIure=[ISIure ISI];
%                 PPC_ure = nanmean(PPC, 1);
%         end
%         clear spike_count
%     end
%         complexity = mean(complexityy,2);
%         load(strcat(path.output,filesep,'results\BaselineOscAmplDurOcc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         OscAmplDurOcc.baseline.OscTimes
%         duration(period,n)=OscAmplDurOcc.baseline.meanDurOsc(1);
%         amplitude(period,n)=OscAmplDurOcc.baseline.meanAmplOsc_max(1);
%         occurrence(period,n)=OscAmplDurOcc.baseline.occurrenceOsc(1);
%         load(strcat(path.output,filesep,'results\baselinePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         thetaOsc(period, n) = baselinePower.baseline.thetaOsc;
%         betaOsc(period, n) = baselinePower.baseline.betaOsc;
%         gammaOsc(period, n) = baselinePower.baseline.gammaOsc;
%         theta(period, n) = baselinePower.baseline.thetaFull;
%         beta(period, n) = baselinePower.baseline.betaFull;
%         gamma(period, n) = baselinePower.baseline.gammaFull;
%         if strcmp(experiment.Exp_type,'AWA')
%             PowerPlot(:, period, (n+1)  / 2) = baselinePower.baseline.pxxWelchFull;
%             PowerPlotOsc(:, period, (n+1) / 2) = baselinePower.baseline.pxxWelchOsc;
%         else
%             PowerPlot(:, period+1, n / 2) = baselinePower.baseline.pxxWelchFull;
%             PowerPlotOsc(:, period+1, n / 2) = baselinePower.baseline.pxxWelchOsc;
%         end
%         load(strcat(path.output,filesep,'results\baselineSlowPower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         rrOsc(period, n) = baselineSlowPower.baseline.betaOsc;
%         rr(period, n) = baselineSlowPower.baseline.betaFull;
%         if strcmp(experiment.Exp_type,'AWA')
%             PowerPlotSlow(:, period, (n+1)/2) = baselineSlowPower.baseline.pxxWelchFull;
%             try
%                 PowerPlotSlowOsc(:, period, (n+1)/2) = baselineSlowPower.baseline.pxxWelchOsc;
%             catch
%                 PowerPlotSlowOsc(:, period, (n+1)/2) = zeros(1, 65);
%             end
%         else
%             PowerPlotSlow(:, period+1, n/2) = baselineSlowPower.baseline.pxxWelchFull;
%             try
%                 PowerPlotSlowOsc(:, period+1, n/2) = baselineSlowPower.baseline.pxxWelchOsc;
%             catch
%                 PowerPlotSlowOsc(:, period, n/2) = zeros(1, 65);
%             end
%                 
%         end          
%         if strcmp(experiment.Exp_type,'AWA')
%             PPC_Spec((n + 1) / 2, period, :) = PPC_awa;
%             PPC_Spec(:,n) = PPC_awa;
%         else
%             PPC_Spec(n / 2, period + 1, :) = PPC_ure;
%             PPC_Spec(:,n) = PPC_ure;
%         end
%         load(strcat(path.output,filesep,'results\PPC&PCDI&PLV\',experiment.name,filesep,'PPC15',num2str(CSC),num2str(period),'.mat'))
%         ppc_theta(period,n)=PPC(1);
%         ppc_beta(period,n)=PPC(2);
%         ppc_gamma(period,n)=PPC(3);
%         load(strcat(path.output,filesep,'results\SampleEntropy\',experiment.name,filesep,'SampEntFullCSC15',num2str(CSC),num2str(period),'.mat'))
%         entropy(period,n)=nanmean(SampEnt);
%         load(strcat(path.output,filesep,'results\EntropyStuffBisFreq\',experiment.name,filesep,'15',num2str(CSC),num2str(period),'.mat'))
%         DiffEnt1(period, :, n) = EntropyStuffBis.DiffEnt1;
%         DiffEnt2(period, :, n) = EntropyStuffBis.DiffEnt2;
%         MutInfo(period, :, n) = EntropyStuffBis.MutInfo;
%         load(strcat(path.output,filesep,'results\AmpPhaseCorr\',experiment.name,filesep,'15',num2str(CSC),num2str(period),'.mat'))
%         AmpCorr(period, :, n) = squeeze(mean(AmpPhaseCor(1:23, :), 2));
%         PhaseCorr(period, :, n) = squeeze(mean(AmpPhaseCor(24:end, :), 2));
        load(strcat(path.output, filesep, 'results\MinutePower\', experiment.name, filesep, ...
            'CSC15', num2str(CSC), num2str(period), '.mat'))
        if size(pWelch,1) < 15
            pWelch(size(pWelch, 1):15, :) = NaN;
        end
        if n < 400
            if strcmp(experiment.Exp_type,'AWA')
                minutePower(15 * (period - 1) + 1:15 * period, :, (n + 1) / 2) = pWelch;
            else
                minutePower(15 * period+1 : 15 * (period + 1), :, n / 2) = pWelch;
            end
        end
        load(strcat(path.output, filesep, 'results\MinutePower\', experiment.name, filesep, ...
            'CSC15', num2str(CSC), num2str(period), 'median.mat'))
        if size(pWelch,1) < 15
            pWelch(size(pWelch, 1):15, :) = NaN;
        end
        if n < 400
            if strcmp(experiment.Exp_type,'AWA')
                medianMinutePower(15 * (period - 1) + 1:15 * period, :, (n + 1) / 2) = pWelch;
            else
                medianMinutePower(15 * period+1 : 15 * (period + 1), :, n / 2) = pWelch;
            end
        end

        load(strcat(path.output, filesep, 'results\MinutePowerOsc\', experiment.name, ...
            filesep, 'CSC15', num2str(CSC), num2str(period), '.mat'))
        if size(pWelchOsc,1) < 15
            pWelchOsc(size(pWelchOsc, 1):15, :) = NaN;
        end
        if n < 400
            if strcmp(experiment.Exp_type,'AWA')
                minutePowerOsc(15 * (period - 1) + 1:15 * period, :, (n + 1) / 2) = pWelchOsc;
            else
                minutePowerOsc(15 * period+1 : 15 * (period + 1), :, n / 2) = pWelchOsc;
            end
        end
        load(strcat(path.output, filesep, 'results\MinutePowerOsc\', experiment.name, ...
            filesep, 'CSC15', num2str(CSC), num2str(period), 'median.mat'))
        if size(pWelchOsc,1) < 15
            pWelchOsc(size(pWelchOsc, 1):15, :) = NaN;
        end
        if n < 400
            if strcmp(experiment.Exp_type,'AWA')
                medianMinutePowerOsc(15 * (period - 1) + 1:15 * period, :, (n + 1) / 2) = pWelchOsc;
            else
                medianMinutePowerOsc(15 * period+1 : 15 * (period + 1), :, n / 2) = pWelchOsc;
            end
        end
        
%         load(strcat(path.output,filesep,'results\SecondPower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         if size(SecondPower, 1) < 900
%             SecondPower(size(SecondPower,1) : 900,:)=NaN;
%         end
%         if strcmp(experiment.Exp_type,'AWA')
%             secondPower(900*(period-1)+1:900*period,:,(n+1)/2) = SecondPower;
%         else
%             secondPower(900*(period)+1:900*(period+1),:,n/2) = SecondPower;
%         end
%         try
%             load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         catch
%             signal(1, 1: 15) = NaN;
%         end
%         if size(signal, 2) < 15
%             signal(1, size(signal, 2) : 15) = NaN;
%         end
%         if n < 400
%             if strcmp(experiment.Exp_type,'AWA')
%                 MinuteOsc(15*(period-1)+1:15*period,(n+1)/2)=signal;
%             else
%                 MinuteOsc(15*(period)+1:15*(period+1),n/2)=signal;
%             end
%         end
%         load(strcat(path.output,filesep,'results\BaselineCoherence\',experiment.name,filesep,'15',num2str(experiment.HPreversal),num2str(period),'.mat'))
%         if strcmp(experiment.Exp_type,'AWA')
%             Coherence(:,n)=ImCoh.Coh;
%             Coherence(:,period,(n+1)/2)=ImCoh.Coh;
%             Dummy(:,period,(n+1)/2)=ImCoh.Dummy;
%         else
%             Coherence(:,period+1,n/2)=ImCoh.Coh;
%             Coherence(:,n)=ImCoh.Coh;
%             Dummy(:,period+1,n/2)=ImCoh.Dummy;
%         end
%         load(strcat(path.output,filesep,'results\BaselineGrangerPDC\',experiment.name,filesep,'15',num2str(experiment.PL(1)),num2str(period),'.mat'))
%         if strcmp(experiment.Exp_type,'AWA')
%             HPtoPFC(:,period,(n+1)/2)=nanmean(grangerPDC.XtoY);
%             PFCtoHP(:,period,(n+1)/2)=nanmean(grangerPDC.YtoX);
%         else
%             HPtoPFC(:,period+1,n/2)=nanmean(grangerPDC.XtoY);
%             PFCtoHP(:,period+1,n/2)=nanmean(grangerPDC.YtoX);
%         end
%           load(strcat(path.output,filesep,'results\MutualInfo\',experiment.name,filesep,'15',num2str(experiment.PL(4)),num2str(period),'.mat'))
%           if strcmp(experiment.Exp_type,'AWA')
%               MutualInformation(:,period,(n+1)/2)=MutualInfo;
%           else
%               MutualInformation(:,period+1,n/2)=MutualInfo;
%           end
%         load(strcat(path.output,filesep,'results\EntropyStuff\',experiment.name,filesep,'15',num2str(experiment.PL(4)),num2str(period),'.mat'))
%         if strcmp(experiment.Exp_type,'AWA')
%             MutualInfo((n+1)/2, period, :) = EntropyStuff.MutInfo;
%             EntropyPFC((n+1)/2, period, :) = EntropyStuff.Ent1;
%             EntropyHP((n+1)/2, period, :) = EntropyStuff.Ent2;
%             CondEntPFC((n+1)/2, period, :) = EntropyStuff.CondEnt1;
%             CondEntHP((n+1)/2 ,period, :) = EntropyStuff.CondEnt2;
%         else
%             MutualInfo(n/2, period + 1, :) = EntropyStuff.MutInfo;
%             EntropyPFC(n/2, period + 1, :) = EntropyStuff.Ent1;
%             EntropyHP(n/2, period + 1, :) = EntropyStuff.Ent2;
%             CondEntPFC(n/2, period + 1, :) = EntropyStuff.CondEnt1;
%             CondEntHP(n/2, period + 1, :) = EntropyStuff.CondEnt2;
%         end
    end
end
toc


%% reshape so that you attach the urethane data to the awake of the same animal

% FR=squeeze(reshape(FR,size(FR,1),1,size(FR,3)*size(FR,2))); 
% duration=reshape(duration,size(duration,1)*2,size(duration,2)/2); duration(2:3,:)=[];
% amplitude=reshape(amplitude,size(amplitude,1)*2,size(amplitude,2)/2); amplitude(2:3,:)=[];
% occurrence=reshape(occurrence,size(occurrence,1)*2,size(occurrence,2)/2); occurrence(2:3,:)=[];
% rr=reshape(rr,size(rr,1)*2,size(rr,2)/2); rr(2:3,:)=[];
% theta=reshape(theta,size(theta,1)*2,size(theta,2)/2); theta(2:3,:)=[];
% beta=reshape(beta,size(beta,1)*2,size(beta,2)/2); beta(2:3,:)=[];
% gamma=reshape(gamma,size(gamma,1)*2,size(gamma,2)/2); gamma(2:3,:)=[];
% rrOsc=reshape(rrOsc,size(rrOsc,1)*2,size(rrOsc,2)/2); rrOsc(2:3,:)=[];
% thetaOsc=reshape(thetaOsc,size(thetaOsc,1)*2,size(thetaOsc,2)/2); thetaOsc(2:3,:)=[];
% betaOsc=reshape(betaOsc,size(betaOsc,1)*2,size(betaOsc,2)/2); betaOsc(2:3,:)=[];
% gammaOsc=reshape(gammaOsc,size(gammaOsc,1)*2,size(gammaOsc,2)/2); gammaOsc(2:3,:)=[];
% osc_time=duration.*occurrence./60*100;
% ppc_theta=reshape(ppc_theta,size(ppc_theta,1)*2,size(ppc_theta,2)/2); ppc_theta(2:3,:)=[];
% ppc_beta=reshape(ppc_beta,size(ppc_beta,1)*2,size(ppc_beta,2)/2); ppc_beta(2:3,:)=[];
% ppc_gamma=reshape(ppc_gamma,size(ppc_gamma,1)*2,size(ppc_gamma,2)/2); ppc_gamma(2:3,:)=[];
% entropy = reshape(entropy,size(entropy,1)*2,size(entropy,2)/2); entropy(2:3,:) = [];
% TsallisEnt1 = reshape(TsallisEnt1,size(TsallisEnt1,1)*2,size(TsallisEnt1,2)/2); TsallisEnt1(2:3,:) = [];
% TsallisEnt2 = reshape(TsallisEnt2,size(TsallisEnt2,1)*2,size(TsallisEnt2,2)/2); TsallisEnt2(2:3,:) = [];
% DiffEnt1 = reshape(DiffEnt1,size(DiffEnt1,1)*2,size(DiffEnt1,2)/2); DiffEnt1(2:3,:) = [];
% DiffEnt2 = reshape(DiffEnt2,size(DiffEnt2,1)*2,size(DiffEnt2,2)/2); DiffEnt2(2:3,:) = [];
% MutInfo = reshape(MutInfo,size(MutInfo,1)*2,size(MutInfo,2)/2); MutInfo(2:3,:) = [];
% complexity=squeeze(reshape(complexity,size(complexity,1),1,size(complexity,3)*size(complexity,2))); 
% complexity1=squeeze(reshape(complexity1,size(complexity1,1),1,size(complexity1,3)*size(complexity1,2)));
% 
% normFR=FR./osc_time;
% 
% 
% oscillations = squeeze(median(reshape(MinuteOsc, 15, [], size(MinuteOsc, 2))));

%% plot firing rate over time

% Osc3min = squeeze(mean(reshape(MinuteOsc, 3, size(spikes_over_time, 2), size(MinuteOsc, 2))));
% Osc15min = squeeze(mean(reshape(MinuteOsc, 15, size(FR, 1), size(MinuteOsc, 2))));
% 
% FR = FR ./ (60 * 15);
% normFR = log10(FR ./ Osc15min); FR = log10(FR);
% FR(isinf(FR)) = NaN; normFR(isinf(normFR)) = NaN;
% 
% spikes_over_time = spikes_over_time ./ (3 * 60);
% norm_spikes_over_time = log10(spikes_over_time ./ Osc3min'); spikes_over_time = log10(spikes_over_time);
% spikes_over_time(isinf(spikes_over_time)) = NaN; norm_spikes_over_time(isinf(norm_spikes_over_time)) = NaN;
% xvalues = repmat(linspace(8, 53, 4)', 1, size(FR, 2));
% 
% figure; hold on
% boundedline(linspace(1, 60, 20), nanmedian(norm_spikes_over_time), nanstd(norm_spikes_over_time) ./ sqrt(size(norm_spikes_over_time, 1)), 'r');
% title('Firing rate'); ylabel('Log of N° spikes / sec'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
% ylim([-3 3]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);
% 
% figure; hold on
% norm_dots = scatter(xvalues(:), normFR(:), 'o', 'filled', 'MarkerFaceColor', [178/255 34/255 34/255]); 
% norm_lines = plot(xvalues, normFR, 'Color', [178/255 34/255 34/255], 'linewidth', 0.5);
% title('Firing rate'); ylabel('Log of N° spikes / sec'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
% ylim([-3 3]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);
% norm_dots.MarkerFaceAlpha = 0.3; 
% 
% 
% figure; hold on
% boundedline(linspace(1, 60, 20), nanmedian(spikes_over_time), nanstd(spikes_over_time) ./ sqrt(size(spikes_over_time, 1)));
% title('Firing rate'); ylabel('Log of N° spikes / sec'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
%  ylim([-3 3]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);
% 
% figure; hold on
% dots = scatter(xvalues(:), FR(:), 'o', 'filled', 'MarkerFaceColor', [0 0 0.5]);  
% lines = plot(xvalues, FR, 'Color', [0 0 0.5], 'linewidth', 0.5);
% title('Firing rate'); ylabel('Log of N° spikes / sec'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
% ylim([-3 3]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);
% dots.MarkerFaceAlpha = 0.3; 


%% plot 1st versus last oscillations

% xvalues=vertcat(linspace(1,1,length(FR)),linspace(2,2,length(FR)));
% figure; scatter(xvalues(1,:),log10(FR(1,:)./(60*15)),'s','filled','k'); hold on; scatter(xvalues(2,:),log10(FR(2,:)./(60*15)),'s','filled','k')
% plot(xvalues,vertcat(log10(FR(1,:)./(60*15)),log10(FR(2,:)./(60*15))),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[]); set(gca,'TickDir','out')
% scatter(xvalues(:,1),median(log10(FR./(60*15)),2)','s','filled','r'); plot(xvalues(:,1),median(log10(FR(1:2,:)./(60*15)),2)','r','linewidth',3);
% title(strcat('Firing Rate p=',num2str(signrank(FR(1,:),FR(2,:))))); ylabel('Log firing rate (spikes/s)'); xlabel('Pre vs Post'); set(gca,'FontSize',20); ylim([-3 2]);

% 
% xvalues=vertcat(linspace(1,1,length(amplitude)),linspace(2,2,length(amplitude)));
% figure; scatter(xvalues(1,:),amplitude(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),amplitude(2,:),'s','filled','k')
% plot(xvalues,vertcat(amplitude(1,:),amplitude(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('Amplitude p=',num2str(signrank(amplitude(1,:),amplitude(2,:))))); ylabel('Amplitude (µV)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% figure; scatter(xvalues(1,:),osc_time(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),osc_time(2,:),'s','filled','k')
% plot(xvalues,vertcat(osc_time(1,:),osc_time(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('% of FullTime p=',num2str(signrank(osc_time(1,:),osc_time(2,:))))); ylabel('% of FullTime'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% 
% % figure; scatter(xvalues(1,:),duration(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),duration(2,:),'s','filled','k')
% % plot(xvalues,vertcat(duration(1,:),duration(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% % title(strcat('Duration p=',num2str(signrank(duration(1,:),duration(2,:))))); ylabel('Duration (s)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% % figure; scatter(xvalues(1,:),occurrence(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),occurrence(2,:),'s','filled','k')
% % plot(xvalues,vertcat(occurrence(1,:),occurrence(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% % title(strcat('Occurrence p=',num2str(signrank(occurrence(1,:),occurrence(2,:))))); ylabel('Occurrence (osc/min)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% 
% 
%% plot 1st versus last power
% 
% xvalues=vertcat(linspace(1,1,length(theta)),linspace(2,2,length(theta)));
% 
% figure; boundedline(linspace(1,400,3201),mean(PowerPlot(:,1,:)./PowerPlot(:,2,:),3), ...
%     std(PowerPlot(:,1,:)./PowerPlot(:,2,:),0,3)./sqrt(size(PowerPlot,3)))
% hold on; boundedline(linspace(1,400,3201),mean(PowerPlotOsc(:,1,:)./PowerPlotOsc(:,2,:),3), ...
%     std(PowerPlotOsc(:,1,:)./PowerPlotOsc(:,2,:),0,3)./sqrt(size(PowerPlot,3)), 'r')
% xlim([4 45]); ylim([0.5 4.5]); title('Relative Power Spectrum'); ylabel('Power (µV^2)'); 
% xlabel('Frequency (Hz)'); set(gca,'FontSize',20); set(gca,'TickDir','out')
% 
% figure; scatter(xvalues(1,:),theta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),theta(2,:),'s','filled','k')
% plot(xvalues,vertcat(theta(1,:),theta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('Theta p=',num2str(signrank(theta(1,:),theta(2,:))))); ylabel('4-12 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% figure; scatter(xvalues(1,:),beta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),beta(2,:),'s','filled','k')
% plot(xvalues,vertcat(beta(1,:),beta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('Beta p=',num2str(signrank(beta(1,:),beta(2,:))))); ylabel('12-30 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% figure; scatter(xvalues(1,:),gamma(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),gamma(2,:),'s','filled','k')
% plot(xvalues,vertcat(gamma(1,:),gamma(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('Gamma p=',num2str(signrank(gamma(1,:),gamma(2,:))))); ylabel('30-100 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% 
% figure; boundedline(linspace(0,8,65) , mean(PowerPlotSlow(:,1,:) ./ PowerPlotSlow(:,2,:), 3), ...
%     std(PowerPlotSlow(:,1,:) ./ PowerPlotSlow(:,2,:), 0, 3) ./ sqrt(size(PowerPlotSlow, 3)))
% hold on; boundedline(linspace(0,8,65), mean(PowerPlotSlowOsc(:,1,:) ./ PowerPlotSlowOsc(:,2,:), 3), ...
%     std(PowerPlotSlowOsc(:,1,:) ./ PowerPlotSlowOsc(:,2,:), 0, 3) ./ sqrt(size(PowerPlotSlowOsc, 3)), 'r')
% xlim([2 4]); ylim([0.5 4.5]); title('Relative Power Spectrum'); ylabel('Power (µV^2)'); 
% xlabel('Frequency (Hz)'); set(gca,'FontSize',20); set(gca,'TickDir','out')


%% plot 1st versus last PPC

% figure; boundedline(linspace(1, 100, 50), squeeze(nanmedian(PPC_Spec(:, 3, :), 1)), ...
%     squeeze(nanstd(PPC_Spec(:, 3, :), 0, 1) ./ sqrt(size(PPC_Spec, 1))), 'r');
% hold on; boundedline(linspace(1, 100, 50), squeeze(nanmedian(PPC_Spec(:, 1, :), 1)), ...
%     squeeze(nanstd(PPC_Spec(:, 1, :), 0, 1) ./ sqrt(size(PPC_Spec, 1))));
% xlim([2 100]); title('PPC Spectrum'); ylabel('PPC'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20); set(gca,'TickDir','out')
% 
% PPC_RR = (PPC_Spec(:, 3, 2) - PPC_Spec(:, 1, 2)) ./  (PPC_Spec(:, 3, 2) + PPC_Spec(:, 1, 2));
% PPC_theta = (nanmedian(PPC_Spec(:, 3, 3 : 5), 3) - nanmedian(PPC_Spec(:, 1, 3 : 5), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 3 : 5), 3) + nanmedian(PPC_Spec(:, 1, 3 : 5), 3));
% PPC_beta = (nanmedian(PPC_Spec(:, 3, 6 : 15), 3) - nanmedian(PPC_Spec(:, 1, 6 : 15), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 6 : 15), 3) + nanmedian(PPC_Spec(:, 1, 6 : 15), 3));
% PPC_gamma = (nanmedian(PPC_Spec(:, 3, 16 : 50), 3) - nanmedian(PPC_Spec(:, 1, 16 : 50), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 16 : 50), 3) + nanmedian(PPC_Spec(:, 1, 16 : 50), 3));
% PPC_violin = {PPC_RR, PPC_theta, PPC_beta, PPC_gamma};
% 
% figure
% distributionPlot(PPC_violin,'showMM',6,'color',{[0 0 128/255], [0 0 128/255], [0 0 128/255], [0 0 128/255]});
% set(gca,'TickDir','out'); set(gca,'XTickLabel',{'RR', 'Theta', 'Beta', 'Gamma'})
% f = plotSpread(PPC_violin, 'spreadWidth', 1, 'distributionColors', [1 1 0]);
% set(f{1}, 'marker', '*');
% title('HP'); ylabel('PPC OMI'); ylim([-5 5])


% 
% xvalues=vertcat(linspace(1,1,length(ppc_gamma)),linspace(2,2,length(ppc_gamma)));
% 
% figure; scatter(xvalues(1,:),ppc_theta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),ppc_theta(2,:),'s','filled','k')
% plot(xvalues,vertcat(ppc_theta(1,:),ppc_theta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('PPC Theta p=',num2str(signrank(ppc_theta(1,:),ppc_theta(2,:))))); ylabel('PPC Theta'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% figure; scatter(xvalues(1,:),ppc_beta(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),ppc_beta(2,:),'s','filled','k')
% plot(xvalues,vertcat(ppc_beta(1,:),ppc_beta(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('PPC Beta p=',num2str(signrank(ppc_beta(1,:),ppc_beta(2,:))))); ylabel('PPC Beta'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% figure; scatter(xvalues(1,:),ppc_gamma(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),ppc_gamma(2,:),'s','filled','k')
% plot(xvalues,vertcat(ppc_gamma(1,:),ppc_gamma(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% title(strcat('PPC Gamma p=',num2str(signrank(ppc_gamma(1,:),ppc_gamma(2,:))))); ylabel('PPC Gamma'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% 
%% entropy

% xvalues=vertcat(linspace(1,1,length(MutualInfo)),linspace(2,2,length(MutualInfo)));
% figure; scatter(xvalues(1,:),MutualInfo(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),MutualInfo(2,:),'s','filled','k')
% plot(xvalues,vertcat(MutualInfo(1,:),MutualInfo(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% scatter(xvalues(:,1),median(MutualInfo(1:2,:),2)','s','filled','r'); plot(xvalues(:,1),median(MutualInfo(1:2,:),2)','r','linewidth',3);
% title(strcat('Entropy p=',num2str(signrank(MutualInfo(1,:),MutualInfo(2,:))))); ylabel('Sample Entropy'); xlabel('Pre vs Post'); set(gca,'FontSize',20)
% 
% 
% xvalues=vertcat(linspace(1,1,length(complexity)),linspace(2,2,length(complexity)));
% figure; scatter(xvalues(1,:),complexity(1,:),'s','filled','k'); hold on; scatter(xvalues(2,:),complexity(2,:),'s','filled','k')
% plot(xvalues,vertcat(complexity(1,:),complexity(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[])
% scatter(xvalues(:,1),median(complexity(1:2,:),2)','s','filled','r'); plot(xvalues(:,1),median(complexity(1:2,:),2)','r','linewidth',3);
% title(strcat('Spike complexity p=',num2str(signrank(complexity(1,:),complexity(2,:))))); ylabel('Lempel-Ziv complexity'); xlabel('Pre vs Post'); set(gca,'FontSize',20)

% figure; boundedline(linspace(2,48,24), squeeze(nanmean(MutualInformation(:,1,:), 3)), ...
%     squeeze(nanstd(MutualInformation(:,1,:),0,3) ./ sqrt(size(MutualInformation,3))))
% hold on; boundedline(linspace(2,48,24), squeeze(nanmean(MutualInformation(:,2,:),3)), ...
%     squeeze(nanstd(MutualInformation(:,2,:),0, 3) ./ sqrt(size(MutualInformation,3))),'r')
% xlim([2 48]); title('Mutual Information - PFC and HP'); ylabel('Mutual Info'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
% 
% figure; boundedline(linspace(2,49,48), squeeze(nanmean(EntropyPFC(:,1,:))), squeeze(nanstd(EntropyPFC(:,1,:)) ./ sqrt(size(EntropyPFC,1))))
% hold on; boundedline(linspace(2,49,48), squeeze(nanmean(nanmean(EntropyPFC(:,2,:),2))), ...
%     squeeze(nanstd(nanmean(EntropyPFC(:,2,:),2)) ./ sqrt(size(EntropyPFC,1))),'r')
% xlim([2 48]); title('Entropy - PFC'); ylabel('Entropy'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
% 
% figure; boundedline(linspace(2,49,48), squeeze(nanmean(EntropyHP(:,1,:))), squeeze(nanstd(EntropyHP(:,1,:)) ./ sqrt(size(EntropyHP,1))))
% hold on; boundedline(linspace(2,49,48), squeeze(nanmean(nanmean(EntropyHP(:,2,:),2))), ...
%     squeeze(nanstd(nanmean(EntropyHP(:,2,:),2)) ./ sqrt(size(EntropyHP,1))),'r')
% xlim([2 48]); title('Entropy - HP'); ylabel('Entropy'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
% 
% figure; boundedline(linspace(2,49,48), squeeze(nanmean(CondEntPFC(:,1,:))), squeeze(nanstd(CondEntPFC(:,1,:)) ./ sqrt(size(CondEntPFC,1))))
% hold on; boundedline(linspace(2,49,48), squeeze(nanmean(nanmean(CondEntPFC(:,2,:),2))), ...
%     squeeze(nanstd(nanmean(CondEntPFC(:,2,:),2)) ./ sqrt(size(CondEntPFC,1))),'r')
% xlim([2 48]); title(' Conditional Entropy - PFC'); ylabel(' Conditional Entropy'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
% 
% figure; boundedline(linspace(2,49,48), squeeze(nanmean(CondEntHP(:,1,:))), squeeze(nanstd(CondEntHP(:,1,:)) ./ sqrt(size(CondEntHP,1))))
% hold on; boundedline(linspace(2,49,48), squeeze(nanmean(nanmean(CondEntHP(:,2,:),2))), ...
%     squeeze(nanstd(nanmean(CondEntHP(:,2,:),2)) ./ sqrt(size(CondEntHP,1))),'r')
% xlim([2 48]); title(' Conditional Entropy - HP'); ylabel(' Conditional Entropy'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
%% plot minute power

redbluish = cbrewer('div', 'RdBu', 100);
pre_median = nanmedian(minutePower(1 : 15, :, :));
AMI = squeeze(nanmedian(bsxfun(@minus, minutePower, pre_median) ./ bsxfun(@plus, minutePower, pre_median), 3));

figure; imagesc(linspace(1,60,60),linspace(1,250,501),AMI',[-1 1]); axis xy; ylim([0 100])
hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3); colormap(flipud(redbluish)); colorbar
title('Minute by minute power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)

redbluish = cbrewer('div', 'RdBu', 100);
pre_median = nanmedian(medianMinutePower(1 : 15, :, :));
AMI = squeeze(nanmedian(bsxfun(@minus, medianMinutePower, pre_median) ./ bsxfun(@plus, medianMinutePower, pre_median), 3));

figure; imagesc(linspace(1,60,60),linspace(1,250,501),AMI',[-1 1]); axis xy; ylim([0 100])
hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3); colormap(flipud(redbluish)); colorbar
title('Minute by minute power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)

pre_median_osc = nanmedian(minutePowerOsc(1 : 15, :, :));
AMIosc = squeeze(nanmedian(bsxfun(@minus, minutePowerOsc, pre_median_osc) ./ bsxfun(@plus, minutePowerOsc, pre_median_osc), 3));

figure; imagesc(linspace(1,60,60),linspace(1,250,501),AMIosc',[-1 1]); axis xy; ylim([0 100])
hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3); colormap(flipud(redbluish)); colorbar
title('Minute by minute osc power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)

pre_median_osc = nanmedian(medianMinutePowerOsc(1 : 15, :, :));
AMIosc = squeeze(nanmedian(bsxfun(@minus, medianMinutePowerOsc, pre_median_osc) ./ bsxfun(@plus, medianMinutePowerOsc, pre_median_osc), 3));

figure; imagesc(linspace(1,60,60),linspace(1,250,501),AMIosc',[-1 1]); axis xy; ylim([0 100])
hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3); colormap(flipud(redbluish)); colorbar
title('Median minute by minute osc power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)


% OLD VERSION WITH Z-SCORE

% m1=nanmedian(minutePower,3);
% m2=nanmedian(median(minutePower,3));
% MAD=std(nanmedian(minutePower,3))*1.25;
% zscore= bsxfun(@rdivide,bsxfun(@minus,m1,m2),MAD);
% figure; imagesc(linspace(1,60,60),linspace(1,250,501),zscore',[-1 2]); axis xy; ylim([0 100])
% hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3); colormap(flipud(redbluish))
% title('Minute by minute power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
% 
% m1=nanmedian(minutePowerOsc,3);
% m2=nanmedian(median(minutePowerOsc,3));
% MAD=std(nanmedian(minutePowerOsc,3))*1.25;
% zscore= bsxfun(@rdivide,bsxfun(@minus,m1,m2),MAD);
% figure; imagesc(linspace(1,60,60),linspace(1,250,501),zscore',[-1 2]); axis xy; ylim([0 100])
% hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3); colormap(flipud(redbluish))
% title('Minute by minute power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)

%% plot minute oscillation percentage
% 
% figure; xvalues = repmat(linspace(8, 53, 4)', 1, size(oscillations, 2)); scatter(xvalues(:), oscillations(:), 'o', 'filled', 'k'); 
% hold on; plot(xvalues, oscillations, 'Color', [0.5 0.5 0.5], 'linewidth', 0.5); %alpha(0.3)
% boundedline(linspace(1,60,60), nanmean(MinuteOsc,2), nanstd(MinuteOsc, 0, 2)./sqrt(size(MinuteOsc,2)));
% title('Time in oscillations'); ylabel('Proportion'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
% ylim([0 1]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);


%% plot absolute power spectrum

% figure; boundedline(linspace(1,400,3201),mean(PowerPlot(:,1,:),3), std(PowerPlot(:,1,:),0,3)./sqrt(size(PowerPlot,3)))
% hold on; set(gca, 'YScale', 'log');
% boundedline(linspace(1,400,3201),mean(PowerPlot(:,4,:),3), std(PowerPlot(:,4,:),0,3)./sqrt(size(PowerPlot,3)),'r')
% xlim([0 50]); title('Power Spectrum'); ylabel('Power (µV^2)'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)

%% plot ISI
% 
% awa=histcounts(ISIawa,linspace(0,500,100))./numel(ISIawa);
% ure=histcounts(ISIure,linspace(0,500,100))./numel(ISIure);
% figure; plot(awa,'linewidth',3); hold on; plot(ure,'linewidth',3)


%% plot coherence & gPDC

% figure; boundedline(linspace(1,100,2001), smooth(nanmedian(Coherence(:,1,:),3), 10), ...
%     1.25 * smooth(nanstd(Coherence(:,1,:),0,3)./sqrt(size(Coherence,3)), 10))
% hold on; boundedline(linspace(1,100,2001), smooth(nanmedian(nanmedian(Coherence(:,2,:),2),3), 10), ...
%     1.25 * smooth(nanstd(nanmedian(Coherence(:,2,:),2),0,3)./sqrt(size(Coherence,3)), 10), 'r')
% xlim([4 100]); title('Coherency - PFC and HP'); ylabel('Coherency'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
% 
% AMI_RR = (squeeze(nanmedian(Coherence(22 : 62, 2, :))) - squeeze(nanmedian(Coherence(22 : 62, 1, :)))) ./ ...
%     (squeeze(nanmedian(Coherence(22 : 62, 2, :))) + squeeze(nanmedian(Coherence(22 : 62, 1, :))));
% AMI_theta = (squeeze(nanmedian(Coherence(63 : 224, 2, :))) - squeeze(nanmedian(Coherence(63 : 224, 1, :)))) ./ ...
%     (squeeze(nanmedian(Coherence(63 : 224, 2, :))) + squeeze(nanmedian(Coherence(63 : 224, 1, :))));
% AMI_beta = (squeeze(nanmedian(Coherence(225 : 587, 2, :))) - squeeze(nanmedian(Coherence(225 : 587, 1, :)))) ./ ...
%     (squeeze(nanmedian(Coherence(225 : 587, 2, :))) + squeeze(nanmedian(Coherence(225 : 587, 1, :))));
% AMI_gamma = (squeeze(nanmedian(Coherence(588 : end, 2, :))) - squeeze(nanmedian(Coherence(588 : end, 1, :)))) ./ ...
%     (squeeze(nanmedian(Coherence(588 : end, 2, :))) + squeeze(nanmedian(Coherence(588 : end, 1, :))));
% 
% violinOsc = {AMI_RR, AMI_theta, AMI_beta, AMI_gamma};
% 
% figure
% distributionPlot(violinOsc,'showMM',6,'color',{[0 0 128/255], [0 0 128/255], [0 0 128/255], [0 0 128/255]});
% set(gca,'TickDir','out'); set(gca,'XTickLabel',{'RR', 'Theta', 'Beta', 'Gamma'})
% f = plotSpread(violinOsc, 'distributionColors', [1 1 0]);
% set(f{1}, 'marker', '*');
% title('AMI coherence'); ylabel('AMI coherence');

% figure; boundedline(linspace(1,50,24),nanmean(MutualInformation(:,1,:),3),nanstd(MutualInformation(:,1,:),0,3)./sqrt(size(MutualInformation,3)))
% hold on; boundedline(linspace(1,50,24),nanmean(nanmean(MutualInformation(:,2,:),2),3),nanstd(nanmean(MutualInformation(:,2,:),2),0,3)./sqrt(size(MutualInformation,3)),'r')
% xlim([0 45]); title('Mutual Information - PFC and HP'); ylabel('Mutual Info'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)

% figure; boundedline(linspace(1,50,128),nanmean(PFCtoHP(:,1,:),3),nanstd(PFCtoHP(:,1,:),0,3)./sqrt(size(PFCtoHP,3)))
% hold on; boundedline(linspace(1,50,128),nanmean(HPtoPFC(:,1,:),3),nanstd(HPtoPFC(:,1,:),0,3)./sqrt(size(HPtoPFC,3)),'r')
% xlim([1 50]); title('gPDC - HP & PFC - awake'); ylabel('gPDC'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
% 
% figure; boundedline(linspace(1,50,128),nanmean(PFCtoHP(:,2,:),3),nanstd(PFCtoHP(:,2,:),0,3)./sqrt(size(PFCtoHP,3)))
% boundedline(linspace(1,50,128),nanmean(HPtoPFC(:,2,:),3),nanstd(HPtoPFC(:,2,:),0,3)./sqrt(size(HPtoPFC,3)),'r')
% xlim([1 50]); title('gPDC - HP & PFC - urethane'); ylabel('gPDC'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
% 
% figure; boundedline(linspace(1,50,128),nanmean(HPtoPFC(:,1,:)./PFCtoHP(:,1,:),3),nanstd(HPtoPFC(:,1,:)./PFCtoHP(:,1,:),0,3)./sqrt(size(PFCtoHP,3)),'b')
% hold on; boundedline(linspace(1,50,128),nanmean(HPtoPFC(:,2,:)./PFCtoHP(:,2,:),3),nanstd(HPtoPFC(:,2,:)./PFCtoHP(:,2,:),0,3)./sqrt(size(PFCtoHP,3)),'r')
