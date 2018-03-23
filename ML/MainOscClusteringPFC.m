
clear all

experiments=get_experiment_list;
parameters = get_parameters;
Path = get_path;
animal=1:38;
save_data=1;
downsampling_factor=100;
fs=32000/downsampling_factor;
fifteen_min=fs*60*15;

for n=1:length(animal)
    experiment=experiments(animal(n));
    CSC = experiment.PL(1);
    if strcmp(experiment.Exp_type,'AWA')
        repetitions=1;
    else
        if animal(n)>25
            repetitions=1:3;
        else
            repetitions=1:3;
        end
    end
    for period=repetitions
        FiringRateSup = []; FiringRateDeep = []; FiringRateHP = [];
        TimePoints=[fifteen_min*(period-1)+1 fifteen_min*period];
        timepoints=[round(TimePoints(1)/(512/downsampling_factor)) round(TimePoints(2)/(512/downsampling_factor))];
        CSC2save=str2num(strcat('15',num2str(CSC),num2str(period)));
        [time,LFP,~,~]=nlx_load_Opto(experiment,CSC,timepoints,downsampling_factor, 0);
        [~,LFP2,~,~]=nlx_load_Opto(experiment,experiment.HPreversal,timepoints,downsampling_factor, 0);
        getWaveletOscProperties(time, LFP, LFP2, fs, experiment, CSC2save, save_data); % this version also has spectra in it
        clearvars LFP LFP2
%         for channel = [experiment.HPreversal-2:experiment.HPreversal+2 17:24 25:32]
%             [time,MUA,~,~]=nlx_load_Opto(experiment,channel,round(timepoints),downsampling_factor/40, 0);
%             firing = getOscPropertiesMUA(time,MUA,fs*40,experiment,CSC2save);
%             clearvars MUA
%             if channel < 17
%                 FiringRateHP = [FiringRateHP firing];
%             elseif channel > 24
%                 FiringRateDeep = [FiringRateDeep firing];
%             else
%                 FiringRateSup = [FiringRateSup firing];
%             end                
%         end
%         
%         FiringRateSup = sum(reshape(FiringRateSup,8,length(FiringRateSup)/8));
%         FiringRateDeep = sum(reshape(FiringRateDeep,8,length(FiringRateDeep)/8));
%         FiringRateHP = sum(reshape(FiringRateHP,5,length(FiringRateHP)/5));
%         OscFiring = horzcat(FiringRateSup, FiringRateDeep, FiringRateHP);
%         
%         mkdir(strcat(Path.output,filesep,'results',filesep,'OscFiring',filesep,experiment.name,filesep))
%         save(strcat(Path.output,filesep,'results',filesep,'OscFiring',filesep,experiment.name,filesep,['CSC' num2str(CSC2save)]),'OscFiring')
%         display(strcat('mancano ', num2str(length(animal)-n),' animali e ', num2str(length(repetitions)-period), ' periodi'))
    end
end
