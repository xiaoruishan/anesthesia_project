function mainOscViewer(f, osc, plottype)

% osc = [], --> run through all oscillations
% plottype = 1, plot in subplot,
% plottype = 2, plot individual figures

%% load parameters and info about experiment
parameters = get_parameters;
Path = get_path;
experiments = get_experiment_list;
experiment = experiments(f);
downsampling_factor=10;
fs=32000/downsampling_factor;
CSC = experiment.PL;
save_data = 0;
fifteen_min=fs*60*15;
BaselineTimePoints=[fs fifteen_min];
baseline=[round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];
ExtractModeArray = baseline;

%loaddata
[~, signal,~,~] = nlx_load_Opto(experiment, CSC(1), ExtractModeArray, downsampling_factor, save_data);
[~, signal1,~,~] = nlx_load_Opto(experiment, CSC(2), ExtractModeArray, downsampling_factor, save_data);
[~, signal2,~,~] = nlx_load_Opto(experiment, CSC(3), ExtractModeArray, downsampling_factor, save_data);
[~, signal3,~,~] = nlx_load_Opto(experiment, CSC(4), ExtractModeArray, downsampling_factor, save_data);
% [~, signalMUA,~,~] = nlx_load_Opto(experiment, CSC(3), ExtractModeArray, 1, save_data);
% detect oscillations
[oscStart,~] = detection_discont_events(signal,fs);


% filter
signalLFP = ZeroPhaseFilter(signal,fs,parameters.FrequencyBands.LFP);
signalLFP1 = ZeroPhaseFilter(signal1,fs,parameters.FrequencyBands.LFP);
signalLFP2 = ZeroPhaseFilter(signal2,fs,parameters.FrequencyBands.LFP);
signalLFP3 = ZeroPhaseFilter(signal3,fs,parameters.FrequencyBands.LFP);
% signalTheta = ZeroPhaseFilter(signal,fs,parameters.FrequencyBands.theta);
% signalBeta = ZeroPhaseFilter(signal,fs,parameters.FrequencyBands.beta);
% signalGamma = ZeroPhaseFilter(signal,fs,parameters.FrequencyBands.gamma);
% signalMUA = ZeroPhaseFilter(signalMUA,fs*10,[500 5000]);

%% Loop through each oscillation
% identify which osc to plot
if isempty(osc)
    jj = 3:length(oscStart);
else
    jj = osc;
end

fig = figure('Color', 'white');
hold on
for ii = jj;
    disp(['Osc: ' num2str(ii) '/' num2str(length(oscStart))]);
    figure(fig);
    subplot(5,1,1)
    plot(linspace(0,6,fs*9+1),signal(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
    ylim([-200 200])
    
    subplot(5,1,2)
    plot(linspace(0,6,fs*9+1),signal1(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
    ylim([-200 200])
    
    subplot(5,1,3)
    plot(linspace(0,6,fs*9+1),signal2(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
    ylim([-200 200])
    
    subplot(5,1,4)
    plot(linspace(0,6,fs*9+1),signal3(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
    ylim([-200 200])
    
    subplot(5,1,5)    
    [waveLFP, periodLFP, ~, ~] = wt([linspace(0,6,fs*9+1)' signalLFP(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs)'],'S0',1/parameters.wavelet_oscViewer.ymax,'MaxScale',1/parameters.wavelet_oscViewer.ymin);
    powerLFP      = (abs(waveLFP)).^2 ;
    sigma2LFP     = var(signalLFP(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
    imagesc(linspace(0,6,fs*9+1),log2(periodLFP),log2(abs(powerLFP(:,1:end)/sigma2LFP)));
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
    title('1-100Hz Wavelet')
    set(gca,'xtick',[]) % Removes X axis label       
%     subplot(5,1,6)
    %         plot(recordingTime(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs),recordingMUA(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs:oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs));
    %         title('500-5000Hz')
    %         xlim([recordingTime(oscStart(1,ii)-parameters.mainOscViewer.preOsc*fs) recordingTime(oscStart(1,ii)+parameters.mainOscViewer.postOscStart*fs)]);
    %         ylim([-35 35])
    %         set(gca,'xtick',[]) % Removes X axis label
    %         line([recordingTime(oscEnd(1,ii)) recordingTime(oscEnd(1,ii))], [-500 500], 'Color','r','Linestyle','-')
    %         line([recordingTime(oscStart(1,ii)) recordingTime(oscStart(1,ii))], [-500 500], 'Color','r','Linestyle','-')
    
    
    k = waitforbuttonpress;
    
end
close all
end
