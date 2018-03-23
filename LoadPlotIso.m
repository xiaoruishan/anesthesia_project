%% same old scripts

% clear all
tic
path = get_path;
experiments = get_experiment_list;
animal = 201 : 203;

%% initialize a gazillion variables

% FR = zeros(2, 1, length(animal)/2); complexity = FR; complexity1 = FR; PPC_awa = zeros(50,4); PPC_ure = PPC_awa; duration = zeros(3,length(animal));
% amplitude = duration; occurrence = duration; theta = duration; beta = duration; gamma = duration; ppc_theta = duration;
% ppc_beta = duration; ppc_gamma = duration; PowerPlot = zeros(3201,4, length(animal)/2); PPC_Spec = zeros(50,4,length(animal)/2);
% entropy = duration;
spikes_over_time = zeros(length(animal), 5); edges = linspace(0, 900, 6);

%% load stuff 

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = experiment.PL(4); % PL(1) PL(4) HPreversal
    repetitions = 1 : 4;

    for period = repetitions
        canale = 0;
        for channel = experiment.HPreversal
            canale = canale+1;
            load(strcat(path.output,filesep,'results\MUAfiringrate\',experiment.name,filesep,'MUAfiringrate15',num2str(channel),num2str(period),'.mat'))
            load(strcat(path.output,filesep,'results\PPC_Spectrum\',experiment.name,filesep,'PPC_Spectrum15',num2str(channel),num2str(period),'.mat'))
            load(strcat(path.output,filesep,'results\MUAtimestamps\',experiment.name,filesep,'MUAtimestamps15',num2str(channel),num2str(period),'.mat'))
            timestamps = floor(peakLoc./(32000));
            spike_count(canale, :) = histcounts(timestamps, edges);
            MUA(canale, :) = MUAfiringrate;
        end
        spikes_count = sum(spike_count);
        spikes_over_time(n, 1:5) = median(spike_count, 1);
        FR(period, n) = nanmean(MUA);
        PPC(:, period, n) = PPC_Spectrum;
        load(strcat(path.output,filesep,'results\BaselineOscAmplDurOcc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        duration(period, n)=OscAmplDurOcc.baseline.meanDurOsc(1);
        amplitude(period, n)=OscAmplDurOcc.baseline.meanAmplOsc_max(1);
        occurrence(period, n)=OscAmplDurOcc.baseline.occurrenceOsc(1);
        load(strcat(path.output,filesep,'results\baselinePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        thetaOsc(period, n) = baselinePower.baseline.thetaOsc;
        betaOsc(period, n) = baselinePower.baseline.betaOsc;
        gammaOsc(period, n) = baselinePower.baseline.gammaOsc;
        theta(period, n) = baselinePower.baseline.thetaFull;
        beta(period, n) = baselinePower.baseline.betaFull;
        gamma(period, n) = baselinePower.baseline.gammaFull;
        PowerPlot(:, period, n) = baselinePower.baseline.pxxWelchFull;
        PowerPlotOsc(:, period, n) = baselinePower.baseline.pxxWelchOsc;
        load(strcat(path.output,filesep,'results\baselineSlowPower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        rrOsc(period, n) = baselineSlowPower.baseline.betaOsc;
        rr(period, n) = baselineSlowPower.baseline.betaFull;
        PowerPlotSlow(:, period, n) = baselineSlowPower.baseline.pxxWelchFull;       
        load(strcat(path.output,filesep,'results\MinutePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        if size(pWelch,1) < 15
            pWelch(size(pWelch, 1):15, :) = NaN;
        end
        minutePower(15 * (period - 1) + 1:15 * period, :, n) = pWelch;
        
        load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        if size(signal, 2) < 15
            signal(1, size(signal, 2) : 15) = NaN;
        end
        MinuteOsc(15 * (period - 1) + 1 : 15 * period,n) = signal;
        
        load(strcat(path.output,filesep,'results\BaselineCoherence\',experiment.name,filesep,'15',num2str(experiment.HPreversal),num2str(period),'.mat'))
        Coherence(:, period, n) = ImCoh.Coh;
    end
end
toc


%% reshape so that you attach the urethane data to the awake of the same animal

% osc_time = duration .* occurrence ./ 60 * 100;
% oscillations = squeeze(median(reshape(MinuteOsc, 15, [], size(MinuteOsc, 2))));

%% plot firing rate over time

% FR = FR ./ (60 * 15);
% spikes_over_time = spikes_over_time ./ (3 * 60);
% figure; xvalues = repmat(linspace(8, 53, 4)', 1, size(FR, 2)); scatter(xvalues(:), FR(:), 'o', 'filled', 'k'); 
% hold on; plot(xvalues, FR, 'Color', [0.5 0.5 0.5], 'linewidth', 0.5); alpha(0.3)
% % boundedline(linspace(1, 60, 5), mean(spikes_over_time), std(spikes_over_time) ./ sqrt(size(spikes_over_time, 1)));
% title('Firing rate'); ylabel('Log of N° spikes / sec'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
% plot([15 15],get(gca,'ylim'),'r','linewidth',3);
% 
% %% plot 1st versus last oscillations
% 
% xvalues = vertcat(linspace(1, 1, size(FR, 2)), linspace(2, 2, size(FR, 2)));
% figure; scatter(xvalues(1, :), log10(FR(1, :) ./ (60 * 15)), 's', 'filled', 'k'); hold on; scatter(xvalues(2, :), ...
%     log10(FR(2, :) ./ (60 * 15)), 's', 'filled', 'k')
% plot(xvalues, vertcat(log10(FR(1, :) ./ (60 * 15)), log10(FR(2, :) ./ (60 * 15))), 'k'); ...
%     xlim([0.5 2.5]); set(gca, 'xtick', []); set(gca, 'xticklabel', []); set(gca, 'TickDir', 'out')
% scatter(xvalues(:, 1), median(log10(FR(1 : 2, :) ./ (60 * 15)), 2)', 's', 'filled', 'r'); plot(xvalues(:, 1), ...
%     median(log10(FR(1 : 2, :) ./ (60 * 15)), 2)', 'r', 'linewidth', 3);
% title(strcat('Firing Rate p = ', num2str(signrank(FR(1, :), FR(2, :))))); ylabel('Log firing rate (spikes/s)'); 
% xlabel('Pre vs Post'); set(gca, 'FontSize', 20);
% 
% 
% figure; scatter(xvalues(1, :), amplitude(1, :), 's', 'filled', 'k'); hold on; scatter(xvalues(2, :), amplitude(2, :), 's', 'filled', 'k')
% plot(xvalues, vertcat(amplitude(1, :), amplitude(2, :)), 'k'); xlim([0.5 2.5]); set(gca, 'xtick', []); set(gca, 'xticklabel', [])
% title(strcat('Amplitude p = ', num2str(signrank(amplitude(1, :), amplitude(2, :))))); ylabel('Amplitude (µV)'); xlabel('Pre vs Post'); set(gca, 'FontSize', 20)
% figure; scatter(xvalues(1, :), osc_time(1, :), 's', 'filled', 'k'); hold on; scatter(xvalues(2, :), osc_time(2, :), 's', 'filled', 'k')
% plot(xvalues, vertcat(osc_time(1, :), osc_time(2, :)), 'k'); xlim([0.5 2.5]); set(gca, 'xtick', []); set(gca, 'xticklabel', [])
% title(strcat('% of FullTime p = ', num2str(signrank(osc_time(1, :), osc_time(2, :))))); ylabel('% of FullTime'); xlabel('Pre vs Post'); set(gca, 'FontSize', 20)
% 
% %% plot 1st versus last power
%  
% 
% xvalues = vertcat(linspace(1, 1, size(theta, 2)), linspace(2, 2, size(theta, 2)));
% 
% figure; boundedline(linspace(1, 400, 3201), mean(PowerPlot(:, 1, :) ./ PowerPlot(:, 2, :), 3),  ...
%     std(PowerPlot(:, 1, :) ./ PowerPlot(:, 2, :), 0, 3) ./ sqrt(size(PowerPlot, 3)))
% hold on; boundedline(linspace(1, 400, 3201), mean(PowerPlotOsc(:, 1, :) ./ PowerPlotOsc(:, 2, :), 3),  ...
%     std(PowerPlotOsc(:, 1, :) ./ PowerPlotOsc(:, 2, :), 0, 3) ./ sqrt(size(PowerPlot, 3)),  'r')
% xlim([4 45]); ylim([0.5 1.5]); title('Relative Power Spectrum'); ylabel('Power (µV^2)'); 
% xlabel('Frequency (Hz)'); set(gca, 'FontSize', 20); set(gca, 'TickDir', 'out')
% 
% figure; scatter(xvalues(1, :), theta(1, :), 's', 'filled', 'k'); hold on; scatter(xvalues(2, :), theta(2, :), 's', 'filled', 'k')
% plot(xvalues, vertcat(theta(1, :), theta(2, :)), 'k'); xlim([0.5 2.5]); set(gca, 'xtick', []); set(gca, 'xticklabel', [])
% title(strcat('Theta p = ', num2str(signrank(theta(1, :), theta(2, :))))); ylabel('4-12 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca, 'FontSize', 20)
% figure; scatter(xvalues(1, :), beta(1, :), 's', 'filled', 'k'); hold on; scatter(xvalues(2, :), beta(2, :), 's', 'filled', 'k')
% plot(xvalues, vertcat(beta(1, :), beta(2, :)), 'k'); xlim([0.5 2.5]); set(gca, 'xtick', []); set(gca, 'xticklabel', [])
% title(strcat('Beta p = ', num2str(signrank(beta(1, :), beta(2, :))))); ylabel('12-30 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca, 'FontSize', 20)
% figure; scatter(xvalues(1, :), gamma(1, :), 's', 'filled', 'k'); hold on; scatter(xvalues(2, :), gamma(2, :), 's', 'filled', 'k')
% plot(xvalues, vertcat(gamma(1, :), gamma(2, :)), 'k'); xlim([0.5 2.5]); set(gca, 'xtick', []); set(gca, 'xticklabel', [])
% title(strcat('Gamma p = ', num2str(signrank(gamma(1, :), gamma(2, :))))); ylabel('30-100 Hz Power (µV^2)'); xlabel('Pre vs Post'); set(gca, 'FontSize', 20)
% 
% figure; boundedline(linspace(0, 8, 21) ,  mean(PowerPlotSlow(:, 1, :) ./ PowerPlotSlow(:, 2, :),  3),  ...
%     std(PowerPlotSlow(:, 1, :) ./ PowerPlotSlow(:, 2, :),  0,  3) ./ sqrt(size(PowerPlotSlow,  3)))
% hold on; boundedline(linspace(0, 8, 21),  mean(PowerPlotSlowOsc(:, 1, :) ./ PowerPlotSlowOsc(:, 2, :),  3),  ...
%     std(PowerPlotSlowOsc(:, 1, :) ./ PowerPlotSlowOsc(:, 2, :),  0,  3) ./ sqrt(size(PowerPlotSlowOsc,  3)),  'r')
% xlim([2 4]); ylim([0.5 4.5]); title('Relative Power Spectrum'); ylabel('Power (µV^2)'); 
% xlabel('Frequency (Hz)'); set(gca, 'FontSize', 20); set(gca, 'TickDir', 'out')
% 
% 
% %% plot 1st versus last PPC
% 
% figure; boundedline(linspace(1,100,50),nanmean(PPC_Spectrum(:,3,:),3),nanstd(PPC_Spectrum(:,3,:),0,3)./sqrt(size(PPC_Spectrum,3)),'r');
% hold on; boundedline(linspace(1,100,50),nanmean(PPC_Spectrum(:,1,:),3),nanstd(PPC_Spectrum(:,1,:),0,3)./sqrt(size(PPC_Spectrum,3)))
% xlim([1 100]); title('PPC Spectrum'); ylabel('PPC'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20); set(gca,'TickDir','out')

%% plot minute power

% m1=nanmean(minutePower,3);
% m2=nanmean(mean(minutePower,3));
% MAD=mad(nanmean(minutePower,3));
% zscore=bsxfun(@rdivide,bsxfun(@minus,m1,m2),MAD*1.4826);
% figure; imagesc(linspace(1,60,60),linspace(1,250,501),zscore',[-1 2]); axis xy; ylim([0 50])
% hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3)
% title('Minute by minute power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
% 
% %% plot minute oscillation percentage
% % 
% figure; xvalues = repmat(linspace(8, 53, 4)', 1, size(oscillations, 2)); scatter(xvalues(:), oscillations(:), 'o', 'filled', 'k'); 
% hold on; plot(xvalues, oscillations, 'Color', [0.5 0.5 0.5], 'linewidth', 0.5); alpha(0.3)
% boundedline(linspace(1,60,60), nanmean(MinuteOsc,2), nanstd(MinuteOsc, 0, 2)./sqrt(size(MinuteOsc,2)));
% title('Time in oscillations'); ylabel('Proportion'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
% ylim([0 1.1]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);
% 
% %% plot coherence
% 
% figure; boundedline(linspace(1,100,2001),nanmean(Coherence(:,1,:),3),nanstd(Coherence(:,1,:),0,3)./sqrt(size(Coherence,3)))
% hold on; boundedline(linspace(1,100,2001),nanmean(nanmean(Coherence(:,2,:),2),3),nanstd(nanmean(Coherence(:,2,:),2),0,3)./sqrt(size(Coherence,3)),'r')
% xlim([0 45]); title('Coherency - PFC and HP'); ylabel('Coherency'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
