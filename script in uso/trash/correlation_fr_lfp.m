
clearvars -except secondPower spikes_over_time

spikes = log10(spikes_over_time)';
secondPower(:, 1, :) = [];
%% animal by animal

power = log10(squeeze(mean(reshape(secondPower, size(secondPower,1), [], 1, size(secondPower,3)), 3)));
% powa = log10(secondPower);
periodo = vertcat(1:900, 901:1800);

for per_idx = 1:2
    period = periodo(per_idx, :)';
    for animal = 1 : size(power, 3)
        for freq = 1 : 100
            spikes_animal = spikes(period, animal);
            inf_idx = find(spikes_animal== -Inf);
            spikes_animal(inf_idx) = [];
            power_animal = power(period, freq, animal);
            power_animal(inf_idx, :) = [];
            corr(freq, animal, per_idx, :) = robustfit(power_animal, spikes_animal);
        end
    end
end

figure; boundedline(linspace(1, 100, 100), squeeze(median(corr(:, :, 1, 2), 2))', squeeze(mad(corr(:, :, 1, 2), 0, 2))./sqrt(19)')
hold on; boundedline(linspace(1, 100, 100), squeeze(median(corr(:, :, 2, 2), 2))', squeeze(mad(corr(:, :, 2, 2), 0, 2))./sqrt(19)', 'r')


%% globally

power = log10(squeeze(mean(reshape(secondPower, size(secondPower,1), [], 1, size(secondPower,3)), 3)));
% powa = log10(secondPower);
periodo = vertcat(1:900, 901:1800);

for per_idx = 1:2
    period = periodo(per_idx, :)';
    for freq = 1 : 100
        spikes_animal = spikes(period, :);
        inf_idx = find(spikes_animal== -Inf);
        spikes_animal(inf_idx) = [];
        power_animal = squeeze(power(period, freq, :));
        power_animal(inf_idx) = [];
        corr(freq, per_idx, :) = robustfit(power_animal, spikes_animal);
     end
end

figure; plot(linspace(1, 100, 100), squeeze(mean(corr(:, 1, 2), 2))')
hold on; plot(linspace(1, 100, 100), squeeze(mean(corr(:, 2, 2), 2))')