
clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list_Sabine;


animal = 1:12;

for n = 1:length(animal)%[1:4 7:length(animal)]
    
    experiment = experiments(animal(n));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, 'power', filesep, experiment.name));
    PowerSWR = PowerSpectrums{1};
    PowerpreSWR = PowerSpectrums{2};
    PowerRip = PowerSpectrums{3};
    PowerpreRip = PowerSpectrums{4};
    
    SWR(:,n) = mean(PowerSWR,2);
    preSWR(:,n) = mean(PowerpreSWR,2);
    Rip(:,n) = mean(PowerRip,2);
    preRip(:,n) = mean(PowerpreRip,2);
end

figure
plot(linspace(120,300,361),mean(Rip(240:600,:),2),'linewidth',3)
hold on
plot(linspace(120,300,361),mean(preRip(240:600,:),2),'linewidth',3)

RipPower = mean(Rip(240:600,:),1);
preRipPower = mean(preRip(240:600,:),1);

[h,intHP] = ttest2(RipPower,preRipPower)

