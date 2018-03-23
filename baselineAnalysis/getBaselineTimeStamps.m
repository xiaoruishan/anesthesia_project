

clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
animal = [1010:1014];

%% load stuff

for n=1:length(animal)
    experiment = experiments(animal(n));
    load(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name, filesep, 'BaselineTimePoints.mat'))
    points(n,:)=BaselineTimePoints(1:2);
end