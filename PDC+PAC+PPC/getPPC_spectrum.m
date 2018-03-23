function PPC=getPPC_spectrum(experiment,LFP,MUA,fs,downsampling_factor,time,threshold,CSC,save_data)
% by Mattia
Path=get_path;
bands = linspace(0,100,51);
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
    num_bands=size(bands,2);
    for num_band=1:num_bands-1
        band=bands(num_band:num_band+1);
        Signal_filtered=ZeroPhaseFilter(LFP,fs,band);
        Signal_phase=angle(hilbert(Signal_filtered));
        Spikephase=[];
        for num_Osc=1:num_Oscs
            S=min(find(peakLoc>=OscStart(1,num_Osc))); %
            E=max(find(peakLoc<=OscEnd(1,num_Osc))); %
            spike_phase=Signal_phase(peakLoc(S:E));
            Spikephase=[Spikephase,spike_phase]; %
        end
        SpikephaseMatrix = repmat(Spikephase,length(Spikephase),1);
        DotProd=cos(SpikephaseMatrix-SpikephaseMatrix');
        DotProd(logical(eye(size(DotProd))))=0; SumDotProd=sum(sum(DotProd));
        PPC_Spectrum(1,num_band)=SumDotProd/(length(Spikephase)*(length(Spikephase)-1));       
    end
else
    PPC_Spectrum(1,1:size(bands))=NaN;
end
%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'PPC_Spectrum',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'PPC_Spectrum',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'PPC_Spectrum',filesep,experiment.name,filesep, ...
        ['PPC_Spectrum' num2str(CSC)]),'PPC_Spectrum')
end
end