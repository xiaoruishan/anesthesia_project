

clear all

path = get_path;
experiments = get_experiment_list;
animal = [601:642 301:325];
WTanimal = 0;
GEanimal = 0;
ISI_animal = [];

for n = [1:3 7:48 50 52 53 55:67];
    
    clear PL_MUA
    
    experiment = experiments(animal(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'spikes4isi'));
    
    %     HP_MUA = spikes{1};
    %     CG_MUA = spikes{2};
    PL_MUA = spikes4isi{1};
    PL_MUA = PL_MUA(:,5233:6400,:);%5233:6400
    
    ISI_animal = [];
    
    for SWR = 1:size(PL_MUA,3)
        clear spike_timestamps & ISI_event
        spike_timestamps = find(PL_MUA(1,:,SWR));
        ISI_event = diff(spike_timestamps);
        ISI_animal = [ISI_animal ISI_event];
    end
    
    if n < 43
        WTanimal = WTanimal+1;
        wtISI{WTanimal} = ISI_animal;
    else
        GEanimal = GEanimal+1;
        geISI{GEanimal} = ISI_animal;
    end
end

edges = linspace(1,1500,100);

for animale = 1:39
    [ISI_WT(:,animale),~] = histcounts(wtISI{animale},edges);
    ISI_WT(:,animale) = ISI_WT(:,animale)./nnz(wtISI{animale});
    
    if animale < 23
       [ISI_GE(:,animale),~] = histcounts(geISI{animale},edges);
        ISI_GE(:,animale) = ISI_GE(:,animale)./nnz(geISI{animale}); 
    end
end

goodWTanimals = [2 4:8 10:14 16:20 23:30 33 34]; %PL
goodGEanimals = [2 8 10 12:14 17:19 22];

ISI_WT = ISI_WT(:,goodWTanimals);
ISI_GE = ISI_GE(:,goodGEanimals);

semWT = std(ISI_WT,0,2)./sqrt(size(ISI_WT,2));
semGE = std(ISI_GE,0,2)./sqrt(size(ISI_GE,2));

figure
hold on
boundedline(linspace(5,500,99),mean(ISI_WT,2),semWT,'g');
hold on
boundedline(linspace(5,500,99),mean(ISI_GE,2),semGE,'r');


