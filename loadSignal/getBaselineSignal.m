function [baselineStructure] = getBaselineSignal(experiment, CSC, downsample_factor)
Path = get_path;
if  exist(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected','.mat'));
    load(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected'));
else
    disp('STIMPROPERTIES NOT FOUND')
end

[time, ~, ~] = nlx_load_Opto(experiment,'stim1D',[],10,0);

T_first = time(1);
T_last = time(end);
clearvars time

P_start = [T_first cell2mat(StimulationProperties_corrected(:,2))' T_last];
P_baseline = find(diff(P_start) > (15*60*10^6));
P_baselines = [P_start(P_baseline(1)) P_start(P_baseline(end))];

for bb = 1:2
        ExtractModeArray(1) = P_baselines(bb);
        ExtractModeArray(2) = P_baselines(bb)+15*60*10^6;
        [timeX, signalX,samplingrate] = nlx_load_Opto(experiment,CSC,ExtractModeArray,downsample_factor,0);
        timeX = timeX(1:(15*60*samplingrate));
        signalX = signalX(1:(15*60*samplingrate));
        baselineStructure.signal(bb,:) = signalX(samplingrate*10:end-samplingrate*10); % cut away 10 sec from start and end. This is to prevent artifact/filter artifacts coming from power estimation or end of last trial.
        baselineStructure.time(bb,:) = timeX(samplingrate*10:end-samplingrate*10);
        baselineStructure.samplingrate = samplingrate;
end
baselineStructure.CSC = CSC;
end