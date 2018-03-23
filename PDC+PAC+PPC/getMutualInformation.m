function MutualInfo = getMutualInformation(signal1, signal2, fs, experiment, save_data, CSC)

Path = get_path;
freq_bands = 1:2:49;
windows = 1 : length(signal1)/10 : length(signal1);

for iwindow = 1:10
    for freq_idx = 1:length(freq_bands)-1
        signal1i = signal1(windows(iwindow) : windows(iwindow) + round(length(signal1)/10 -1));
        signal2i = signal2(windows(iwindow) : windows(iwindow) + round(length(signal2)/10 -1));
        LFP1 = ZeroPhaseFilter(signal1i, fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)]);
        LFP2 = ZeroPhaseFilter(signal2i, fs, [freq_bands(freq_idx) freq_bands(freq_idx+1)]);
        MutualInfo1(freq_idx, iwindow) = mi(LFP1', LFP2');
        MutualInfo2(freq_idx, iwindow) = kernelmi(LFP1, LFP2);
        MutualInfo3(freq_idx, iwindow) = mutual_information(LFP1, LFP2);
    end
end

MutualInfo = struct;
MutualInfo.hist = mean(MutualInfo1, 2);
MutualInfo.kernel = mean(MutualInfo2, 2);
MutualInfo.diff = mean(MutualInfo3, 2);

if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'MutualInfo',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'MutualInfo',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'MutualInfo',filesep,experiment.name,filesep,num2str(CSC)),'MutualInfo')
end
end
