clear all

experiments = get_experiment_list;
parameters = get_parameters;
animal = [107 108 112];
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
    CSC = [experiment.Cg experiment.IL]; % 
    CSC4LFP = [experiment.Cg experiment.IL]; % 
    if strcmp(experiment.Exp_type,'URE')
        repetitions = 1;
    else
%         if animal(n)>25
%             repetitions=1:7;
%         else
        repetitions = 1;
%         end
    end
    for period = repetitions
        TimePoints = [fifteen_min*(period-1)+1 fifteen_min*period];
        timepoints = [round(TimePoints(1) / (512 / downsampling_factor)) round(TimePoints(2) / (512 / downsampling_factor))];
        for channel = 1 : length(CSC)
            CSC2save = str2num(strcat('15', num2str(CSC(channel)), num2str(period)));
            if ismember(CSC(channel), CSC4LFP)
                if strcmp(experiment.Exp_type,'ISO') && period==2
                    [time, LFP, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, downsampling_factor, 0);
                    getBaselineSlowOscPower(time, LFP,fs,experiment,CSC2save,save_data);
                else
                    [time,LFP,~,~]=nlx_load_Opto(experiment,CSC(channel),timepoints,downsampling_factor, 0);
                    getBaselineSlowOscPower(time, LFP,fs,experiment,CSC2save,save_data);
                end
            end
        end
        display(strcat('mancano ', num2str(length(animal)-n),' animali e ', num2str(length(repetitions) - 5 + period), ' periodi'))
    end
end
