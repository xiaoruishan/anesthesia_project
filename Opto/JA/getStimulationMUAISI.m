function [ISIPre,ISIStim,ISIPost,ISIrawData]=getStimulationMUAISI(experiment, CSC, stimulusType,Frequency)
% Calculate InterStimulusInterval (ISI) for stimulation periods
parameters = get_parameters;
Path = get_path;

%get filename
if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
    loadname = ['CSC' num2str(CSC) '_' stimulusType{1} num2str(Frequency)];
elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
    loadname = ['CSC' num2str(CSC) '_' stimulusType{1}];
end

% load MUA spikeTimes
load(strcat(Path.output, 'results', filesep, 'StimulationMUAspikeTimes', filesep, experiment.name, filesep, loadname))

% create empty vectors
ISIPreX = [];
ISIStimX = [];
ISIPostX = [];

% loop through each stimulationloop and calculate ISI
for PP=1:size(fieldnames(spikeTimeData),1)
    % pre stim ISI
    spikes=spikeTimeData.(['P' num2str(PP)])(1,:);
    spikes=spikes(spikes<2.99 | spikes>3.01);
    spikeTimePre = spikes(find(spikes<parameters.(['Window_' stimulusType{1}])(2)));
    ISIPreX = [ISIPreX diff(spikeTimePre)];
    % stim ISI
    spikeTimeStim = spikes(find(spikes>=parameters.(['Window_' stimulusType{1}])(2) & spikes < parameters.(['Window_' stimulusType{1}])(3)));
    ISIStimX = [ISIStimX diff(spikeTimeStim)];
    % post stim ISI
    spikeTimePost = spikes(find(spikes>=parameters.(['Window_' stimulusType{1}])(3)));
    ISIPostX = [ISIPostX diff(spikeTimePost)];
    clearvars spikeTimeStim spikeTimePre spikeTimePost
end
ISIPre = histc(ISIPreX,[0:parameters.spikeanalysis.ISI.binsize:1])./(size(fieldnames(spikeTimeData),1)*parameters.(['Window_' stimulusType{1}])(3)-parameters.(['Window_' stimulusType{1}])(2));
ISIStim = histc(ISIStimX,[0:parameters.spikeanalysis.ISI.binsize:1])./(size(fieldnames(spikeTimeData),1)*parameters.(['Window_' stimulusType{1}])(3)-parameters.(['Window_' stimulusType{1}])(2));
ISIPost = histc(ISIPostX,[0:parameters.spikeanalysis.ISI.binsize:1])./(size(fieldnames(spikeTimeData),1)*parameters.(['Window_' stimulusType{1}])(3)-parameters.(['Window_' stimulusType{1}])(2));

% count n_spikes
ISIrawData.preStim = ISIPreX;
ISIrawData.Stim = ISIStimX;
ISIrawData.postStim = ISIPostX;
end