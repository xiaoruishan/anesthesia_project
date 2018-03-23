
clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812 101:186];%900:912 1000:1005 501:536 1:18]; % above 900 is intCA1

half_window=4800;
ISI8=[]; ISI9=[]; ISI10=[]; ISI81=[]; ISI91=[]; ISI101=[]; ISIpj=[]; Isi=[];
SWR8=0; SWR9=0; SWR10=0; SWR81=0; SWR91=0; SWR101=0; SWRjp=0;
MUA_sharp=zeros(length(animal),2*half_window/10);
for n=102:length(animal)
    
    clearvars signal_filt wavelet
    experiment=experiments(animal(n));
    if n>666
        load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_SpikeTimes'))
        HP_spikes=SpikeTimes{1,1}{3,1};
    else
        load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_SpikeTimesHP'))
        HP_spikes=SpikeTimesHP{1,1}{3,1};
    end
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_sharptimepoints1'))
    HP_spikes(2,:)=[];
    HP_spikes=fix(HP_spikes./10);
    mua_sharp=zeros(2*half_window,length(sharptimepoints));
    for event=1:length(sharptimepoints)
        SWR=sharptimepoints(event);
        first_spike=min(find(HP_spikes>=SWR-half_window)); % first spike of the oscillation
        last_spike=max(find(HP_spikes<=SWR+half_window-1)); %last spike of the oscillation
        mua_sharp(HP_spikes(first_spike:last_spike)-SWR+half_window+1,event)=1;
    end
    MUA_sharp(n,:)=sum(reshape(mean(mua_sharp,2),[10,960]));    
end

figure; boundedline(linspace(-3,3,960),mean(MUA_sharp(p8,:))*100,std(MUA_sharp(p8,:))*100./sqrt(numel(p8)),'g')
hold on; boundedline(linspace(-3,3,960),mean(MUA_sharp(p81,:))*100,std(MUA_sharp(p81,:))*100./sqrt(numel(p81)),'r'); ylim([0 25])

figure; boundedline(linspace(-3,3,960),mean(MUA_sharp(p9,:))*100,std(MUA_sharp(p9,:))*100./sqrt(numel(p9)),'g')
hold on; boundedline(linspace(-3,3,960),mean(MUA_sharp(p91,:))*100,std(MUA_sharp(p91,:))*100./sqrt(numel(p91)),'r'); ylim([0 25])

figure; boundedline(linspace(-3,3,960),mean(MUA_sharp(p10,:))*100,std(MUA_sharp(p10,:))*100./sqrt(numel(p10)),'g')
hold on; boundedline(linspace(-3,3,960),mean(MUA_sharp(p101,:))*100,std(MUA_sharp(p101,:))*100./sqrt(numel(p101)),'r'); ylim([0 25])
