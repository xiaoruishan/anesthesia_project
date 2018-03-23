function getOscSpectra(time, signal1, signal2, fs, experiment, CSC, save_data)
Path=get_path;
parameters=get_parameters;

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);

%%
powerPFC = zeros(size(oscTimes,2),3201); powerHP = powerPFC; coherence = powerPFC;
for oscillation = 1:size(oscTimes,2)
    LFP = signal1(oscTimes(1,oscillation) : oscTimes(2,oscillation));
    [powerPFC(oscillation,:),~,~] = pWelchSpectrum(LFP, 1, parameters.powerSpectrum.overlap, ...
            parameters.powerSpectrum.nfft, fs, 0.95, parameters.powerSpectrum.maxFreq);
    LFP2 = signal2(oscTimes(1,oscillation) : oscTimes(2,oscillation));
    [powerHP(oscillation,:),~,~] = pWelchSpectrum(LFP2, 1, parameters.powerSpectrum.overlap, ...
            parameters.powerSpectrum.nfft, fs, 0.95, parameters.powerSpectrum.maxFreq);
    [coherence(oscillation,:),~]=ImCohere(LFP,LFP2,1,parameters.coherence.overlap,parameters.coherence.nfft,fs);
end

OscSpectra = {powerPFC, powerHP, coherence};

%% save data

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'OscSpectra',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'OscSpectra',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'OscSpectra',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'OscSpectra')
end