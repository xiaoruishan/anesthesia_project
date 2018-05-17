
clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
% animal = [501:538 601:642 551:568 301:325 571:588];
animal = [501:538 551:568 571:588];
% single_shank=[601:642 301:325];
% animal=[1001:1017];
single_shank=[401:492 1001:1017];

%% load stuff

for n=1:length(animal)
    experiment = experiments(animal(n));
    if ismember(animal(n),single_shank)
        CSC=experiment.PL;
    else
        CSC=19;
    end
        load(strcat(path.output,filesep,'results',filesep,'baselinePower',filesep,experiment.name, filesep, 'CSC', num2str(CSC),'.mat'))
        load(strcat(path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name, filesep,'CSC', num2str(CSC),'.mat'))
%     supPow(n,:)=baselinePower.baseline.pxxWelchOsc;
%     supsilence(n,:)=baselinePower.baseline.pxxWelchNonOsc;
        duration(n)=OscAmplDurOcc.baseline.meanDurOsc(1,1);
        amplitude(n)=OscAmplDurOcc.baseline.meanAmplOsc_max(1,1);
        number(n)=length(OscAmplDurOcc.baseline.OscTimes);
        theta(n)=baselinePower.baseline.thetaFull;
        beta(n)=baselinePower.baseline.betaFull;
        gamma(n)=baselinePower.baseline.gammaFull;
        age(n)=experiment.age;
    %     notheta_sup(n)=baselinePower.baseline.thetaNonOsc;
    %     nobeta_sup(n)=baselinePower.baseline.betaNonOsc;
    %     nogamma_sup(n)=baselinePower.baseline.gammaNonOsc;
    CSC=31;
    load(strcat(path.output,filesep,'results',filesep,'baselinePower',filesep,experiment.name, filesep,'CSC', num2str(CSC),'.mat'))
    load(strcat(path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name, filesep,'CSC', num2str(CSC),'.mat'))
    deep_theta(n)=baselinePower.baseline.thetaFull;
    deep_beta(n)=baselinePower.baseline.betaFull;
    deep_gamma(n)=baselinePower.baseline.gammaFull;
    deep_duration(n)=OscAmplDurOcc.baseline.meanDurOsc(1,1);
    deep_number(n)=length(OscAmplDurOcc.baseline.OscTimes);
    deep_amplitude(n)=OscAmplDurOcc.baseline.meanAmplOsc_max(1,1);
%     deepPow(n,:)=baselinePower.baseline.pxxWelchOsc;
%     deepsilence(n,:)=baselinePower.baseline.pxxWelchNonOsc;
    %     theta_norm(n)=baselinePower.baseline.thetaOsc/baselinePower.baseline.thetaNonOsc;
    %     beta_norm(n)=baselinePower.baseline.betaOsc/baselinePower.baseline.betaNonOsc;
    %     gamma_norm(n)=baselinePower.baseline.gammaOsc/baselinePower.baseline.gammaNonOsc;
    
end
freq=baselinePower.baseline.fWelchFull;
variable=beta_sup;%./nobeta_sup(:,1);
variable1=beta_sup(:,4);

[a,b]=ttest2(variable(1:38),variable([39:52 54:56]))
[a,b]=ttest2(variable(57:end),variable(39:56))
[a,b]=ttest2(variable([1:38]),variable(57:end))

mean(variable(1:38))
mean(variable([39:52 54:56]))
mean(variable(57:end))

betagammawt=sum(supPow(1:38,61:101),2);
betagammage=sum(supPow(39:54,61:101),2);
betagammamicro=mean(supPow(55:end,25:101),2);
[a,b]=ttest2(betagammawt,betagammage)
[a,b]=ttest2(variable([1:38]),variable(57:end))
[a,b]=ttest2(variable([1:38]),variable(57:end))

%%

figure; hold on
boundedline(freq,mean(supPow(1:38,:)),std(supPow(1:38,:))/sqrt(38),'b'); xlim([20 50])
boundedline(freq,mean(supPow([39:52 54:56],:)),std(supPow([39:52 54:56],:))/sqrt(17),'r');
boundedline(freq,mean(supPow(57:end,:)),std(supPow(57:end,:))/sqrt(18),'g');

figure; hold on
boundedline(freq,mean(supPow(1:38,:)./supsilence(1:38,:)),std(supPow(1:38,:)./supsilence(1:38,:))/sqrt(38),'b'); xlim([4 100])
boundedline(freq,mean(supPow([39:52 54:56],:)./supsilence([39:52 54:56],:)),std(supPow([39:52 54:56],:)./supsilence([39:52 54:56],:))/sqrt(17),'r');
boundedline(freq,mean(supPow(57:end,:)./supsilence(57:end,:)),std(supPow(57:end,:)./supsilence(57:end,:))/sqrt(18),'g');

[a,b]=ttest2(mean(deepPow(1:38,41:201)),mean(deepPow([39:52 54:56],41:61)))
[a,b]=ttest2(mean(supPow(1:38,41:61)),mean(supPow(57:end,41:61)))

