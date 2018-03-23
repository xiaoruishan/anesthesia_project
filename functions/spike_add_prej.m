
clear all

path = get_path;
experiments = get_experiment_list_Cg_juvenile;
animal = 1:23;

for n = 1:length(animal)
    
    experiment = experiments(animal(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SharpWaves1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SpikeTimes'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC1'));
    
    HP = SpikeTimes{1};
    HP(1,:) = round(HP(1,:)/10);
    
    PL = SpikeTimes{2};
    PL(1,:) = round(PL(1,:)/10);
    
    for ss = 1 : size(HP,2)
        spikesHP(1,HP(1,ss)) = 100;
    end
    
    if length(spikesHP) < max(sharptimepoints1)+4800
        spikesHP(1,end:max(sharptimepoints1)+4800) = 0;
    end
    
    for ss = 1 : size(PL,2)
        spikesPL(1,PL(1,ss)) = 100;
    end
    
    if length(spikesPL) < max(sharptimepoints1)+4800
        spikesPL(1,end:max(sharptimepoints1)+4800) = 0;
    end
    
    for pp = 1 : size(sharptimepoints1,2)
        
        sharpwaves(6,:,pp) = spikesHP(1,sharptimepoints1(pp)-4800:sharptimepoints1(pp)+4800);
        sharpPFC(2,:,pp) = spikesPL(1,sharptimepoints1(pp)-1600:sharptimepoints1(pp)+1600);
        
    end
    
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SharpWaves1chan'),'sharpwaves');
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFC1'),'sharpPFC');
    
    
end


















%         for tt = 1 : size(sharptimepoints1,2)
%             figure('units','normalized','outerposition',[0 0 1 1])
%             subplot(2,1,1)
%             plot(sharpwaves1chan(4,3200:6401,tt))
%             hold on
%             plot(spikesHP(1,sharptimepoints1(tt)-1600:sharptimepoints1(tt)+1600))
%             xlim([1 3200])
%             subplot(2,1,2)
%             plot(sharpPFC1(1,:,tt))
%             hold on
%             plot(spikesPL(1,sharptimepoints1(tt)-1600:sharptimepoints1(tt)+1600))
%             xlim([1 3200])
%             k = waitforbuttonpress
%             close
%         end
%
%         for gg = 1 : size(sharptimepoints2,2)
%             sharpspikes1(1,gg) = nnz(spikesHP(1,sharptimepoints2(gg)-1600:sharptimepoints2(gg)+1600));
%             sharpspikes1(2,gg) = nnz(spikesPL(1,sharptimepoints2(gg)-1600:sharptimepoints2(gg)+1600));
%         end
%
%         banana = sum(sharpspikes1(2,:)




