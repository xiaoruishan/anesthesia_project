function [oscStart, oscEnd] = detection_discont_events_awa(signal,fs,thr)
%detection using root-mean-square and gaussian noise fitting

parameters = get_parameters;

%% root-mean-square
lfp = ZeroPhaseFilter(signal,fs,parameters.FrequencyBands.LFP);
N = length(lfp);
rms = zeros(1,N);
win = 0.2*fs;
halfwin = round(win/2);

for i = halfwin : N-halfwin;
    rms(i) = norm(lfp(i-halfwin+1:i+halfwin))/sqrt(win);
end


%% calculate threshold and detect oscillations
osc = rms > thr;
osc([1,end]) = 0;

%% combine if short interval
osc_start = find(diff(osc)==1);
osc_end = find(diff(osc)==-1);
interval = (osc_start(2:end)-osc_end(1:end-1)) / fs;
for k=find(interval<parameters.osc_detection.min_interval)
    osc(osc_end(k):osc_start(k+1)) = 1;
end

%% delete if short event
osc_start = find(diff(osc)==1);
osc_end = find(diff(osc)==-1);
dur = (osc_end-osc_start) / fs;
for k = find(dur<parameters.osc_detection.min_duration)
    osc(osc_start(k):osc_end(k)) = 0;
end

%% start and end of events
oscStart = find(diff(osc)==1);
oscEnd = find(diff(osc)==-1);

end
