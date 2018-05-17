% same old stuff

clear all

path = get_path;
experiments = get_experiment_list;
animal = 101 : 142;

%% load stuff for PFC

X = log10(linspace(20, 40, 161));

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = experiment.Cg(1);
    if strcmp(experiment.Exp_type, 'AWA')
        repetitions = 1;
    else
        repetitions = 1 : 3;
    end
    for period = repetitions
        canale = 0;
        for channel = str2num(experiment.PL)
            canale = canale+1;
            load(strcat(path.output,filesep,'results\MUAfiringrate\',experiment.name,filesep,'MUAfiringrate15',num2str(channel),num2str(period),'.mat'))
            try
                load(strcat(path.output,filesep,'results\PPC_Spectrum\',experiment.name,filesep,'PPC_Spectrum15',num2str(channel),num2str(period),'.mat'))
                if isnan(PPC_Spectrum)
                    PPC(canale, :) = nan(1, 50);
                else
                    PPC(canale, :) = PPC_Spectrum;
                end
            catch
                PPC(canale, :) = nan(1, 50);
            end 
            MUA(canale, :) = MUAfiringrate;
            clear PPC_Spectrum
        end
        if strcmp(experiment.Exp_type,'AWA')
                FR(period, (n+1)/2) = nanmedian(MUA);
                PPC_awa = nanmean(PPC, 1);
        elseif strcmp(experiment.Exp_type,'URE') %&& period==1
                FR(period+1, n/2) = nanmedian(MUA);
                PPC_ure = nanmean(PPC, 1);
        end
        
        load(strcat(path.output,filesep,'results\baselinePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        thetaOsc(period, n) = baselinePower.baseline.thetaOsc;
        betaOsc(period, n) = baselinePower.baseline.betaOsc;
        gammaOsc(period, n) = baselinePower.baseline.gammaOsc;
        theta(period, n) = baselinePower.baseline.thetaFull;
        beta(period, n) = baselinePower.baseline.betaFull;
        gamma(period, n) = baselinePower.baseline.gammaFull;

        load(strcat(path.output,filesep,'results\baselineSlowPower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        rrOsc(period, n) = baselineSlowPower.baseline.betaOsc;
        rr(period, n) = baselineSlowPower.baseline.betaFull;
       
        if strcmp(experiment.Exp_type,'AWA')
            PPC_Spec((n + 1) / 2, period, :) = PPC_awa;
        else
            PPC_Spec(n / 2, period + 1, :) = PPC_ure;
        end
        
        load(strcat(path.output,filesep,'results\MinutePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        if size(pWelch,1) < 15
            pWelch(size(pWelch, 1):15, :) = NaN;
        end
        
        one_over_f = zeros(size(pWelch, 1), 2);
        Y = log10(nanmedian(pWelch(:, 160:320)));
        for minuto = 1 : size(pWelch, 1)
            Y = log10((pWelch(minuto, 160:320)));
            try
                one_over_f(minuto, :) = robustfit(X(:), Y(:));
            catch
                one_over_f(minuto, :) = NaN;
            end
        end
        one_over_f(:, 1) = [];
        if strcmp(experiment.Exp_type,'AWA')
            slope((n + 1) / 2, period, :) = nanmedian(one_over_f);
        else
            slope(n / 2, period + 1, :) = nanmedian(one_over_f);
        end

        try
            load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        catch
            signal(1, 1: 15) = NaN;
        end
        if size(signal, 2) < 15
            signal(1, size(signal, 2) : 15) = NaN;
        end
        if strcmp(experiment.Exp_type,'AWA')
            MinuteOsc(15*(period-1)+1:15*period,(n+1)/2)=signal;
        else
            MinuteOsc(15*(period)+1:15*(period+1),n/2)=signal;
        end
        
        load(strcat(path.output,filesep,'results\BaselineCoherence\',experiment.name,filesep,'15',num2str(experiment.Cg),num2str(period),'.mat'))
        if strcmp(experiment.Exp_type,'AWA')
            Coherence(:,period,(n+1)/2)=ImCoh.Coh;
        else
            Coherence(:,period+1,n/2)=ImCoh.Coh;
        end
        
        if period == 1
            load(strcat(path.output,filesep,'results\InfoTheory\',experiment.name,filesep,'15',num2str(CSC),num2str(period),'.mat'))
            SampleEntPFC(n, :) = nanmedian(InfoTheory.SampEnt1);
            SampleEntHP(n, :) = nanmedian(InfoTheory.SampEnt2);
        end
    end
end

clear baselinePower baselineSlowPower canale channel CSC experiment ImCoh InfoTheory minutePower MUA MUAfiringrate n...
    period PPC pWelch repetitions signal PPC_awa PPC_ure

%% reshape variables

rr = reshape(rr, size(rr, 1) * 2, size(rr, 2) / 2); rr(2 : 3, :) = [];
theta = reshape(theta, size(theta, 1) * 2, size(theta, 2) / 2); theta(2 : 3, :) = [];
beta = reshape(beta, size(beta, 1) * 2, size(beta, 2) / 2); beta(2 : 3, :) = [];
gamma = reshape(gamma, size(gamma, 1) * 2, size(gamma, 2) / 2); gamma(2 : 3, :) = [];
rrOsc = reshape(rrOsc, size(rrOsc, 1) * 2, size(rrOsc, 2) / 2); rrOsc(2 : 3, :) = [];
thetaOsc = reshape(thetaOsc, size(thetaOsc, 1) * 2, size(thetaOsc, 2) / 2); thetaOsc(2 : 3,:) = [];
betaOsc = reshape(betaOsc, size(betaOsc, 1) * 2,size(betaOsc, 2) / 2); betaOsc(2 : 3, :) = [];
gammaOsc = reshape(gammaOsc, size(gammaOsc, 1) * 2, size(gammaOsc, 2) / 2); gammaOsc(2 : 3, :) = [];

%% firing rate

oscillations = squeeze(nanmean(reshape(MinuteOsc, 15, size(FR, 1), size(MinuteOsc, 2))));

FR = FR ./ (60 * 15);
normFR = log10(FR ./ oscillations); FR = log10(FR);
FR(isinf(FR)) = NaN; normFR(isinf(normFR)) = NaN;

clear MinuteOsc

%% PPC

PPC_RR = cat(1, PPC_Spec(:, 1, 2), PPC_Spec(:, 3, 2));
PPC_theta = cat(1, nanmedian(PPC_Spec(:, 1, 3 : 5), 3), nanmedian(PPC_Spec(:, 3, 3 : 5), 3));
PPC_beta = cat(1, nanmedian(PPC_Spec(:, 1, 6 : 15), 3), nanmedian(PPC_Spec(:, 3, 6 : 15), 3));
PPC_gamma = cat(1, nanmedian(PPC_Spec(:, 1, 16 : 50), 3), nanmedian(PPC_Spec(:, 3, 16 : 50), 3));

% PPC_RR = (PPC_Spec(:, 3, 2) - PPC_Spec(:, 1, 2)) ./  (PPC_Spec(:, 3, 2) + PPC_Spec(:, 1, 2));
% PPC_theta = (nanmedian(PPC_Spec(:, 3, 3 : 5), 3) - nanmedian(PPC_Spec(:, 1, 3 : 5), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 3 : 5), 3) + nanmedian(PPC_Spec(:, 1, 3 : 5), 3));
% PPC_beta = (nanmedian(PPC_Spec(:, 3, 6 : 15), 3) - nanmedian(PPC_Spec(:, 1, 6 : 15), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 6 : 15), 3) + nanmedian(PPC_Spec(:, 1, 6 : 15), 3));
% PPC_gamma = (nanmedian(PPC_Spec(:, 3, 16 : 50), 3) - nanmedian(PPC_Spec(:, 1, 16 : 50), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 16 : 50), 3) + nanmedian(PPC_Spec(:, 1, 16 : 50), 3));

clear PPC_Spec

%% power

power_rr = cat(1, rr(1, :), rr(2, :));
power_rrOsc = cat(1, rrOsc(1, :), rrOsc(2, :));
power_theta = cat(1, theta(1, :), theta(2, :));
power_thetaOsc = cat(1, thetaOsc(1, :), thetaOsc(2, :));
power_beta = cat(1, beta(1, :), beta(2, :));
power_betaOsc = cat(1, betaOsc(1, :), betaOsc(2, :));
power_gamma = cat(1, gamma(1, :), gamma(2, :));
power_gammaOsc = cat(1, gammaOsc(1, :), gammaOsc(2, :));


% power_rr = rr(2, :) - rr(1, :)) ./ (rr(1, :) + rr(2, :));
% power_rrOsc = (rrOsc(2, :) - rrOsc(1, :)) ./ (rrOsc(1, :) + rrOsc(2, :));
% power_theta = (theta(2, :) - theta(1, :)) ./ (theta(1, :) + theta(2, :));
% power_thetaOsc = (thetaOsc(1, :) - thetaOsc(2, :)) ./ (thetaOsc(1, :) + thetaOsc(2, :));
% power_beta = (beta(2, :) - beta(1, :)) ./ (beta(1, :) + beta(2, :));
% power_betaOsc = (betaOsc(2, :) - betaOsc(1, :)) ./ (betaOsc(1, :) + betaOsc(2, :));
% power_gamma = (gamma(2, :) - gamma(1, :)) ./ (gamma(1, :) + gamma(2, :));
% power_gammaOsc = (gammaOsc(2, :) - gammaOsc(1, :)) ./ (gammaOsc(1, :) + gammaOsc(2, :));

clear rr rrOsc theta thetaOsc beta betaOsc gamma gammaOsc

%% coherence

Coh_RR = cat(1, squeeze(nanmedian(Coherence(22 : 62, 1, :))), squeeze(nanmedian(Coherence(22 : 62, 2, :))));
Coh_theta = cat(1, squeeze(nanmedian(Coherence(63 : 224, 1, :))), squeeze(nanmedian(Coherence(63 : 224, 2, :))));
Coh_beta = cat(1, squeeze(nanmedian(Coherence(225 : 587, 1, :))), squeeze(nanmedian(Coherence(225 : 587, 2, :))));
Coh_gamma = cat(1, squeeze(nanmedian(Coherence(588 : end, 1, :))), squeeze(nanmedian(Coherence(588 : end, 2, :))));

% Coh_RR = (squeeze(nanmedian(Coherence(22 : 62, 2, :))) - squeeze(nanmedian(Coherence(22 : 62, 1, :)))) ./ ...
%     (squeeze(nanmedian(Coherence(22 : 62, 2, :))) + squeeze(nanmedian(Coherence(22 : 62, 1, :))));
% Coh_theta = (squeeze(nanmedian(Coherence(63 : 224, 2, :))) - squeeze(nanmedian(Coherence(63 : 224, 1, :)))) ./ ...
%     (squeeze(nanmedian(Coherence(63 : 224, 2, :))) + squeeze(nanmedian(Coherence(63 : 224, 1, :))));
% Coh_beta = (squeeze(nanmedian(Coherence(225 : 587, 2, :))) - squeeze(nanmedian(Coherence(225 : 587, 1, :)))) ./ ...
%     (squeeze(nanmedian(Coherence(225 : 587, 2, :))) + squeeze(nanmedian(Coherence(225 : 587, 1, :))));
% Coh_gamma = (squeeze(nanmedian(Coherence(588 : end, 2, :))) - squeeze(nanmedian(Coherence(588 : end, 1, :)))) ./ ...
%     (squeeze(nanmedian(Coherence(588 : end, 2, :))) + squeeze(nanmedian(Coherence(588 : end, 1, :))));

clear Coherence

%% entropy

Entropy1_rr = cat(1, SampleEntPFC(1 : 2 : end, 1), SampleEntPFC(2 : 2 : end, 1));
Entropy1_theta = cat(1, nanmedian(SampleEntPFC(1 : 2 : end, 2 : 6), 2), nanmedian(SampleEntPFC(2 : 2 : end, 2 : 6), 2));
Entropy1_beta = cat(1, nanmedian(SampleEntPFC(1 : 2 : end, 7 : 15), 2), nanmedian(SampleEntPFC(2 : 2 : end, 7 : 15), 2));
Entropy1_gamma = cat(1, nanmedian(SampleEntPFC(1 : 2 : end, 16 : end), 2), nanmedian(SampleEntPFC(2 : 2 : end, 16 : end), 2));

Entropy2_rr = cat(1, SampleEntHP(1 : 2 : end, 1), SampleEntHP(2 : 2 : end, 1));
Entropy2_theta = cat(1, nanmedian(SampleEntHP(1 : 2 : end, 2 : 6), 2), nanmedian(SampleEntHP(2 : 2 : end, 2 : 6), 2));
Entropy2_beta = cat(1, nanmedian(SampleEntHP(1 : 2 : end, 7 : 15), 2), nanmedian(SampleEntHP(2 : 2 : end, 7 : 15), 2));
Entropy2_gamma = cat(1, nanmedian(SampleEntHP(1 : 2 : end, 16 : end), 2), nanmedian(SampleEntHP(2 : 2 : end, 16 : end), 2));

% Entropy1_rr = (SampleEntPFC(2 : 2 : end, 1) - SampleEntPFC(1 : 2 : end, 1)) ./ (SampleEntPFC(2 : 2 : end, 1) + SampleEntPFC(1 : 2 : end, 1));
% Entropy1_theta = (nanmedian(SampleEntPFC(2 : 2 : end, 2 : 6), 2) - nanmedian(SampleEntPFC(1 : 2 : end, 2 : 6), 2)) ...
%     ./ (nanmedian(SampleEntPFC(2 : 2 : end, 2 : 6), 2) + nanmedian(SampleEntPFC(1 : 2 : end, 2 : 6), 2));
% Entropy1_beta = (nanmedian(SampleEntPFC(2 : 2 : end, 7 : 15), 2) - nanmedian(SampleEntPFC(1 : 2 : end, 7 : 15), 2)) ...
%     ./ (nanmedian(SampleEntPFC(2 : 2 : end, 7 : 15), 2) + nanmedian(SampleEntPFC(1 : 2 : end, 7 : 15), 2));
% Entropy1_gamma = (nanmedian(SampleEntPFC(2 : 2 : end, 16 : end), 2) - nanmedian(SampleEntPFC(1 : 2 : end, 16 : end), 2)) ...
%     ./ (nanmedian(SampleEntPFC(2 : 2 : end, 16 : end), 2) + nanmedian(SampleEntPFC(1 : 2 : end, 16 : end), 2));
% 
% Entropy2_rr = (SampleEntHP(2 : 2 : end, 1) - SampleEntHP(1 : 2 : end, 1)) ./ (SampleEntHP(2 : 2 : end, 1) + SampleEntHP(1 : 2 : end, 1));
% Entropy2_theta = (nanmedian(SampleEntHP(2 : 2 : end, 2 : 6), 2) - nanmedian(SampleEntHP(1 : 2 : end, 2 : 6), 2)) ...
%     ./ (nanmedian(SampleEntHP(2 : 2 : end, 2 : 6), 2) + nanmedian(SampleEntHP(1 : 2 : end, 2 : 6), 2));
% Entropy2_beta = (nanmedian(SampleEntHP(2 : 2 : end, 7 : 15), 2) - nanmedian(SampleEntHP(1 : 2 : end, 7 : 15), 2)) ...
%     ./ (nanmedian(SampleEntHP(2 : 2 : end, 7 : 15), 2) + nanmedian(SampleEntHP(1 : 2 : end, 7 : 15), 2));
% Entropy2_gamma = (nanmedian(SampleEntHP(2 : 2 : end, 16 : end), 2) - nanmedian(SampleEntHP(1 : 2 : end, 16 : end), 2)) ...
%     ./ (nanmedian(SampleEntHP(2 : 2 : end, 16 : end), 2) + nanmedian(SampleEntHP(1 : 2 : end, 16 : end), 2));

clear SampleEntPFC SampleEntHP

%% load stuff for PFC

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = experiment.IL;
    if strcmp(experiment.Exp_type, 'AWA')
        repetitions = 1;
    else
        repetitions = 1 : 3;
    end
    for period = repetitions
        canale = 0;
        for channel = experiment.nameDead
            canale = canale + 1;
            load(strcat(path.output,filesep,'results\MUAfiringrate\',experiment.name,filesep,'MUAfiringrate15',num2str(channel),num2str(period),'.mat'))
            try
                load(strcat(path.output,filesep,'results\PPC_Spectrum\',experiment.name,filesep,'PPC_Spectrum15',num2str(channel),num2str(period),'.mat'))
                if isnan(PPC_Spectrum)
                    PPC(canale, :) = nan(1, 50);
                else
                    PPC(canale, :) = PPC_Spectrum;
                end
            catch
                PPC(canale, :) = nan(1, 50);
            end 
            MUA(canale, :) = MUAfiringrate;
            clear PPC_Spectrum
        end
        if strcmp(experiment.Exp_type,'AWA')
                FR1(period, (n+1)/2) = nanmedian(MUA);
                PPC_awa = nanmean(PPC, 1);
        elseif strcmp(experiment.Exp_type,'URE') %&& period==1
                FR1(period+1, n/2) = nanmedian(MUA);
                PPC_ure = nanmean(PPC, 1);
        end
        
        load(strcat(path.output,filesep,'results\baselinePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        thetaOsc(period, n) = baselinePower.baseline.thetaOsc;
        betaOsc(period, n) = baselinePower.baseline.betaOsc;
        gammaOsc(period, n) = baselinePower.baseline.gammaOsc;
        theta(period, n) = baselinePower.baseline.thetaFull;
        beta(period, n) = baselinePower.baseline.betaFull;
        gamma(period, n) = baselinePower.baseline.gammaFull;

        load(strcat(path.output,filesep,'results\baselineSlowPower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        rrOsc(period, n) = baselineSlowPower.baseline.betaOsc;
        rr(period, n) = baselineSlowPower.baseline.betaFull;
       
        if strcmp(experiment.Exp_type,'AWA')
            PPC_Spec((n + 1) / 2, period, :) = PPC_awa;
        else
            PPC_Spec(n / 2, period + 1, :) = PPC_ure;
        end
        
        load(strcat(path.output,filesep,'results\MinutePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        if size(pWelch,1) < 15
            pWelch(size(pWelch, 1):15, :) = NaN;
        end
        one_over_f = zeros(size(pWelch, 1), 2);
        Y = log10(nanmedian(pWelch(:, 160:320)));
        for minuto = 1 : size(pWelch, 1)
            Y = log10((pWelch(minuto, 160:320)));
            try
                one_over_f(minuto, :) = robustfit(X(:), Y(:));
            catch
                one_over_f(minuto, :) = NaN;
            end
        end
        one_over_f(:, 1) = [];
        if strcmp(experiment.Exp_type,'AWA')
            slope1((n + 1) / 2, period, :) = nanmedian(one_over_f);
        else
            slope1(n / 2, period + 1, :) = nanmedian(one_over_f);
        end
        
        try
            load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        catch
            signal(1, 1: 15) = NaN;
        end
        if size(signal, 2) < 15
            signal(1, size(signal, 2) : 15) = NaN;
        end
        if strcmp(experiment.Exp_type,'AWA')
            MinuteOsc(15*(period-1)+1:15*period,(n+1)/2)=signal;
        else
            MinuteOsc(15*(period)+1:15*(period+1),n/2)=signal;
        end

    end
end

clear baselinePower baselineSlowPower canale channel CSC experiment experiments ImCoh InfoTheory minutePower MUA MUAfiringrate n path...
    period PPC pWelch repetitions signal PPC_awa PPC_ure

%% reshape variables

rr = reshape(rr, size(rr, 1) * 2, size(rr, 2) / 2); rr(2 : 3, :) = [];
theta = reshape(theta, size(theta, 1) * 2, size(theta, 2) / 2); theta(2 : 3, :) = [];
beta = reshape(beta, size(beta, 1) * 2, size(beta, 2) / 2); beta(2 : 3, :) = [];
gamma = reshape(gamma, size(gamma, 1) * 2, size(gamma, 2) / 2); gamma(2 : 3, :) = [];
rrOsc = reshape(rrOsc, size(rrOsc, 1) * 2, size(rrOsc, 2) / 2); rrOsc(2 : 3, :) = [];
thetaOsc = reshape(thetaOsc, size(thetaOsc, 1) * 2, size(thetaOsc, 2) / 2); thetaOsc(2 : 3,:) = [];
betaOsc = reshape(betaOsc, size(betaOsc, 1) * 2,size(betaOsc, 2) / 2); betaOsc(2 : 3, :) = [];
gammaOsc = reshape(gammaOsc, size(gammaOsc, 1) * 2, size(gammaOsc, 2) / 2); gammaOsc(2 : 3, :) = [];

%% firing rate

oscillations1 = squeeze(nanmean(reshape(MinuteOsc, 15, size(FR1, 1), size(MinuteOsc, 2))));

FR1 = FR1 ./ (60 * 15);
normFR1 = log10(FR1 ./ oscillations1); FR1 = log10(FR1);
FR1(isinf(FR1)) = NaN; normFR1(isinf(normFR1)) = NaN;

clear MinuteOsc

%% PPC

PPC_RR1 = cat(1, PPC_Spec(:, 1, 2), PPC_Spec(:, 3, 2));
PPC_theta1 = cat(1, nanmedian(PPC_Spec(:, 1, 3 : 5), 3), nanmedian(PPC_Spec(:, 3, 3 : 5), 3));
PPC_beta1 = cat(1, nanmedian(PPC_Spec(:, 1, 6 : 15), 3), nanmedian(PPC_Spec(:, 3, 6 : 15), 3));
PPC_gamma1 = cat(1, nanmedian(PPC_Spec(:, 1, 16 : 50), 3), nanmedian(PPC_Spec(:, 3, 16 : 50), 3));

% PPC_RR1 = (PPC_Spec(:, 3, 2) - PPC_Spec(:, 1, 2)) ./  (PPC_Spec(:, 3, 2) + PPC_Spec(:, 1, 2));
% PPC_theta1 = (nanmedian(PPC_Spec(:, 3, 3 : 5), 3) - nanmedian(PPC_Spec(:, 1, 3 : 5), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 3 : 5), 3) + nanmedian(PPC_Spec(:, 1, 3 : 5), 3));
% PPC_beta1 = (nanmedian(PPC_Spec(:, 3, 6 : 15), 3) - nanmedian(PPC_Spec(:, 1, 6 : 15), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 6 : 15), 3) + nanmedian(PPC_Spec(:, 1, 6 : 15), 3));
% PPC_gamma1 = (nanmedian(PPC_Spec(:, 3, 16 : 50), 3) - nanmedian(PPC_Spec(:, 1, 16 : 50), 3)) ./ ...
%     (nanmedian(PPC_Spec(:, 3, 16 : 50), 3) + nanmedian(PPC_Spec(:, 1, 16 : 50), 3));

clear PPC_Spec

%% power

power_rr1 = cat(1, rr(1, :), rr(2, :));
power_rrOsc1 = cat(1, rrOsc(1, :), rrOsc(2, :));
power_theta1 = cat(1, theta(1, :), theta(2, :));
power_thetaOsc1 = cat(1, thetaOsc(1, :), thetaOsc(2, :));
power_beta1 = cat(1, beta(1, :), beta(2, :));
power_betaOsc1 = cat(1, betaOsc(1, :), betaOsc(2, :));
power_gamma1 = cat(1, gamma(1, :), gamma(2, :));
power_gammaOsc1 = cat(1, gammaOsc(1, :), gammaOsc(2, :));

% power_rr1 = (rr(2, :) - rr(1, :)) ./ (rr(1, :) + rr(2, :));
% power_rrOsc1 = (rrOsc(2, :) - rrOsc(1, :)) ./ (rrOsc(1, :) + rrOsc(2, :));
% power_theta1 = (theta(2, :) - theta(1, :)) ./ (theta(1, :) + theta(2, :));
% power_thetaOsc1 = (thetaOsc(1, :) - thetaOsc(2, :)) ./ (thetaOsc(1, :) + thetaOsc(2, :));
% power_beta1 = (beta(2, :) - beta(1, :)) ./ (beta(1, :) + beta(2, :));
% power_betaOsc1 = (betaOsc(2, :) - betaOsc(1, :)) ./ (betaOsc(1, :) + betaOsc(2, :));
% power_gamma1 = (gamma(2, :) - gamma(1, :)) ./ (gamma(1, :) + gamma(2, :));
% power_gammaOsc1 = (gammaOsc(2, :) - gammaOsc(1, :)) ./ (gammaOsc(1, :) + gammaOsc(2, :));

clear rr rrOsc theta thetaOsc beta betaOsc gamma gammaOsc

%% make summary

% one-way

max_animal = length(animal) / 2;
time_freq = 4;

anim = repmat(1:1:max_animal, time_freq, 1);
time = repmat(1:1:time_freq', max_animal, 1)';

summary_one_way = horzcat(anim(:), time(:), FR(:), normFR(:), FR1(:), normFR1(:),oscillations(:), ...
    oscillations1(:), slope(:), slope1(:));
summary_one_way(isnan(summary_one_way)) = 0;

% two-way

anim = repmat(sort(repmat(1:1:max_animal, 1, 2))', 1, time_freq);
frequency = repmat(1 : 2 : time_freq * 2, max_animal * 2, 1);
condition = repmat([1 2]', max_animal, time_freq);

powerPFC = cat(1, power_rr(:), power_theta(:), power_beta(:), power_gamma(:));
powerOscPFC = cat(1, power_rrOsc(:), power_thetaOsc(:), power_betaOsc(:), power_gammaOsc(:));
powerHP = cat(1, power_rr1(:), power_theta1(:), power_beta1(:), power_gamma1(:));
powerOscHP = cat(1, power_rrOsc1(:), power_thetaOsc1(:), power_betaOsc1(:), power_gammaOsc1(:));
Coherence = cat(1, Coh_RR(:), Coh_theta(:), Coh_beta(:), Coh_gamma(:));
ppcPFC = cat(1, PPC_RR(:), PPC_theta(:), PPC_beta(:), PPC_gamma(:));
ppcHP = cat(1, PPC_RR1(:), PPC_theta1(:), PPC_beta1(:), PPC_gamma1(:));
entropyPFC = cat(1, Entropy1_rr(:), Entropy1_theta(:), Entropy1_beta(:), Entropy1_gamma(:));
entropyHP = cat(1, Entropy2_rr(:), Entropy2_theta(:), Entropy2_beta(:), Entropy2_gamma(:));

summary_two_way = horzcat(anim(:), frequency(:), condition(:), powerPFC, powerOscPFC, powerHP, ...
    powerOscHP, Coherence, ppcPFC, entropyPFC, entropyHP);
summary_two_way(isnan(summary_two_way)) = 0;
nan_ppcOB = unique(summary_two_way(isnan(ppcHP), 1));
ppcHP(ismember(summary_two_way(:, 1), nan_ppcOB)) = [];

clearvars -except summary_one_way summary_two_way ppcHP