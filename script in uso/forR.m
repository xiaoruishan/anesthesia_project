
%% create matrix for animals and frequencies

max_animal = length(DiffEnt1) /2;
max_freq = size(PPC_Spec, 2);

anim = repmat(sort(repmat(1:1:max_animal, 1, 2))', 1, max_freq);
frequency = repmat(1:2:max_freq*2, max_animal*2, 1);
condition = repmat([1 2]', max_animal, max_freq);

%% info theory

anim = reshape(anim, [], 1);
frequency = reshape(frequency, [], 1);
condition = reshape(condition, [], 1);



MutInfoDiff = reshape(MutInfoDiff, [], 1);
% MutInfoKernel = reshape(MutInfoKernel, [], 1);
DiffEnt1 = reshape(DiffEnt1, [], 1);
DiffEnt2 = reshape(DiffEnt2, [], 1);
% RenyiEnt1 = reshape(RenyiEnt1, [], 1);
% RenyiEnt2 = reshape(RenyiEnt2, [], 1);

summary = horzcat(anim, frequency, condition, MutInfoDiff, DiffEnt1, DiffEnt2);

%% ppc & coherence, also repeated measure anova as above
clearvars -except PPC_Spec Coherence

max_animal = size(PPC_Spec, 2) /2;
max_freq = 12;

anim = repmat(sort(repmat(1:1:max_animal, 1, 2))', 1, max_freq);
frequency = repmat(1:2:max_freq*2, max_animal*2, 1);
condition = repmat([1 2]', max_animal, max_freq);

anim = reshape(anim, [], 1);
frequency = reshape(frequency, [], 1);
condition = reshape(condition, [], 1);


ppc = PPC_Spec(2:25, :);
ppc = squeeze(median(reshape(ppc, 2, [], size(ppc, 2))))'; 
ppc1 = reshape(ppc, [], 1);

coherence = Coherence(1:936, :); 
coherence = squeeze(median(reshape(coherence, 78, [], size(Coherence, 2))))';
coherence = reshape(coherence, [], 1);

summary = horzcat(anim, frequency, condition, ppc1, ppc2, coherence);

%% stuff that is over time

max_animal = size(FR1, 2);
max_time = 4;

anim = repmat(1:1:max_animal, max_time, 1);
time = repmat(1:1:max_time', max_animal, 1)';

summary = horzcat(anim(:), time(:), FR1(:), FR2(:), oscillations1(:), oscillations2(:));

%% power

powerPFC = cat(1, rr(:), theta(:), beta(:), gamma(:));
powerOscPFC = cat(1, rrOsc(:), thetaOsc(:), betaOsc(:), gammaOsc(:));
powerHP = cat(1, rr(:), theta(:), beta(:), gamma(:));
powerOscHP = cat(1, rrOsc(:), thetaOsc(:), betaOsc(:), gammaOsc(:));


max_animal = size(rr, 2);
max_freq = 4;
anim = repmat(sort(repmat(1:1:max_animal, 1, 2))', 1, max_freq);
freq = repmat(1:1:max_freq', max_animal*2, 1);
condition = repmat([1 2]', max_animal, max_freq);


summary = horzcat(anim(:), freq(:), condition(:), powerPFC, powerOscPFC, powerHP, powerOscHP);


powerLEC = cat(2, rr(:), rrOsc(:), theta(:), thetaOsc(:), beta(:), betaOsc(:), gamma(:), gammaOsc(:));
powerOB = cat(2, rr(:), rrOsc(:), theta(:), thetaOsc(:), beta(:), betaOsc(:), gamma(:), gammaOsc(:));




