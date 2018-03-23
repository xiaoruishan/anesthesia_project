%% By Joachim
function [stimulatioTimeStamps] = getStimulationTimeStamps(experiment, save_data)
%% USE NOT downsampled data!
Path = get_path;
parameters=get_parameters;
%create filename
filename = strcat(experiment.path,filesep, experiment.name,filesep, 'STIM1D.ncs');

FieldSelectionArray     = [1 0 1 0 1]; %TimeStamps, ChannelNumbers, SampleFrequencies, NumberValidSamples, Samples
ExtractHeaderValue      = 0;
ExtractMode             = 1;
ExtractModeArray        = [];
[TimeStamps, SampleFrequencies, Samples] = Nlx2MatCSC(filename, FieldSelectionArray, ExtractHeaderValue, ExtractMode, ExtractModeArray);

TimeStampsStart=TimeStamps(1);
clear TimeStamps
f=median(SampleFrequencies);
clear SampleFrequencies

% rearray and adjust
Samples=reshape(Samples,1,size(Samples,1)*size(Samples,2));
Samples=Samples./32.81; %adjust to microVolt; only for LFP
Samples=Samples>max(Samples)*parameters.preprocessing.nlx_load_Opto.digital2binary.Threshold;

%% find stimulus period
StimDStart=find(diff(Samples)==1)+1;
StimDEnd=find(diff(Samples)==-1)-1;
StimDshortinterval=find(diff(StimDStart)<f)+1;
StimDStart(StimDshortinterval)=[];
StimDEnd(StimDshortinterval-1)=[];

StimStart=StimDStart./f*10^6+TimeStampsStart; %convert to microseconds
StimEnd=StimDEnd./f*10^6+TimeStampsStart; %convert to microseconds

stimulatioTimeStamps = [StimStart',StimEnd'];

%% Save
if save_data == 0;
    return
else
    if ~exist(strcat(Path.temp,'temp',filesep,'stimulatioTimeStamps', filesep, experiment.name, filesep));
    mkdir(strcat(Path.output,filesep,'temp',filesep,'stimulatioTimeStamps', filesep, experiment.name, filesep));
    end
    save(strcat(Path.temp, 'temp', filesep, 'stimulatioTimeStamps', filesep, experiment.name, filesep, experiment.name,'.mat'),'stimulatioTimeStamps');
end
end