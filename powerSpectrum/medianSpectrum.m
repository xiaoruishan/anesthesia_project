function [spectrum, freq] = medianSpectrum(signal, windowSize, overlap, nfft, fs, maxFreq, use_mean)
%% Calculate median powerSpectrum using matlab pwelch on single windows
%       By Mattia
%       This function replaces the last step of welch's method (mean) with
%       a median ("Measuring the average power of neural oscillations",
%       Izhikevich et al., 2018)

%       INPUTS:
%       signal: ´        signal in row vector
%       windowSize:      windowSize in sec (2)
%       overlap:         overlap in sec    (0)
%       nfft:            points for FFT (es. 2048)
%       fs:              samplingfrequency
%       use_mean:        if 1 ~= welch method (mean and no median). Default
%                        is median

if nargin < 7
    use_mean = 0;
    if nargin < 6
        maxFreq = [];
    end
end

overlap = overlap * fs;
window_length = windowSize * fs;
n_windows = floor((length(signal) - 1) / window_length);

spectrum = zeros(n_windows, nfft / 2 + 1);

for window_idx = 1 : n_windows
    window = (window_idx - 1) * window_length + 1 : window_idx * window_length + 1;
    [spectrum(window_idx, :), freq] = pwelch(signal(window), hanning(window_length), ...
        overlap, nfft, fs);    
end

if n_windows > 1
    if use_mean == 1
        spectrum = mean(spectrum);
    else
        spectrum = median(spectrum);
    end
end

if ~isempty(maxFreq)
    freq = freq(freq <= maxFreq)';
    spectrum = spectrum(1 : length(freq))';
end

end