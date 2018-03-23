function getEntropyStuffOscbyOsc(time, signal1, signal2, fs, experiment, save_data, CSC)

parameters = get_parameters;
Path = get_path;
windowSize = parameters.powerSpectrum.windowSize;
freq_bands = 2:1:49;

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);

signalGlued1 = CutNGlueX(signal1,fs,oscTimes(1,:),oscTimes(2,:),windowSize);
signalGlued2 = CutNGlueX(signal2,fs,oscTimes(1,:),oscTimes(2,:),windowSize);

if numel(signalGlued2.xndetrend)==0
    signalOsc1=signal1;
    signalOsc2=signal2;
    n_windows=floor(length(signalOsc1)/(fs*parameters.powerSpectrum.windowSize));
    signalOsc1=signalOsc1(1:n_windows*fs*parameters.powerSpectrum.windowSize);
    signalOsc1=reshape(signalOsc1,n_windows,length(signalOsc1)/n_windows);
    signalOsc2=signalOsc2(1:n_windows*fs*parameters.powerSpectrum.windowSize);
    signalOsc2=reshape(signalOsc2,n_windows,length(signalOsc2)/n_windows);
else
    signalOsc1=reshape(signalGlued1.xndetrend,signalGlued1.Nwindows,length(signalGlued1.xndetrend)/signalGlued1.Nwindows);
    signalOsc2=reshape(signalGlued2.xndetrend,signalGlued2.Nwindows,length(signalGlued2.xndetrend)/signalGlued2.Nwindows);
    n_windows=signalGlued1.Nwindows;
end

CondEnt1 = zeros(n_windows, numel(freq_bands), 21); Ent1 = CondEnt1; MutualInfo1 = CondEnt1;
CondEnt2 = CondEnt1; Ent2 = CondEnt1; MutualInfo2 = CondEnt1;

for window=1:n_windows
    delay_idx = 0;
    for delay = 0:1:20
        delay_idx = delay_idx+1;
        for freq_idx = 1:length(freq_bands)-1
            LFP1 = round(ZeroPhaseFilter(signalOsc1(window,:), fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)]));
            LFP2 = round(ZeroPhaseFilter(signalOsc2(window,:), fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)]));
            CondEnt1(window, freq_idx, delay_idx) = condEntropy(LFP1(1+delay:end), LFP2(1:end-delay));
            CondEnt2(window, freq_idx, delay_idx) = condEntropy(LFP2(1+delay:end), LFP1(1:end-delay));
            Ent1(window, freq_idx, delay_idx) = entropy(LFP1);
            Ent2(window, freq_idx, delay_idx) = entropy(LFP2);
            MutualInfo1(window, freq_idx, delay_idx) = nmi(LFP1(1+delay:end), LFP2(1:end-delay));
            MutualInfo2(window, freq_idx, delay_idx) = nmi(LFP2(1+delay:end), LFP1(1:end-delay));
        end
    end
end

CondEnt2 = squeeze(mean(CondEnt2));
Ent2 = squeeze(mean(Ent2));
MutualInfo2 = squeeze(mean(MutualInfo2));
CondEnt1 = squeeze(mean(CondEnt1));
Ent1 = squeeze(mean(Ent1));
MutualInfo1 = squeeze(mean(MutualInfo1));

EntropyStuff = struct;
EntropyStuff.ConditionalEntropy = horzcat(CondEnt1, CondEnt2);
EntropyStuff.Entropy = horzcat(Ent1, Ent2);
EntropyStuff.MutualInformation = horzcat(MutualInfo1, MutualInfo2);

if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    if ~exist(strcat(Path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name,filesep,num2str(CSC)),'EntropyStuff')
end
end
