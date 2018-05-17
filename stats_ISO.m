%% same old scripts

clear all
path = get_path;
experiments = get_experiment_list;
animal = 201 : 217;

%% load PFC stuff

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = experiment.PL(1);
    repetitions = 1 : 4;
    
    for period = repetitions
        canale = 0;
        for channel = 17:20
            canale = canale+1;
            load(strcat(path.output,filesep,'results\MUAfiringrate\',experiment.name,filesep,'MUAfiringrate15',num2str(channel),num2str(period),'.mat'))
            MUA(canale, :) = MUAfiringrate;
        end
        FR(period, n) = nanmean(MUA);
        load(strcat(path.output,filesep,'results\baselinePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        try
            thetaOsc(period, n) = baselinePower.baseline.thetaOsc;
            betaOsc(period, n) = baselinePower.baseline.betaOsc;
            gammaOsc(period, n) = baselinePower.baseline.gammaOsc;
        catch
            thetaOsc(period, n) = NaN;
            betaOsc(period, n) = NaN;
            gammaOsc(period, n) = NaN;
        end
        theta(period, n) = baselinePower.baseline.thetaFull;
        beta(period, n) = baselinePower.baseline.betaFull;
        gamma(period, n) = baselinePower.baseline.gammaFull;
        load(strcat(path.output,filesep,'results\baselineSlowPower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        rrOsc(period, n) = baselineSlowPower.baseline.betaOsc;
        rr(period, n) = baselineSlowPower.baseline.betaFull;
        try
            load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        catch
            signal(1, 1: 15) = NaN;
        end
        if size(signal, 2) < 15
            signal(1, size(signal, 2) : 15) = NaN;
        end
        MinuteOsc(15 * (period - 1) + 1 : 15 * period,n) = signal;
    end
end

%% adjust oscillations and FR variables

oscillations = squeeze(median(reshape(MinuteOsc, 15, [], size(MinuteOsc, 2))));
Osc15min = squeeze(mean(reshape(MinuteOsc, 15, size(FR, 1), size(MinuteOsc, 2))));
FR = FR ./ (60 * 15);
normFR = log10(FR ./ Osc15min); FR = log10(FR);
FR(isinf(FR)) = NaN; normFR(isinf(normFR)) = NaN;

%% power 

power_rr = cat(1, rr(1, :), rr(2, :));
power_rrOsc = cat(1, rrOsc(1, :), rrOsc(2, :));
power_theta = cat(1, theta(1, :), theta(2, :));
power_thetaOsc = cat(1, thetaOsc(1, :), thetaOsc(2, :));
power_beta = cat(1, beta(1, :), beta(2, :));
power_betaOsc = cat(1, betaOsc(1, :), betaOsc(2, :));
power_gamma = cat(1, gamma(1, :), gamma(2, :));
power_gammaOsc = cat(1, gammaOsc(1, :), gammaOsc(2, :));


%% load stuff HP

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = experiment.HPreversal(1);
    repetitions = 1 : 4;
    
    for period = repetitions
        canale = 0;
        for channel = experiment.HPreversal - 1 : experiment.HPreversal + 1
            canale = canale+1;
            load(strcat(path.output,filesep,'results\MUAfiringrate\',experiment.name,filesep,'MUAfiringrate15',num2str(channel),num2str(period),'.mat'))
            MUA(canale, :) = MUAfiringrate;
        end
        FR1(period, n) = nanmean(MUA);
        load(strcat(path.output,filesep,'results\baselinePower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        try
            thetaOsc(period, n) = baselinePower.baseline.thetaOsc;
            betaOsc(period, n) = baselinePower.baseline.betaOsc;
            gammaOsc(period, n) = baselinePower.baseline.gammaOsc;
        catch
            thetaOsc(period, n) = NaN;
            betaOsc(period, n) = NaN;
            gammaOsc(period, n) = NaN;
        end
        theta(period, n) = baselinePower.baseline.thetaFull;
        beta(period, n) = baselinePower.baseline.betaFull;
        gamma(period, n) = baselinePower.baseline.gammaFull;
        load(strcat(path.output,filesep,'results\baselineSlowPower\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        rrOsc(period, n) = baselineSlowPower.baseline.betaOsc;
        rr(period, n) = baselineSlowPower.baseline.betaFull;
        try
            load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        catch
            signal(1, 1: 15) = NaN;
        end
        if size(signal, 2) < 15
            signal(1, size(signal, 2) : 15) = NaN;
        end
        MinuteOsc(15 * (period - 1) + 1 : 15 * period,n) = signal;
    end
end



%% adjust oscillations and FR variables

oscillations1 = squeeze(median(reshape(MinuteOsc, 15, [], size(MinuteOsc, 2))));
Osc15min = squeeze(mean(reshape(MinuteOsc, 15, size(FR1, 1), size(MinuteOsc, 2))));
FR1 = FR1 ./ (60 * 15);
normFR1 = log10(FR1 ./ Osc15min); FR1 = log10(FR1);
FR1(isinf(FR1)) = NaN; normFR1(isinf(normFR1)) = NaN;

%% power 

power_rr1 = cat(1, rr(1, :), rr(2, :));
power_rrOsc1 = cat(1, rrOsc(1, :), rrOsc(2, :));
power_theta1 = cat(1, theta(1, :), theta(2, :));
power_thetaOsc1 = cat(1, thetaOsc(1, :), thetaOsc(2, :));
power_beta1 = cat(1, beta(1, :), beta(2, :));
power_betaOsc1 = cat(1, betaOsc(1, :), betaOsc(2, :));
power_gamma1 = cat(1, gamma(1, :), gamma(2, :));
power_gammaOsc1 = cat(1, gammaOsc(1, :), gammaOsc(2, :));

%% make summary

% one-way

max_animal = length(animal);
time_freq = 4;

anim = repmat(1:1:max_animal, time_freq, 1);
time = repmat(1:1:time_freq', max_animal, 1)';

summary_one_way = horzcat(anim(:), time(:), FR(:), normFR(:), FR1(:), normFR1(:), oscillations(:), oscillations1(:));
summary_one_way(isnan(summary_one_way)) = 0;

% two-way

anim = repmat(sort(repmat(1:1:max_animal, 1, 2))', 1, time_freq);
frequency = repmat(1 : 2 : time_freq * 2, max_animal * 2, 1);
condition = repmat([1 2]', max_animal, time_freq);

powerPFC = cat(1, power_rr(:), power_theta(:), power_beta(:), power_gamma(:));
powerOscPFC = cat(1, power_rrOsc(:), power_thetaOsc(:), power_betaOsc(:), power_gammaOsc(:));
powerHP = cat(1, power_rr1(:), power_theta1(:), power_beta1(:), power_gamma1(:));
powerOscHP = cat(1, power_rrOsc1(:), power_thetaOsc1(:), power_betaOsc1(:), power_gammaOsc1(:));

summary_two_way = horzcat(anim(:), frequency(:), condition(:), powerPFC, powerOscPFC, ...
    powerHP, powerOscHP);
summary_two_way(isnan(summary_two_way)) = 0;


clearvars -except summary_one_way summary_two_way