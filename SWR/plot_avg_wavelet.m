
avgs = mean(avgsharp,3);
avgps = mean(avgpresharp,3);
avgpfc = mean(avgPFC,3);
avgppfc = mean(avgPFCpre,3);

figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
lim = [min(min((avgs./davgs))) max(max(avgs./davgs))];
imagesc(linspace(-500,500,3201),log2(periodsharp),avgs./davgs,lim);
Yticks = 2.^(fix(log2(min(periodsharp))):fix(max(log2(periodsharp))));
             set(gca,'YLim',log2([min(periodsharp),max(periodsharp)]), ...
             'YDir','reverse', ...
             'YTickLabel',num2str(1./Yticks'), ...
             'layer','top')
title('1-300Hz Wavelet of Average Sharpwave (WT)')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')


subplot(2,1,2)
lim = [min(min((avgpfc./davgpfc))) max(max((avgpfc./davgpfc)))];
imagesc(linspace(-500,500,3201),log2(periodPFC),avgpfc./davgpfc,lim);
Yticks = 2.^(fix(log2(min(periodPFC))):fix(max(log2(periodPFC))));
             set(gca,'YLim',log2([min(periodPFC),max(periodPFC)]), ...
             'YDir','reverse', ...
             'YTickLabel',num2str(1./Yticks'), ...
             'layer','top')
title('1-100Hz Wavelet of Sharpwave-locked PFC (WT)')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')


davgs = mean(avgsharpdorsal,3);
davgps = mean(avgsharppredorsal,3);
davgpfc = mean(avgPFCdorsal,3);
davgppfc = mean(avgPFCpredorsal,3);

figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
lim = [min(min((davgs./davgps))) max(max(davgs./davgps))];
imagesc(linspace(-500,500,3201),log2(periodsharp),davgs./davgps,lim);
Yticks = 2.^(fix(log2(min(periodsharp))):fix(max(log2(periodsharp))));
             set(gca,'YLim',log2([min(periodsharp),max(periodsharp)]), ...
             'YDir','reverse', ...
             'YTickLabel',num2str(1./Yticks'), ...
             'layer','top')
title('1-300Hz Wavelet of Average Sharpwave (GE)')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')

subplot(2,1,2)
lim = [min(min((davgpfc./davgppfc))) max(max((davgpfc./davgppfc)))];
imagesc(linspace(-500,500,3201),log2(periodPFC),davgpfc./davgppfc,lim);
Yticks = 2.^(fix(log2(min(periodPFC))):fix(max(log2(periodPFC))));
             set(gca,'YLim',log2([min(periodPFC),max(periodPFC)]), ...
             'YDir','reverse', ...
             'YTickLabel',num2str(1./Yticks'), ...
             'layer','top')
title('1-100Hz Wavelet of Average Sharpwave-locked PFC (GE)')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')





% 
% 
% for p = 1:20
%     figure('units','normalized','outerposition',[0 0 1 1])
%     subplot(2,1,1)
%     lim = [min(min((avgsharp(:,:,p)./avgpresharp(:,:,p)))) 0.6*max(max((avgsharp(:,:,p)./avgpresharp(:,:,p))))];
%     imagesc(linspace(-time_window,time_window,3201),flip(1./periodsharp),avgsharp(:,:,p)./avgpresharp(:,:,p),lim);
%     subplot(2,1,2)
%     lim = [min(min((avgPFC(:,:,p)./avgPFCpre(:,:,p)))) 0.8*max(max((avgPFC(:,:,p)./avgPFCpre(:,:,p))))];
%     imagesc(linspace(-time_window,time_window,3201),flip(1./periodPFC),avgPFC(:,:,p)./avgPFCpre(:,:,p),lim);
%     k = waitforbuttonpress
%     close
% end
% 
% for p = 1:20
%     figure('units','normalized','outerposition',[0 0 1 1])
%     subplot(2,1,1)
%     lim = [min(min((davgsharp(:,:,p)./davgpresharp(:,:,p)))) 0.6*max(max((davgsharp(:,:,p)./davgpresharp(:,:,p))))];
%     imagesc(linspace(-time_window,time_window,3201),flip(1./periodsharp),davgsharp(:,:,p)./davgpresharp(:,:,p),lim);
%     subplot(2,1,2)
%     lim = [min(min((davgPFC(:,:,p)./davgPFCpre(:,:,p)))) 0.8*max(max((davgPFC(:,:,p)./davgPFCpre(:,:,p))))];
%     imagesc(linspace(-time_window,time_window,3201),flip(1./periodPFC),davgPFC(:,:,p)./davgPFCpre(:,:,p),lim);
%     k = waitforbuttonpress
%     close
% end

