
% gli animali di joachim - da n = 24 in poi - hanno sharptimepoints come
% variabile, senze l'1 finale

clear all

path = get_path;
experiments = get_experiment_list;
animal = 537%[501:536];

for n = 1:length(animal);
    
    clearvars -except experiments & path & animal & n & type2
    
    experiment = experiments(animal(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SpikeTimes'));
%     load(strcat(path.output, 'results', filesep, 'BaselineTimePoints', filesep, experiment.name, filesep, 'BaselineTimePoints'));
    
    HPtot = SpikeTimes{1,1};
    
    for channel = 1:5
        spikes_channel(1,channel) = length(HPtot{channel});
    end
    
    [~,channel_to_use] = max(spikes_channel);
    
    HPfiring = HPtot{channel_to_use};
    
    HPfiring(1,:) = round(HPfiring(1,:)/10); % firing is computed on signal with 32000 fs, whereas SWR-P are detected with 3200 fs
   
    for spike = 1 : size(HPfiring,2) % size(HPfiring,2) is the total number of spikes in the HP
        spikesHPtimestamps(1,HPfiring(1,spike)) = 1;
    end
    
    if length(spikesHPtimestamps) < max(sharptimepoints)+4800 % given how I "assign" spikes to SWR-P it is convenient to have the spikesHPtimestamps vector as "long" as the last detected SWR-P + 4800 timepoints
        spikesHPtimestamps(1,end:max(sharptimepoints)+4800) = 0; % if the spikesHPtimestamps vector is too short, extend it until the last detected SWR-P
    end
    
    totPFCspikes = SpikeTimes{1,2}; % first 5 channels are CG, last 5 are PL
    
    for channel = 1:16
        
        clearvars PFCspikes
        
        PFCspikes = totPFCspikes{channel};
        PFCspikes(1,:) = round(PFCspikes(1,:)/10); % firing is computed on signal with 32000 fs, whereas SWR-P are detected with 3200 fs
        
        if channel < 5 % first 5 channels are first tetrode
            for spike = 1 : size(PFCspikes,2)
                spikessup1timestamps(1,PFCspikes(1,spike)) = 1;
            end
            
            if length(spikessup1timestamps) < max(sharptimepoints)+4800
                spikessup1timestamps(1,end:max(sharptimepoints)+4800) = 0;
            end
        elseif channel > 4 & channel < 9 %second tetrode
            for spike = 1 : size(PFCspikes,2)
                spikessup2timestamps(1,PFCspikes(1,spike)) = 1;
            end
            
            if length(spikessup2timestamps) < max(sharptimepoints)+4800
                spikessup2timestamps(1,end:max(sharptimepoints)+4800) = 0;
            end
        elseif channel > 8 & channel < 13 %third tetrode
            for ss = 1 : size(PFCspikes,2)
                spikesdeep1timestamps(1,PFCspikes(1,ss)) = 1;
            end
            
            if length(spikesdeep1timestamps) < max(sharptimepoints)+4800
                spikesdeep1timestamps(1,end:max(sharptimepoints)+4800) = 0;
            end
        else %fourth tetrode
            for ss = 1 : size(PFCspikes,2)
                spikesdeep2timestamps(1,PFCspikes(1,ss)) = 1;
            end
            
            if length(spikesdeep2timestamps) < max(sharptimepoints)+4800
                spikesdeep2timestamps(1,end:max(sharptimepoints)+4800) = 0;
            end
        end
    end
    
    for SWR1 = 1 : size(sharptimepoints,2)
        
        if sharptimepoints(SWR1)-4800 > 0 %&& sharptimepoints(SWR1) < (BaselineTimePoints(2) - BaselineTimePoints(1))
            HPspikes(1,:,SWR1) = spikesHPtimestamps(1,sharptimepoints(SWR1)-4800:sharptimepoints(SWR1)+4800);
            Sup1spikes(1,:,SWR1) = spikessup1timestamps(1,sharptimepoints(SWR1)-4800:sharptimepoints(SWR1)+4800);
            Sup2spikes(1,:,SWR1) = spikessup2timestamps(1,sharptimepoints(SWR1)-4800:sharptimepoints(SWR1)+4800);
            Deep1spikes(1,:,SWR1) = spikesdeep1timestamps(1,sharptimepoints(SWR1)-4800:sharptimepoints(SWR1)+4800);
            Deep2spikes(1,:,SWR1) = spikesdeep2timestamps(1,sharptimepoints(SWR1)-4800:sharptimepoints(SWR1)+4800);
        end
        
    end
    
    HPspikes = logical(HPspikes);
    Sup1spikes = logical(Sup1spikes);
    Sup2spikes = logical(Sup2spikes);
    Deep1spikes = logical(Deep1spikes);
    Deep2spikes = logical(Deep2spikes);
    
    spikes = {HPspikes, Sup1spikes, Sup2spikes, Deep1spikes, Deep2spikes}
    
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'spikes'),'spikes');
    
end




