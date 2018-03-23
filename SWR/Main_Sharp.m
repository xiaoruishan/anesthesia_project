
%% find sharpwaves, perform powerspectrum for 1s and 30ms around the SWR

clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812];% 900:912 1000:1005 501:536 1:18]; %101:186 above 900 is intCA1
fs = 3200;
fifteen_min = fs*60*15;
freq_to_filter = [1 300];
downsampling_factor = 10;
threshold = 5;
visual_inspection = 0;
repeatCalc = 0;
stimulation = 1;
save_data = 1;

for n=1:length(animal)
    
    clearvars signal_filt 
    experiment=experiments(animal(n));
    channels=[experiment.HPreversal-2 experiment.HPreversal+2 experiment.HPreversal];
    BaselineTimePoints=gimmeBaselineSignal(experiment,save_data,repeatCalc,stimulation);
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
    SharpMUASpikeTimes(experiment,baseline)
    
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
    
end

%% perform wavelet or pWelch around the SWR

clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = 101:186%[700:732 800:812 900:912 1000:1005 501:536]; % above 900 is intCA1
fs = 3200;
fifteen_min = fs*60*15;
freq_to_filter = [1 300];
downsampling_factor = 10;
repeatCalc = 0;
stimulation = 1;
save_data = 1;
half_window=1600;
window_rip=0.1;
window_silence=1;
parameters=get_parameters;

for n=1:length(animal)
    
    clearvars signal_filt wavelet
    experiment=experiments(animal(n));
%     filename = strcat('CSC',num2str(experiment.HPreversal-2)); 
    BaselineTimePoints=gimmeBaselineSignal(experiment,save_data,repeatCalc,stimulation);
    baseline=[round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];
    [time,signal,~,~]=nlx_load_Opto(experiment,experiment.HPreversal,baseline,downsampling_factor,0);
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_sharptimepoints1'))
%     load(strcat(path.output, 'results', filesep, 'BaselineOscAmplDurOcc', filesep, experiment.name, filesep, filename));
%     oscTimes = round((OscAmplDurOcc.(['baseline']).OscTimes- time(1))*fs/10^6);
    for event=1:length(sharptimepoints)
        SWR=sharptimepoints(event);
        if SWR-half_window>0 && SWR+half_window<length(signal)
%             [wavelet(:,:,event), period, ~, ~] = wt([linspace(-half_window,half_window,3201)'/fs ...
%             signal(1,SWR-half_window:SWR+half_window)'],'S0', 1/250, 'MaxScale', 1);
            [pxxWelchRip(event,:),fWelchRip,~]= pWelchSpectrum(signal(1,sharptimepoints(event)-fs/20:... % 100ms for ripples
                sharptimepoints(event)+fs/20), window_rip,[], parameters.powerSpectrum.nfft,...
                fs, 0.95, parameters.powerSpectrum.maxFreq);
        end
    end
%     wavelet=abs(wavelet).^2;
%     for event=1:10
%         [pxxWelchSilence(event,:),~,~]= pWelchSpectrum(signal(1,oscTimes(2,event)-fs/2:... % 1s for silence
%             oscTimes(2,event)+fs/2),window_silence,[],parameters.powerSpectrum.nfft,...
%             fs, 0.95, parameters.powerSpectrum.maxFreq);
%     end
%     SilenceWelch={mean(pxxWelchSilence)};
    RipWelchShifted={mean(pxxWelchRip),fWelchRip};
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_RipWelchShifted'),'RipWelchShifted')
    clearvars pxxWelchRip pxxcWelchRip SilenceWelch wavelet
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end
%% load data

clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812 101:186];%900:912 1000:1005 501:536 1:18]; % above 900 is intCA1

for n=1:length(animal)
    experiment=experiments(animal(n));
    age(n,:)=experiment.age;
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SilenceWelch'))
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_RipWelch'))
    Silence(n,:)=SilenceWelch{1,1};
    Ripple(n,:)=RipWelch{1,1};    
end

age1=age(47:end);
age(47:end)=[];
p10=find(age==10);
p9=find(age==9);
p8=find(age==8);
p101=find(age1==10)+46;
p91=find(age1==9)+46;
p81=find(age1==8)+46;


figure; boundedline(RipWelch{1,2},mean(Ripple(p8',:)).*RipWelch{1,2},std(Ripple(p8,:)).*RipWelch{1,2}./numel(p8),'g')
hold on; boundedline(RipWelch{1,2},mean(Ripple([p81'],:)).*RipWelch{1,2},std(Ripple([p81'],:)).*RipWelch{1,2}./numel([p81']),'r')
figure; boundedline(RipWelch{1,2},mean(Ripple(p9',:)).*RipWelch{1,2},std(Ripple(p9,:)).*RipWelch{1,2}./numel(p9),'g')
hold on; boundedline(RipWelch{1,2},mean(Ripple([p91'],:)).*RipWelch{1,2},std(Ripple([p91'],:)).*RipWelch{1,2}./numel([p91']),'r')
figure; boundedline(RipWelch{1,2},mean(Ripple(p10',:)).*RipWelch{1,2},std(Ripple(p10,:)).*RipWelch{1,2}./numel(p10),'g')
hold on; boundedline(RipWelch{1,2},mean(Ripple([p101'],:)).*RipWelch{1,2},std(Ripple([p101'],:)).*RipWelch{1,2}./numel([p101']),'r')
xlim([70 200]); ylim([0 2500])

figure; boundedline(RipWelch{1,2},smooth(mean(Ripple(p10',:))./mean(Silence(p10',:)),10),std(Ripple(p10',:))./mean(Silence(p10',:))./numel(p10'),'g')
hold on; boundedline(RipWelch{1,2},smooth(mean(Ripple(p101',:))./mean(Silence(p101',:)),10),std(Ripple(p101',:))./mean(Silence(p101',:))./numel(p101'),'r')
figure; boundedline(RipWelch{1,2},smooth(mean(Ripple(p9',:))./mean(Silence(p9',:)),10),std(Ripple(p9',:))./mean(Silence(p9',:))./numel(p9'),'g')
hold on; boundedline(RipWelch{1,2},smooth(mean(Ripple(p91',:))./mean(Silence(p91',:)),10),std(Ripple(p91',:))./mean(Silence(p91',:))./numel(p91'),'r')
figure; boundedline(RipWelch{1,2},smooth(mean(Ripple(p8',:))./mean(Silence(p8',:)),10),std(Ripple(p8',:))./mean(Silence(p8',:))./numel(p8'),'g')
hold on; boundedline(RipWelch{1,2},smooth(mean(Ripple(p81',:))./mean(Silence(p81',:)),10),std(Ripple(p81',:))./mean(Silence(p81',:))./numel(p81'),'r')
xlim([70 200]); ylim([0 450])


figure
plot(RipWelch{1,2},mean(Ripple([p91' p101'],:))./mean(Silence([p91' p101'],:))); hold on
plot(RipWelch{1,2},mean(Ripple(p9,:))./mean(Silence(p9,:)))
plot(RipWelch{1,2},mean(Ripple(p81,:))./mean(Silence(p81,:)))

%%

clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812 101:186];%900:912 1000:1005 501:536]; % above 900 is intCA1
half_window=1600;
ISI8=[]; ISI9=[]; ISI10=[]; ISI81=[]; ISI91=[]; ISI101=[]; ISIpj=[];
Isi=[];
SWR8=0; SWR9=0; SWR10=0; SWR81=0; SWR91=0; SWR101=0; SWRpj=0;

for n=1:length(animal)
    
    clearvars signal_filt wavelet
    experiment=experiments(animal(n));
    if n<66
        load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_SpikeTimes')) % qui non ci andrebbe il suffisso HP!!
        HP_spikes=SpikeTimes{1,1}{3,1};
%         HP_spikes=horzcat(SpikeTimesHP{1,1}{3,1},SpikeTimesHP{1,1}{2,1});
    else
        load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_SpikeTimesHP'))
        HP_spikes=SpikeTimesHP{1,1}{3,1};
%         HP_spikes=horzcat(SpikeTimesHP{1,1}{3,1},SpikeTimesHP{1,1}{2,1});
    end
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_sharptimepoints1'))

    HP_spikes(2,:)=[];
    HP_spikes=sort(HP_spikes);
    for event=1:length(sharptimepoints)
        SWR=sharptimepoints(event)*10+200;
        first_spike=min(find(HP_spikes>=SWR-half_window)); % first spike of the oscillation
        last_spike=max(find(HP_spikes<=SWR+half_window)); %last spike of the oscillation
        isi=diff(HP_spikes(first_spike:last_spike));
        Isi=[Isi isi];
    end
    if numel(Isi)>0        
        if n<47
            if experiment.age==8
                SWR8=SWR8+numel(sharptimepoints);
                ISI8=[ISI8 Isi];
            elseif experiment.age==9
                ISI9=[ISI9 Isi];
                SWR9=SWR9+numel(sharptimepoints);
            elseif experiment.age==10
                ISI10=[ISI10 Isi];
                SWR10=SWR10+numel(sharptimepoints);
            end
        else
            if experiment.age==8
                ISI81=[ISI81 Isi];
                SWR81=SWR81+numel(sharptimepoints);
            elseif experiment.age==9
                ISI91=[ISI91 Isi];
                SWR91=SWR91+numel(sharptimepoints);
            elseif experiment.age==10
                ISI101=[ISI101 Isi];
                SWR101=SWR101+numel(sharptimepoints);
            else
                ISIpj=[ISI91 Isi];
                SWRpj=SWRpj+numel(sharptimepoints);
            end
        end
    end
    Isi=[];
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end
edges=linspace(1,3200,100);
[p8,~]=histcounts(ISI8,edges);
[p10,~]=histcounts(ISI10,edges);
[p9,~]=histcounts(ISI9,edges);
[p81,~]=histcounts(ISI81,edges);
[p101,~]=histcounts(ISI101,edges);
[p91,~]=histcounts(ISI91,edges);
[pj,~]=histcounts(ISIpj,edges);

figure; plot(p8./numel(ISI8),'linewidth',3,'color','g'); hold on; plot(p81./numel(ISI81),'linewidth',3,'color','r'); xlim([0 50])
axis=gca; axis.XTickLabel={'','245','109','70','52','41','34','29','25','22','20'}; 
xlabel('Frequency (Hz)'); ylabel('Relative frequency')
title('Inter Spike Interval - 100ms around a SWR - P8')
figure; plot(p9./numel(ISI9),'linewidth',3,'color','g'); hold on; plot(p91./numel(ISI91),'linewidth',3,'color','r'); xlim([0 50])
axis=gca; axis.XTickLabel={'','245','109','70','52','41','34','29','25','22','20'}; 
xlabel('Frequency (Hz)'); ylabel('Relative frequency')
title('Inter Spike Interval - 100ms around a SWR - P9')
figure; plot(p10./numel(ISI10),'linewidth',3,'color','g'); hold on; plot(p101./numel(ISI101),'linewidth',3,'color','r'); xlim([0 50])
axis=gca; axis.XTickLabel={'','245','109','70','52','41','34','29','25','22','20'}; 
xlabel('Frequency (Hz)'); ylabel('Relative frequency')
title('Inter Spike Interval - 100ms around a SWR - P10')
