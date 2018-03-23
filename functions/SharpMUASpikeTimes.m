function [MUAspikeTimes]=SharpMUASpikeTimes(experiment,baseline)
%% calc oscTimes,Ampl,Duration, and occurence
path = get_path;
parameters=get_parameters;
ExtractModeArray = baseline;
downsampling_factor = 1;
save_data = 0;

load(strcat(path.output, 'results', filesep, 'BaselineTimePoints', filesep, experiment.name, filesep, 'BaselineTimePoints'));

for ii = 1:5
    [~, signalHP, ~, ~] = nlx_load_Opto(experiment, experiment.HPreversal-3+ii, ExtractModeArray, downsampling_factor, save_data);
% 
% 
% signalMUAHP1 = ZeroPhaseFilter(signalHP(1,BaselineTimePoints(1)*10:BaselineTimePoints(2)*10),32000, parameters.FrequencyBands.MUA);
% signalMUAHP2 = ZeroPhaseFilter(signalHP(1,BaselineTimePoints(3)*10:end),32000, parameters.FrequencyBands.MUA);
% signalMUAHP = horzcat(signalMUAHP1,signalMUAHP2);
% thr = std(signalHP)*parameters.spikeanalysis.spikeDetection.threshold;
thr = std(signalHP)*4;
% detect all spikes in period window
[peakLoc, Ampl] = peakfinderOpto(signalHP,thr/2,-thr,-1,false);
% [peakLoc, Ampl] = peakfinderOpto(signalHP,0,-thr,-1,false);
peakLoc = (peakLoc);
spikeData = [peakLoc;Ampl];
MUAHP{ii,:} = spikeData;

clearvars signalMUAHP1 & signalMUAHP2 & signalMUAHP & spikeData & peakLoc & Ampl & signalHP
end

% for ii = 1:5
%     
%     clearvars signalMUAPFC1 & signalMUAPFC2 & signalMUAPFC & spikeData & peakLoc & Ampl & signalPL
%     
%     [~, signalPL, ~, ~] = nlx_load_Opto(experiment, experiment.PL-3+ii, ExtractModeArray, downsampling_factor, save_data);
% %     
% %     signalMUAPFC1 = ZeroPhaseFilter(signalPL(1,BaselineTimePoints(1)*10:BaselineTimePoints(2)*10),32000, parameters.FrequencyBands.MUA);
% %     signalMUAPFC2 = ZeroPhaseFilter(signalPL(1,BaselineTimePoints(3)*10:end),32000, parameters.FrequencyBands.MUA);
% %     signalMUAPFC = horzcat(signalMUAPFC1,signalMUAPFC2);
%     thr = std(signalPL)*parameters.spikeanalysis.spikeDetection.threshold;
%     % detect all spikes in period window
%     [peakLoc, Ampl] = peakfinderOpto(signalPL,thr/2,-thr,-1,false);
%     peakLoc = (peakLoc);
%     spikeData = [peakLoc;Ampl];
%     MUAPFC{ii,:} = spikeData;
% 
% end


% SpikeTimes = {MUAHP MUAPFC};
SpikeTimesHP = {MUAHP};

save_data = 1; 

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_SpikeTimesHP'),'SpikeTimesHP');
end
end