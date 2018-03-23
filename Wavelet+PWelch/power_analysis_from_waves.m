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
type2 = [1:2 4 7:11 43:45 47 48 50 52 53];

%% load signal

for n = [1:4 7:11 43:48 50 52 53]
    
    clearvars PowerPFC PowerPFCpre PowerPFCpost
    experiment = experiments(animal(n));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC1'));
    
    for kk = 1:size(sharpPFC1,3)-1
        [PowerPFC(:,kk),~] = pWelchSpectrum(sharpPFC1(1,1067:2133,kk),window,noverlap,nfft,fs,0.95,100);
        [PowerPFCpre(:,kk),~] = pWelchSpectrum(sharpPFC1(1,1:1066,kk),window,noverlap,nfft,fs,0.95,100);
        [PowerPFCpost(:,kk),~] = pWelchSpectrum(sharpPFC1(1,2134:3200,kk),window,noverlap,nfft,fs,0.95,100);
    end
    
    if ismember(n,type2)
        load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC2'));
        for ss = 1:size(sharpPFC2,3)
            [PowerPFC(:,kk+ss),~] = pWelchSpectrum(sharpPFC2(1,1067:2133,ss),window,noverlap,nfft,fs,0.95,100);
            [PowerPFCpre(:,kk+ss),~] = pWelchSpectrum(sharpPFC2(1,1:1066,ss),window,noverlap,nfft,fs,0.95,100);
            [PowerPFCpost(:,kk+ss),~] = pWelchSpectrum(sharpPFC2(1,2134:3200,ss),window,noverlap,nfft,fs,0.95,100);
        end
    end
    
    PFC = {PowerPFC, PowerPFCpre, PowerPFCpost};
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,'power',filesep,experiment.name),'PFC');
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
    
end




