
%%

figure; boundedline(linspace(2, 48, 12), median(MutInfoDiff(1:2:end,:)), mad(MutInfoDiff(1:2:end,:)) ./ (sqrt(size(MutInfoDiff,1)/2)))
hold on
boundedline(linspace(2, 48, 12), median(MutInfoDiff(2:2:end,:)), mad(MutInfoDiff(2:2:end,:)) ./ (sqrt(size(MutInfoDiff,1)/2)), 'r')
title('Differential Mutual Information'); xlim([2 45])

% figure; boundedline(linspace(2, 48, 12), median(MutInfoKernel(1:2:end,:)), mad(MutInfoKernel(1:2:end,:)) ./ (sqrt(size(MutInfoKernel,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(MutInfoKernel(2:2:end,:)), mad(MutInfoKernel(2:2:end,:)) ./ (sqrt(size(MutInfoKernel,1)/2)), 'r')
% title('Kernel Mutual Information'); xlim([2 45])
% 
% figure; boundedline(linspace(2, 48, 12), median(MutInfoHist(1:2:end,:)), mad(MutInfoHist(1:2:end,:)) ./ (sqrt(size(MutInfoHist,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(MutInfoHist(2:2:end,:)), mad(MutInfoHist(2:2:end,:)) ./ (sqrt(size(MutInfoHist,1)/2)), 'r')
% title('Histogram Mutual Information'); xlim([2 45])

%%

figure; boundedline(linspace(2, 48, 12), median(DiffEnt1(1:2:end,:)), mad(DiffEnt1(1:2:end,:)) ./ (sqrt(size(DiffEnt1,1)/2)))
hold on
boundedline(linspace(2, 48, 12), median(DiffEnt1(2:2:end,:)), mad(DiffEnt1(2:2:end,:)) ./ (sqrt(size(DiffEnt1,1)/2)), 'r')
title('Differential Entropy'); xlim([2 45])

figure; boundedline(linspace(2, 48, 12), median(DiffEnt2(1:2:end,:)), mad(DiffEnt2(1:2:end,:)) ./ (sqrt(size(DiffEnt2,1)/2)))
hold on
boundedline(linspace(2, 48, 12), median(DiffEnt2(2:2:end,:)), mad(DiffEnt2(2:2:end,:)) ./ (sqrt(size(DiffEnt2,1)/2)), 'r')
title('Differential Entropy'); xlim([2 45])

% figure; boundedline(linspace(2, 48, 12), median(RenyiEnt1(1:2:end,:)), mad(RenyiEnt1(1:2:end,:)) ./ (sqrt(size(RenyiEnt1,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(RenyiEnt1(2:2:end,:)), mad(RenyiEnt1(2:2:end,:)) ./ (sqrt(size(RenyiEnt1,1)/2)), 'r')
% title('Renyi Entropy'); xlim([2 45])
% 
% figure; boundedline(linspace(2, 48, 12), median(SampleEnt1(1:2:end,:)), mad(SampleEnt1(1:2:end,:)) ./ (sqrt(size(SampleEnt1,1)/2)))
% hold on
% boundedline(linspace(2, 48, 12), median(SampleEnt1(2:2:end,:)), mad(SampleEnt1(2:2:end,:)) ./ (sqrt(size(SampleEnt1,1)/2)), 'r')
% title('Sample Entropy'); xlim([2 45])
