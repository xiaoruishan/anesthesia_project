
clear all

path=get_path;
parameters=get_parameters;
experiments=get_experiment_list;
experiment=experiments(2013); %2013 516 2018
Frequency=[];
stimStructure=getStimulusSignal(experiment,'CSC24','ramp', Frequency, 1);
spike_signal=[];
for stimulation=1:30
    MUA=ZeroPhaseFilter(stimStructure.signal(stimulation,:),32000,[300 10000]);
    thr = std(MUA)*parameters.spikeanalysis.spikeDetection.threshold;
    [spikes,~] = peakfinderOpto(MUA,thr/2,-thr,-1,false);
    for spike=1:length(spikes)
        signal(spike,:)=MUA(1,spikes(spike)-100:spikes(spike)+100);
    end
    if numel(signal)
        spike_signal=vertcat(spike_signal,signal);
    end
    signal=[];
end
figure; plot(mean(spike_signal))
figure; plot(spike_signal')