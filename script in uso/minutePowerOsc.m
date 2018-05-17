clear all

experiments = get_experiment_list;
parameters = get_parameters;
animal = 201 : 216;
save_data = 1;
downsampling_factor = 100;
fs = 32000 / downsampling_factor;
fifteen_min = fs * 60 * 15;
threshold = 5;
windowSize = 1;
overlap = 0;
nfft = 2^13;

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = [experiment.HPreversal experiment.PL(4)];
    if strcmp(experiment.Exp_type,'URE')
        repetitions = 1 : 3; 
    elseif strcmp(experiment.Exp_type,'ISO')
        repetitions = 1 : 4; 
    else
%         if animal(n)>25
%             repetitions=1:7;
%         else
        repetitions = 1;
%         end
    end
    for period = flip(repetitions)
        TimePoints = [fifteen_min*(period-1)+1 fifteen_min*period];
        timepoints = [round(TimePoints(1) / (512 / downsampling_factor)) round(TimePoints(2) / (512 / downsampling_factor))];
        for channel = 1 : length(CSC)
            CSC2save = str2num(strcat('15', num2str(CSC(channel)), num2str(period)));
            [time, LFP, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, downsampling_factor, 0);
            getMinutePowerOsc(LFP, time, fs, experiment, CSC2save, save_data);
        end
        display(strcat('mancano ', num2str(length(animal)-n),' animali e ', num2str(length(repetitions) - 5 + period), ' periodi'))
    end
end
