

clear all

path = get_path;
experiments = get_experiment_list;
animals = [801:814 400:405 407:415 419:427];
% animals = [601:642 301:325];
% animals = [501:536 551:565];
windowSize = 3;
fs = 3200;
overlap = 0;
nfft = 2^13;

for animale = 1:length(animals)%[1:4 7:42 43:48 50 52 53 55:length(animals)]
    
    experiment = experiments(animals(animale));
    
    clear HP & PFCsup
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpWaves1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'nonOscWaves'));
    
    if exist('sharpwaves1')
        sharpwaves = sharpwaves1;
        sharpPFC = sharpPFC1;
    end
    clear sharpwaves1 & sharpPFC1
    
    events = 1:size(sharpwaves,3);
    osc_events = setdiff(events,nonOscwaves);
    
    SWR = squeeze(sharpwaves(1,1:9600,osc_events));
    HP = reshape(SWR,1,[]);
    index = find(HP);
    HP = HP(index);
    
    sharpPFCsup = squeeze(sharpPFC(1,1:9600,osc_events));
    PFCsup = reshape(sharpPFCsup,1,[]);
    index = find(PFCsup);
    PFCsup = PFCsup(index);
    sharpPFCdeep = squeeze(sharpPFC(4,1:9600,osc_events));
    PFCdeep = reshape(sharpPFCdeep,1,[]);
    index = find(PFCdeep);
    PFCdeep = PFCdeep(index);
    
    clear sharpPFC & sharpwaves & sharpPFC1 & sharpwaves1
     
    [HP_PFCsup,f]=ImCohere(HP,PFCsup,windowSize,overlap,nfft,fs);
    [HP_PFCdeep,f]=ImCohere(HP,PFCdeep,windowSize,overlap,nfft,fs);
%     [deep_sup,f]=ImCohere(PFCdeep,PFCsup,windowSize,overlap,nfft,fs);
%     [HP_PFCsup,freq] = mscohere(HP,PFCsup,hanning(windowSize*fs),overlap*fs, 2^13, fs);
%     [HP_PFCdeep,~] = mscohere(HP,PFCdeep,hanning(windowSize*fs),overlap*fs, 2^13, fs);
%     [deep_sup,freq] = mscohere(PFCdeep,PFCsup,hanning(windowSize*fs),overlap*fs, 2^13, fs);
 

    if animale < 15
        WT1(:,animale) = HP_PFCsup;
        WT2(:,animale) = HP_PFCdeep;
%         WT3(:,animale) = deep_sup;
    else
        GE1(:,animale-14) = HP_PFCsup;
        GE2(:,animale-14) = HP_PFCdeep;
%         GE3(:,animale-14) = deep_sup;
    end
    display(strcat('mancano', num2str(length(animals)-animale),' animali'))        
               
        
    end
    
figure
plot(freq,mean(WT1,2),'linewidth',3)
hold on
plot(freq,mean(WT2,2),'linewidth',3)
plot(freq,mean(GE1,2),'linewidth',3)
plot(freq,mean(GE2,2),'linewidth',3)
xlim([3 100])


figure
plot(freq,mean(WT2,2),'linewidth',3)
hold on
plot(freq,mean(GE2,2),'linewidth',3)
xlim([1 50])


semWT = std(WT1,0,2)/sqrt(size(WT1,2));
semGE = std(GE1,0,2)/sqrt(size(GE1,2));

figure
boundedline(linspace(0,300,769),mean(WT1(1:769,:),2),semWT(1:769),'b')
hold on
boundedline(linspace(0,300,769),mean(GE1(1:769,:),2),semGE(1:769),'r')
xlim([1 50])

