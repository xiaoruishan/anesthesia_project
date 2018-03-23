
clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812];%101:186; 900:912 1000:1005 501:536]; % above 900 is intCA1
bands=[100 150];
fs=3200;
fifteen_min = fs*60*15;
downsampling_factor = 10;
save_data=1;

for n=1:length(animal)
    experiment = experiments(animal(n));
    load(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'));
    baseline = [round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];
    CSC=experiment.HPreversal;
    [time, LFP, ~, ~] = nlx_load_Opto(experiment, CSC, baseline, downsampling_factor, 0);
    getSharpPPC_PCDI_PLV(experiment,LFP,bands,fs,downsampling_factor,save_data,animal(n));
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end