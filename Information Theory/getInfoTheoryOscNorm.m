function getInfoTheoryOscNorm(time, signal1, signal2, fs, experiment, save_data, CSC)

parameters=get_parameters;
path = get_path;
freq_bands = 1:2:49;

load(strcat(path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6)';

param.win_points = floor(parameters.coherence.windowSize.*fs);
param.minwindowN = 1;
[cutnglued] = CutNGlueXY(signal1, signal2, oscTimes, fs, param);

DiffEnt1 = zeros(cutnglued.NWindows, numel(freq_bands) - 1); DiffEnt2 = DiffEnt1; RenyiEnt1 = DiffEnt1; 
RenyiEnt2 = DiffEnt1; MutInfoHist = DiffEnt1; MutInfoKernel = DiffEnt1; MutInfoDiff = DiffEnt1;

for freq_idx = 1 : length(freq_bands) - 1
    LFP1 = ZeroPhaseFilter(cutnglued.xn, fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)])';
    LFP1 = (LFP1 - mean(LFP1)) ./ std(LFP1);
    LFP1 = reshape(LFP1, [], cutnglued.NWindows);
    LFP2 = ZeroPhaseFilter(cutnglued.yn, fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)])';
    LFP2 = (LFP2 - mean(LFP2)) ./ std(LFP2);
    LFP2 = reshape(LFP2, [], cutnglued.NWindows);
    for n_window = 1 : cutnglued.NWindows
        RenyiEnt1(n_window, freq_idx) = renyi_entropy_lps(LFP1(:, n_window)');
        RenyiEnt2(n_window, freq_idx) = renyi_entropy_lps(LFP2(:, n_window)');
        DiffEnt1(n_window, freq_idx) = differential_entropy_kl(LFP1(:, n_window)');
        DiffEnt2(n_window, freq_idx) = differential_entropy_kl(LFP2(:, n_window)');
        MutInfoHist(n_window, freq_idx) = mi(LFP1(:, n_window), LFP2(:, n_window));
        MutInfoKernel(n_window, freq_idx) = kernelmi(LFP1(:, n_window)', LFP2(:, n_window)');
        MutInfoDiff(n_window, freq_idx) = mutual_information(LFP1(:, n_window)', LFP2(:, n_window)');
    end
end

InfoTheory = struct;
InfoTheory.DiffEnt1 = DiffEnt1;
InfoTheory.DiffEnt2 = DiffEnt2;
InfoTheory.RenyiEnt1 = RenyiEnt1;
InfoTheory.RenyiEnt2 = RenyiEnt2;
InfoTheory.MutInfoHist = MutInfoHist;
InfoTheory.MutInfoKernel = MutInfoKernel;
InfoTheory.MutInfoDiff = MutInfoDiff;

if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    if ~exist(strcat(path.output,filesep,'results',filesep,'InfoTheoryNorm',filesep,experiment.name));
        mkdir(strcat(path.output,filesep,'results',filesep,'InfoTheoryNorm',filesep,experiment.name));
    end
    save(strcat(path.output,filesep,'results',filesep,'InfoTheoryNorm',filesep,experiment.name,filesep,num2str(CSC)),'InfoTheory')
end
end
