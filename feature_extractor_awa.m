%% same old stuff

clear all

path = get_path;
experiments = get_experiment_list;
animal = [213 215 : 217 219 220];

%% load stuff
features = [];

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = [experiment.PL(4) experiment.HPreversal];
    features_animal = [];
    depth = [];
    
    for channel = CSC
        
        if animal(n) < 219
            repetitions = 1 : 5;
        else
            repetitions = 1 : 2;
        end
        
        features_area = [];
        
        for period = repetitions
            load(strcat(path.output, filesep, 'results\MinutePower\', experiment.name, filesep, ...
                'CSC15', num2str(channel), num2str(period), '.mat'))
            power = pWelch(:, 1 : 640, :);
            power = squeeze(median(reshape(power, size(pWelch,1), 64, 10, []), 2));
            
            load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(channel),num2str(period),'.mat'))
            
            if period == 1 && ~strcmp(experiment.Exp_type, 'URE')
                mean_power = mean(power);
                mean_osc = mean(signal);
            end
            
            load(strcat(path.output, filesep, 'results\MinuteOscComponents\', experiment.name, filesep, 'CSC15', ...
                num2str(channel), num2str(period), '.mat'))
            if period == 1 && ~strcmp(experiment.Exp_type, 'URE')
                mean_power = median(power);
                mean_osc = median(signal);
                mean_osc_prop = median(OscMatrix);
            end
            
            
            power = power ./ repmat(mean_power, size(power, 1), 1);
            signal = signal ./ mean_osc;
            OscMatrix = bsxfun(@rdivide, OscMatrix, mean_osc_prop);
            
            
            if channel == CSC(1)
                depth = cat(2, depth, period * ones(1, size(power, 1)));
            end
            features_area_period = cat(2, power, signal', OscMatrix);
            features_area = cat(1, features_area, features_area_period);
        end
        features_animal = cat(2, features_animal, features_area);
    end
    if strcmp(experiment.Exp_type, 'URE')
        depth = depth + 1;
    end
    features_animal = cat(2, depth', features_animal);
    features = cat(1, features, features_animal);
end


animals_finder = diff(features(:, 1));
animals_borders = find(animals_finder < 0);

animals = zeros(1, length(features));
for idx = 1 : length(animals_borders) + 1
    if idx == 1
        animals(1 : animals_borders(idx)) = idx;
    elseif idx == length(animals_borders) + 1
        animals(animals_borders(idx - 1) : end) = idx;
    else
        animals(animals_borders(idx - 1) : animals_borders(idx)) = idx;
    end
end

