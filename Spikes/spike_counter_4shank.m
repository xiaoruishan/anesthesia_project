clear all

path = get_path;
experiments = get_experiment_list;
animal = [501:537 551:566];

for n = 1:length(animal);
    
    clearvars spikes_hp & spikes_deep1 & spikes_deep2 & spikes_sup1 & spikes_sup2 & HP_MUA & Sup1_MUA & Sup2_MUA & Deep1_Mua & Deep2_Mua
    
    experiment = experiments(animal(n));
    
    if n < 37
        load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'spikes1stbaseline'));
        spikes = spikes1stbaseline;
        clearvars spikes1stbaseline
    else
        load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'spikes'));
    end
    
    HP_MUA = spikes{1};
    Sup1_MUA = spikes{2};
    Sup2_MUA = spikes{3};
    Deep1_MUA = spikes{4};
    Deep2_MUA = spikes{5};
    edges = linspace(0,9600,301);
 
    
    
    for SWR = 1:size(HP_MUA,3) % size(HP_MUA,3) is the total number of SWR of the animal
        
        [spikes_hp(:,SWR),~] = histcounts(find(HP_MUA(1,:,SWR)),edges);
        [spikes_sup1(:,SWR),~] = histcounts(find(Sup1_MUA(1,:,SWR)),edges);
        [spikes_sup2(:,SWR),~] = histcounts(find(Sup2_MUA(1,:,SWR)),edges);
        [spikes_deep1(:,SWR),~] = histcounts(find(Deep1_MUA(1,:,SWR)),edges);
        [spikes_deep2(:,SWR),~] = histcounts(find(Deep2_MUA(1,:,SWR)),edges);
    end
     
    if n < 38
        SpikesHP(:,n) = mean(spikes_hp,2);
        SpikesSup1(:,n) = mean(spikes_sup1,2);
        SpikesSup2(:,n) = mean(spikes_sup2,2);
        SpikesDeep1(:,n) = mean(spikes_deep1,2);
        SpikesDeep2(:,n) = mean(spikes_deep2,2);
    else
        dSpikesHP(:,n-37) = mean(spikes_hp,2);
        dSpikesSup1(:,n-37) = mean(spikes_sup1,2);
        dSpikesSup2(:,n-37) = mean(spikes_sup2,2);
        dSpikesDeep1(:,n-37) = mean(spikes_deep1,2);
        dSpikesDeep2(:,n-37) = mean(spikes_deep2,2);
    end

end


clearvars -except SpikesHP & SpikesSup1 & SpikesSup2 & SpikesDeep1 & SpikesDeep2 & dSpikesHP & dSpikesSup1 & dSpikesSup2 & dSpikesDeep1 & dSpikesDeep2

Sup = mean(SpikesSup1,2) + mean(SpikesSup2,2);
Deep = mean(SpikesDeep1,2) + mean(SpikesDeep2,2);

dSup = mean(dSpikesSup1,2) + mean(dSpikesSup2,2);
dDeep = mean(dSpikesDeep1,2) + mean(dSpikesDeep2,2);



SpikesSup1corr = SpikesSup1;
SpikesSup2corr = SpikesSup2;
SpikesDeep1corr = SpikesDeep1;
SpikesDeep2corr = SpikesDeep2;


for animale = 1:37
    mean_firingSup1_MUA = mean(SpikesSup1(:,animale));
    normSup1(:,animale) = SpikesSup1(:,animale)./mean_firingSup1_MUA; 
    if animale < 17
        mean_firingSup1_MUA = mean(dSpikesSup1(:,animale));
        dnormSup1(:,animale) = dSpikesSup1(:,animale)./mean_firingSup1_MUA; 
    end
end

Sup = normSup1 + normSup2;
normDeep = normDeep1 + normDeep2;




for uu = 1:19
    for mm = 2:100
        Sup1_MUA(1,uu) = sum(SpikesSup1_MUA(1:3,uu));
        Sup1_MUA(mm,uu) = sum(SpikesSup1_MUA(3*(mm-1):3*mm,uu));
        Sup2_MUA(1,uu) = sum(SpikesSup2_MUA(1:3,uu));
        Sup2_MUA(mm,uu) = sum(SpikesSup2_MUA(3*(mm-1):3*mm,uu));
        Deep1(1,uu) = sum(SpikesDeep1(1:3,uu));
        Deep1(mm,uu) = sum(SpikesDeep1(3*(mm-1):3*mm,uu));
        Deep2(1,uu) = sum(SpikesDeep2(1:3,uu));
        Deep2(mm,uu) = sum(SpikesDeep2(3*(mm-1):3*mm,uu));
    end
    
end

semsup = std(normSup1,0,2)/sqrt(size(normSup1,2));
semdeep = std(normDeep,0,2)/sqrt(size(normSup1,2));

semwt = std(SpikesSup1,0,2)/sqrt(size(SpikesSup1,2));
semge = std(dSpikesSup1,0,2)/sqrt(size(dSpikesSup1,2));

figure
hold on
boundedline(linspace(-500,500,100),mean(SpikesSup1(101:200,:),2),semwt(101:200,1),'b')
boundedline(linspace(-500,500,100),mean(dSpikesSup1(101:200,:),2),semge(101:200,1),'r')


subplot(2,2,1)
hold on
boundedline(linspace(-1500,1500,300),mean(dSpikesHP,2),semge,'r')
boundedline(linspace(-1500,1500,300),mean(SpikesHP,2),semwt,'b')
title('MUA - PFC Deep Layers centered on SWR', 'FontSize', 18)
ylabel('Firing Rate (10ms bins)', 'FontSize', 12)
xlabel('Time (ms)', 'FontSize', 12)


boundedline(linspace(1,1000,100),mean(normDeep1corr(101:200,:),2),semdeep1(101:200),'g')
boundedline(linspace(1,1000,100),mean(normDeep2corr(101:200,:),2),semdeep2(101:200),'g')


figure
plot(mean(SpikesDeep2,2),'linewidth',3)
plot(mean(dSpikesDeep2,2),'linewidth',3)



    