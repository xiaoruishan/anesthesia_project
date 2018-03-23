
clear all

experiments = get_experiment_list;
parameters = get_parameters;
path = get_path;
animal=101:142;
save_data=1;
downsampling_factor=100;
fs=32000/downsampling_factor;
fifteen_min=fs*60*15;
for n=1:length(animal)
    experiment=experiments(animal(n));
    CSC = experiment.Cg;
    if strcmp(experiment.Exp_type,'AWA')
        repetitions=1;
    else
        if animal(n)>25
            repetitions=1:3;
        else
            repetitions=1:3;
        end
    end
    for period = repetitions
        FiringRateSup = []; FiringRateLEC = []; FiringRateOB = []; OB = 0; LEC = 0;
        TimePoints=[fifteen_min*(period-1)+1 fifteen_min*period];
        timepoints=[round(TimePoints(1)/(512/downsampling_factor)) round(TimePoints(2)/(512/downsampling_factor))];
        CSC2save=str2num(strcat('15',num2str(CSC),num2str(period)));
%         [time,LFP,~,~] = nlx_load_Opto(experiment,CSC,timepoints,downsampling_factor, 0);
%         [~,LFP2,~,~] = nlx_load_Opto(experiment,experiment.IL,timepoints,downsampling_factor, 0);
%         getWaveletOscProperties(time, LFP, LFP2, fs, experiment, CSC2save, save_data); % this version also has spectra in it
%         getLFPOscProperties(time, LFP, LFP2, fs, experiment, CSC2save, save_data); % this version also has spectra in it
%         clearvars LFP LFP2
        for channel = [str2num(experiment.PL) experiment.nameDead]
            [time, MUA, ~, ~] = nlx_load_Opto(experiment,channel,round(timepoints),downsampling_factor/40, 0);
            firing = getOscPropertiesMUA(time,MUA,fs*40,experiment,CSC2save);
            clearvars MUA
            if channel < 20
                FiringRateOB = [FiringRateOB firing];
                OB = OB+1;
            else
                FiringRateLEC = [FiringRateLEC, firing];
                LEC = LEC+1;
            end
        end
        if LEC > 1
            FiringRateLEC = sum(reshape(FiringRateLEC, size(FiringRateLEC,1)*LEC, []))./LEC;
        end
        if OB > 1
            FiringRateOB = sum(reshape(FiringRateOB, size(FiringRateOB,1)*OB, []))./OB;
        end
        OscFiring = horzcat(FiringRateLEC, FiringRateOB);
        
        mkdir(strcat(path.output,filesep,'results',filesep,'OscFiring',filesep,experiment.name,filesep))
        save(strcat(path.output,filesep,'results',filesep,'OscFiring',filesep,experiment.name,filesep,['CSC' num2str(CSC2save)]),'OscFiring')
        display(strcat('mancano ', num2str(length(animal)-n),' animali'))
    end
end
