clear all

path = get_path;
experiments = get_experiment_list_triple_rec;
animal = [1 2 4:9]; % the rest is not PL-HP-LEC
fs = 3200;
fifteen_min = fs*60*15;
freq_to_filter = [1 300];
downsampling_factor = 10;
threshold = 7;
visual_inspection = 0;
repeatCalc = 0;
stimulation = 0;
save_data = 1;

for n=5:length(animal)
    
    clearvars signal_filt 
    experiment=experiments(animal(n));
    canali=experiment.chan_num{1,1};
    channels=[canali(2)-2 canali(2)+2 canali(2)];
%     BaselineTimePoints=gimmeBaselineSignal(experiment,save_data,repeatCalc,stimulation);
    BaselineTimePoints = [fs fifteen_min*2];
    mkdir(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name));
    save(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'),'BaselineTimePoints');    
    baseline=[round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];

    for channel=1:length(channels)
        CSC=channels(channel);
        if channel<2
            [time,signal,~,~]=nlx_load_Opto(experiment,CSC,baseline,downsampling_factor,0);
            time_to_subtract=time(1);
            getBaselineOscComponents(time,signal,fs,experiment,CSC,save_data)
            clear time
        else
            [~,signal,~,~]=nlx_load_Opto(experiment,CSC,baseline,downsampling_factor,0);
        end
        signal_filt(channel,:)=ZeroPhaseFilter(signal,fs,freq_to_filter);
        clearvars signal
    end
    
    [average,stdev]=getMeanSDsignal(experiment,signal_filt,channels,time_to_subtract,fs);
    SharpDetector(experiment,signal_filt,average,stdev,threshold,save_data,visual_inspection,time_to_subtract,fs)
    SharpMUASpikeTimesLEC(experiment,baseline)
    
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
    
end

%% 

clear all

path = get_path;
experiments = get_experiment_list_triple_rec;
animal = [1 2 4:9]; % the rest is not PL-HP-LEC

for n=1:length(animal)
    experiment=experiments(animal(n));
    age(n,:)=experiment.age;
%     load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SilenceWelch'))
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_RipWelch'))
%     Silence(n,:)=SilenceWelch{1,1};
    Ripple(n,:)=RipWelch{1,1};    
end

figure; boundedline(RipWelch{1,2},mean(Ripple).*RipWelch{1,2},std(Ripple).*RipWelch{1,2}./sqrt(size(Ripple,1)),'cmap',[1,0,0])

%%

clear all

path = get_path;
experiments = get_experiment_list_triple_rec;
animal = [1:9]; % the rest is not PL-HP-LEC
half_window=16000;
ISI=[];
HPspikes=[];
LECspikes=[];
PFCspikes=[];

for n=1:length(animal)
    
    experiment=experiments(animal(n));
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_sharptimepoints1'))
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_SpikeTimes'))
    HP_spikes=horzcat(SpikeTimes{1,1}{1,1},SpikeTimes{1,1}{2,1},SpikeTimes{1,1}{3,1},SpikeTimes{1,1}{4,1},SpikeTimes{1,1}{5,1});
%     HP_spikes=SpikeTimes{1,1}{3,1};
    HP_spikes(2,:)=[];
    HP_spikes=sort(HP_spikes);
    LEC_spikes=horzcat(SpikeTimes{1,3}{1,1},SpikeTimes{1,3}{2,1},SpikeTimes{1,3}{3,1},SpikeTimes{1,3}{4,1},SpikeTimes{1,3}{5,1});
    LEC_spikes(2,:)=[];
    LEC_spikes=sort(LEC_spikes);
%     PFC_spikes=horzcat(SpikeTimes{1,2}{1,1},SpikeTimes{1,2}{2,1},SpikeTimes{1,2}{3,1},SpikeTimes{1,2}{4,1},SpikeTimes{1,2}{5,1});
%     PFC_spikes(2,:)=[];
%     PFC_spikes=sort(PFC_spikes);
    for event=1:length(sharptimepoints)
        SWR=sharptimepoints(event)*10;
        first_spike=min(find(HP_spikes>=SWR-half_window)); % first spike of the oscillation
        last_spike=max(find(HP_spikes<=SWR+half_window)); %last spike of the oscillation
        HPspikes=[HPspikes HP_spikes(first_spike:last_spike)-SWR];
        first_spike=min(find(LEC_spikes>=SWR-half_window)); % first spike of the oscillation
        last_spike=max(find(LEC_spikes<=SWR+half_window)); %last spike of the oscillation
        LECspikes=[LECspikes LEC_spikes(first_spike:last_spike)-SWR];
%         first_spike=min(find(PFC_spikes>=SWR-half_window)); % first spike of the oscillation
%         last_spike=max(find(PFC_spikes<=SWR+half_window)); %last spike of the oscillation
%         PFCspikes=[PFCspikes PFC_spikes(first_spike:last_spike)-SWR];
        %         ISI=[ISI diff(HP_spikes(first_spike:last_spike))];

    end
    LEC{n}=LECspikes;
    LECspikes=[];
    HP{n}=HPspikes;
    HPspikes=[];
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end

figure
plot(linspace(-500,500,100),hist(LECspikes,100),'linewidth',3)
hold on
plot(linspace(-500,500,100),hist(HPspikes,100),'linewidth',3)
plot(linspace(-500,500,100),hist(PFCspikes,100),'linewidth',3)
xlim([-16000 16000])

figure
hist(ISI,200)
xlim([0 1000])