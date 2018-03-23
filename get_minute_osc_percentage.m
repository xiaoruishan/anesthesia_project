
clear all

experiments=get_experiment_list;
path = get_path;
animal = 201 : 203;
save_data = 1;
downsampling_factor = 3200;
fs = 32000 / downsampling_factor;
fifteen_min = fs * 60 * 15;

for n = 1: length(animal)
    experiment = experiments(animal(n));
    CSC = [experiment.PL experiment.HPreversal];
    mkdir(strcat(path.output,filesep,'results\MinuteOsc\',experiment.name))
    if strcmp(experiment.Exp_type,'AWA')
        repetitions = 1;
    else
       repetitions = 1 : 4;
    end
    for period = repetitions
        TimePoints = [fifteen_min * (period -1) +1 fifteen_min * period];
        timepoints = [round(TimePoints(1) / (512 / downsampling_factor)) round(TimePoints(2) / (512 / downsampling_factor))];
        for channel = 1 : length(CSC)
            CSC2save = str2num(strcat('15', num2str(CSC(channel)), num2str(period)));
            [time, ~, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, downsampling_factor, 0);
            load(strcat(path.output, filesep, 'results\BaselineOscAmplDurOcc\', experiment.name,filesep, ...
                'CSC15',num2str(CSC(channel)), num2str(period),'.mat'))
            oscTimes = round((OscAmplDurOcc.(['baseline']).OscTimes - time(1, 1)) * fs / 10^6);
            if oscTimes(1) == 0
                oscTimes(1) = 1;
            end
            signal = zeros(size(time));
            for event = 1 : size(oscTimes, 2)
                signal(oscTimes(1,event) : oscTimes(2, event)) = 1;
            end
            signal = mean(reshape(signal, 600, []));
            save(strcat(path.output, filesep, 'results\MinuteOsc\', experiment.name, filesep, 'CSC15',num2str(CSC(channel)), num2str(period),'.mat'),'signal')
        end        
        display(strcat('mancano ', num2str(length(animal) -n),' animali e ', num2str(length(repetitions) -period), ' periodi'))
    end
end