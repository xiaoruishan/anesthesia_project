function MUAfiringrate=getBaselineFiringRate(experiment,MUA,threshold,CSC,save_data)
%%
% inputs:
% experiment: as usual
% MUA: the signal that you want to analyze, NOT DOWNSAMPLED
% threshold: the threshold you want to use for spike detection. 5 is
% standard
% CSC: the number of the channel that you want to analyze. it is used to
% save the data with a correct annotation
% save_data: ...
Path=get_path;
%% load oscillation vectors, and cut and glue the signal

recordingMUA = ZeroPhaseFilter(MUA,32000,[500 5000]);
thr = std(recordingMUA)*threshold;
[peakLoc,~]=peakfinderOpto(recordingMUA,thr/2,-thr,-1,false);
MUAfiringrate = length(peakLoc);

%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1   
    if ~exist(strcat(Path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name,filesep, ...
        ['MUAfiringrate' num2str(CSC)]),'MUAfiringrate')
end
end