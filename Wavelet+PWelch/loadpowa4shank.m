

clear all

path = get_path;
experiments = get_experiment_list;
animals = [501:537 551:566];

for n=1:length(animals)
    experiment = experiments(animals(n));
    for CSC=17:32
%                         load(strcat(path.output, 'results', filesep, 'baselinePower', filesep, experiment.name, filesep, 'CSC', num2str(CSC)));
        load(strcat(path.output, 'results', filesep, 'Coherence', filesep, experiment.name, filesep, 'CSC17', num2str(CSC)));
        coherencefull(:,CSC-16,n) = ImCoherence.coherence;
%         coherencepre(:,CSC-16,n) = ImCoherence.coherencepre;
%         coherencepost(:,CSC-16,n) = ImCoherence.coherencepost;
        %                 BetaPowa(n,CSC-16) = baselinePower.baseline.betaFull;
        %                 ThetaPowa(n,CSC-16) = baselinePower.baseline.thetaFull;
        %                 GammaPowa(n,CSC-16) = baselinePower.baseline.gammaFull;
        load(strcat(path.output, 'results', filesep, 'Coherence', filesep, experiment.name, filesep, 'CSC29', num2str(CSC)));
        coherencefull1(:,CSC-16,n) = ImCoherence.coherence;
%         coherencepre1(:,CSC-16,n) = ImCoherence.coherencepre;
%         coherencepost1(:,CSC-16,n) = ImCoherence.coherencepost;
        %                 welchfull(:,CSC-16,n) = baselinePower.baseline.pxxWelchFull;
        %                 welchosc(:,CSC-16,n) = baselinePower.baseline.pxxWelchOsc;
    end
end

%% coherence

freq = ImCoherence.freq;
beta = 311:769;
betacoh = mean(squeeze(mean(coherence((beta),:,1:37))),2);
cohbeta = reshape(betacoh,4,4);
gebetacoh = mean(squeeze(mean(coherence((beta),:,38:end))),2);
gecohbeta = reshape(gebetacoh,4,4);
figure
imagesc(cohbeta./gecohbeta)


%% plot color coded values

BetaAv = nanmean(BetaPowa(1:37,:));
BetaAv = reshape(BetaAv,4,4);
GeBetaAv = nanmean(BetaPowa(38:end,:));
GeBetaAv = reshape(GeBetaAv,4,4);
figure; imagesc(BetaAv./GeBetaAv);

ThetaAv = nanmean(ThetaPowa(1:37,:));
ThetaAv = reshape(ThetaAv,4,4);
GeThetaAv = nanmean(ThetaPowa(38:end,:));
GeThetaAv = reshape(GeThetaAv,4,4);
figure; imagesc(ThetaAv./GeThetaAv);

GammaAv = nanmean(GammaPowa(1:37,:));
GammaAv = reshape(GammaAv,4,4);
GeGammaAv = nanmean(GammaPowa(38:end,:));
GeGammaAv = reshape(GeGammaAv,4,4);
figure; imagesc(GammaAv./GeGammaAv);


mean_welch1 = mean(welch(:,1:4,1:37),3)';
mean_welch2 = mean(welch(:,5:8,1:37),3)';
mean_welch3 = mean(welch(:,9:12,1:37),3)';
mean_welch4 = mean(welch(:,13:16,1:37),3)';

gemean_welch1 = mean(welch(:,1:4,38:end),3)';
gemean_welch2 = mean(welch(:,5:8,38:end),3)';
gemean_welch3 = mean(welch(:,9:12,38:end),3)';
gemean_welch4 = mean(welch(:,13:16,38:end),3)';
