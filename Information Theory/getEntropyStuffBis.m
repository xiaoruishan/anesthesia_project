function getEntropyStuffBis(signal1, signal2, fs, experiment, save_data, CSC)
path = get_path;

freq_bands = 1:2:49;

DiffEnt1 = zeros(numel(freq_bands), 1); DiffEnt2 = DiffEnt1; RenyiEnt1 = DiffEnt1; RenyiEnt2 = DiffEnt1;

for freq_idx = 1:length(freq_bands)-1
    LFP1 = ZeroPhaseFilter(signal1, fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)]);
    LFP2 = ZeroPhaseFilter(signal2, fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)]);
    RenyiEnt1(freq_idx) = renyi_entropy_lps(LFP1);
    RenyiEnt2(freq_idx) = renyi_entropy_lps(LFP2);
    DiffEnt1(freq_idx) = differential_entropy_kl(LFP1);
    DiffEnt2(freq_idx) = differential_entropy_kl(LFP2);
end

EntropyStuff = struct;
EntropyStuff.DiffEnt1 = DiffEnt1;
EntropyStuff.DiffEnt2 = DiffEnt2;
EntropyStuff.RenyiEnt1 = RenyiEnt1;
EntropyStuff.RenyiEnt2 = RenyiEnt2;

if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    if ~exist(strcat(path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name));
        mkdir(strcat(path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name));
    end
    save(strcat(path.output,filesep,'results',filesep,'EntropyStuff',filesep,experiment.name,filesep,num2str(CSC)),'EntropyStuff')
end
end
