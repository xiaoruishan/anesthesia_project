function [MUAspikeTimes]=SharpMUASpikeTimes_baseline(experiment)
%% calc oscTimes,Ampl,Duration, and occurence
path = get_path;
parameters=get_parameters;
ExtractModeArray = [];
downsampling_factor = 1;
save_data = 0;

for ii = 1:5
    [~, signalHP, ~, ~] = nlx_load_Opto(experiment, experiment.HPreversal-3+ii, ExtractModeArray, downsampling_factor, save_data);


signalMUAHP = ZeroPhaseFilter(signalHP,32000, parameters.FrequencyBands.MUA);
thr = std(signalMUAHP)*parameters.spikeanalysis.spikeDetection.threshold;
% detect all spikes in period window
[peakLoc, Ampl] = peakfinderOpto(signalMUAHP,0 ,-thr,-1);
peakLoc = (peakLoc);
spikeData = [peakLoc;Ampl];
MUAHP{ii,:} = spikeData;

clearvars signalMUAHP & spikeData & peakLoc & Ampl
end

for ii = 17:32
    
    clearvars signalMUAPFC & spikeData & peakLoc & Ampl & signalPL
    
    [~, signalPL, ~, ~] = nlx_load_Opto(experiment, ii, ExtractModeArray, downsampling_factor, save_data);
    
    signalMUAPFC = ZeroPhaseFilter(signalPL,32000, parameters.FrequencyBands.MUA);
    thr = std(signalMUAPFC)*parameters.spikeanalysis.spikeDetection.threshold;
    % detect all spikes in period window
    [peakLoc, Ampl] = peakfinderOpto(signalMUAPFC,0 ,-thr,-1);
    peakLoc = (peakLoc);
    spikeData = [peakLoc;Ampl];
    MUAPFC{ii-16,:} = spikeData;

end


SpikeTimes = {MUAHP MUAPFC}
save_data = 1; 

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SpikeTimes'),'SpikeTimes');
end
end