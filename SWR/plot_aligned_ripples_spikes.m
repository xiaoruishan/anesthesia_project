

clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812]; %900:912 1000:1005 501:536]; % above 900 is intCA1
fs=3200;
fifteen_min = fs*60*15;
downsampling_factor = 10;
save_data=1;
filter_freq=[100 200];
half_window=320;
aligned_spikes=[];

for n=1:length(animal)
    experiment = experiments(animal(n));
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_SpikeTimes'))
    SpikeTimes=SpikeTimes{1,1}{3,1};
    SpikeTimes(2,:)=[];
    SpikeTimes=fix(SpikeTimes/10);
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_sharptimepoints1'))
    load(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'));
    baseline = [round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];
    CSC=experiment.HPreversal;
    [time, signal, ~, ~] = nlx_load_Opto(experiment, CSC, baseline, downsampling_factor, 0);
    signal=ZeroPhaseFilter(signal,fs,filter_freq);
    for SWR=1:length(sharptimepoints)
        ripple=signal(sharptimepoints(SWR)-half_window:sharptimepoints(SWR)+half_window);
        [~,minimum]=min(ripple);
        shift=minimum-(half_window+1);
        aligned_ripple(SWR,:)=signal(1,sharptimepoints(SWR)-half_window+shift:sharptimepoints(SWR)+half_window+shift);
        spikes=SpikeTimes(SpikeTimes>sharptimepoints(SWR)-half_window);
        spikes=spikes(spikes<sharptimepoints(SWR)+half_window);
        spikes_ripple=spikes-sharptimepoints(SWR)+half_window;
        aligned_spikes=[aligned_spikes spikes_ripple+shift];
    end
    mean_ripple(n,:)=mean(aligned_ripple);
    clear aligned_ripple
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end

