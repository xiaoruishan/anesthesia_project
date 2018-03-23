function [freqPeriods] = sortFreqPeriods(experiment, Periods, StimFrequency)

%% Get basic information
Path = get_path;

%% Load StimProperties
load(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected'))


allPeriods = cell2mat(StimulationProperties_corrected(:,6));

for fp = Periods;
    freqPeriods = find(allPeriods(Periods(1):Periods(end)) == StimFrequency) + Periods(1) - 1;
end

end % End of sortFreqPeriods