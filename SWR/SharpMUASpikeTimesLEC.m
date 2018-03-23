function [MUAspikeTimes]=SharpMUASpikeTimesLEC(experiment,baseline)
%% calc oscTimes,Ampl,Duration, and occurence
path = get_path;
parameters=get_parameters;
ExtractModeArray = baseline;
downsampling_factor = 1;
save_data = 0;
channels=experiment.chan_num{1,1};

load(strcat(path.output, 'results', filesep, 'BaselineTimePoints', filesep, experiment.name, filesep, 'BaselineTimePoints'));

for ii = 1:5
    [~, signalHP, ~, ~] = nlx_load_Opto(experiment, channels(2)-3+ii, ExtractModeArray, downsampling_factor, save_data);
    thr = std(signalHP)*parameters.spikeanalysis.spikeDetection.threshold;
    [peakLoc, Ampl] = peakfinderOpto(signalHP,thr/2,-thr,-1,false);
    peakLoc = (peakLoc);
    spikeData = [peakLoc;Ampl];
    MUAHP{ii,:} = spikeData;
    
    clearvars signalMUAHP1 & signalMUAHP2 & signalMUAHP & spikeData & peakLoc & Ampl & signalHP
end

for ii = 1:5
    
    clearvars signalMUAPFC1 & signalMUAPFC2 & signalMUAPFC & spikeData & peakLoc & Ampl & signalPL
    
    [~, signalPL, ~, ~] = nlx_load_Opto(experiment, channels(3)-3+ii, ExtractModeArray, downsampling_factor, save_data);
    thr = std(signalPL)*parameters.spikeanalysis.spikeDetection.threshold;
    [peakLoc, Ampl] = peakfinderOpto(signalPL,thr/2,-thr,-1,false);
    peakLoc = (peakLoc);
    spikeData = [peakLoc;Ampl];
    MUAPFC{ii,:} = spikeData;
    
end

for ii = 1:5
    
    clearvars signalMUAPFC1 & signalMUAPFC2 & signalMUAPFC & spikeData & peakLoc & Ampl & signalPL
    
    [~, signalLEC, ~, ~] = nlx_load_Opto(experiment, channels(1)-3+ii, ExtractModeArray, downsampling_factor, save_data);
    thr = std(signalLEC)*parameters.spikeanalysis.spikeDetection.threshold;
    [peakLoc, Ampl] = peakfinderOpto(signalLEC,thr/2,-thr,-1,false);
    peakLoc = (peakLoc);
    spikeData = [peakLoc;Ampl];
    MUALEC{ii,:} = spikeData;
    
end

SpikeTimes = {MUAHP MUAPFC MUALEC};
save_data = 1;

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_SpikeTimes'),'SpikeTimes');
end
end