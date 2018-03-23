clear all

experiments=get_experiment_list;
parameters = get_parameters;
opts = get_options;
animal=1;
save_data=1;
downsampling_factor=320;
fs=32000/downsampling_factor;
fifteen_min=fs*60*15;


for n=1:3%length(animal)
    experiment=experiments(animal(n));
    CSC=[experiment.PL(1) experiment.HPreversal];
    if strcmp(experiment.Exp_type,'AWA')
        repetitions=1;
    else
        repetitions=1:3;
    end
    for period=repetitions
        TimePoints=[fifteen_min*(period-1)+1 fifteen_min*period];
        timepoints=[round(TimePoints(1)/(512/downsampling_factor)) round(TimePoints(2)/(512/downsampling_factor))];
        CSC2save=str2num(strcat('15',num2str(CSC(1)),num2str(period)));
        [~,LFP,~,~]=nlx_load_Opto(experiment,CSC(1),timepoints,downsampling_factor, 0);
        [~,LFP2,~,~]=nlx_load_Opto(experiment,CSC(2),timepoints,downsampling_factor, 0);
        info = mutualinfo(LFP, LFP2);
        display(strcat('mancano ', num2str(length(animal)-n),' animali e ', num2str(length(repetitions)-period), ' periodi'))
    end
end
