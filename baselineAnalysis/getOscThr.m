function thr = getOscThr(signal, fs)

parameters = get_parameters;

lfp = ZeroPhaseFilter(signal, fs, parameters.FrequencyBands.LFP);
N = length(lfp);
rms = zeros(1, N);
win = 0.2 * fs;
halfwin = round(win / 2);
for i = halfwin : N - halfwin;
    rms(i) = norm(lfp(i - halfwin + 1 : i + halfwin)) / sqrt(win);
end
num_sd = parameters.osc_detection.thr_sd;   %number of standard deviations
thr = calc_noise_thresh(rms,num_sd);
end