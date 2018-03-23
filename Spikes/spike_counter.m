clear all

path = get_path;
experiments = get_experiment_list;
animal = [501:537 551:566];
WTanimal = 0;
GEanimal = 0;

for n = 1:length(animal)%[1:4 7:42 43:48 50 52 53 55:length(animal)];
    
    clearvars -except spikeHP & spikePL & spikeCG & gespikeHP & gespikePL & gespikeCG & n & path & experiments & animal & SWRtype2 & WTanimal & GEanimal & SpikesHP & SpikesDeep1 & SpikesDeep2 & SpikesSup1 & SpikesSup2 & dorspikeHP & dorspikePL & dorspikeCG
    
    experiment = experiments(animal(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'spikes'));
    
    HP_MUA = spikes{1};
%     CG_MUA = spikes{2};
%     PL_MUA = spikes{3};  
    
    
    for SWR = 1:size(HP_MUA,3) % size(HP_MUA,3) is the total number of SWR of the animal
        
        for bins10ms = 2:300 % my snippets of signal are 3s long, as I want to bin spikes in 10ms, I divide them in 300 bins
            spikes_hp(1,SWR) = nnz(HP_MUA(1,1:32,SWR));
            spikes_hp(bins10ms,SWR) = nnz(HP_MUA(1,(bins10ms-1)*32:bins10ms*32,SWR));
%             spikes_cg(1,SWR) = nnz(CG_MUA(1,1:32,SWR));
%             spikes_cg(bins10ms,SWR) = nnz(CG_MUA(1,(bins10ms-1)*32:bins10ms*32,SWR));
%             spikes_pl(1,SWR) = nnz(PL_MUA(1,1:32,SWR));
%             spikes_pl(bins10ms,SWR) = nnz(PL_MUA(1,(bins10ms-1)*32:bins10ms*32,SWR));

        end
    end
       
     if n < 38
         WTanimal = WTanimal+1
         spikeHP(:,WTanimal) = mean(spikes_hp,2);
%          spikeCG(:,WTanimal) = mean(spikes_cg,2);
%          spikePL(:,WTanimal) = mean(spikes_pl,2);
     else
         GEanimal = GEanimal+1
         gespikeHP(:,GEanimal) = mean(spikes_hp,2);
%          gespikePL(:,GEanimal) = mean(spikes_pl,2);
%          gespikeCG(:,GEanimal) = mean(spikes_cg,2);
     end

end


clearvars -except spikeHP & spikePL & spikeCG & gespikeCG & gespikeHP & gespikePL & SpikesHP & SpikesDeep1 & SpikesDeep2 & SpikesSup1 & SpikesSup2
    

for animale = 1:40
    
    
    mean_firingHP = mean(spikeHP(:,animale));
    normHP(:,animale) = spikeHP(:,animale)./mean_firingHP;
    mean_firingCG = mean(spikeCG(:,animale));
    normCG(:,animale) = spikeCG(:,animale)./mean_firingCG;
    mean_firingPL = mean(spikePL(:,animale));
    normPL(:,animale) = spikePL(:,animale)./mean_firingPL;
    
    if animale < 23
        mean_firingHP = mean(gespikeHP(:,animale));
        genormHP(:,animale) = gespikeHP(:,animale)./mean_firingHP;
        mean_firingCG = mean(gespikeCG(:,animale));
        genormCG(:,animale) = gespikeCG(:,animale)./mean_firingCG;
        mean_firingPL = mean(gespikePL(:,animale));
        genormPL(:,animale) = gespikePL(:,animale)./mean_firingPL;
    end
end

for animale = 1:40

    totspikes(1,animale) = sum(spikePL(:,animale));
    totspikes(2,animale) = sum(spikeCG(:,animale));
    totspikes(3,animale) = sum(spikeHP(:,animale));
    
    if animale < 23
        getotspikes(1,animale) = sum(gespikePL(:,animale));
        getotspikes(2,animale) = sum(gespikeCG(:,animale));
        getotspikes(3,animale) = sum(gespikeHP(:,animale));
    end
    
end

meanspikes = mean(totspikes,2);
semspikes = std(totspikes,0,2)./6.4;
gemeanspikes = mean(getotspikes,2);
gesemspikes = std(getotspikes,0,2)./4.7;


PL = normPL(:,[2 5:9 11:15 17:21 24:31 34 35]);
gePL = normPL(:,[2 8 10 12:14 17:19 22]);

CG = normCG(:,[5:15 17 19 21 24:28 34 37]);
geCG = genormCG(:,[10 12:19 22]);

HP = normHP(:,[1:34 36 38]);
geHP = genormHP(:,[1 3 5 6 9:17 19]);


semPL = std(PL,0,2)/5.3;
gesemPL = std(gePL,0,2)/3;

semCG = std(CG,0,2)/4.4;
gesemCG = std(geCG,0,2)/3.2;

semHP = std(SpikesHP,0,2)/6;
gesemHP = std(dSpikesHP,0,2)/4;

semSup1 = std(normSup1,0,2)/4;
semSup2 = std(normSup2,0,2)/4;
semDeep1 = std(normDeep1,0,2)/4;
semDeep2 = std(normDeep2,0,2)/4;


figure
boundedline(linspace(-1500,1500,300),mean(dSpikesHP,2),gesemHP,'r')
hold on
boundedline(linspace(-1500,1500,300),mean(SpikesHP,2),semHP,'b')
boundedline(linspace(1,3000,300),mean(normSup2,2),semSup2,'g')
boundedline(linspace(1,3000,300),mean(normDeep1,2),semDeep1,'y')
boundedline(linspace(1,3000,300),mean(normDeep2,2),semDeep2,'b')


figure
boundedline(linspace(1,3000,300),mean(PL,2),semPL,'b')
hold on
boundedline(linspace(1,3000,300),mean(gePL,2),gesemPL,'b')

figure
boundedline(linspace(1,3000,300),mean(HP,2),semHP,'b')
hold on
boundedline(linspace(1,3000,300),mean(geHP,2),gesemHP,'r')

figure
boundedline(linspace(1,3000,300),mean(CG,2),semCG,'b')
hold on
boundedline(linspace(1,3000,300),mean(geCG,2),gesemCG,'r')






    