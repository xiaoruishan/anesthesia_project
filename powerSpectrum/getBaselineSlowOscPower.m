function getBaselineSlowOscPower(time, signal, fs, experiment, CSC, save_data)
Path=get_path;
parameters=get_parameters;
%% load oscTimes, Ampl, Duration and occurence
baselineSlowPower=struct;
parameters.powerSpectrum.windowSize = 3;
parameters.powerSpectrum.nfft = 800;
parameters.powerSpectrum.maxFreq = 8;
        
%% calc power on full signal
    [pxxWelchFull,fWelchFull,pxxcWelchFull]= pWelchSpectrum(signal, ...
        parameters.powerSpectrum.windowSize, ...
        [],...
        parameters.powerSpectrum.nfft,...
        fs,...
        0.95,...
        parameters.powerSpectrum.maxFreq);
        
    baselineSlowPower.(['baseline']).pxxWelchFull=pxxWelchFull;
    baselineSlowPower.(['baseline']).fWelchFull=fWelchFull;
    baselineSlowPower.(['baseline']).pxxcWelchFull=pxxcWelchFull;
    
%% calc power on osc and nonosc using pWelch
    load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
    oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);
    % find nonOscTimes, exclude ones that are too short
    nonOscTimes=[oscTimes(2,1:end-1);oscTimes(1,2:end)];
    nonOscTimes=nonOscTimes(:,find(nonOscTimes(2,:)-nonOscTimes(1,:) > fs*parameters.powerSpectrum.windowSize));
    
    %osc periods
    signalGlued=CutNGlueX(signal,fs,oscTimes(1,:),oscTimes(2,:),parameters.powerSpectrum.windowSize);
    pxxWelchOsc=[];
    fWelchOsc=[];
    pxxcWelchOsc=[];
    if ~isempty(signalGlued.xn)
        [pxxWelchOsc,fWelchOsc,pxxcWelchOsc]= pWelchSpectrum(signalGlued.xn, ...
            parameters.powerSpectrum.windowSize, ...
            parameters.powerSpectrum.overlap,...
            parameters.powerSpectrum.nfft,...
            fs,...
            0.95,...
            parameters.powerSpectrum.maxFreq);
    end
    baselineSlowPower.(['baseline']).pxxWelchOsc=pxxWelchOsc;
    baselineSlowPower.(['baseline']).fWelchOsc=fWelchOsc;
    baselineSlowPower.(['baseline']).pxxcWelchOsc=pxxcWelchOsc;
    
    % non Osc
    signalGlued=CutNGlueX(signal, ...
        fs,...
        nonOscTimes(1,:), ...
        nonOscTimes(2,:), ...
        parameters.powerSpectrum.windowSize);
    pxxWelchNonOsc=[];
    fWelchNonOsc=[];
    pxxcWelchNonOsc=[];
    if ~isempty(signalGlued.xn)
        [pxxWelchNonOsc,fWelchNonOsc,pxxcWelchNonOsc]= pWelchSpectrum(signalGlued.xn, ...
            parameters.powerSpectrum.windowSize, ...
            parameters.powerSpectrum.overlap,...
            parameters.powerSpectrum.nfft,...
            fs,...
            0.95,...
            parameters.powerSpectrum.maxFreq);
    end
    baselineSlowPower.(['baseline']).pxxWelchNonOsc=pxxWelchNonOsc;
    baselineSlowPower.(['baseline']).fWelchNonOsc=fWelchNonOsc;
    baselineSlowPower.(['baseline']).pxxcWelchNonOsc=pxxcWelchNonOsc;

%% compute power for freq ranges

% find frequencies ranges

delta = find(baselineSlowPower.baseline.fWelchOsc > 2 & baselineSlowPower.baseline.fWelchOsc < 4);
slowtheta = find(baselineSlowPower.baseline.fWelchOsc > 4 & baselineSlowPower.baseline.fWelchOsc < 8);

% compute power
delta_powerOsc=mean(baselineSlowPower.baseline.pxxWelchOsc(delta))*2;
slowtheta_powerOsc=mean(baselineSlowPower.baseline.pxxWelchOsc(slowtheta))*4;

if numel(pxxWelchNonOsc)>0
    delta_powerNonOsc=mean(baselineSlowPower.baseline.pxxWelchNonOsc(delta))*2;
    slowtheta_powerNonOsc=mean(baselineSlowPower.baseline.pxxWelchNonOsc(slowtheta))*4;
else
    slowtheta_powerNonOsc=NaN; delta_powerNonOsc=NaN;
end

slowtheta_powerFull=mean(baselineSlowPower.baseline.pxxWelchFull(slowtheta))*4;
delta_powerFull=mean(baselineSlowPower.baseline.pxxWelchFull(delta))*2;

    baselineSlowPower.(['baseline']).thetaFull=slowtheta_powerFull;
    baselineSlowPower.(['baseline']).betaFull=delta_powerFull;
    
    baselineSlowPower.(['baseline']).thetaOsc=slowtheta_powerOsc;
    baselineSlowPower.(['baseline']).betaOsc=delta_powerOsc;
    
    baselineSlowPower.(['baseline']).thetaNonOsc=slowtheta_powerNonOsc;
    baselineSlowPower.(['baseline']).betaNonOsc=delta_powerNonOsc;

%% save data

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'baselineSlowPower',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'baselineSlowPower',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'baselineSlowPower',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'baselineSlowPower')
end