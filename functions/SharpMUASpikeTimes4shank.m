function [MUAspikeTimes]=SharpMUASpikeTimes4shank(experiment)
%% calc oscTimes,Ampl,Duration, and occurence
path = get_path;
parameters=get_parameters;
ExtractModeArray = [];
downsampling_factor = 1;
save_data = 0;

disp(['Calculating MUA spike times for Animal: ' experiment.name])
load(strcat(path.output, 'results', filesep, 'BaselineTimePoints', filesep, experiment.name, filesep, 'BaselineTimePoints'));

for ii = 1:5
    [~, signalHP, ~, ~] = nlx_load_Opto(experiment, experiment.HPreversal-3+ii, ExtractModeArray, downsampling_factor, save_data);


signalMUAHP1 = ZeroPhaseFilter(signalHP(1,BaselineTimePoints(1)*10:BaselineTimePoints(2)*10),32000, parameters.FrequencyBands.MUA);
signalMUAHP2 = ZeroPhaseFilter(signalHP(1,BaselineTimePoints(3)*10:end),32000, parameters.FrequencyBands.MUA);
signalMUAHP = horzcat(signalMUAHP1,signalMUAHP2);
thr = std(signalMUAHP)*parameters.spikeanalysis.spikeDetection.threshold;
% detect all spikes in period window
[peakLoc, Ampl] = peakfinderOpto(signalMUAHP,0 ,-thr,-1);
peakLoc = (peakLoc);
spikeData = [peakLoc;Ampl];
MUAHP{ii,:} = spikeData;

clearvars signalMUAHP1 & signalMUAHP2 & signalMUAHP & spikeData & peakLoc & Ampl
end

for ii = 17:32
    
    clearvars signalMUAPFC1 & signalMUAPFC2 & signalMUAPFC & spikeData & peakLoc & Ampl & signalPL
    
    [~, signalPL, ~, ~] = nlx_load_Opto(experiment, ii, ExtractModeArray, downsampling_factor, save_data);
    
    signalMUAPFC1 = ZeroPhaseFilter(signalPL(1,BaselineTimePoints(1)*10:BaselineTimePoints(2)*10),32000, parameters.FrequencyBands.MUA);
    signalMUAPFC2 = ZeroPhaseFilter(signalPL(1,BaselineTimePoints(3)*10:end),32000, parameters.FrequencyBands.MUA);
    signalMUAPFC = horzcat(signalMUAPFC1,signalMUAPFC2);
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