function getSUAfromPlexon(experiment,CSC,save_data)
Path = get_path;
load(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected'))
SUAspikeTimesPlexon=load(strcat(Path.output,filesep,'temp',filesep,'SpikeSorting',filesep,experiment.name,filesep,['CSC' num2str(CSC) 'wave']));
Fieldname = fieldnames(SUAspikeTimesPlexon);
SUAspikeTimesPlexon = SUAspikeTimesPlexon.(cell2mat(Fieldname));
StimulationTimes=cell2mat(StimulationProperties_corrected(:,[1:2]))/10^6;
SUATimes(1,:) = SUAspikeTimesPlexon(:,3)';
SUATimes(2,:) = SUAspikeTimesPlexon(:,2)';
nUnits=max(SUAspikeTimesPlexon(:,2));

%% get units during stim periods
for stimulationLoop = 1:size(StimulationTimes,1)
    clearvars X stimulationWindow periodTimes
    stimulationWindow = [StimulationTimes(stimulationLoop,1)-3, StimulationTimes(stimulationLoop,1)+6];
    X = find(SUATimes(1,:)>stimulationWindow(1) & SUATimes(1,:)<stimulationWindow(2));
    periodTimes(1,:) = SUATimes(1,X)-StimulationTimes(stimulationLoop,1);
    periodTimes(2,:)= SUATimes(2,X);
    SUAspikeTimes.(['StimulationPeriod' num2str(stimulationLoop)]) = periodTimes;
end

%% get units during baseline recording
[time, ~, ~] = nlx_load_Opto(experiment,'stim1D',[],10,0);
T_first = time(1);
T_last = time(end);
clearvars time

P_start = [T_first cell2mat(StimulationProperties_corrected(:,2))' T_last];
P_baseline = find(diff(P_start) > (15*60*10^6));
P_baselines = [P_start(P_baseline(1)) P_start(P_baseline(end))];

for bb=1:2
    clearvars X stimulationWindow periodTimes
        stimulationWindow = [P_baselines(bb)/10^6, P_baselines(bb)/10^6+15*60];
        X = find(SUATimes(1,:)>stimulationWindow(1) & SUATimes(1,:)<stimulationWindow(2));
        periodTimes(1,:) = SUATimes(1,X);
        periodTimes(2,:)= SUATimes(2,X);
        SUAspikeTimes.(['baseline' num2str(bb)])=periodTimes;
end
%% calc nunits
SUAspikeTimes.nUnits=nUnits;
%% SAVE
if save_data == 0
    disp('DATA NOT SAVED');
elseif save_data == 1
    if ~exist(strcat(Path.output,'temp',filesep,'SpikeSorting', filesep, experiment.name, filesep));
        mkdir(strcat(Path.output,filesep,'temp',filesep,'SpikeSorting', filesep, experiment.name, filesep));
    end
    save(strcat(Path.output, 'temp', filesep, 'SpikeSorting', filesep, experiment.name, filesep, ['SUA_CSC' num2str(CSC)],'.mat'),'SUAspikeTimes');
end
end