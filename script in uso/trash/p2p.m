clear all

experiments=get_experiment_list;
parameters = get_parameters;
animal=101:142;
save_data=1;
downsampling_factor=320;
fs=32000/downsampling_factor;
fifteen_min=fs*60*15;
threshold=5;
windowSize = 1;
overlap = 0;
nfft = 2^13;

pi2pi = [];
for n = 11:12
    experiment = experiments(animal(n));
    CSC = 25;
    if strcmp(experiment.Exp_type,'AWA')
        repetitions = 1;
    else
        repetitions = 1:3;
    end
    for period = repetitions
        TimePoints = [fifteen_min*(period-1)+1 fifteen_min*period];
        timepoints = [round(TimePoints(1)/(512/downsampling_factor)) round(TimePoints(2)/(512/downsampling_factor))];
        [~,LFP,~,~] = nlx_load_Opto(experiment,CSC,timepoints,downsampling_factor, 0);
        media = mean(LFP);
        standard = std(LFP);
        thr = media + standard;
        [a, b] = peakfinderOpto(LFP, thr, thr/2);
        pi2pi = horzcat(pi2pi, a);
    end
    
end

zuzzo = diff(pi2pi);
zuzzo(zuzzo < 0) = [];
zuzzo(zuzzo > mean(zuzzo) + std(zuzzo)) = [];
zuzzo(zuzzo < mean(zuzzo) - std(zuzzo)) = [];
figure; plot(zuzzo)

