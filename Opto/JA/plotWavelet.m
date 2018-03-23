function plotWavelet(time, signal, scales)
% parameters = get_parameters;
% [signal] = ZeroPhaseFilter(signal, samplingrate, parameters.ZeroPhaseFilter.LFP);
[waveLFP, periodLFP, ~, ~] = wt([time' signal'],'S0',1/scales(2),'MaxScale',1/scales(1));
powerLFP      = (abs(waveLFP)).^2 ;
sigma2LFP     = var(signal);
imagesc(time',log2(periodLFP),log2(abs(powerLFP(:,1:end)/sigma2LFP)));
clim=get(gca,'clim'); %center color limits around log2(1)=0
globclim4_400=max(clim(2),3); %global
clim=[0 1]*globclim4_400;
set(gca,'clim',clim)
Yticks = 2.^(fix(log2(min(periodLFP))):fix(log2(max(periodLFP))));
set(gca,'YLim',log2([min(periodLFP),max(periodLFP)]), ...
'YDir','reverse', ...
'YTick',log2(Yticks(:)), ...
'YTickLabel',num2str(1./Yticks'), ...
'layer','top')
% set(gca,'xtick',[]) % Removes X axis label
end