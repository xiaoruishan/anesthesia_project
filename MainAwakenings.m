clear all

experiments = get_experiment_list;
parameters = get_parameters;
animal = 218 : 220;
save_data = 1;
downsampling_factor = 100;
fs = 32000 / downsampling_factor;
minute = 60 * fs;
baseline_length = [12 10 16];

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = [experiment.HPreversal experiment.PL(4)]; %
    repetitions = 1 : 5;
    
    for period = repetitions
        
        if ismember(animal(n), 218 : 220) && period == 2
            TimePoints = [minute * (baseline_length(n)-1) minute * baseline_length(n) * 10];
        else
            TimePoints = [1 minute * baseline_length];
        end
        
        timepoints = [round(TimePoints(1) / (512 / downsampling_factor)) round(TimePoints(2) / (512 / downsampling_factor))];
        
        for channel = 1 : length(CSC)
            
            CSC2save = str2num(strcat('15', num2str(CSC(channel)), num2str(period)));
            
            if strcmp(experiment.Exp_type,'ISO') && period == 1
                [time, LFP, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, downsampling_factor, 0);
                getBaselineOscComponents(time, LFP, fs, experiment, CSC2save, save_data);
                getMinuteOsc(time, fs, experiment, CSC2save, save_data)
                getMinutePower(LFP, fs, experiment, CSC2save, save_data);
                getMinutePowerOsc(LFP, time, fs, experiment, CSC2save, save_data);
                thr = getOscThr(LFP, fs);
                getMinuteOscComponents(time, LFP, thr / 2, fs, experiment, CSC2save, save_data)
                clearvars LFP lfp N rms win halfwin num_sd
            else
                [time,LFP, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, downsampling_factor, 0);
                getBaselineOscComponentsAwake(time, LFP, fs, experiment, CSC2save, save_data, thr);
                getMinuteOsc(time, fs, experiment, CSC2save, save_data)
                getMinuteOscComponents(time, LFP, thr / 2, fs, experiment, CSC2save, save_data)
                getMinutePowerOsc(LFP, time, fs, experiment, CSC2save, save_data);
                getMinutePower(LFP,fs,experiment,CSC2save,save_data);
            end
        end
        display(strcat('mancano ', num2str(length(animal)-n),' animali e ', num2str(length(repetitions) - period), ' periodi'))
    end
end
