%% same old scripts

clear all
tic
path = get_path;
experiments = get_experiment_list;
animal = 201 : 217;

%% initialize a gazillion variables

% FR = zeros(2, 1, length(animal)/2); complexity = FR; complexity1 = FR; PPC_awa = zeros(50,4); PPC_ure = PPC_awa; duration = zeros(3,length(animal));
% amplitude = duration; occurrence = duration; theta = duration; beta = duration; gamma = duration; ppc_theta = duration;
% ppc_beta = duration; ppc_gamma = duration; PowerSpectrum = zeros(3201,4, length(animal)/2); PPC_Spec = zeros(50,4,length(animal)/2);
% entropy = duration;
spikes_over_time = zeros(length(animal), 5); edges = linspace(0, 900, 6);

%% load stuff

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = experiment.HPreversal(1); % PL(1) HPreversal
    repetitions = 1 : 4;
    
    for period = repetitions
        canale = 0;
        for channel = experiment.HPreversal-1 : experiment.HPreversal+1 %  17:20
            canale = canale+1;
            load(strcat(path.output,filesep,'results\MUAfiringrate\',experiment.name,filesep,'MUAfiringrate15',num2str(channel),num2str(period),'.mat'))
            load(strcat(path.output,filesep,'results\MUAtimestamps\',experiment.name,filesep,'MUAtimestamps15',num2str(channel),num2str(period),'.mat'))
            timestamps = floor(peakLoc./(32000));
            spike_count(canale, :) = histcounts(timestamps, edges);
            MUA(canale, :) = MUAfiringrate;
        end
        spikes_count = sum(spike_count);
        spikes_over_time(n, (1:5) + 5 * (period - 1)) = median(spike_count, 1);
        FR(period, n) = nanmean(MUA);
        load(strcat(path.output,filesep,'results\BaselineOscAmplDurOcc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        try
            duration(period, n) = OscAmplDurOcc.baseline.meanDurOsc(1);
            occurrence(period, n) = OscAmplDurOcc.baseline.occurrenceOsc(1);
        catch
            duration(period, n) = NaN;
            occurrence(period, n) = NaN;
        end
        load(strcat(path.output,filesep,'results\baselinePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        try
            thetaOsc(period, n) = baselinePower.baseline.thetaOsc;
            betaOsc(period, n) = baselinePower.baseline.betaOsc;
            gammaOsc(period, n) = baselinePower.baseline.gammaOsc;
        catch
            thetaOsc(period, n) = NaN;
            betaOsc(period, n) = NaN;
            gammaOsc(period, n) = NaN;
        end
        theta(period, n) = baselinePower.baseline.thetaFull;
        beta(period, n) = baselinePower.baseline.betaFull;
        gamma(period, n) = baselinePower.baseline.gammaFull;
        PowerSpectrum(:, period, n) = baselinePower.baseline.pxxWelchFull;
        try
            PowerSpectrumOsc(:, period, n) = baselinePower.baseline.pxxWelchOsc;
        catch
            PowerSpectrumOsc(:, period, n) = NaN;
        end
        load(strcat(path.output,filesep,'results\baselineSlowPower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        rrOsc(period, n) = baselineSlowPower.baseline.betaOsc;
        rr(period, n) = baselineSlowPower.baseline.betaFull;
        PowerSpectrumSlow(:, period, n) = baselineSlowPower.baseline.pxxWelchFull;
        try
            PowerSpectrumSlowOsc(:, period, n) = baselineSlowPower.baseline.pxxWelchOsc;
        catch
            PowerSpectrumSlowOsc(:, period, n) = zeros(1, 21);
        end
        load(strcat(path.output,filesep,'results\MinutePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        if size(pWelch,1) < 15
            pWelch(size(pWelch, 1):15, :) = NaN;
        end
        minutePower(15 * (period - 1) + 1:15 * period, :, n) = pWelch;
        load(strcat(path.output,filesep,'results\MinutePowerOsc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        if size(pWelchOsc,1) < 15
            pWelchOsc(size(pWelchOsc, 1):15, :) = NaN;
        end
            minutePowerOsc(15 * (period - 1) + 1:15 * period, :, n) = pWelchOsc;
        try
            load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        catch
            signal(1, 1: 15) = NaN;
        end
        if size(signal, 2) < 15
            signal(1, size(signal, 2) : 15) = NaN;
        end
        MinuteOsc(15 * (period - 1) + 1 : 15 * period,n) = signal;
    end
end
toc


%% adjust variables

osc_time = duration .* occurrence ./ 60 * 100;
oscillations = squeeze(median(reshape(MinuteOsc, 15, [], size(MinuteOsc, 2))));

%% plot firing rate over time

Osc3min = squeeze(mean(reshape(MinuteOsc, 3, size(spikes_over_time, 2), size(MinuteOsc, 2))));
Osc15min = squeeze(mean(reshape(MinuteOsc, 15, size(FR, 1), size(MinuteOsc, 2))));

FR = FR ./ (60 * 15);
normFR = log10(FR ./ Osc15min); FR = log10(FR);
FR(isinf(FR)) = NaN; normFR(isinf(normFR)) = NaN;

spikes_over_time = spikes_over_time ./ (3 * 60);
norm_spikes_over_time = log10(spikes_over_time ./ Osc3min'); spikes_over_time = log10(spikes_over_time);
spikes_over_time(isinf(spikes_over_time)) = NaN; norm_spikes_over_time(isinf(norm_spikes_over_time)) = NaN;
xvalues = repmat(linspace(8, 53, 4)', 1, size(FR, 2));

figure; hold on
scatter(xvalues(:), normFR(:), 'o', 'filled', 'MarkerFaceColor', [178/255 34/255 34/255])
plot(xvalues, normFR, 'Color', [178/255 34/255 34/255], 'linewidth', 0.5)
boundedline(linspace(1, 60, 20), nanmedian(norm_spikes_over_time), nanstd(norm_spikes_over_time) ./ sqrt(size(norm_spikes_over_time, 1)), 'r');
title('Firing rate'); ylabel('Log of N° spikes / sec'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
ylim([-2 2]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);

figure; hold on
scatter(xvalues(:), FR(:), 'o', 'filled', 'MarkerFaceColor', [0 0 0.5])
plot(xvalues, FR, 'Color', [0 0 0.5], 'linewidth', 0.5)
boundedline(linspace(1, 60, 20), nanmedian(spikes_over_time), nanstd(spikes_over_time) ./ sqrt(size(spikes_over_time, 1)));
title('Firing rate'); ylabel('Log of N° spikes / sec'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
ylim([-2 2]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);

%% power violin plots


powa1 = squeeze(nanmedian(reshape(PowerSpectrumSlow(16 : end, 1 : 2, :), 2, [], 2, size(PowerSpectrumSlow, 3))));
powa2 = squeeze(nanmedian(reshape(PowerSpectrum(162 : 2001, 1 : 2, :), 5, [], 2, size(PowerSpectrum, 3))));
powa = cat(1, powa1, powa2);

powa1 = squeeze(nanmedian(reshape(PowerSpectrumSlowOsc(16 : end, 1 : 2, :), 2, [], 2, size(PowerSpectrumSlowOsc, 3))));
powa2 = squeeze(nanmedian(reshape(PowerSpectrumOsc(162 : 2001, 1 : 2, :), 5, [], 2, size(PowerSpectrumOsc, 3))));
powaOsc = cat(1, powa1, powa2);

AMI_rr = (rr(4, :) - rr(1, :)) ./ (rr(1, :) + rr(4, :));
AMI_rrOsc = (rrOsc(4, :) - rrOsc(1, :)) ./ (rrOsc(1, :) + rrOsc(4, :));
AMI_theta = (theta(4, :) - theta(1, :)) ./ (theta(1, :) + theta(4, :));
AMI_thetaOsc = (thetaOsc(4, :) - thetaOsc(1, :)) ./ (thetaOsc(1, :) + thetaOsc(4, :));
AMI_beta = (beta(4, :) - beta(1, :)) ./ (beta(1, :) + beta(4, :));
AMI_betaOsc = (betaOsc(4, :) - betaOsc(1, :)) ./ (betaOsc(1, :) + betaOsc(4, :));
AMI_gamma = (gamma(4, :) - gamma(1, :)) ./ (gamma(1, :) + gamma(4, :));
AMI_gammaOsc = (gammaOsc(4, :) - gammaOsc(1, :)) ./ (gammaOsc(1, :) + gammaOsc(4, :));

violinPower = {AMI_rr, AMI_rrOsc, AMI_theta, AMI_thetaOsc, AMI_beta, AMI_betaOsc, AMI_gamma, AMI_gammaOsc};

figure
distributionPlot(violinPower,'showMM',6,'color',{[0 0 128/255], [204/255 0 0], [0 0 128/255], [204/255 0 0], ...
    [0 0 128/255], [204/255 0 0], [0 0 128/255], [204/255 0 0]});
set(gca,'TickDir','out'); set(gca,'XTickLabel',{'RR', 'oRR', 'Theta', 'oTheta', 'Beta', 'oBeta', 'Gamma', 'oGamma'})
f = plotSpread(violinPower, 'distributionColors', [1 1 0]);
set(f{1}, 'marker', '*');
title('Relative Power'); ylabel('Relative Power');

%% AMI imagesc


redbluish = cbrewer('div', 'RdBu', 100);
pre_median = nanmedian(minutePower(1 : 15, :, :));
AMI = squeeze(nanmedian(bsxfun(@minus, minutePower, pre_median) ./ bsxfun(@plus, minutePower, pre_median), 3));

figure; imagesc(linspace(1,60,60),linspace(1,250,501),AMI',[-1 1]); axis xy; ylim([0 100])
hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3); colormap(flipud(redbluish)); colorbar
title('Minute by minute power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)

pre_median_osc = nanmedian(minutePowerOsc(1 : 15, :, :));
AMIosc = squeeze(nanmedian(bsxfun(@minus, minutePowerOsc, pre_median_osc) ./ bsxfun(@plus, minutePowerOsc, pre_median_osc), 3));

figure; imagesc(linspace(1,60,60),linspace(1,250,501),AMIosc',[-1 1]); axis xy; ylim([0 100])
hold on; plot([15 15],get(gca,'ylim'),'r','linewidth',3); colormap(flipud(redbluish)); colorbar
title('Minute by minute power (z-score)'); ylabel('Frequency (Hz)'); xlabel('Time (minutes)'); set(gca,'FontSize',20)

%% plot minute oscillation percentage

figure; xvalues = repmat(linspace(8, 53, 4)', 1, size(oscillations, 2)); scatter(xvalues(:), oscillations(:), 'o', 'filled', 'k'); 
hold on; plot(xvalues, oscillations, 'Color', [0.5 0.5 0.5], 'linewidth', 0.5); %alpha(0.3)
boundedline(linspace(1,60,60), nanmean(MinuteOsc,2), nanstd(MinuteOsc, 0, 2)./sqrt(size(MinuteOsc,2)));
title('Time in oscillations'); ylabel('Proportion'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
ylim([0 1]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);