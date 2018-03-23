%% 

clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
animal = [501:537 551:566];
fs = 3200;
save_data = 1;
downsampling_factor = 10;
fifteen_min = fs*60*15; % I take only the first fifteen minutes of the recording - i.e. the first
% baseline when the experiment entails also optogenetics. hence, fs*60seconds*15minutes
bands=[12 30];
cross='bb';
threshold = 5;

for n=1:length(animal)
    experiment = experiments(animal(n));
    CSC = [17:20 29:32];
    load(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'));
    baseline = [round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];
    for channel=1:length(CSC)
        [time, signal, ~, ~] = nlx_load_Opto(experiment, CSC(channel), baseline, downsampling_factor, 0);
        [~, signal_MUA, ~, ~] = nlx_load_Opto(experiment, CSC(channel), baseline, 1, 0);
        getBaselinePPC(signal,signal_MUA,bands,fs*10,downsampling_factor,threshold,channel+16);
        getBaselinePLV(signal,signal_MUA,experiment,bands,threshold,fs,time,path,windowSize)
    end
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end


%% PPC old



for n = 1:length(animal)
    experiment = experiments(animal(n));
    PPC(n)=ppc_Mattia(experiment,bands,cross,threshold,path);
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end



%%  phase locking on entire oscillations

bands=[12 30];
cross='bb';
threshold = 5;

for n = 46:length(animal)
    experiment = experiments(animal(n));
    R{n} = spikePhase_cross_4shank(experiment,bands,cross,threshold,path);
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end

%% phase locking for 3s around SWR

bands=[12 50];
cross='bb';
threshold = 5;

for n = 1:length(animal)
    experiment = experiments(animal(n));
    S{n} = spikePhase_cross_4shank_sharp(experiment,bands,cross,threshold,path);
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end

%% plotting oscillations

figure
for animale = 1:45
    if isstruct(R{1,animale})
        if animale < 38
            polarplot(R{1,animale}.phase_rad{1,1}{1,1},R{1,animale}.rvl{1,1}{1,1},'b*')
            hold on
        else
            polarplot(R{1,animale}.phase_rad{1,1}{1,1},R{1,animale}.rvl{1,1}{1,1},'r*')
        end
    end
end

%% plotting SWR

figure
for animale = 1:length(animal)
    if isstruct(S{1,animale})
        if animale < 38
            polarplot(S{1,animale}.phase_rad{1,1}{1,1},S{1,animale}.rvl{1,1}{1,1},'b*')
            hold on
        else
            polarplot(S{1,animale}.phase_rad{1,1}{1,1},S{1,animale}.rvl{1,1}{1,1},'r*')
        end
    end
end
polarplot([0 circ_mean(swt(1,:)')],[0 circ_r(swt(1,:)')],'linewidth',3)
polarplot([0 circ_mean(sge(1,:)')],[0 circ_r(sge(1,:)')],'linewidth',3)



%% extract values for stats

% entire oscillations
for n = 1:length(animal)
    if n < 38
        wt(1,n) = R{1,n}.phase_rad{1,1}{1,1};
        wt(2,n) = R{1,n}.rvl{1,1}{1,1};
        wt(3,n) = R{1,n}.p{1,1}{1,1};
    else
        ge(1,n-37) = R{1,n-37}.phase_rad{1,1}{1,1};
        ge(2,n-37) = R{1,n-37}.rvl{1,1}{1,1};
        ge(3,n-37) = R{1,n-37}.p{1,1}{1,1};
    end
end

% SWR

for n = 1:length(animal)
    if n < 38
        swt(1,n) = S{1,n}.phase_rad{1,1}{1,1};
        swt(2,n) = S{1,n}.rvl{1,1}{1,1};
        swt(3,n) = S{1,n}.p{1,1}{1,1};
    else
        sge(1,n-37) = S{1,n-37}.phase_rad{1,1}{1,1};
        sge(2,n-37) = S{1,n-37}.rvl{1,1}{1,1};
        sge(3,n-37) = S{1,n-37}.p{1,1}{1,1};
    end
end



%% Xiaxia Stuff
cross='aa';R_MUA_LPF.aa= main_function_FullSig_OscPeriod_spikePhase_cross(experiment,bands,DownsampleFactor,cross,4);
cross='bb';R_MUA_LPF.bb= main_function_FullSig_OscPeriod_spikePhase_cross(Experiment,bands,DownsampleFactor,cross,4);

save('R_MUA_LPF_fs_1000_cross_full_Osc.mat','bands','R_MUA_LPF');

