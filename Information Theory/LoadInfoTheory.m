%% same old scripts
clear all
path = get_path;
experiments = get_experiment_list;
animal = 101 : 142;

%% initialize a gazillion variables


%% load stuff

for n=1:length(animal)
    experiment=experiments(animal(n));
    CSC=experiment.Cg(1);% PL(4) Cg(1)
    if strcmp(experiment.Exp_type,'AWA')
        repetitions=1;
    else
        repetitions=1;
    end
    for period=repetitions
        load(strcat(path.output,filesep,'results\InfoTheory\',experiment.name,filesep,'15',num2str(CSC),num2str(period),'.mat'))
        SampleEnt1(n, :) = median(InfoTheory.SampEnt1);
        SampleEnt2(n, :) = median(InfoTheory.SampEnt2);
%         load(strcat(path.output,filesep,'results\InfoTheoryNorm\',experiment.name,filesep,'15',num2str(CSC),num2str(period),'.mat'))
%         MutInfoHist(n, :) = median(InfoTheory.MutInfoHist);
%         MutInfoKernel(n, :) = median(InfoTheory.MutInfoKernel);
%         MutInfoDiff(n, :) = median(reshape(median(InfoTheory.MutInfoDiff), 2, []));
%         DiffEnt1(n, :) = median(reshape(median(InfoTheory.DiffEnt1), 2, [])); 
%         DiffEnt2(n, :) = median(reshape(median(InfoTheory.DiffEnt2), 2, []));
%         RenyiEnt1(n, :) = median(InfoTheory.RenyiEnt1);
%         RenyiEnt2(n, :) = median(InfoTheory.RenyiEnt2);
    end
end


