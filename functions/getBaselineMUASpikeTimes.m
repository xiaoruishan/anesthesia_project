function [MUAspikeTimes]=getBaselineMUASpikeTimes(baselineStructure,experiment,CSC,save_data,repeatCalc)
%% calc oscTimes,Ampl,Duration, and occurence
Path = get_path;
parameters=get_parameters;
if repeatCalc == 0 && exist(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name,filesep,['CSC' num2str(CSC)],'.mat'))
    load(strcat(Path.output, 'results', filesep, 'BaselineMUAspikeTimes', filesep, experiment.name, filesep,['CSC' num2str(CSC)]))
else
    disp(['Calculating MUA spike times for Animal: ' experiment.name ', CSC' num2str(CSC)])

        signalMUA = ZeroPhaseFilter(baselineStructure.signal,baselineStructure.samplingrate, parameters.FrequencyBands.MUA);
        thr = std(signalMUA)*parameters.spikeanalysis.spikeDetection.threshold;
        % detect all spikes in period window
        [peakLoc, Ampl] = peakfinderOpto(signalMUA,thr/2,-thr,-1,false);
        peakLoc = (peakLoc/baselineStructure.samplingrate);
        spikeData = [peakLoc;Ampl];
        MUAspikeTimes.baseline=spikeData;
    if save_data == 0
        %     disp('DATA NOT SAVED!');
    elseif save_data==1
        % data structure
        if ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name));
            mkdir(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name));
        end
        save(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'MUAspikeTimes')
    end
end