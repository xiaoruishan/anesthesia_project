function PLV=getBaselinePLV(experiment,LFP,MUA,bands,threshold,fs,downsampling_factor,time,CSC,save_data)
%written by Xiaxia, 06.01.2017
% use the full signal to detect MUA-LFP phase
% locking

% input:
%       bands--------------------------LFP frquency bands, for example [4 12;12 30;30 48; 52 100]
%       downsampling_factor------------for LFP
%       cross--------'aa','ab','bb','ba'
%       threshold---- for spike detection, for example 4

% output:
%      R--------------R.details, all the phases of the spike happens
%                     R.p, Reiley test
%                     R.phase_rad, mean phase
%                     R.rvl,resultant vector length

Path=get_path;
%% load oscillation vectors, and cut and glue the signal

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC17'));% num2str(CSC)]));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);
OscStart=oscTimes(1,:);
OscEnd=oscTimes(2,:);
num_Oscs=length(OscStart);

%% obtain MUA, chan_num{1}
recordingMUA = ZeroPhaseFilter(MUA,32000,[500 5000]);
thr = std(recordingMUA)*threshold;
[peakLoc, ~] = peakfinderOpto(recordingMUA,0 ,-thr,-1);
peakLoc=round(peakLoc/downsampling_factor);
peakLoc(find(peakLoc==0))=1;

[num_bands,~]=size(bands);

% obtain specific frequency
for num_band=1:num_bands
    band=bands(num_band,:);
    Signal_filtered=ZeroPhaseFilter(LFP,fs,band);
    Signal_phase=angle(hilbert(Signal_filtered));
    Spikephase=[];
    for num_Osc=1:num_Oscs
        S=min(find(peakLoc>=OscStart(1,num_Osc)));
        E=max(find(peakLoc<=OscEnd(1,num_Osc)));
        spike_phase=Signal_phase(peakLoc(S:E));
        Spikephase=[Spikephase,spike_phase];
    end
    if numel(Spikephase) > 0
        PLV.details{num_band,1}= Spikephase;
        PLV.p{num_band,1}=circ_rtest(Spikephase'); %Rayleigh test, small p indicates departure from uniformity
        PLV.phase_rad{num_band,1}=circ_mean(Spikephase'); %mean resultant vector/preferred phase
        PLV.rvl{num_band,1}= circ_r(Spikephase'); %resultant vector length/Spike_Phase
    end
end

%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'PLV',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'PLV',filesep,experiment.name));
    end
      save(strcat(Path.output,filesep,'results',filesep,'PLV',filesep,experiment.name,filesep, ...
        ['PLV' num2str(CSC)]),'PLV')
end
end




