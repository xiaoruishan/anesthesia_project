%% same old stuff

clear all

path = get_path;
experiments = get_experiment_list;
animal = 201 : 209;

%% initialize a gazillion variables


%% load stuff
features = [];

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = [experiment.PL(4) experiment.HPreversal];
    features_animal = [];
    depth = [];
    
    for channel = CSC
        repetitions = 1 : 4;
        features_area = [];
        
        for period = repetitions
            load(strcat(path.output,filesep,'results\MinutePower\',experiment.name,filesep,'CSC15',num2str(channel),num2str(period),'.mat'))
            if size(pWelch,1) < 15
                pWelch(size(pWelch, 1):15, :) = NaN;
            end
            power = pWelch(:, 1 : 640, :);
            power = squeeze(median(reshape(power, 15, 64, 10, []), 2));
            
            load(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name,filesep,'CSC15',num2str(channel),num2str(period),'.mat'))
            if size(signal, 2) < 15
                signal(1, size(signal, 2) : 15) = NaN;
            end
            
            if period == 1
                mean_power = mean(power);
                mean_osc = mean(signal);
            end
            power = power ./ repmat(mean_power, size(power, 1), 1);
            signal = signal ./ mean_osc;
            
            
            if channel == CSC(1)
                depth = cat(2, depth, period * ones(1, size(power, 1)));
            end
            features_area_period = cat(2, power, signal');
            features_area = cat(1, features_area, features_area_period);
        end
        %         features_area = cat(2, depth', features_area);
        features_animal = cat(2, features_animal, features_area);
    end
    features_animal = cat(2, depth', features_animal);
    features = cat(1, features, features_animal);
end
