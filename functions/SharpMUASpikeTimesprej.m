function [MUAspikeTimes]=SharpMUASpikeTimesprej(experiment,save_data)
%% calc oscTimes,Ampl,Duration, and occurence
path = get_path;
parameters=get_parameters;
ExtractModeArray = [];
downsampling_factor = 1;

disp(['Calculating MUA spike times for Animal: ' experiment.name])

[~, signalHP, ~, ~] = nlx_load_Opto(experiment, experiment.chan_num{2}, ExtractModeArray, downsampling_factor, save_data);
[~, signalPL, ~, ~] = nlx_load_Opto(experiment, experiment.chan_num{1}+5, ExtractModeArray, downsampling_factor, save_data);

signalMUAHP = ZeroPhaseFilter(signalHP,32000, parameters.FrequencyBands.MUA);
thr = std(signalMUAHP)*parameters.spikeanalysis.spikeDetection.threshold;
% detect all spikes in period window
[peakLoc, Ampl] = peakfinderOpto(signalMUAHP,0 ,-thr,-1);
peakLoc = (peakLoc);
spikeData = [peakLoc;Ampl];
MUAHP = spikeData;
clearvars signalMUAHP1 & signalMUAHP2 & signalMUAHP & spikeData & peakLoc & Ampl

signalMUAPFC = ZeroPhaseFilter(signalPL,32000, parameters.FrequencyBands.MUA);
thr = std(signalMUAPFC)*(parameters.spikeanalysis.spikeDetection.threshold);
% detect all spikes in period window
[peakLoc, Ampl] = peakfinderOpto(signalMUAPFC,0 ,-thr,-1);
peakLoc = (peakLoc);
spikeData = [peakLoc;Ampl];
MUAPFC = spikeData;


SpikeTimes = {MUAHP MUAPFC}
save_data = 1; 

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SpikeTimes'),'SpikeTimes');
end
end