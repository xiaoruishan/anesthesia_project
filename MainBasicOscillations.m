clear all

path=get_path;
parameters=get_parameters;
experiments=get_experiment_list;
animal=[501:538 551:568 571:588];
fs=3200;
save_data=1;
downsampling_factor=10;
fifteen_min=fs*60*15;
% three_min=fs*60*3;
bands=[4 12;12 30;30 100];
threshold=5;
  
for n=72:length(animal)
    experiment=experiments(animal(n));
    CSC=[17:20 29:32 experiment.HPreversal];
    if n<38
%         gimmeBaselineSignal(experiment,save_data,1,1);
        load(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'));
    else
            BaselineTimePoints=[fs fifteen_min];
    end
    baseline=[round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+fifteen_min)/51.2)];
%     baseline=[round(BaselineTimePoints(1)/51.2) round(BaselineTimePoints(2)/51.2)];
    for channel=1:length(CSC)
        [time,LFP,~,~]=nlx_load_Opto(experiment, CSC(channel), baseline, downsampling_factor, 0);
        getBaselineOscComponents(time,LFP,fs,experiment,CSC(channel),save_data);
        [~,MUA,~,~]=nlx_load_Opto(experiment, CSC(channel), baseline, 1, 0);
        PPC=getBaselinePPC_PCDI_PLV(experiment,LFP,MUA,bands,fs,downsampling_factor,time,threshold,CSC(channel),save_data);
%         getBaselineOscPower(time, signal,fs,experiment,CSC(channel),save_data);
    end
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end
