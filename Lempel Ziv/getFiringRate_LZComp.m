function getFiringRate_LZComp(experiment,MUA,threshold,CSC,save_data)
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
MUAfiringrate=length(peakLoc);

%% calculate Lempel Ziv complexity

recordingMUA(:)=0; recordingMUA=downsample(recordingMUA,32); % downsample to 1ms-bin
recordingMUA(floor(peakLoc/32))=1;
strInput=strrep((mat2str(recordingMUA)),' ','');
strInput=strrep(strInput,'[','');
strInput= strrep(strInput,']','');
codeBook=cellstr(['0';'1']);
[~,~,~,LZ.NumRepBin]=lempelzivEnc(strInput,codeBook);
LZ.outputLength=length(LZ.NumRepBin{1})*length(LZ.NumRepBin)-length(LZ.NumRepBin);
LZ.inputLength=length(strInput);
LZ.compRatio=LZ.outputLength/LZ.inputLength*100;

%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1   
    if ~exist(strcat(Path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name,filesep, ...
        ['MUAfiringrate' num2str(CSC)]),'MUAfiringrate')
    if ~exist(strcat(Path.output,filesep,'results',filesep,'Lempel-Ziv',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'Lempel-Ziv',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'Lempel-Ziv',filesep,experiment.name,filesep, ...
        ['Lempel-Ziv' num2str(CSC)]),'LZ')
end
end