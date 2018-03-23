clear all

path = get_path;
experiments = get_experiment_list_Cg_juvenile;
animal = 1:23;
wt = 0;
ge = 0;


for n = 1:length(animal)
    
    
    p = 0;

    clearvars n_spikesHP & n_spikesPL
    
    experiment = experiments(animal(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpWaves1chan'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC1'));
    
    for tt = 1:size(sharptimepoints1,2)
        if max(max(sharpwaves(4,:,tt))) > 0
            p = p+1;
            for gg = 2:300
                n_spikesHP(1,p) = nnz(sharpwaves(6,1:32,tt));
                n_spikesHP(gg,p) = nnz(sharpwaves(6,(gg-1)*32:gg*32,tt));
            if gg < 101
                n_spikesPL(1,p) = nnz(sharpPFC(2,1:32,tt));
                n_spikesPL(gg,p) = nnz(sharpPFC(2,(gg-1)*32:gg*32,tt));
            end
            end
        end
    end
    
    if n < 13
        wt = wt+1
        spikeHP(:,wt) = mean(n_spikesHP,2);
        spikePL(:,wt) = mean(n_spikesPL,2);
    else
        ge = ge+1
        dspikeHP(:,ge) = mean(n_spikesHP,2);
        dspikePL(:,ge) = mean(n_spikesPL,2);
    end
end
    

for rr = 1:9
    figure
    plot(dspikePL(:,rr))
    k = waitforbuttonpress
    close
end

for uu = 1:7
    for mm = 2:20
        dPL(1,uu) = sum(dspikePL(1:5,uu));
        dPL(mm,uu) = sum(dspikePL(5*(mm-1):5*mm,uu));
    end
end

n = 0;
for uu = [2 5:9]
    n = n+1;
    for mm = 2:20
        PL(1,n) = sum(spikePL(1:5,uu));
        PL(mm,n) = sum(spikePL(5*(mm-1):5*mm,uu));
    end
end




    