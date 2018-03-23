
clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
animal = [501:539 401:492 551:565 1001:1015 571:584]; % see previous script

%% load stuff

for n=1:length(animal)
    experiment = experiments(animal(n));
    CSC1=experiment.PL(1);
    CSC2=experiment.HPreversal;
    load(strcat(path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name, filesep,'CSC', num2str(CSC1),'.mat'))
    load(strcat(path.output,filesep,'results',filesep,'baselinePower',filesep,experiment.name, filesep, 'CSC', num2str(CSC1),'.mat'))
    duration(n)=OscAmplDurOcc.baseline.meanDurOsc(1,1);
    amplitude(n)=OscAmplDurOcc.baseline.meanAmplOsc_max(1,1);
    number(n)=length(OscAmplDurOcc.baseline.OscTimes);
    theta_sup(n)=baselinePower.baseline.thetaOsc;
    beta_sup(n)=baselinePower.baseline.betaOsc;
    gamma_sup(n)=baselinePower.baseline.gammaOsc;
    notheta_sup(n)=baselinePower.baseline.thetaNonOsc;
    nobeta_sup(n)=baselinePower.baseline.betaNonOsc;
    nogamma_sup(n)=baselinePower.baseline.gammaNonOsc;
    frequencies(n,:)=baselinePower.baseline.fWelchOsc;
    powerOsc(n,:)=baselinePower.baseline.pxxWelchOsc;
    powerNonOsc(n,:)=baselinePower.baseline.pxxWelchNonOsc;
end

% maybe do a bar plot of the different paramenters (e.g. amplitude, occurrence, mean power in theta, beta etc.)? and a power plot?


