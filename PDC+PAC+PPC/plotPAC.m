
figure
subplot(2,2,1)
imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,wtS2S,[0 4.5])
colormap('jet')
axis xy
title('Phase Amplitude Coupling - PFC sup layers - WT', 'FontSize', 16)
ylabel('Amplitude - Frequency (hz)', 'FontSize', 16)
xlabel('Phase - Frequency (hz)', 'FontSize', 16)

subplot(2,2,2)
imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,geS2S,[0 4.5])
colormap('jet')
axis xy
title('Phase Amplitude Coupling - PFC sup layers - GE', 'FontSize', 16)
ylabel('Amplitude - Frequency (hz)', 'FontSize', 16)
xlabel('Phase - Frequency (hz)', 'FontSize', 16)

subplot(4,4,9)
imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,wtS2S./geS2S,[0 3])
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
colormap('jet')
axis xy
title('PAC sup2sup - WT/GE ratio', 'FontSize', 10)
subplot(4,4,10)
imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,wtS2D./geS2D,[0 3])
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
colormap('jet')
axis xy
title('PAC sup2deep - WT/GE ratio', 'FontSize', 10)
subplot(4,4,13)
imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,wtD2S./geD2S,[0 3])
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
colormap('jet')
axis xy
title('PAC deep2sup - WT/GE ratio', 'FontSize', 10)
subplot(4,4,14)
imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,wtD2D./geD2D,[0 3])
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
colormap('jet')
axis xy
title('PAC deep2deep - WT/GE ratio', 'FontSize', 10)

subplot(2,2,4)
bar(1, mean(wtbeta2gamma), 'facecolor', 'b');
hold on
bar(2, mean(gebeta2gamma), 'facecolor', 'r');
bar(4, mean(wttheta2gamma), 'facecolor', 'b');
bar(5, mean(getheta2gamma), 'facecolor', 'r');
errorbar([mean(wtbeta2gamma) mean(gebeta2gamma) 0 mean(wttheta2gamma) mean(getheta2gamma)], ...
    [std(wtbeta2gamma)/sqrt(37) std(gebeta2gamma)/sqrt(16) 0 std(wttheta2gamma)/sqrt(37)...
    std(getheta2gamma)/sqrt(16)],'.','LineWidth',3, 'Color', 'k');
plot(1.5, wtbeta2gamma,'x', 'LineWidth',2,'Color', 'k')
plot(2.5, gebeta2gamma,'x', 'LineWidth',2,'Color', 'k')
plot(4.5, wttheta2gamma,'x', 'LineWidth',2,'Color', 'k')
plot(5.5, getheta2gamma,'x', 'LineWidth',2,'Color', 'k')
Labels = {'Beta to Gamma', 'Theta to Gamma'};
set(gca, 'XTick', [1.5 4.5], 'XTickLabel', Labels, 'FontSize', 16);
title('Phase Amplitude Coupling', 'FontSize', 16)
ylabel('PAC', 'FontSize', 16)