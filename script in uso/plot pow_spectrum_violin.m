

powa1 = squeeze(nanmedian(reshape(PowerPlotSlow(16 : end, 1 : 2, :), 2, [], 2, size(PowerPlotSlow, 3))));
powa2 = squeeze(nanmedian(reshape(PowerPlot(162 : 2001, 1 : 2, :), 5, [], 2, size(PowerPlot, 3))));
powa = cat(1, powa1, powa2);

powa1 = squeeze(nanmedian(reshape(PowerPlotSlowOsc(16 : end, 1 : 2, :), 2, [], 2, size(PowerPlotSlowOsc, 3))));
powa2 = squeeze(nanmedian(reshape(PowerPlotOsc(162 : 2001, 1 : 2, :), 5, [], 2, size(PowerPlotOsc, 3))));
powaOsc = cat(1, powa1, powa2);


figure; boundedline(linspace(2, 100, 393), squeeze(nanmedian(powa(:, 1, :) ./ powa(:, 2, :), 3)), ...
    squeeze(std(powa(:, 1, :) ./ powa(:, 2, :), 0, 3)) * 1.25 ./ sqrt(size(powa, 3))) 
hold on; boundedline(linspace(2, 100, 393), squeeze(nanmedian(powaOsc(:, 1, :) ./ powaOsc(:, 2, :), 3)), ...
    squeeze(nanstd(powaOsc(:, 1, :) ./ powaOsc(:, 2, :), 0, 3)) * 1.25 ./ sqrt(size(powaOsc, 3)), 'r')
title('Relative Power Spectrum Full and Osc only'); ylabel('Relative Power'); xlabel('Frequency (Hz)'); set(gca,'FontSize',20)
ylim([0 4]); plot(get(gca,'xlim'), [1 1], 'k','linewidth', 1); plot([4 4], get(gca,'ylim'), 'k','linewidth', 1); 
plot([12 12], get(gca,'ylim'), 'k','linewidth', 1); plot([30 30], get(gca,'ylim'), 'k','linewidth', 1); 
xlim([1 100])

AMI_rr = (rr(2, :) - rr(1, :)) ./ (rr(1, :) + rr(2, :));
AMI_rrOsc = (rrOsc(2, :) - rrOsc(1, :)) ./ (rrOsc(1, :) + rrOsc(2, :));
AMI_theta = (theta(2, :) - theta(1, :)) ./ (theta(1, :) + theta(2, :));
AMI_thetaOsc = (thetaOsc(1, :) - thetaOsc(2, :)) ./ (thetaOsc(1, :) + thetaOsc(2, :));
AMI_beta = (beta(2, :) - beta(1, :)) ./ (beta(1, :) + beta(2, :));
AMI_betaOsc = (betaOsc(2, :) - betaOsc(1, :)) ./ (betaOsc(1, :) + betaOsc(2, :));
AMI_gamma = (gamma(2, :) - gamma(1, :)) ./ (gamma(1, :) + gamma(2, :));
AMI_gammaOsc = (gammaOsc(2, :) - gammaOsc(1, :)) ./ (gammaOsc(1, :) + gammaOsc(2, :));

violinPower = {AMI_rr, AMI_rrOsc, AMI_theta, AMI_thetaOsc, AMI_beta, AMI_betaOsc, AMI_gamma, AMI_gammaOsc};

figure
distributionPlot(violinPower,'showMM',6,'color',{[0 0 128/255], [204/255 0 0], [0 0 128/255], [204/255 0 0], ...
    [0 0 128/255], [204/255 0 0], [0 0 128/255], [204/255 0 0]});
set(gca,'TickDir','out'); set(gca,'XTickLabel',{'RR', 'oRR', 'Theta', 'oTheta', 'Beta', 'oBeta', 'Gamma', 'oGamma'})
f = plotSpread(violinPower, 'distributionColors', [1 1 0]);
set(f{1}, 'marker', '*');
title('Relative Power'); ylabel('Relative Power');