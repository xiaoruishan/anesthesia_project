
for ff = 1:11
        clearvars average & standard

  
    for rr = 1:size(avgPFC,1)
        average(rr,1) = mean(mean(avgPFC(rr,:,ff)));
        standard(rr,1) = std(avgPFC(rr,:,ff));
        normPFC(rr,:,ff) = (avgPFC(rr,:,ff)-average(rr,1))./standard(rr,1);
    end
    
    for rr = 1:size(avgsharp,1)
        average(rr,1) = mean(mean(avgsharp(rr,:,ff)));
        standard(rr,1) = std(avgsharp(rr,:,ff));
        normHP(rr,:,ff) = (avgsharp(rr,:,ff)-average(rr,1))./standard(rr,1);
    end
    clearvars average & standard
    for rr = 1:size(davgPFC,1)
        average(rr,1) = mean(mean(davgPFC(rr,:,ff)));
        standard(rr,1) = std(davgPFC(rr,:,ff));
        dnormPFC(rr,:,ff) = (davgPFC(rr,:,ff)-average(rr,1))./standard(rr,1);
    end
    
    for rr = 1:size(davgsharp,1)
        average(rr,1) = mean(mean(davgsharp(rr,:,ff)));
        standard(rr,1) = std(davgsharp(rr,:,ff));
        dnormHP(rr,:,ff) = (davgsharp(rr,:,ff)-average(rr,1))./standard(rr,1);
    end
end

HP = mean(avgsharp,3);
dHP = mean(davgsharp,3);
ratio = HP./dHP;
figure
imagesc(linspace(-500,500,3201),log2(periodsharp),ratio,[0.5 2.5]);
Yticks = 2.^(fix(log2(min(periodsharp))):fix(max(log2(periodsharp))));
set(gca,'YLim',log2([min(periodsharp),max(periodsharp)]), ...
    'YDir','reverse', ...
    'YTickLabel',num2str(1./Yticks'), ...
    'layer','top')
    title('Ratio (WT/GE) of average 1-300Hz SWR-P Wavelet')
 xlabel('Time (ms)')
 ylabel('Frequency (Hz)')


HPpre = mean(avgpresharp,3);
dHPpre = mean(davgpresharp,3);
ratiopre = HPpre./dHPpre;
figure
imagesc(linspace(-500,500,3201),log2(periodsharp),ratiopre,[0.5 2.5]);
Yticks = 2.^(fix(log2(min(periodsharp))):fix(max(log2(periodsharp))));
set(gca,'YLim',log2([min(periodsharp),max(periodsharp)]), ...
    'YDir','reverse', ...
    'YTickLabel',num2str(1./Yticks'), ...
    'layer','top')
    title('Ratio (WT/GE) of average 1-300Hz 1 second before SWR-P Wavelet')
 xlabel('Time (ms)')
 ylabel('Frequency (Hz)')

metaratio = ratio./ratiopre;
metaratio = medfilt2(metaratio,[2 64]);
figure
imagesc(linspace(-500,500,3201),log2(periodsharp),metaratio,[0.5 2.5]);
Yticks = 2.^(fix(log2(min(periodsharp))):fix(max(log2(periodsharp))));
set(gca,'YLim',log2([min(periodsharp),max(periodsharp)]), ...
    'YDir','reverse', ...
    'YTickLabel',num2str(1./Yticks'), ...
    'layer','top')
title('Metaratio (WT/GE) of average 1-300Hz SWR-P Wavelet')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')

PL = mean(avgPFC,3);
dPL = mean(davgPFC,3);
ratioPL = PL./dPL;
figure
imagesc(linspace(-500,500,3201),log2(periodPFC),ratioPL,[0.8 3]);
Yticks = 2.^(fix(log2(min(periodPFC))):fix(max(log2(periodPFC))));
set(gca,'YLim',log2([min(periodPFC),max(periodPFC)]), ...
    'YDir','reverse', ...
    'YTickLabel',num2str(1./Yticks'), ...
    'layer','top')
title('Ratio (WT/GE) of average 1-100Hz PFC SWR-P-time locked Wavelet')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')


PLpre = mean(avgPFCpre,3);
dPLpre = mean(davgPFCpre,3);
ratioPLpre = PLpre./dPLpre;
figure
imagesc(linspace(-500,500,3201),log2(periodPFC),ratioPLpre,[0.5 2.5]);
Yticks = 2.^(fix(log2(min(periodPFC))):fix(max(log2(periodPFC))));
set(gca,'YLim',log2([min(periodPFC),max(periodPFC)]), ...
    'YDir','reverse', ...
    'YTickLabel',num2str(1./Yticks'), ...
    'layer','top')
title('Ratio (WT/GE) of average 1-100Hz PFC 1 second before SWR-P-time locked Wavelet')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')

metaratioPL = ratioPL./ratioPLpre;
metaratioPL = medfilt2(metaratioPL,[5 5]);
figure
imagesc(linspace(-500,500,3201),log2(periodPFC),metaratioPL,[0.5 2.5]);
Yticks = 2.^(fix(log2(min(periodPFC))):fix(max(log2(periodPFC))));
set(gca,'YLim',log2([min(periodPFC),max(periodPFC)]), ...
    'YDir','reverse', ...
    'YTickLabel',num2str(1./Yticks'), ...
    'layer','top')
title('Metaratio (WT/GE) of average 1-100Hz PFC SWR-P-time locked Wavelet')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')
