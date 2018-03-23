clear all

path = get_path;
experiments = get_experiment_list;
animal = 501:536;%[700:732 800:812 900:912 1000:1005]; % above 900 is intCA1
fs = 3200;
fifteen_min = fs*60*15;
freq_to_filter = [100 300];
downsampling_factor = 10;
repeatCalc = 0;
stimulation = 1;
half_window=1600;
save_data=0;
spacing = 50*0.001; % the first factor in the multiplication is the distance between electrodes in mm(?)


for n=1:length(animal)
    
    experiment=experiments(animal(n));
    BaselineTimePoints=gimmeBaselineSignal(experiment,save_data,repeatCalc,stimulation);
    baseline=[round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];
    for channel=1:16
        [time,signal(channel,:),~,~]=nlx_load_Opto(experiment,channel,baseline,downsampling_factor,0);
        signal(channel,:)=ZeroPhaseFilter(signal(channel,:),fs,freq_to_filter);
    end
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_sharptimepoints1'))
    sharpwave=zeros(16,2*half_window+1,length(sharptimepoints));
    for event=1:length(sharptimepoints)
        SWR=sharptimepoints(event);
        if SWR-half_window>0 && SWR+half_window<length(signal)
            sharpwave(:,:,event)=signal(:,SWR-half_window:SWR+half_window);
        end
    end
    clearvars signal
    average_sharpwave=mean(sharpwave,3);
    
    for channel = 3 : 14  % subtract 2, because CSD is computed on three neighboring channels, and therefore it can´t be computed on the two channels on the extremes
        CSD(channel-2,:) = ...
            -(2.*average_sharpwave(channel+2,:) ...
            +2.*average_sharpwave(channel-2,:)...
            - average_sharpwave(channel-1,:)...
            - average_sharpwave(channel+1,:)...
            -2.*average_sharpwave(channel,:)) / spacing^2;
    end
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_CSD'),'CSD')
    %% plot CSD
    
%     figure
%     hold on
%     colormap jet
%     imagesc(flipud(CSD))
%     for ppp = 1:length(CSC)-2
%         plot(average_wave(ppp,500:length(average_wave)-500)*0.08 + 50-7.5*(ppp-1), 'k', 'LineWidth', 1)
%     end
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end