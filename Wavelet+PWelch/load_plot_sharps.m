
clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list_ripples;
animal_number = [700:732 800:812 900:912 1000:1005];

save_data = 0;
repeatCalc = 0;
stimulation = 1;
ExtractModeArray = [];
downsampling_factor = 10;
fs = 3200;
freq_to_filter = [4 300];

%% load Sharps

n = 6;

experiment = experiments(animal_number(n));
Baseline = gimmeBaselineSignal(experiment,save_data,repeatCalc,stimulation);
BaselineTimePoints = Baseline.BaselineTimePoints;
channels = [experiment.HPreversal-2 experiment.HPreversal experiment.HPreversal+2 experiment.PL];

for CSC = 1:4
    [~, signal, ~, ~] = nlx_load_Opto(experiment, channels(4), ExtractModeArray, 1, save_data);
    signal1 = signal(1,BaselineTimePoints(1)*10:BaselineTimePoints(2)*10);
    signal2 = signal(1,BaselineTimePoints(3)*10:end-9600);
    clear signal
    signal_MUA_PFC = horzcat(signal1, signal2);
    clear signal1 & signal2
%     signal_filt(CSC,:) = ZeroPhaseFilter(signal,fs,freq_to_filter);
%     clearvars signal
end

load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SpikeTimes'));

HP = SpikeTimes{1};
for channel = 1:5
    spikes_channel(1,channel) = length(HP{channel});
end
[~,channelHP] = max(spikes_channel);
HPtrace = HP{channelHP};
HPspikes = zeros(1,size(signal_filt,2));
HPspikes(1,round(HPtrace(1,:)./10)) = 1;

PL = SpikeTimes{2};
for channel = 6:10
    spikes_channel(1,channel-5) = length(PL{channel});
end
[~,channelPL] = max(spikes_channel);
PLtrace = PL{channelPL};
PLspikes = zeros(1,size(signal_filt,2));
PLspikes(1,round(PLtrace(1,:)./10)) = 1;


%% plot for figure

for event = 77
    figure('units','normalized','outerposition',[0 0 1 1])
    
    subplot(8,2,1)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,961),downsample(signal_filt(1,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot),10))
    ylim([-1000 1000])
    title('raw signal of rev-2, rev and rev+2')
    
    subplot(8,2,3)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,961),downsample(signal_filt(2,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot),10))
    ylim([-1000 1000])
    
    subplot(8,2,5)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,961),downsample(signal_filt(3,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot),10))
    ylim([-1000 1000])
    
    subplot(8,2,7)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,961),downsample(ZeroPhaseFilter(signal_filt(1,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot),fs,[4 300]),10))
    title('4-300 filtered signal of rev-2, rev and rev+2')
    ylim([-1000 1000])
    
    subplot(8,2,9)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,961),downsample(ZeroPhaseFilter(signal_filt(2,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot),fs,[4 300]),10))
    title('4-300 filtered signal of rev-2, rev and rev+2')
    ylim([-1000 1000])
    
    subplot(8,2,11)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,961),downsample(ZeroPhaseFilter(signal_filt(3,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot),fs,[4 300]),10))
    title('4-300 filtered signal of rev-2, rev and rev+2')
    ylim([-1000 1000])
    
    subplot(8,2,13)
    plot(linspace(-time_to_plot*10/32000,time_to_plot*10/32000,96001),ZeroPhaseFilter(signal_MUA_HP(1,sharptimepoints(event)*10-48000:sharptimepoints(event)*10+48000),32000,[500 5000]))
    ylim([-40 40])
    
    subplot(8,2,15)
    colormap jet
    [waveLFP, periodLFP, ~, ~] = wt([linspace(-time_to_plot/3200,time_to_plot/3200,9601)' signal_filt(2,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot)'],'S0', 1/300, 'MaxScale', 0.25);
    powerLFP      = (abs(waveLFP)).^2;
    sigmaLFP = var(signal_filt(2,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot));
    avgpower = mean(powerLFP,2);
%     stdpower = std(powerLFP,0,2);
%     imagesc(linspace(-time_to_plot,time_to_plot,9601),periodLFP,bsxfun(@rdivide,bsxfun(@minus,powerLFP,avgpower),stdpower));
    imagesc(linspace(-time_to_plot/3200,time_to_plot/3200,961),log2(periodLFP),downsample(log2(powerLFP./sigmaLFP),10));
    title('wavelet 4:300 Hz')
    clim=get(gca,'clim'); %center color limits around log2(1)=0
    globclim4_100=max(clim(2),3); %global
    clim=[0 1]*globclim4_100;
    set(gca,'clim',clim)
    Yticks = 2.^(fix(log2(min(periodLFP))):fix(max(log2(periodLFP))));
    set(gca,'YLim',[log2(min(periodLFP)),log2(max(periodLFP))], ...
        'YDir','reverse', ...
        'YTickLabel',num2str(1./Yticks'), ...
        'layer','top')
    
    subplot(8,2,2)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,961),downsample(signal_filt(4,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot),10))
    ylim([-200 200])
    title('raw PFC signal')
    
    subplot(8,2,4)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,961),downsample(ZeroPhaseFilter(signal_filt(4,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot),fs,[4 100]),10))
    title('4-100 filtered PFC signal')
    ylim([-200 200])
    
    subplot(8,2,6)
    plot(linspace(-time_to_plot*10/32000,time_to_plot*10/32000,96001),ZeroPhaseFilter(signal_MUA_PFC(1,sharptimepoints(event)*10-48000:sharptimepoints(event)*10+48000),32000,[500 5000]))
    ylim([-40 40])
   
    subplot(8,2,8)
    colormap jet
    [waveLFP, periodLFP, ~, ~] = wt([linspace(-time_to_plot/3200,time_to_plot/3200,9601)' signal_filt(4,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot)'],'S0', 1/100, 'MaxScale', 0.25);
    powerLFP      = (abs(waveLFP)).^2 ;
    avgpower = mean(powerLFP,2);
    stdpower2 = std(powerLFP,0,2);
    sigmaLFP = var(signal_filt(4,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot));
%     imagesc(linspace(-time_to_plot,time_to_plot,9601),periodLFP,bsxfun(@rdivide,bsxfun(@minus,powerLFP,avgpower),stdpower2));
    imagesc(linspace(-time_to_plot/3200,time_to_plot/3200,961),log2(periodLFP),downsample(log2(powerLFP./sigmaLFP),10));
    title('wavelet 4-100 Hz')
%     clim=get(gca,'clim'); %center color limits around log2(1)=0
    globclim4_100=max(clim(2),3); %global
%     clim=[0 1]*globclim4_100;
    set(gca,'clim',clim)
    Yticks = 2.^(fix(log2(min(periodLFP))):fix(max(log2(periodLFP))));
    set(gca,'YLim',[log2(min(periodLFP)),log2(max(periodLFP))], ...
        'YDir','reverse', ...
        'YTickLabel',num2str(1./Yticks'), ...
        'layer','top')
    
end
%% plotting to find right examples

time_to_plot = 4800;

for event = 5:size(sharptimepoints,2)
    figure('units','normalized','outerposition',[0 0 1 1])
    
    subplot(5,2,1)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,9601),signal_filt(1,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot))
    title('1-300 Hz filtered signals of rev-2, rev and rev+2')
    
    subplot(5,2,3)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,9601),signal_filt(2,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot))
    
    subplot(5,2,5)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,9601),signal_filt(3,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot))
    
    subplot(5,2,7)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,9601),HPspikes(sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot))
    
    subplot(5,2,9)
    colormap jet
    [waveLFP, periodLFP, ~, ~] = wt([linspace(-time_to_plot/3200,time_to_plot/3200,9601)' signal_filt(2,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot)'],'S0', 1/300, 'MaxScale', 0.25);
    powerLFP      = (abs(waveLFP)).^2;
    sigmaLFP = var(signal_filt(2,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot));
    avgpower = mean(powerLFP,2);
%     stdpower = std(powerLFP,0,2);
%     imagesc(linspace(-time_to_plot,time_to_plot,9601),periodLFP,bsxfun(@rdivide,bsxfun(@minus,powerLFP,avgpower),stdpower));
    imagesc(linspace(-time_to_plot/3200,time_to_plot/3200,9601),log2(periodLFP),log2(powerLFP./sigmaLFP));
    title('wavelet 4:300 Hz')
    clim=get(gca,'clim'); %center color limits around log2(1)=0
    globclim4_100=max(clim(2),3); %global
    clim=[0 1]*globclim4_100;
    set(gca,'clim',clim)
    Yticks = 2.^(fix(log2(min(periodLFP))):fix(max(log2(periodLFP))));
    set(gca,'YLim',[log2(min(periodLFP)),log2(max(periodLFP))], ...
        'YDir','reverse', ...
        'YTickLabel',num2str(1./Yticks'), ...
        'layer','top')
    
    subplot(5,2,2)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,9601),signal_filt(4,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot))
    title('1-300 Hz filtered signal of PFC')
    
    subplot(5,2,4)
    plot(linspace(-time_to_plot/3200,time_to_plot/3200,9601),PLspikes(sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot))
   
    subplot(5,2,6)
    colormap jet
    [waveLFP, periodLFP, ~, ~] = wt([linspace(-time_to_plot/3200,time_to_plot/3200,9601)' signal_filt(4,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot)'],'S0', 1/100, 'MaxScale', 0.25);
    powerLFP      = (abs(waveLFP)).^2 ;
    avgpower = mean(powerLFP,2);
    stdpower2 = std(powerLFP,0,2);
    sigmaLFP = var(signal_filt(4,sharptimepoints(event)-time_to_plot:sharptimepoints(event)+time_to_plot));
%     imagesc(linspace(-time_to_plot,time_to_plot,9601),periodLFP,bsxfun(@rdivide,bsxfun(@minus,powerLFP,avgpower),stdpower2));
    imagesc(linspace(-time_to_plot/3200,time_to_plot/3200,9601),log2(periodLFP),log2(powerLFP./sigmaLFP));
    title('wavelet 4:100 Hz')
    clim=get(gca,'clim'); %center color limits around log2(1)=0
    globclim4_100=max(clim(2),3); %global
    clim=[0 1]*globclim4_100;
    set(gca,'clim',clim)
    Yticks = 2.^(fix(log2(min(periodLFP))):fix(max(log2(periodLFP))));
    set(gca,'YLim',[log2(min(periodLFP)),log2(max(periodLFP))], ...
        'YDir','reverse', ...
        'YTickLabel',num2str(1./Yticks'), ...
        'layer','top')
    
    subplot(5,2,8)
    title(strcat('this is oscillation',num2str(event),'/',num2str(length(sharptimepoints))))
    
    
    k = waitforbuttonpress
    close
    
end