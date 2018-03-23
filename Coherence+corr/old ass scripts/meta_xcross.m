
clear all

path = get_path;
experiments = get_experiment_list;
animals = [501:536 551:566];%[601:642 301:325 801:814 400:405 407:415 419:427];:
save_data = 0;
ExtractModeArray = [];
downsampling_factor = 10;
windowSize = 0.25;
fs = 3200;
overlap = 0;
nfft = 2^13;
% delta = [1 4];
theta = [4 8];
alpha = [8 12];
beta = [12 30];
lowgamma = [30 50];
highgamma = [50 80];
freq_bands = {theta, alpha, beta, lowgamma, highgamma};
SWRtype2 = [1:2 4 7:11 43:45 47:48 50 52:53];

for animal = 1:length(animals)%[1:4 7:48 50 52 53 55:length(animals)]
    
    experiment = experiments(animals(animal));
    channels = [experiment.PL(1) experiment.PL(2) experiment.HPreversal];
    load(strcat(path.output, 'results', filesep, 'BaselineTimePoints', filesep, experiment.name, filesep, 'BaselineTimePoints'));
    for channel = 1:3
        CSC = channels(channel);
        [~, signal, ~, ~] = nlx_load_Opto(experiment, CSC, ExtractModeArray, downsampling_factor, save_data);
        signal_baseline1 = signal(1,BaselineTimePoints(1):BaselineTimePoints(2));
        signal_baseline2 = signal(1,BaselineTimePoints(3):end);
        clearvars signal
        if animal < 37
            signal_baseline = signal_baseline1;
        else
            signal_baseline = horzcat(signal_baseline1,signal_baseline2);
        end
        clearvars signal_baseline1 signal_baseline2
        for frequency = 1:5
            freq_band = freq_bands{frequency};
            signal_filt(channel,frequency,:) = ZeroPhaseFilter(signal_baseline,3200,freq_band);
        end
        clearvars signal_baseline
    end
     
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
    if exist('sharptimepoints1')
        sharptimepoints = sharptimepoints1;
    end
    clear sharptimepoints1
    
    %     if ismember(animal,SWRtype2)
    %         load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints2'));
    %         sharptimepoints = horzcat(sharptimepoints,sharptimepoints2);
    %         clear sharptimepoints2
    %     end
    
    
    for event = 1:size(sharptimepoints,2)
        if sharptimepoints(event)-1600>0 && sharptimepoints(event)+1600<length(signal_filt)
            corr_theta(:,event) = xcorr(squeeze(signal_filt(1,1,sharptimepoints(event)-1599:sharptimepoints(event)+1600)),squeeze(signal_filt(3,1,sharptimepoints(event)-1599:sharptimepoints(event)+1600)),300);
            corr_alpha(:,event) = xcorr(squeeze(signal_filt(1,2,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(3,2,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            corr_beta(:,event) = xcorr(squeeze(signal_filt(1,3,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(3,3,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            corr_lowgamma(:,event) = xcorr(squeeze(signal_filt(1,4,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(3,4,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            corr_highgamma(:,event) = xcorr(squeeze(signal_filt(1,5,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(3,5,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            corr_alphapre(:,event) = xcorr(squeeze(signal_filt(1,2,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(3,2,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            corr_betapre(:,event) = xcorr(squeeze(signal_filt(1,3,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(3,3,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            corr_lowgammapre(:,event) = xcorr(squeeze(signal_filt(1,4,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(3,4,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            corr_highgammapre(:,event) = xcorr(squeeze(signal_filt(1,5,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(3,5,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            corr_alphapost(:,event) = xcorr(squeeze(signal_filt(1,2,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(3,2,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            corr_betapost(:,event) = xcorr(squeeze(signal_filt(1,3,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(3,3,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            corr_lowgammapost(:,event) = xcorr(squeeze(signal_filt(1,4,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(3,4,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            corr_highgammapost(:,event) = xcorr(squeeze(signal_filt(1,5,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(3,5,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            deepcorr_theta(:,event) = xcorr(squeeze(signal_filt(2,1,sharptimepoints(event)-1599:sharptimepoints(event)+1600)),squeeze(signal_filt(3,1,sharptimepoints(event)-1599:sharptimepoints(event)+1600)),300);
            deepcorr_alpha(:,event) = xcorr(squeeze(signal_filt(2,2,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(3,2,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            deepcorr_beta(:,event) = xcorr(squeeze(signal_filt(2,3,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(3,3,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            deepcorr_lowgamma(:,event) = xcorr(squeeze(signal_filt(2,4,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(3,4,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            deepcorr_highgamma(:,event) = xcorr(squeeze(signal_filt(2,5,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(3,5,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            deepcorr_alphapre(:,event) = xcorr(squeeze(signal_filt(2,2,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(3,2,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            deepcorr_betapre(:,event) = xcorr(squeeze(signal_filt(2,3,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(3,3,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            deepcorr_lowgammapre(:,event) = xcorr(squeeze(signal_filt(2,4,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(3,4,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            deepcorr_highgammapre(:,event) = xcorr(squeeze(signal_filt(2,5,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(3,5,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            deepcorr_alphapost(:,event) = xcorr(squeeze(signal_filt(2,2,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(3,2,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            deepcorr_betapost(:,event) = xcorr(squeeze(signal_filt(2,3,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(3,3,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            deepcorr_lowgammapost(:,event) = xcorr(squeeze(signal_filt(2,4,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(3,4,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            deepcorr_highgammapost(:,event) = xcorr(squeeze(signal_filt(2,5,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(3,5,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            intercorr_theta(:,event) = xcorr(squeeze(signal_filt(1,1,sharptimepoints(event)-1599:sharptimepoints(event)+1600)),squeeze(signal_filt(2,1,sharptimepoints(event)-1599:sharptimepoints(event)+1600)),300);
            intercorr_alpha(:,event) = xcorr(squeeze(signal_filt(1,2,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(2,2,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            intercorr_beta(:,event) = xcorr(squeeze(signal_filt(1,3,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(2,3,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            intercorr_lowgamma(:,event) = xcorr(squeeze(signal_filt(1,4,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(2,4,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            intercorr_highgamma(:,event) = xcorr(squeeze(signal_filt(1,5,sharptimepoints(event)-399:sharptimepoints(event)+400)),squeeze(signal_filt(2,5,sharptimepoints(event)-399:sharptimepoints(event)+400)),300);
            intercorr_alphapre(:,event) = xcorr(squeeze(signal_filt(1,2,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(2,2,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            intercorr_betapre(:,event) = xcorr(squeeze(signal_filt(1,3,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(2,3,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            intercorr_lowgammapre(:,event) = xcorr(squeeze(signal_filt(1,4,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(2,4,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            intercorr_highgammapre(:,event) = xcorr(squeeze(signal_filt(1,5,sharptimepoints(event)-1199:sharptimepoints(event)-400)),squeeze(signal_filt(2,5,sharptimepoints(event)-1199:sharptimepoints(event)-400)),300);
            intercorr_alphapost(:,event) = xcorr(squeeze(signal_filt(1,2,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(2,2,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            intercorr_betapost(:,event) = xcorr(squeeze(signal_filt(1,3,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(2,3,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            intercorr_lowgammapost(:,event) = xcorr(squeeze(signal_filt(1,4,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(2,4,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            intercorr_highgammapost(:,event) = xcorr(squeeze(signal_filt(1,5,sharptimepoints(event)+401:sharptimepoints(event)+1200)),squeeze(signal_filt(2,5,sharptimepoints(event)+401:sharptimepoints(event)+1200)),300);
            
        end
    end
    
    cross_coherence = {corr_theta, corr_alpha, corr_beta, corr_lowgamma, corr_highgamma, corr_alphapre, corr_betapre, ...
        corr_lowgammapre, corr_highgammapre, corr_alphapost, corr_betapost, corr_lowgammapost, corr_highgammapost, ...
        deepcorr_theta, deepcorr_alpha, deepcorr_beta, deepcorr_lowgamma, deepcorr_highgamma, deepcorr_alphapre, deepcorr_betapre, ...
        deepcorr_lowgammapre, deepcorr_highgammapre, deepcorr_alphapost, deepcorr_betapost, deepcorr_lowgammapost, deepcorr_highgammapost,...
        intercorr_theta, intercorr_alpha, intercorr_beta, intercorr_lowgamma, intercorr_highgamma, intercorr_alphapre, intercorr_betapre, ...
        intercorr_lowgammapre, intercorr_highgammapre, intercorr_alphapost, intercorr_betapost, intercorr_lowgammapost, intercorr_highgammapost};
    
    clearvars signal_filt corr_theta corr_alpha corr_beta corr_lowgamma corr_highgamma corr_alphapre corr_betapre...
        corr_lowgammapre corr_highgammapre corr_alphapost corr_betapost corr_lowgammapost corr_highgammapost...
        deepcorr_theta deepcorr_alpha deepcorr_beta deepcorr_lowgamma deepcorr_highgamma deepcorr_alphapre deepcorr_betapre ...
        deepcorr_lowgammapre deepcorr_highgammapre deepcorr_alphapost deepcorr_betapost deepcorr_lowgammapost deepcorr_highgammapost...
        deepcorr_theta deepcorr_alpha deepcorr_beta deepcorr_lowgamma deepcorr_highgamma deepcorr_alphapre deepcorr_betapre ...
        deepcorr_lowgammapre deepcorr_highgammapre deepcorr_alphapost deepcorr_betapost deepcorr_lowgammapost deepcorr_highgammapost
    
    %     cross_coherence = {imag_coh, imag_cohpre, imag_cohpost, deepimag_coh, deepimag_cohpre, deepimag_cohpost};
    
    save(strcat(path.output,filesep,'results',filesep,'correlation',filesep,experiment.name,filesep,'cross_coherence'),'cross_coherence');
    clearvars cross_coherence
    
    display(strcat('mancano', num2str(length(animals)-animal),' animali'))
end
