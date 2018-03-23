
clearvars -except powerPFC oscPFC powerHP oscHP minutePower MinuteOsc

power = minutePower(:, 1 : 640, :); 
power = squeeze(median(reshape(power, 60, 64, 10, []), 2));

%% 
powerPFC = power(:, :, [1]); powerPFC(16:17, :) = [];
oscPFC = MinuteOsc(:, [1]); oscPFC(16:17, :) = [];

%%
powerHP = power(:, :, [1]); powerHP(16:17, :) = [];
oscHP = MinuteOsc(:, [1]); oscHP(16:17, :) = [];

%% 

depth = cat(1, repmat(4, 15, 1), repmat(1, 13, 1), repmat(2, 15, 1), repmat(3, 15, 1));

mpowerPFC = mean(powerPFC(1 : 15, :));
moscPFC = mean(oscPFC(1 : 15, :));

mpowerHP = mean(powerHP(1 : 15, :));
moscHP = mean(oscHP(1 : 15, :));

features = cat(2, powerPFC(1 : end, :) ./ repmat(mpowerPFC, 58, 1), oscPFC(1 : end, :) / moscPFC, ...
    powerHP(1 : end, :) ./ repmat(mpowerHP, 58, 1), oscHP(1 : end, :) / moscHP);


Mdl = fitcecoc(features, depth)
CVMdl = crossval(Mdl);
oosLoss = kfoldLoss(CVMdl)

