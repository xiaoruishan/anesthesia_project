

clear all

path = get_path;
experiments = get_experiment_list;
animals = [801:814 400:405 407:415 419:427];
%animals = [601:642 301:325];
% animals = [501:536 551:565];
windowSize = 1;
fs = 3200;
overlap = 0;
nfft = 2^13;

for animale = 1:length(animals)
    
    experiment = experiments(animals(animale));
    
    clear HP & PFCsup
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpWaves1'));
%     load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'nonOscWaves'));
    
    if exist('sharpwaves1')
        sharpwaves = sharpwaves1;
        sharpPFC = sharpPFC1;
    end
    clear sharpwaves1 & sharpPFC1
    
    wavcoh = zeros(145,9601,size(sharpwaves,3));
    
    for event = 1:size(sharpwaves,3)
        [wavcoh(:,:,event),~,freq]=wcoherence(sharpwaves(1,:,event),sharpPFC(1,:,event),3200);
    end

    clear sharpPFC & sharpwaves

    if animale < 15
        WT1(:,:,animale) = mean(wavcoh,3);
    else
        GE1(:,:,animale-14) = mean(wavcoh,3);
    end
    
    clear wavcoh
    
    display(strcat('mancano', num2str(length(animals)-animale),' animali'))                  
        
    end
    
figure
plot(freq,mean(WT3,2),'linewidth',3)
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

