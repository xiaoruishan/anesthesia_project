function [baselineStructure] = getBaselineSignal(experiment, CSC,downsampling_factor)
Path = get_path;
if  exist(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected','.mat'));
    load(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected'));
else
    disp('STIMPROPERTIES NOT FOUND')
end

BaselineTimePoints=gimmeBaselineSignal(experiment,1,0,1);

baseline=[round(BaselineTimePoints(1)/51.2) round((BaselineTimePoints(1)+3200*60*15)/51.2)];
[timeX, signalX,samplingrate] = nlx_load_Opto(experiment,CSC,baseline,downsampling_factor,0);
baselineStructure.signal(1,:) = signalX(samplingrate*10:end-samplingrate*10); % cut away 10 sec from start and end. This is to prevent artifact/filter artifacts coming from power estimation or end of last trial.
baselineStructure.time(1,:) = timeX(samplingrate*10:end-samplingrate*10);
baselineStructure.samplingrate = samplingrate;

baselineStructure.CSC = CSC;
end