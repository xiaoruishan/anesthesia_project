
hold on

subplot(6,1,1)
plot(linspace(0,9,fs*9+1),signal(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
ylim([-250 250])

subplot(6,1,2)
plot(linspace(0,9,fs*9+1),signal1(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
ylim([-250 250])

subplot(6,1,3)
plot(linspace(0,9,fs*9+1),signal2(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
ylim([-250 250])

subplot(6,1,4)
plot(linspace(0,9,fs*9+1),signalLFP3(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
ylim([-250 250])

subplot(6,1,5)
[waveLFP, periodLFP, ~, ~] = wt([linspace(0,9,fs*9+1)' signalLFP(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs)'],'S0',1/parameters.wavelet_oscViewer.ymax,'MaxScale',1/parameters.wavelet_oscViewer.ymin);
powerLFP      = (abs(waveLFP)).^2 ;
sigma2LFP     = var(signalLFP(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
imagesc(linspace(0,9,fs*9+1),log2(periodLFP),log2(abs(powerLFP(:,1:end)/sigma2LFP)));
clim=get(gca,'clim'); %center color limits around log2(1)=0
globclim4_100=max(clim(2),3); %global
clim=[0 1]*globclim4_100;
set(gca,'clim',clim)
Yticks = 2.^(fix(log2(min(periodLFP))):fix(log2(max(periodLFP))));
set(gca,'YLim',log2([min(periodLFP),max(periodLFP)]), ...
    'YDir','reverse', ...
    'YTick',log2(Yticks(:)), ...
    'YTickLabel',num2str(1./Yticks'), ...
    'layer','top')
colormap('jet')
set(gca,'xtick',[]) % Removes X axis label

subplot(6,1,6)
plot(linspace(0,9,fs*90+1),signalMUA(oscStart(1,ii)*10-96000:oscStart(1,ii)*10+192000));
ylim([-50 50])