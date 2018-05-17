
%%

figure; boundedline(linspace(2, 50, 24), median(SampleEnt1(1:2:end,:)), 1.25 * std(SampleEnt1(1:2:end,:)) ./ (sqrt(size(SampleEnt1,1)/2)))
hold on
boundedline(linspace(2, 50, 24), median(SampleEnt1(2:2:end,:)), 1.25 * std(SampleEnt1(2:2:end,:)) ./ (sqrt(size(SampleEnt1,1)/2)), 'r')
title('Sample Entropy'); xlim([2 50])

AMI_rr = (SampleEnt1(2 : 2 : end, 1) - SampleEnt1(1 : 2 : end, 1)) ./ (SampleEnt1(2 : 2 : end, 1) + SampleEnt1(1 : 2 : end, 1));
AMI_theta = (nanmedian(SampleEnt1(2 : 2 : end, 2 : 6)) - nanmedian(SampleEnt1(1 : 2 : end, 2 : 6))) ...
    ./ (nanmedian(SampleEnt1(2 : 2 : end, 2 : 6)) + nanmedian(SampleEnt1(1 : 2 : end, 2 : 6)));
AMI_beta = (nanmedian(SampleEnt1(2 : 2 : end, 7 : 15)) - nanmedian(SampleEnt1(1 : 2 : end, 7 : 15))) ...
    ./ (nanmedian(SampleEnt1(2 : 2 : end, 7 : 15)) + nanmedian(SampleEnt1(1 : 2 : end, 7 : 15)));
AMI_gamma = (nanmedian(SampleEnt1(2 : 2 : end, 16 : end)) - nanmedian(SampleEnt1(1 : 2 : end, 16 : end))) ...
    ./ (nanmedian(SampleEnt1(2 : 2 : end, 16 : end)) + nanmedian(SampleEnt1(1 : 2 : end, 16 : end)));

violinPower = {AMI_rr, AMI_theta, AMI_beta, AMI_gamma};

figure
distributionPlot(violinPower,'showMM',6,'color',{[0 0 128/255], [0 0 128/255], [0 0 128/255], [0 0 128/255]});
set(gca,'TickDir','out'); set(gca,'XTickLabel',{'RR', 'Theta', 'Beta','Gamma'})
f = plotSpread(violinPower, 'distributionColors', [1 1 0]);
set(f{1}, 'marker', '*');
title('Sample Entropy - AMI'); ylabel('Sample Entropy');


figure; boundedline(linspace(2, 50, 24), median(SampleEnt2(1:2:end,:)), 1.25 * std(SampleEnt2(1:2:end,:)) ./ (sqrt(size(SampleEnt2,1)/2)))
hold on
boundedline(linspace(2, 50, 24), median(SampleEnt2(2:2:end,:)), 1.25 * std(SampleEnt2(2:2:end,:)) ./ (sqrt(size(SampleEnt2,1)/2)), 'r')
title('Sample Entropy'); xlim([2 50])

AMI_rr = (SampleEnt2(2 : 2 : end, 1) - SampleEnt2(1 : 2 : end, 1)) ./ (SampleEnt2(2 : 2 : end, 1) + SampleEnt2(1 : 2 : end, 1));
AMI_theta = (nanmedian(SampleEnt2(2 : 2 : end, 2 : 6)) - nanmedian(SampleEnt2(1 : 2 : end, 2 : 6))) ...
    ./ (nanmedian(SampleEnt2(2 : 2 : end, 2 : 6)) + nanmedian(SampleEnt2(1 : 2 : end, 2 : 6)));
AMI_beta = (nanmedian(SampleEnt2(2 : 2 : end, 7 : 15)) - nanmedian(SampleEnt2(1 : 2 : end, 7 : 15))) ...
    ./ (nanmedian(SampleEnt2(2 : 2 : end, 7 : 15)) + nanmedian(SampleEnt2(1 : 2 : end, 7 : 15)));
AMI_gamma = (nanmedian(SampleEnt2(2 : 2 : end, 16 : end)) - nanmedian(SampleEnt2(1 : 2 : end, 16 : end))) ...
    ./ (nanmedian(SampleEnt2(2 : 2 : end, 16 : end)) + nanmedian(SampleEnt2(1 : 2 : end, 16 : end)));

violinPower = {AMI_rr, AMI_theta, AMI_beta, AMI_gamma};

figure
distributionPlot(violinPower,'showMM',6,'color',{[0 0 128/255], [0 0 128/255], [0 0 128/255], [0 0 128/255]});
set(gca,'TickDir','out'); set(gca,'XTickLabel',{'RR', 'Theta', 'Beta','Gamma'})
f = plotSpread(violinPower, 'distributionColors', [1 1 0]);
set(f{1}, 'marker', '*');
title('Sample Entropy - AMI'); ylabel('Sample Entropy');

%%

% figure; boundedline(linspace(2, 48, 12), median(MutInfoDiff(1:2:end,:)), 1.25 * std(MutInfoDiff(1:2:end,:)) ./ (sqrt(size(MutInfoDiff,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(MutInfoDiff(2:2:end,:)), 1.25 * std(MutInfoDiff(2:2:end,:)) ./ (sqrt(size(MutInfoDiff,1)/2)), 'r')
% title('Differential Mutual Information'); xlim([2 45])

% figure; boundedline(linspace(2, 48, 12), median(MutInfoKernel(1:2:end,:)), 1.25 * std(MutInfoKernel(1:2:end,:)) ./ (sqrt(size(MutInfoKernel,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(MutInfoKernel(2:2:end,:)), 1.25 * std(MutInfoKernel(2:2:end,:)) ./ (sqrt(size(MutInfoKernel,1)/2)), 'r')
% title('Kernel Mutual Information'); xlim([2 45])
% 
% figure; boundedline(linspace(2, 48, 12), median(MutInfoHist(1:2:end,:)), 1.25 * std(MutInfoHist(1:2:end,:)) ./ (sqrt(size(MutInfoHist,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(MutInfoHist(2:2:end,:)), 1.25 * std(MutInfoHist(2:2:end,:)) ./ (sqrt(size(MutInfoHist,1)/2)), 'r')
% title('Histogram Mutual Information'); xlim([2 45])

%%

% figure; boundedline(linspace(2, 48, 12), median(DiffEnt1(1:2:end,:)), 1.25 * std(DiffEnt1(1:2:end,:)) ./ (sqrt(size(DiffEnt1,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(DiffEnt1(2:2:end,:)), 1.25 * std(DiffEnt1(2:2:end,:)) ./ (sqrt(size(DiffEnt1,1)/2)), 'r')
% title('Differential Entropy'); xlim([2 45])
% 
% figure; boundedline(linspace(2, 48, 12), median(DiffEnt2(1:2:end,:)), 1.25 * std(DiffEnt2(1:2:end,:)) ./ (sqrt(size(DiffEnt2,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(DiffEnt2(2:2:end,:)), 1.25 * std(DiffEnt2(2:2:end,:)) ./ (sqrt(size(DiffEnt2,1)/2)), 'r')
% title('Differential Entropy'); xlim([2 45])

% figure; boundedline(linspace(2, 48, 12), median(RenyiEnt1(1:2:end,:)), 1.25 * std(RenyiEnt1(1:2:end,:)) ./ (sqrt(size(RenyiEnt1,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(RenyiEnt1(2:2:end,:)), 1.25 * std(RenyiEnt1(2:2:end,:)) ./ (sqrt(size(RenyiEnt1,1)/2)), 'r')
% title('Renyi Entropy'); xlim([2 45])
