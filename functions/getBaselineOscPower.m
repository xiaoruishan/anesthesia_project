function getBaselineOscPower(time, signal, fs, experiment, CSC, save_data)
Path=get_path;
parameters=get_parameters;
%% load oscTimes, Ampl, Duration and occurence
baselinePower=struct;
        
%% calc power on full signal
    [pxxWelchFull,fWelchFull,pxxcWelchFull]= pWelchSpectrum(signal, ...
        parameters.powerSpectrum.windowSize, ...
        [],...
        parameters.powerSpectrum.nfft,...
        fs,...
        0.95,...
        parameters.powerSpectrum.maxFreq);
        
    baselinePower.(['baseline']).pxxWelchFull=pxxWelchFull;
    baselinePower.(['baseline']).fWelchFull=fWelchFull;
    baselinePower.(['baseline']).pxxcWelchFull=pxxcWelchFull;
    
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
    baselinePower.(['baseline']).pxxWelchOsc=pxxWelchOsc;
    baselinePower.(['baseline']).fWelchOsc=fWelchOsc;
    baselinePower.(['baseline']).pxxcWelchOsc=pxxcWelchOsc;
    
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
    baselinePower.(['baseline']).pxxWelchNonOsc=pxxWelchNonOsc;
    baselinePower.(['baseline']).fWelchNonOsc=fWelchNonOsc;
    baselinePower.(['baseline']).pxxcWelchNonOsc=pxxcWelchNonOsc;

%% compute power for freq ranges

% find frequencies ranges

theta=find(baselinePower.baseline.fWelchOsc > parameters.FrequencyBands.theta(1) & baselinePower.baseline.fWelchOsc < parameters.FrequencyBands.theta(2));
beta=find(baselinePower.baseline.fWelchOsc > parameters.FrequencyBands.beta(1) & baselinePower.baseline.fWelchOsc < parameters.FrequencyBands.beta(2));
gamma=find(baselinePower.baseline.fWelchOsc > parameters.FrequencyBands.gamma(1) & baselinePower.baseline.fWelchOsc < parameters.FrequencyBands.gamma(2));

% compute power
theta_powerOsc=mean(baselinePower.baseline.pxxWelchOsc(theta))*(parameters.FrequencyBands.theta(2)-parameters.FrequencyBands.theta(1));
beta_powerOsc=mean(baselinePower.baseline.pxxWelchOsc(beta))*(parameters.FrequencyBands.beta(2)-parameters.FrequencyBands.beta(1));
gamma_powerOsc=mean(baselinePower.baseline.pxxWelchOsc(gamma))*(parameters.FrequencyBands.gamma(2)-parameters.FrequencyBands.gamma(1));

if numel(pxxWelchNonOsc)>0
    theta_powerNonOsc=mean(baselinePower.baseline.pxxWelchNonOsc(theta))*(parameters.FrequencyBands.theta(2)-parameters.FrequencyBands.theta(1));
    beta_powerNonOsc=mean(baselinePower.baseline.pxxWelchNonOsc(beta))*(parameters.FrequencyBands.beta(2)-parameters.FrequencyBands.beta(1));
    gamma_powerNonOsc=mean(baselinePower.baseline.pxxWelchNonOsc(gamma))*(parameters.FrequencyBands.gamma(2)-parameters.FrequencyBands.gamma(1));
else
    theta_powerNonOsc=NaN; beta_powerNonOsc=NaN; gamma_powerNonOsc=NaN;
end

theta_powerFull=mean(baselinePower.baseline.pxxWelchFull(theta))*(parameters.FrequencyBands.theta(2)-parameters.FrequencyBands.theta(1));
beta_powerFull=mean(baselinePower.baseline.pxxWelchFull(beta))*(parameters.FrequencyBands.beta(2)-parameters.FrequencyBands.beta(1));
gamma_powerFull=mean(baselinePower.baseline.pxxWelchFull(gamma))*(parameters.FrequencyBands.gamma(2)-parameters.FrequencyBands.gamma(1));

    baselinePower.(['baseline']).thetaFull=theta_powerFull;
    baselinePower.(['baseline']).betaFull=beta_powerFull;
    baselinePower.(['baseline']).gammaFull=gamma_powerFull;
    
    baselinePower.(['baseline']).thetaOsc=theta_powerOsc;
    baselinePower.(['baseline']).betaOsc=beta_powerOsc;
    baselinePower.(['baseline']).gammaOsc=gamma_powerOsc;
    
    baselinePower.(['baseline']).thetaNonOsc=theta_powerNonOsc;
    baselinePower.(['baseline']).betaNonOsc=beta_powerNonOsc;
    baselinePower.(['baseline']).gammaNonOsc=gamma_powerNonOsc;

%% save data

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'baselinePower',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'baselinePower',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'baselinePower',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'baselinePower')
end