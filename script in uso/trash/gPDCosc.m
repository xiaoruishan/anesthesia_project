clear all

experiments=get_experiment_list;
parameters = get_parameters;
animal=4001:4024;
fs=3200;
save_data=1;
downsampling_factor=10;
fifteen_min=fs*60*15;
threshold=5;
bands=[4 12;12 30;30 50];
windowSize = 1;
overlap = 0;
nfft = 2^13;

for n=1:length(animal)
    experiment=experiments(animal(n));
    CSC=experiment.HPreversal;
    if strcmp(experiment.Exp_type,'AWA')
        repetitions=1;
    else
        repetitions=1:3;
    end
    for period=repetitions
        TimePoints=[fifteen_min*(period-1)+1 fifteen_min*period];
        timepoints=[round(TimePoints(1)/51.2) round(TimePoints(2)/51.2)];
        CSC2save=str2num(strcat('15',num2str(experiment.PL(1)),num2str(period)));
        [time,LFP,~,~]=nlx_load_Opto(experiment,CSC,timepoints,downsampling_factor, 0);
        [~,LFP2,~,~]=nlx_load_Opto(experiment,experiment.PL(1),timepoints,downsampling_factor, 0);
%         getBaselineCoherenceOsc(time,LFP,LFP2,fs,experiment,save_data,CSC2save)
        getBaselineGrangerPDCOsc(time,LFP,LFP2,fs,experiment,save_data,CSC2save)
    end
    display(strcat('mancano ', num2str(length(animal)-n),' animali e ', num2str(length(repetitions)-period), ' periodi'))
end

