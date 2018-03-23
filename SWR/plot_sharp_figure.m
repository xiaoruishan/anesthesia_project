

clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812 900:912 1000:1005]; % above 900 is intCA1
fs = 3200;
fifteen_min = fs*60*15;
freq_to_filter = [1 300];
downsampling_factor = 10;
half_window=1600;
save_data=0;
repeatCalc=0;
stimulation=1;

n=10;
experiment=experiments(animal(n));

BaselineTimePoints=gimmeBaselineSignal(experiment,save_data,repeatCalc,stimulation);
baseline=[round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];
[time,signal,~,~]=nlx_load_Opto(experiment,experiment.HPreversal,baseline,downsampling_factor,0);
[~,signal1,~,~]=nlx_load_Opto(experiment,experiment.HPreversal-2,baseline,downsampling_factor,0);
[~,signal2,~,~]=nlx_load_Opto(experiment,experiment.HPreversal+2,baseline,downsampling_factor,0);

load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_sharptimepoints1'))

figure
for event=1:length(sharptimepoints)
    SWR=sharptimepoints(event)
    subplot(3,1,1)
    plot(linspace(-half_window,half_window,3201)/fs,signal(SWR-half_window:SWR+half_window)); hold on
    plot(linspace(-half_window,half_window,3201)/fs,signal1(SWR-half_window:SWR+half_window))
    plot(linspace(-half_window,half_window,3201)/fs,signal2(SWR-half_window:SWR+half_window))
    hold off
    subplot(3,1,2)
    plot(linspace(-half_window,half_window,3201)'/fs,ZeroPhaseFilter(signal(SWR-half_window:SWR+half_window),fs,[100 300]))
    ylim([-50 50])
    subplot(3,1,3)
    [wavelet, period, ~, ~] = wt([linspace(-half_window,half_window,3201)'/fs signal(1,SWR-half_window:SWR+half_window)'],'S0', 1/250, 'MaxScale', 1);
    wavelet=abs(wavelet).^2;
    imagesc(wavelet./var(signal(SWR-half_window:SWR+half_window))); colormap('jet')
    title(num2str(event));
    k=waitforbuttonpress
end
    
    