
%% input parameters of the animal you want to analyze

clear all

animal_number = 601;
path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
experiment = experiments(animal_number);
CSC = [1:16];
spacing = 50*0.001; % the first factor in the multiplication is the distance between electrodes in mm(?)
fs = 3200;
cycles_of_signal = 2; %number of cycles of the oscillations that will be aligned and on which CSD will be plotted
frequencies_to_filter = [1 300]; % frequencies of the oscillations used to detect the sharpwave
save_data = 0;
repeatCalc = 0;
security_factor = 3200;

%% find baseline

gimmeBaselineSignal(experiment,save_data,repeatCalc);
[signal_filt,time_to_subtract] = loadNfilterBaselineSignal(experiment,CSC,fs,frequencies_to_filter,security_factor);

load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));



%% align everything to find max amplitude and shift everything according to that phase

for mm = 1:length(sharptimepoints1)
    sharp_wave(:,:,mm) = signal_filt(:, sharptimepoints1(mm)-1000:sharptimepoints1(mm)+1000);    
end

average_wave = mean(sharp_wave,3);


%% computes CSD
for channel = 3 : 14  % subtract 2, because CSD is computed on three neighboring channels, and therefore it can´t be computed on the two channels on the extremes
    CSD(channel-2,:) = ...
        -(2.*average_wave(channel+2,:) ...
        +2.*average_wave(channel-2,:)...
        - average_wave(channel-1,:)...
        - average_wave(channel+1,:)...
        -2.*average_wave(channel,:)) / spacing^2;
end


%% plot CSD

figure
hold on
colormap jet
imagesc((0:length(sharp_wave)-1000), [-50:50], flipud(CSD(:,500:1500)))

for ppp = 1:length(CSC)-2
    plot(average_wave(ppp,500:length(average_wave)-500)*0.08 + 50-7.5*(ppp-1), 'k', 'LineWidth', 1)
end

xlim([0 1000])
ylim([-65 65])
%% plot aligned signal

figure

for tt = 1:size(sharpwave,3)
    
    plot(squeeze((sharpwave(8,:,tt))))
    hold on
end

plot(sharp_wave(8,:), 'r', 'LineWidth', 3)


