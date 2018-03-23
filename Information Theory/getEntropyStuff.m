function getEntropyStuff(signal1, signal2, fs, experiment, save_data, CSC)
%% these function is probably crap, as it is using subfunctions that were thought to be used on discrete data!!

path = get_path;
freq_bands = 2:1:49;

CondEnt1 = zeros(numel(freq_bands), 1); Ent1 = CondEnt1; MutualInfo1 = CondEnt1;
CondEnt2 = CondEnt1; Ent2 = CondEnt1; MutualInfo2 = CondEnt1;

for freq_idx = 1:length(freq_bands)-1
    LFP1 = round(ZeroPhaseFilter(signal1, fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)]));
    LFP2 = round(ZeroPhaseFilter(signal2, fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)]));
    CondEnt1(freq_idx) = condEntropy(LFP1, LFP2);
    CondEnt2(freq_idx) = condEntropy(LFP2, LFP1);
    Ent1(freq_idx) = entropy(LFP1);
    Ent2(freq_idx) = entropy(LFP2);
    MutualInfo1(freq_idx) = nmi(LFP1, LFP2);
end

EntropyStuff = struct;
EntropyStuff.CondEnt1 = CondEnt1;
EntropyStuff.CondEnt2 = CondEnt2;
EntropyStuff.Ent1 = Ent1;
EntropyStuff.Ent2 = Ent2;
EntropyStuff.MutInfo = MutualInfo1;

if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    if ~exist(strcat(path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name));
        mkdir(strcat(path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name));
    end
    save(strcat(path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name,filesep,num2str(CSC)),'EntropyStuff')
end
end
