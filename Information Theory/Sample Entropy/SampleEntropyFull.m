function SampleEntropyFull(experiment, signal, CSC, save_data)

%% cut and glue signal

Path=get_path;
parameters=get_parameters;

%% compute SE
r = 0.2*std(signal);
SampEnt = SampEn(2, r, signal);


%% save data

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'SampleEntropy',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'SampleEntropy',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'SampleEntropy',filesep,experiment.name,filesep,['SampEntFullCSC' num2str(CSC)]),'SampEnt')
end