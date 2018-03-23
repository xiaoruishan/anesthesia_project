function [cutandglued, Nwindows]=CutNGlueX(signalRaw,samplingrate, oscStart,oscEnd,WindowSize)
parameters = get_parameters;
%written by S.Gretenkord 10.02.14
%to cut and glue a signal with REM or SWS or discont events, 
%in this version, severel segments from each event are included(as many as can be fitted, 
%starting from the middle, and chopping off the end).
%note that analysis like pwelch or coherence shouls be performed with the
%same window length as the cutting ang glueing.

%
%Inputs:
%data: unfiltered LFP
%CSC.oscStart: start of oscillation
%CSC.oscEnd: end of oscillation
%parameters such as sampling rate and window length in second and min
%window number needed to include data for later analysis.
%
timestamps = [oscStart;oscEnd];
timestamps = timestamps';
% cutandglued = data(timestamps(1,1):timestamps(2,1));
% 
% for ii = 2:length(timestamps)
% cutandglued = horzcat(cutandglued, data(timestamps(1,ii):timestamps(2,ii)));
% end

%Outputs:
%cutandglued: structure with  chopped and glued signals,
%Nwindows: number of windows that could be cut and glued for the given
%signal


%get no and lengths of 'multi events' - can be segments of continuous data
%such as REM or SWS, or discontinuous (e.g. spindle burst) events
[multievent_num, col] = size(timestamps);

win_points = floor(WindowSize.*samplingrate); %window in samples

if mod(win_points,2) > 0  %window in samples needs to be even
    win_points = win_points + 1;
end

%calculate segments of events - as many segments as can be fitted -
%centralised, i.e. remainder cut off right and left of multi event -
%with bias to left part if remainder uneven

xn_seg=[];
xn_seg_detrend=[];
good_events = 0;

for ev = 1:multievent_num
    
    p_start = floor(timestamps(ev,1));
    p_end = floor(timestamps(ev,2));
    length_ev=p_end-p_start+1;
    
    N_windows=floor(length_ev/win_points);
    remain=mod(length_ev,win_points);
    
    if mod(remain,2) >0 %uneven
        remain=remain-1; %part at begin of multievent that is discarded one sample shorter than the discarded part a the end
    end
    
    for ii=1:N_windows
        seg_start=p_start+remain/2+(ii-1)*win_points;
        if seg_start > 0 % && seg_start+win_points-1<=length(data)
            good_events = good_events + 1;
            
             %get segments
             lfpSegX= signalRaw(seg_start:seg_start+win_points-1);
            
             %create cut and glued trace
             xn_seg(good_events,:) = lfpSegX ;
             
             %detrended
             xn_seg_detrend(good_events,:) = lfpSegX - mean(lfpSegX);
        end
    end %windowed one event
end %windowed many events

Nwindows=size(xn_seg,1);
% if isempty(xn_seg) || Nwindows<minwindowN %set min window number in parameters
%     cutandglued=[];
% else
    xn = [];
    xn_detrend = [];
    for ii = 1:good_events
        xn = [xn xn_seg(ii,:)];
        xn_detrend = [xn_detrend xn_seg_detrend(ii,:)];
    end
    cutandglued.xn=xn;
    cutandglued.xndetrend= xn_detrend;
    cutandglued.Nwindows=Nwindows;
% end 
 
    
end



