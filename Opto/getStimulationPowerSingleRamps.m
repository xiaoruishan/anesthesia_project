function [StimulationPowerSingleRamps]=getStimulationPowerSingleRamps(stimStructure,experiment,save_data,repeatCalc)
Path = get_path;
parameters=get_parameters;
savename = ['CSC' num2str(stimStructure.CSC) '_' stimStructure.stimulusType];

if repeatCalc == 0 && exist(strcat(Path.output,filesep,'results',filesep,'StimulationPowerSingleRamps',filesep,experiment.name,filesep,savename,'.mat'))
    load(strcat(Path.output,filesep,'results',filesep,'StimulationPowerSingleRamps',filesep,experiment.name,filesep,savename))
else
                                        disp(['Calculating LFP Power for Animal: ' experiment.name ', ' savename])


%% get parameters
segmentLength = parameters.powerSpectrum.windowSize*stimStructure.samplingrate;
%find stim start
firstZero = find(stimStructure.time>0); %find all upward going zeros
t_start = firstZero(1);


%% append each period to each other
for ss = 1:size(stimStructure.signal,1);
    signalX = stimStructure.signal(ss,:);
    [StimFirstHalf(ss,:),~,~]=pWelchSpectrum(signalX(t_start:t_start+segmentLength-1),segmentLength/stimStructure.samplingrate,parameters.powerSpectrum.overlap,parameters.powerSpectrum.nfft,stimStructure.samplingrate,0.95,parameters.powerSpectrum.maxFreq);
    [StimLastHalf(ss,:),~,~]=pWelchSpectrum(signalX(t_start+segmentLength:t_start+segmentLength*2-1),segmentLength/stimStructure.samplingrate,parameters.powerSpectrum.overlap,parameters.powerSpectrum.nfft,stimStructure.samplingrate,0.95,parameters.powerSpectrum.maxFreq);
    [Stim(ss,:),~,~]=pWelchSpectrum(signalX(t_start:t_start+segmentLength*2-1),segmentLength/stimStructure.samplingrate,parameters.powerSpectrum.overlap,parameters.powerSpectrum.nfft,stimStructure.samplingrate,0.95,parameters.powerSpectrum.maxFreq);
    [preStim(ss,:),~,~]=pWelchSpectrum(signalX(t_start-segmentLength*1:t_start-1),segmentLength/stimStructure.samplingrate,parameters.powerSpectrum.overlap,parameters.powerSpectrum.nfft,stimStructure.samplingrate,0.95,parameters.powerSpectrum.maxFreq);
end

StimulationPowerSingleRamps=[];
StimulationPowerSingleRamps=setfield(StimulationPowerSingleRamps,'StimFirstHalf',StimFirstHalf);
StimulationPowerSingleRamps=setfield(StimulationPowerSingleRamps,'StimLastHalf',StimLastHalf);
StimulationPowerSingleRamps=setfield(StimulationPowerSingleRamps,'Stim',Stim);
StimulationPowerSingleRamps=setfield(StimulationPowerSingleRamps,'preStim',preStim);

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1

    if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationPowerSingleRamps',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'StimulationPowerSingleRamps',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'StimulationPowerSingleRamps',filesep,experiment.name,filesep,savename),'StimulationPowerSingleRamps');
end
end
end