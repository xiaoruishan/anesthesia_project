clear all

%% load parameters

save_file = 1;
path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
animal = [601:642 301:325 501:537 551:566];
window = 0.33;
noverlap = 0;
nfft = 6400;
fs = 3200;
save_data = 0;
repeatCalc = 0;
ExtractModeArray = [];
downsampling_factor = 10;
stimulation = 1;

%% load signal

for n = [1:4 7:48 50 52 53 55:length(animal)]
    
    clearvars PowerPFC PowerPFCpre PowerPFCpost
    experiment = experiments(animal(n));
    channel = experiment.PL(1);
    Baseline = gimmeBaselineSignal(experiment,save_data,repeatCalc,stimulation);
    BaselineTimePoints = Baseline.BaselineTimePoints;
    
    [~, signal, ~, ~] = nlx_load_Opto(experiment, channel, ExtractModeArray, downsampling_factor, save_data);
    signal1 = signal(1,BaselineTimePoints(1):BaselineTimePoints(2));
    signal2 = signal(1,BaselineTimePoints(3):end-9600);
    clear signal
    signal = horzcat(signal1, signal2);
    clear signal1 & signal2
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
    if exist('sharptimepoints1')
        sharptimepoints = sharptimepoints1;
    end
    clear sharptimepoints1
    
    PowerPFC = zeros(201,size(sharptimepoints,2));
    PowerPFCpre = zeros(201,size(sharptimepoints,2));
    PowerPFCpost = zeros(201,size(sharptimepoints,2));
    
    for event = 1 : size(sharptimepoints,2)
        sharpwindow = sharptimepoints(event)-window/2*fs:sharptimepoints(event)+window/2*fs;
        if min(sharpwindow-1440)>0 && max(sharpwindow+1440)<length(signal)
            [PowerPFC(:,event),~] = pWelchSpectrum(signal(1,sharpwindow-1440),window,noverlap,nfft,fs,0.95,100);
            [PowerPFCpre(:,event),~] = pWelchSpectrum(signal(1,sharpwindow),window,noverlap,nfft,fs,0.95,100);
            [PowerPFCpost(:,event),~] = pWelchSpectrum(signal(1,sharpwindow+1440),window,noverlap,nfft,fs,0.95,100);
        end
    end
    
    PFC = {PowerPFC, PowerPFCpre, PowerPFCpost};
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,'power',filesep,experiment.name),'PFC');
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end







