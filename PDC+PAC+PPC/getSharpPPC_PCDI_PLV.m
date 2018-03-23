function PPC=getSharpPPC_PCDI_PLV(experiment,LFP,bands,fs,downsampling_factor,save_data,animal)
% written by Mattia, 11.04.2017
% 
%% input:
%       signalLFP----entire signal, no need to cut&glue oscillations
%       signalSpike---without downsampling
%       bands----LFP frquency bands at which you want to calculate the PPC, for example [4 12;12 30;30 48; 52 100]
%       fs---sampling frequency for the signalSpike
%       downsampling_factor---at which signalLFP is downsampled relative to signalSpike(es. 10)
%       threshold---- for spike detection, for example 5

% output:
%      PPC
%
path=get_path;
%% load oscillation vectors, and cut and glue the signal

load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_sharptimepoints1'))
% if animal>600
%     load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_SpikeTimes'))
% else
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'5std_SpikeTimesHP'))
    SpikeTimes=SpikeTimesHP;
% end
    
peakLoc=round(SpikeTimes{1,1}{3,1}/downsampling_factor);
peakLoc(find(peakLoc==0))=1;
peakLoc(2,:)=[];

clearvars signalSpike
[num_bands,~]=size(bands);
half_window=160;
for num_band=1:num_bands
    band=bands(num_band,:);
    Signal_filtered=ZeroPhaseFilter(LFP,fs/downsampling_factor,band);
    Signal_phase=angle(hilbert(Signal_filtered));
    Spikephase=[]; %"big vector" for phases corresponding to the spikes
    for SWR=1:size(sharptimepoints,2)
        S=min(find(peakLoc>=sharptimepoints(SWR)-half_window)); % first spike of the oscillation
        E=max(find(peakLoc<=sharptimepoints(SWR)+half_window)); %last spike of the oscillation
        spike_phase=Signal_phase(peakLoc(S:E));
        Spikephase=[Spikephase,spike_phase]; %adds to the "big vector" of phase, the one of the specific oscillation
    end
    SpikephaseMatrix = repmat(Spikephase,length(Spikephase),1);
    PopulationAngularDistance = sum(sum(mod(abs(SpikephaseMatrix-SpikephaseMatrix'),pi)))...
        /(length(Spikephase)*(length(Spikephase)-1));
    PCDI(1,num_band) = (pi-2*PopulationAngularDistance)/pi;
    DiffPhaseMatrix=mod(abs(SpikephaseMatrix-SpikephaseMatrix'),pi);
    CosDiffPhaseMatrix=cos(DiffPhaseMatrix);   
    PPC(1,num_band) =(sum(sum(CosDiffPhaseMatrix))-length(Spikephase))/(length(Spikephase)*(length(Spikephase)-1));
    if numel(Spikephase)>0
        savePLV=1;
        PLV.details{num_band,1}= Spikephase;
        PLV.p{num_band,1}=circ_rtest(Spikephase'); %Rayleigh test, small p indicates departure from uniformity
        PLV.phase_rad{num_band,1}=circ_mean(Spikephase'); %mean resultant vector/preferred phase
        PLV.rvl{num_band,1}= circ_r(Spikephase'); %resultant vector length/Spike_Phase
    else
        savePLV=0;
    end
end
%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name));
        mkdir(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name));
    end
    
    if ~exist(strcat(path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name));
        mkdir(strcat(path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name));
    end
    save(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name,filesep, ...
        'sharpPPC_5std'),'PPC')
    save(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name,filesep, ...
        'sharpPCDI_5std'),'PCDI')
    if savePLV==1
        save(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name,filesep, ...
        'sharpPLV_5std'),'PLV')
    end
end
end