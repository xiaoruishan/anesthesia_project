

clear all

path=get_path;
parameters=get_parameters;
experiments=get_experiment_list;
experiment=experiments(2013);
Frequency=[0];
stimStructure1 = getStimulusSignal(experiment,'CSC24','ramp', Frequency, 1);






baseline=[round(fs/51.2) round((fs+three_min)/51.2)];
[time,signal,~,~]=nlx_load_Opto(experiment, 23, baseline, 1, 0);
[~,signal_stim,~,~]=nlx_load_Opto(experiment, 'STIM1D', baseline, 1, 0);


figure; 
for kk=1:30
    plot(stimStructure1.signal(kk,:))
plot(stimStructure1.signalA(1,96000:192000)-20)
hold on
plot(ZeroPhaseFilter(stimStructure1.signal(kk,96000:192000),32000,[100 300]))
k=waitforbuttonpress
hold off
end


f1=figure
plot(stimStructure1.time,stimStructure1.signalA(1,:),'linewidth',2)
for ff=1:30
   hold on
   plot(stimStructure1.time,ZeroPhaseFilter(stimStructure1.signal(ff,:),32000,[1 5000])-ff*100)
   hold off   
end
f2=figure;
plot(stimStructure1.time,mean(stimStructure1.signal))
plot(stimStructure1.time,mean(ZeroPhaseFilter(stimStructure1.signal,32000,[100 300])))