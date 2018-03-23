function plotWaveletCoherence(signal1,signal2,time, scales)
% Time must be in seconds!!
[waveCohLFP, periodLFP, ~, ~]=wtcJA([time' signal1'],[time' signal2'],'S0',1/scales(2),'MaxScale',1/scales(1));

imagesc(time',log2(periodLFP),waveCohLFP);
set(gca,'clim',[0 1])
Yticks = 2.^(fix(log2(min(periodLFP))):fix(log2(max(periodLFP))));
set(gca,'YLim',log2([min(periodLFP),max(periodLFP)]), ...
'YDir','reverse', ...
'YTick',log2(Yticks(:)), ...
'YTickLabel',num2str(1./Yticks'), ...
'layer','top')
% set(gca,'xtick',[]) % Removes X axis label
%     wtc(sin(t),sin(t.*cos(t*.01)),'ms',16)

% wtc([time' SignalRaw1(1,:)'],[time' SignalRaw2(1,:)'],'S0',1/scales(2),'MaxScale',1/scales(1),'mcc',0,'ms',1','mf',0);
