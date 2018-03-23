
% gli animali di joachim - da n = 24 in poi - hanno sharptimepoints come
% variabile, senze l'1 finale

clear all

path = get_path;
experiments = get_experiment_list;
animal = [601:642 301:325];
SWRtype2 = [1:2 4 7:11 43:45 47:48 50 52:53];


for n = [1:4 7:48 50 52 53 55:67];
    
    clearvars -except experiments & path & animal & n & SWRtype2
    
    experiment = experiments(animal(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SpikeTimes'));
    
    if exist('sharptimepoints1')
        sharptimepoints = sharptimepoints1;
    end
%     
%     HPtot = SpikeTimes{1,1};
%     
%     for channel = 1:5
%         spikes_channel(1,channel) = length(HPtot{channel});
%     end
%     
%     [~,channel_to_use] = max(spikes_channel);
%     
%     HPfiring = HPtot{channel_to_use};
%     
%     HPfiring(1,:) = round(HPfiring(1,:)/10); % firing is computed on signal with 32000 fs, whereas SWR-P are detected with 3200 fs
%     
%     for spike = 1 : size(HPfiring,2) % size(HPfiring,2) is the total number of spikes in the HP
%         spikesHPtimestamps(1,HPfiring(1,spike)) = 1;
%     end
%     
%     if length(spikesHPtimestamps) < max(sharptimepoints)+4800 % given how I "assign" spikes to SWR-P it is convenient to have the spikesHPtimestamps vector as "long" as the last detected SWR-P + 4800 timepoints
%         spikesHPtimestamps(1,end:max(sharptimepoints)+4800) = 0; % if the spikesHPtimestamps vector is too short, extend it until the last detected SWR-P
%     end
    
    totPFCspikes = SpikeTimes{1,2}; % first 5 channels are CG, last 5 are PL
    
    for channel = 8
        
        clearvars PFCspikes
        
        PFCspikes = totPFCspikes{channel};
        PFCspikes(1,:) = round(PFCspikes(1,:)/10); % firing is computed on signal with 32000 fs, whereas SWR-P are detected with 3200 fs
        
        if channel < 6 % first 5 channels are CG
            for spike = 1 : size(PFCspikes,2)
                spikesCGtimestamps(1,PFCspikes(1,spike)) = 1;
            end
            
            if length(spikesCGtimestamps) < max(sharptimepoints)+4800
                spikesCGtimestamps(1,end:max(sharptimepoints)+4800) = 0;
            end
        else %if channel > 4 & channel < 9
            for spike = 1 : size(PFCspikes,2)
                spikesPLtimestamps(1,PFCspikes(1,spike)) = 1;
            end
            
            if length(spikesPLtimestamps) < max(sharptimepoints)+4800
                spikesPLtimestamps(1,end:max(sharptimepoints)+4800) = 0;
            end
        end
    end
    
    for SWR1 = 1 : size(sharptimepoints,2)
        
        if sharptimepoints(SWR1)-4800 > 0
%             HPspikes(1,:,SWR1) = spikesHPtimestamps(1,sharptimepoints(SWR1)-4800:sharptimepoints(SWR1)+4800);
%             CGspikes(1,:,SWR1) = spikesCGtimestamps(1,sharptimepoints(SWR1)-4800:sharptimepoints(SWR1)+4800);
            PLspikes(1,:,SWR1) = spikesPLtimestamps(1,sharptimepoints(SWR1)-4800:sharptimepoints(SWR1)+4800);
        end
        
    end
    
    if ismember(n,SWRtype2)
        
        load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints2'));
        
        for SWR2 = 1 : size(sharptimepoints2,2)
            if sharptimepoints2(SWR2)-4800 > 0 && sharptimepoints2(SWR2)+4800 < length(spikesPLtimestamps)% && sharptimepoints2(SWR2)+4800 < length(spikesHPtimestamps) && sharptimepoints2(SWR2)+4800 < length(spikesPLtimestamps)
                
%                 HPspikes(1,:,SWR1+SWR2) = spikesHPtimestamps(1,sharptimepoints2(SWR2)-4800:sharptimepoints2(SWR2)+4800);
%                 CGspikes(1,:,SWR1+SWR2) = spikesCGtimestamps(1,sharptimepoints2(SWR2)-4800:sharptimepoints2(SWR2)+4800);
                PLspikes(1,:,SWR1+SWR2) = spikesPLtimestamps(1,sharptimepoints2(SWR2)-4800:sharptimepoints2(SWR2)+4800);
            end
        end
        
    end
    
%     HPspikes = logical(HPspikes);  
%     CGspikes = logical(CGspikes);
%     PLspikes = logical(PLspikes);
    spikes4isi = {PLspikes};
    
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'spikes4isi'),'spikes4isi');
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end


