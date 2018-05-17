%% stuff that is over time or over frequency 

max_animal = length(animal) / 2;
time_freq = 4;

anim = repmat(1:1:max_animal, time_freq, 1);
time = repmat(1:1:time_freq', max_animal, 1)';

powerPFC = cat(1, power_rr(:), power_theta(:), power_beta(:), power_gamma(:));
powerOscPFC = cat(1, power_rrOsc(:), power_thetaOsc(:), power_betaOsc(:), power_gammaOsc(:));
powerHP = cat(1, power_rr1(:), power_theta1(:), power_beta1(:), power_gamma1(:));
powerOscHP = cat(1, power_rrOsc1(:), power_thetaOsc1(:), power_betaOsc1(:), power_gammaOsc1(:));
ppcPFC = cat(1, PPC_RR(:), PPC_theta(:), PPC_beta(:), PPC_gamma(:));
ppcHP = cat(1, PPC_RR1(:), PPC_theta1(:), PPC_beta1(:), PPC_gamma1(:));
entropyPFC = cat(1, Entropy1_rr(:), Entropy1_theta(:), Entropy1_beta(:), Entropy1_gamma(:));
entropyHP = cat(1, Entropy2_rr(:), Entropy2_theta(:), Entropy2_beta(:), Entropy2_gamma(:));


summary_forR = horzcat(anim(:), freq(:), FR(:), FR1(:), oscillations(:), oscillations1(:), ...
    powerPFC, powerOscPFC, powerHP, powerOscHP, ppcPFC, entropyPFC, entropyHP);
