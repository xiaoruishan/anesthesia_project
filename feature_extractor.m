%% same old stuff

clear all

path = get_path;
experiments = get_experiment_list;
animal = 1 : 38;

%% load stuff
features = [];

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = [experiment.PL(4) experiment.HPreversal];
    features_animal = [];
    depth = [];
    
    for channel = CSC
        
        if strcmp(experiment.Exp_type, 'AWA')
            repetitions = 1;
        elseif strcmp(experiment.Exp_type, 'URE')
            repetitions = 1 : 3;
        else
            repetitions = 1 : 4;
        end
        
        features_area = [];
        
        for period = repetitions
            load(strcat(path.output, filesep, 'results\MinutePower\', experiment.name, filesep, ...
                'CSC15', num2str(channel), num2str(period), '.mat'))
            if size(pWelch,1) < 15
                pWelch(size(pWelch, 1) : 15, :) = NaN;
            end
            power = pWelch(:, 1 : 640, :);
            power = squeeze(median(reshape(power, size(pWelch,1), 64, 10, []), 2));
            
            load(strcat(path.output,filesep, 'results\MinuteOsc\', experiment.name, filesep, 'CSC15', ...
                num2str(channel), num2str(period), '.mat'))
            if size(signal, 2) < 15
                signal(1, size(signal, 2) : 15) = NaN;
            end
            
            load(strcat(path.output, filesep, 'results\MinuteOscComponents\', experiment.name, filesep, 'CSC15', ...
                num2str(channel), num2str(period), '.mat'))
            if size(OscMatrix, 1) < 15
                OscMatrix(size(OscMatrix, 1) : 15, :) = NaN;
            end
            
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
        %         features_area = cat(2, depth', features_area);
        features_animal = cat(2, features_animal, features_area);
    end
    if strcmp(experiment.Exp_type, 'URE')
        depth = depth + 1;
    end
    features_animal = cat(2, depth', features_animal);
    features = cat(1, features, features_animal);
end
features(836 : 840, 1) = 4;
% features([791:795 923:930 1077:1080], :) = [];

animals_finder = diff(features(:, 1));
animals_borders = find(animals_finder < -2);

animals = zeros(1, length(features));
for idx = 1 : length(animals_borders)
    if idx == 1
        animals(1 : animals_borders(idx + 1)) = idx;
    elseif idx == length(animals_borders)
        animals(animals_borders(idx) : end) = idx;
    else
        animals(animals_borders(idx) : animals_borders(idx + 1)) = idx;
    end
end

