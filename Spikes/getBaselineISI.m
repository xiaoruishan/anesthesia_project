function getBaselineISI(experiment,MUA,threshold,CSC,save_data)
%% by Mattia
% inputs:
% experiment: as usual
% MUA: the signal that you want to analyze, NOT DOWNSAMPLED
% threshold: the threshold you want to use for spike detection. 5 is
% standard
% CSC: the number of the channel that you want to analyze. it is used to
% save the data
% save_data: ...
Path=get_path;
%% get MUA spike times and firing rate

recordingMUA=ZeroPhaseFilter(MUA,32000,[500 5000]);
clear MUA
thr=std(recordingMUA)*threshold;
[peakLoc,~]=peakfinderOpto(recordingMUA,thr/2,-thr,-1,false);
peakLoc=round(peakLoc/32); % bin in 1ms window. I am here assuming that fs=32000, but this should
% be the case as MUA should NOT be downsampled
ISI=diff(peakLoc);

%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1   
    if ~exist(strcat(Path.output,filesep,'results',filesep,'ISI',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'ISI',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'ISI',filesep,experiment.name,filesep, ...
        ['ISI' num2str(CSC)]),'ISI')
end
end