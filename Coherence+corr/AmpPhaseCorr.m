function AmpPhaseCorr(signal1, signal2 , fs, experiment, CSC)

%% get some parameters
path = get_path;
band = linspace(2,48,24);
winpoints = 3 * fs;

%% 

signal1 = signal1 - mean(signal1);
signal2 = signal2 - mean(signal2);

%% initialize
Ampcor = zeros(length(band)); Phasecor = Ampcor;

%% filter and extract amplitude and phase for every band
for iband = 1:length(band)-1
    hilbert1 = hilbert(ZeroPhaseFilter(signal1, fs, [band(iband) band(iband+1)]));
    amp1 = abs(real(hilbert1));
    phase1 = atan2(imag(hilbert1), real(hilbert1));
    hilbert2 = hilbert(ZeroPhaseFilter(signal2, fs, [band(iband) band(iband+1)]));
    amp2 = abs(real(hilbert2));
    phase2 = atan2(imag(hilbert2), real(hilbert2));
    Ampcor(iband) = mean(movcorr(amp1', amp2', winpoints));
    Phasecor(iband) = mean(movcorr(abs(phase1)', abs(phase2)', winpoints));
end

%% get running Pearson correlation (one estimation per point of the signal)

AmpPhaseCor = vertcat(Ampcor, Phasecor);
%% save data

if ~exist(strcat(path.output,filesep,'results',filesep,'AmpPhaseCorr',filesep,experiment.name));
    mkdir(strcat(path.output,filesep,'results',filesep,'AmpPhaseCorr',filesep,experiment.name));
end
save(strcat(path.output,filesep,'results',filesep,'AmpPhaseCorr',filesep,experiment.name,filesep,num2str(CSC)),'AmpPhaseCor')
end