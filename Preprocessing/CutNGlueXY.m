function [CUTNGLUED]=CutNGlueXY(filt1, filt2, timestamps, fs,param)
%% Modified from Vito's script by Sabine 20.01.15,
%% Calculates coherence of continuously sampled data.
% 
% Inputs
% path: toolbox folder structure, from get_path in UMS
% PFC: structure with filtered data from PFC
% HP: structure with filtered data from HP
% oscStart: start of oscillation samples common to PFC and HP
% oscEnd: end of oscillation samples common to PFC and HP
% oscDur: duration of consecutive oscillation samples
% COH: structure for coherence and multitaper coherence values
% CUTANDGLUED: structure for concatenated windows from oscillation periods
% f: experiment number (for figure titles)
% param: from get_parameters in UMS (parameters list)
%
% Outputs
% COH: structure with coherence and multitaper coherence values
% CUTANDGLUED: structure with concatenated windows from oscillation periods
%
% Dependencies
% Chronux
%
% Christoph Lindemann 15/04/13

%% Preliminary settings
% parameters = get_parameters;
win_points=param.win_points;
% win_points = floor(parameters.coherence.windowSize.*fs); %window in samples
if mod(win_points,2) > 0  %window in samples needs to be even
    win_points = win_points + 1;
end
xn_seg = NaN(3*size(timestamps,1),win_points);
yn_seg = NaN(3*size(timestamps,1),win_points);
%% Pre-allocate structures with field names    
field_names = {'xn','yn','yn_perm'}; 
empty_cells = repmat(cell(1),1,numel(field_names));
entries = {field_names{:} ; empty_cells{:}};
CUTNGLUED = struct(entries{:});

%get no and lengths of 'multi events' - can be segments of continuous data
%such as REM or SWS, or discontinuous (e.g. spingle burst) events
[multievent_num, ~] = size(timestamps);

%calculate segments of events - as many segments as can be fitted -
%centralised, i.e. remainder cut off right and left of multi event -
%with bias to left part if remainder uneven

good_events = 0;
for ev = 1:multievent_num
    
    p_start = timestamps(ev,1);
    p_end = timestamps(ev,2);
    length_ev=p_end-p_start+1;
    
    N_windows=floor(length_ev/win_points);
    remain=mod(length_ev,win_points);
    
    if mod(remain,2) >0 % uneven
        % part at bein of multievent that is discarded
        % one sample shorter than the discarded part a the end
        remain=remain-1;
    end
    
    for ii=1:N_windows
        seg_start=p_start+remain/2+(ii-1)*win_points;
        if seg_start > 0
            good_events = good_events + 1;
            
            % Get segments
            lfpSegX = filt1(seg_start:seg_start+win_points-1);
            lfpSegY = filt2(seg_start:seg_start+win_points-1);
            
            % Detrend
            xn_seg(good_events,:) = lfpSegX - mean(lfpSegX);
            yn_seg(good_events,:) = lfpSegY - mean(lfpSegY);
    
        end
    end % Windowed one event
end % Windowed many events

%% Method of Halliday to get and glue data windows    
% Determine size of data vector.
% pts_tot=length(PFC.data);
% Check that input vectors are equal length.
% if (length(HP.data)~=pts_tot) 
%     error (' Unequal length data arrays');
% end
% 
% % Set power for segment length as 10.
% % Thus T=2^10 = 1024.
% seg_pwr=12;
% 
% [nrow,ncol]=size(oscStart);
% if (ncol~=1)
%   error(' Input NOT single column: oscStart')
% end
% [nrow,ncol]=size(oscDur);
% if (ncol~=1)
%   error(' Input NOT single column: oscDur')
% end
% if (min(oscStart)<1)
%   error(' Type 1 - Negative or zero oscStart')
% end
% if (min(oscDur)<1)
%   error(' Type 1 - Negative or zero oscDur')
% end
% if (length(oscStart) ~= length(oscDur))
%   error(' Type 1 - Unequal numbers of oscStart, oscDur')
% end
% if (max(oscStart>pts_tot))
%   error(' Type 1 - oscStart exceed data length')
% end
% if (max(oscStart+oscDur)-1>pts_tot)
%   error(' Type 1 - oscStart+oscDur exceed data length')
% end
% if (max(size(fs)) ~= 1)
%   error(' Type 1 - Non scalar value for: fs');
% end
% if (max(size(seg_pwr)) ~= 1)
%   error(' Type 1 - Non scalar value for: seg_pwr');
% end
% % DFT segment length (S).
% seg_size=2^seg_pwr;
% % Define minimum percentage of data points allowed in each segment.
% seg_min=0.05;
% % Convert to minimum number of data points.
% seg_samp_min=round(seg_min*seg_size);
% % Counts number of segments in analysis.
% seg_tot=0;
% % Counts number of samples  in analysis.
% samp_tot=0;
% % No offset values for type 1 analysis.
% offset=0;           
% for ind=1:length(oscStart)  % Loop through all trigger times.
%   seg_start_offset=0;         % Offset within each block of data.
%   while ((oscDur(ind)-seg_start_offset)>=seg_samp_min)
%     seg_tot=seg_tot+1;        % Additional segment in this block.
%     seg_samp_start(seg_tot,1)=oscStart(ind)+seg_start_offset;
% %   Start of segment.
%     if ((oscDur(ind)-seg_start_offset)>seg_size)
% %     Data for complete segment.
%       seg_samp_no(seg_tot,1)=seg_size;                        
%     else
% %     Data for part segment only.
%       seg_samp_no(seg_tot,1)=oscDur(ind)-seg_start_offset;  
%     end
% %   Update number of samples.
%     samp_tot=samp_tot+seg_samp_no(seg_tot,1);
% %   Update start offset in block.
%     seg_start_offset=seg_start_offset+seg_samp_no(seg_tot,1); 
%   end
% end
% 
% % Create data matrices, S rows, L columns.
% xn_seg=zeros(seg_size,seg_tot);
% yn_seg=zeros(seg_size,seg_tot);
% 
% % de-trend
% trend_x=(1:seg_size)';
% % Loop across all offset values.
% for ind_off=1:length(offset)
% % Loop across columns/segments.
%   for ind=1:seg_tot
% %   No of data points in segment.
%     seg_pts=seg_samp_no(ind);
% %   Start sample in data vector.
%     seg_start=seg_samp_start(ind)+offset(ind_off);
% %   Stop  sample in data vector.
%     seg_stop=seg_start+seg_pts-1;
% %   Extract segment from dat1.                   
%     dat_seg1=PFC.data(seg_start:seg_stop);
% %   Extract segment from dat2.
%     dat_seg2=HP.data(seg_start:seg_stop);
% %   Mean of segment from dat1.
%     md1=mean(dat_seg1);
% %   Mean of segment from dat2.
%     md2=mean(dat_seg2);                             
% 
%     xn_seg(1:seg_pts,ind)=dat_seg1-md1; % Subtract mean from ch 1.
%     yn_seg(1:seg_pts,ind)=dat_seg2-md2; % Subtract mean from ch 2.
% %   Fit 1st order polynomial.
%     p = polyfit(trend_x(1:seg_pts,1),xn_seg(1:seg_pts,ind),1);
% %   Subtract from ch 1.
%     xn_seg(1:seg_pts,ind) = ...
%     xn_seg(1:seg_pts,ind)-p(1)*trend_x(1:seg_pts,1)-p(2);
% %   Fit 1st order polynomial.
%     p = polyfit(trend_x(1:seg_pts,1),yn_seg(1:seg_pts,ind),1);
% %   Subtract from ch 2.
%     yn_seg(1:seg_pts,ind) = ...
%     yn_seg(1:seg_pts,ind)-p(1)*trend_x(1:seg_pts,1)-p(2);
%   end

%% Check if minimum number of windows for calculations is reached
NWindows=good_events;
if NWindows<param.minwindowN
    fig1=[]; %#ok<NASGU>
    fig2=[]; %#ok<NASGU>
else    
    
    %% Permutation of segments in yn for shuffled coherence
    xn = NaN(1,NWindows.*win_points);
    yn = NaN(1,NWindows.*win_points);
    yn_perm = NaN(1,NWindows.*win_points);
    randperm_indexes = randperm(NWindows);

    %% Loop through events
    for ii = 1:NWindows
         xn((win_points*(ii-1)+1):(win_points*ii)) = xn_seg(ii,:);
         yn((win_points*(ii-1)+1):(win_points*ii)) = yn_seg(ii,:);
         yn_perm((win_points*(ii-1)+1):(win_points*ii)) = ...
         yn_seg(randperm_indexes(ii),:);
    end % End loop through events

    %% Save concatenated windows from shared
    % oscillation periods into structure
    CUTNGLUED.xn = xn;
    CUTNGLUED.yn = yn;
    CUTNGLUED.yn_perm = yn_perm;
    CUTNGLUED.NWindows = NWindows;
    
end % End check for minimum window number    
    
end % End of CutNGluedXY