function [stimulationPower]=getStimulationPower(stimStructure,experiment,save_data,repeatCalc)
Path = get_path;
parameters=get_parameters;
if strcmp(stimStructure.stimulusType, 'square') || strcmp(stimStructure.stimulusType, 'sine')
    savename = ['CSC' num2str(stimStructure.CSC) '_' stimStructure.stimulusType num2str(stimStructure.stimulusFrequency)];
elseif strcmp(stimStructure.stimulusType,'ramp') || strcmp(stimStructure.stimulusType, 'chirp')
    savename = ['CSC' num2str(stimStructure.CSC) '_' stimStructure.stimulusType];
end
if repeatCalc == 0 && exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name,filesep,savename,'.mat'))
    load(strcat(Path.output, 'results', filesep, 'StimulationPower', filesep, experiment.name, filesep, savename))  
else
                                        disp(['Calculating LFP Power for Animal: ' experiment.name ', ' savename])


%% get parameters
segmentLength = parameters.powerSpectrum.windowSize*stimStructure.samplingrate;
%find stim start
firstZero = find(stimStructure.time>0); %find all upward going zeros
t_start = firstZero(1);

%allocate arrays
recording_Stim_pwelch = [];
recording_preStim_pwelch = [];
recording_postStim_pwelch = [];
recording_StimFirstHalf_pwelch = [];
recording_StimLastHalf_pwelch = [];
%% append each period to each other
for ss = 1:size(stimStructure.signal,1);
    signalX = stimStructure.signal(ss,:);
    recording_StimFirstHalf_pwelch = [recording_StimFirstHalf_pwelch signalX(t_start:t_start+segmentLength-1)];
    recording_StimLastHalf_pwelch =  [recording_StimLastHalf_pwelch signalX(t_start+segmentLength:t_start+segmentLength*2-1)];
    recording_Stim_pwelch = [recording_Stim_pwelch signalX(t_start:t_start+segmentLength*2-1)];
    recording_preStim_pwelch = [recording_preStim_pwelch signalX(t_start-segmentLength*1:t_start-1)];
    recording_postStim_pwelch = [recording_postStim_pwelch signalX((t_start+segmentLength*2):t_start+segmentLength*3-1)];
end
segmentLength=segmentLength/stimStructure.samplingrate;
%% pwelch calculaton
[pxx_stimFirstHalf,f_stimFirstHalf, pxxc_stimFirstHalf] = pWelchSpectrum(recording_StimFirstHalf_pwelch,segmentLength, parameters.powerSpectrum.overlap, parameters.powerSpectrum.nfft, stimStructure.samplingrate, 0.95,parameters.powerSpectrum.maxFreq);
[pxx_stimLastHalf,f_stimLastHalf, pxxc_stimLastHalf]  = pWelchSpectrum(recording_StimLastHalf_pwelch, segmentLength, parameters.powerSpectrum.overlap, parameters.powerSpectrum.nfft, stimStructure.samplingrate,0.95,parameters.powerSpectrum.maxFreq);
[pxx_stim,f_stim, pxxc_stim] = pWelchSpectrum(recording_Stim_pwelch, segmentLength, parameters.powerSpectrum.overlap, parameters.powerSpectrum.nfft, stimStructure.samplingrate,0.95,parameters.powerSpectrum.maxFreq);
[pxx_preStim,f_preStim, pxxc_preStim] = pWelchSpectrum(recording_preStim_pwelch, segmentLength, parameters.powerSpectrum.overlap, parameters.powerSpectrum.nfft, stimStructure.samplingrate,0.95,parameters.powerSpectrum.maxFreq);
[pxx_postStim,f_postStim,pxxc_postStim] = pWelchSpectrum(recording_postStim_pwelch, segmentLength, parameters.powerSpectrum.overlap, parameters.powerSpectrum.nfft, stimStructure.samplingrate,0.95,parameters.powerSpectrum.maxFreq);
stimulationPower=[];

stimulationPower = setfield(stimulationPower, 'pxx_stimFirstHalf', pxx_stimFirstHalf);
stimulationPower = setfield(stimulationPower, 'f_stimFirstHalf', f_stimFirstHalf);
stimulationPower = setfield(stimulationPower, 'pxxc_stimFirstHalf', pxxc_stimFirstHalf);
stimulationPower = setfield(stimulationPower, 'pxx_stimLastHalf', pxx_stimLastHalf);
stimulationPower = setfield(stimulationPower, 'f_stimLastHalf', f_stimLastHalf);
stimulationPower = setfield(stimulationPower, 'pxxc_stimLastHalf', pxxc_stimLastHalf);

stimulationPower = setfield(stimulationPower, 'pxx_stim', pxx_stim);
stimulationPower = setfield(stimulationPower, 'f_stim', f_stim);
stimulationPower = setfield(stimulationPower, 'pxxc_stim', pxxc_stim);
stimulationPower = setfield(stimulationPower, 'pxx_preStim', pxx_preStim);
stimulationPower = setfield(stimulationPower, 'pxx_postStim', pxx_postStim);
stimulationPower = setfield(stimulationPower, 'f_preStim', f_preStim);
stimulationPower = setfield(stimulationPower, 'f_postStim', f_postStim);
stimulationPower = setfield(stimulationPower, 'pxxc_preStim', pxxc_preStim);
stimulationPower = setfield(stimulationPower, 'pxxc_postStim', pxxc_postStim);
stimulationPower = setfield(stimulationPower, 'overlap', parameters.powerSpectrum.overlap);

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1

    if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name,filesep,savename),'stimulationPower')
end
end