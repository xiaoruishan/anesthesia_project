

powa1 = squeeze(nanmedian(reshape(PowerPlotSlow(16 : end, :, :), 2, [], 2, size(PowerPlotSlow, 3))));
powa2 = squeeze(nanmedian(reshape(PowerPlot(162 : 901, :, :), 5, [], 2, size(PowerPlot, 3))));
powa = cat(1, powa1, powa2);

powa1 = squeeze(nanmedian(reshape(PowerPlotSlowOsc(16 : end, :, :), 2, [], 2, size(PowerPlotSlowOsc, 3))));
powa2 = squeeze(nanmedian(reshape(PowerPlotOsc(162 : 901, :, :), 5, [], 2, size(PowerPlotOsc, 3))));
powaOsc = cat(1, powa1, powa2);

relPow = {rr(1, :) ./ rr(2, :), theta(1, :) ./ theta(2, :), beta(1, :) ./ beta(2, :), gamma(1, :) ./ gamma(2, :)};
relPowOsc = {rrOsc(1, :) ./ rrOsc(2, :), thetaOsc(1, :) ./ thetaOsc(2, :), betaOsc(1, :) ./ betaOsc(2, :), gammaOsc(1, :) ./ gammaOsc(2, :)};

% figure; xvalues = repmat([3 8 21 37]', 1, size(relPow, 2)); scatter(xvalues(:), relPow(:), 'o', 'filled', 'k'); 
% hold on; scatter(xvalues(:), relPowOsc(:), 's', 'filled', 'r'); 
figure; boundedline(linspace(2, 45, 173), squeeze(nanmedian(powa(:, 1, :) ./ powa(:, 2, :), 3)), ...
    squeeze(mad(powa(:, 1, :) ./ powa(:, 2, :), 0, 3)) ./ sqrt(size(powa, 3))) 
hold on; boundedline(linspace(2, 45, 173), squeeze(nanmedian(powaOsc(:, 1, :) ./ powaOsc(:, 2, :), 3)), ...
    squeeze(mad(powaOsc(:, 1, :) ./ powaOsc(:, 2, :), 0, 3)) ./ sqrt(size(powaOsc, 3)), 'r')
title('Relative Power Spectrum Full and Osc only'); ylabel('Relative Power'); xlabel('Time (minutes)'); set(gca,'FontSize',20)
plot(get(gca,'xlim'), [1 1], 'k','linewidth', 1); plot([4 4], get(gca,'ylim'), 'k','linewidth', 1); 
plot([12 12], get(gca,'ylim'), 'k','linewidth', 1); plot([30 30], get(gca,'ylim'), 'k','linewidth', 1); 
xlim([1.5 45])


figure
distributionPlot([relPow relPowOsc],'showMM',6,'color',{'k', 'k', 'k', 'k', 'g', 'g', 'g', 'g'});
set(gca,'TickDir','out')
f = plotSpread([relPow relPowOsc], 'spreadWidth', 1);
set(f{1}, 'marker', 'o'); alpha(0.6)
title('Relative Power RR-theta-beta-gamma'); ylabel('Relative Power'); set(gca,'FontSize',20)