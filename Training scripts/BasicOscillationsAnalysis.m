clear all

path=get_path;
parameters=get_parameters;
experiments=get_experiment_list; % loads your excel file
animal= [501:536]; % the number of the animals that you want to analyze
fs=3200; % sampling frequency
save_data=1; % do you want to save your data or not?
downsampling_factor=10; 

  
for n=1:length(animal) % loops through the animals that you defined in your "animal" vector just above
    experiment=experiments(animal(n)); % loads the info for your experiment
    channels=[experiment.PL experiment.HPreversal-1]; % the channels you want to analyze
    for channel=1:length(channels)
        [time,signal,~,~]=nlx_load_Opto(experiment, channels(channel), [], downsampling_factor, 0);
        getBaselineOscComponents(time,signal,fs,experiment,channels(channel),save_data);
        getBaselineOscPower(time, signal,fs,experiment,channels(channel),save_data)
    end
    display(strcat('there are still', num2str(length(animal)-n),' animals to analyze'))
end