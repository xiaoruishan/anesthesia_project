function PPC=getBaselinePPC_PCDI_PLV(experiment,LFP,MUA,bands,fs,downsampling_factor,time,threshold,CSC,save_data)
% by Mattia
%
% requires
%% input:
%       signalLFP----entire signal, no need to cut&glue oscillations
%       signalSpike---without downsampling
%       bands----LFP frquency bands at which you want to calculate the PPC, for example [4 12;12 30;30 48; 52 100]
%       fs---sampling frequency for the signalLFP
%       downsampling_factor---at which signalLFP is downsampled relative to signalSpike(es. 10)
%       threshold---- for spike detection, for example 5

% output:
%      PPC
%
Path=get_path;
%% load oscillation vectors, and cut and glue the signal

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));

oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);
OscStart=oscTimes(1,:);
OscEnd=oscTimes(2,:);
num_Oscs=length(OscStart);

recordingMUA = ZeroPhaseFilter(MUA,32000,[500 5000]);
thr = std(recordingMUA)*threshold;
[peakLoc,~] = peakfinderOpto(recordingMUA,thr/2,-thr,-1,false);
clearvars recordingMUA
peakLoc=round(peakLoc/downsampling_factor);
peakLoc(find(peakLoc==0))=1;
clearvars signalSpike

if numel(peakLoc)>9
    [num_bands,~]=size(bands);
    for num_band=1:num_bands
        band=bands(num_band,:);
        Signal_filtered=ZeroPhaseFilter(LFP,fs,band);
        Signal_phase=angle(hilbert(Signal_filtered));
        Spikephase=[]; %"big vector" for phases corresponding to the spikes
        for num_Osc=1:num_Oscs
            S=min(find(peakLoc>=OscStart(1,num_Osc))); % first spike of the oscillation
            E=max(find(peakLoc<=OscEnd(1,num_Osc))); %last spike of the oscillation
            spike_phase=Signal_phase(peakLoc(S:E));
            Spikephase=[Spikephase,spike_phase]; %adds to the "big vector" of phase, the one of the specific oscillation
        end
        %     MUAfiringrate = length(Spikephase); %uncomment this line if you want to have
        % the firing rate of oscillations only
        SpikephaseMatrix = repmat(Spikephase,length(Spikephase),1);
        DotProd=cos(SpikephaseMatrix-SpikephaseMatrix');
        DotProd(logical(eye(size(DotProd))))=0; SumDotProd=sum(sum(DotProd));
        PPC(1,num_band)=SumDotProd/(length(Spikephase)*(length(Spikephase)-1));
        %     PopulationAngularDistance = sum(sum(abs(SpikephaseMatrix-SpikephaseMatrix')))...
        %         /(length(Spikephase)*(length(Spikephase)-1));
        %     PCDI(1,num_band)=(pi-2*PopulationAngularDistance)/pi;
        %     DiffPhaseMatrix=abs(SpikephaseMatrix-SpikephaseMatrix');
        %     CosDiffPhaseMatrix=cos(DiffPhaseMatrix);
        %     PPC(1,num_band) =(sum(sum(CosDiffPhaseMatrix))-length(Spikephase))/(length(Spikephase)*(length(Spikephase)-1));
        
    end
else
    PPC(1,1:size(bands))=NaN;
end
%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name,filesep, ...
        ['PPC' num2str(CSC)]),'PPC')
end
end