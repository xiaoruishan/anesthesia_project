function pac = find_pac_shf_several_CutGlue_segs (SIG_pac, Fs, measure, ...
    SIG_mod, ph_freq_vec, amp_freq_vec)
% Xiaxia 
% This function calculates a matrix of PAC values using either the ESC, MI(MVL) 
% or CFC measure. 
% It uses shuffled datasets to conduct a significance analysis of the PAC
% values found

% INPUTS:
%  sig_pac - high frequency,several cut-glue row signals; 
%  Fs - sampling frequency;
%  measure - measure to be used - it should be: 'esc', 'mi' or 'cfc';
%  SIG_mod - low frequency,several cut-glue row signal;
%  ph_freq_vec - range of frequencies for low signal; for example 1:1:20
%  amp_freq_vec - range of frequencies for high signal; for example
%  30:2:200

% Output
%pac.pacmat=pacmat;
%pac.freqvec_ph---the phase frequency band;
%pac.freqvec_amp---the amplitude frequency band;
%pac.shf_data_mean---shuffle mean;
%pac.shf_data_std----shuffle std;
%pac.relat_mi-----Zscore of the pac.pacmat

% Author: Angela Onslow, May 2010

% set some paremeters: 
   waitbar = 0;%  waitbar - display progress in the command window; suggest 1 (Xiaxia)
   width = 7;%  width - width of the wavelet filter; sugguest 7 (Xiaxia)
   nfft = ceil(Fs/(diff(ph_freq_vec(1:2)))); %  nfft - the number of points in fft; 
   num_shf = 50; %  num_shf - the number of shuffled data sets to use during significancetesting; suggest 50 (Xiaxia)
   alpha = 0.05; %  alpha - significance value to use; default = 0.05 
    
% Set up some parameters for clarity
xbins = ceil((max(ph_freq_vec) - min(ph_freq_vec))/(diff(ph_freq_vec(1:2))));
ybins = ceil((max(amp_freq_vec) - min(amp_freq_vec))/(diff(amp_freq_vec(1:2))));
alpha = alpha/(xbins*ybins); % Uncomment to use Bonferonni Correction
    
   sig_pac=SIG_pac';
   sig_mod=SIG_mod';
    
% Filtering phase and amplitude and glue together to obtain a long dataset
if (strcmp(measure, 'esc')) ||(strcmp(measure, 'mi')) 
[filt_sig_mod, filt_sig_pac] =filt_signalsWAV_several_CutGlue_segs(sig_pac, sig_mod, Fs, ...
    ph_freq_vec, amp_freq_vec, measure, width);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create shuffled datasets and distribution of PAC values %%%%%%%%%%%%%%%%%
if num_shf ~= 0
if waitbar == 1
    fprintf('\nCreating shuffled data sets\n');
end
for s = 1:num_shf
    
    if strcmp(measure, 'esc')
           
        shuffled_sig_amp = shuffle_esc(filt_sig_pac, Fs);
        shf_pacmat_final(s,:,:) = find_pac_nofilt(shuffled_sig_amp, Fs, measure, filt_sig_mod, ph_freq_vec, amp_freq_vec,'n');
        
    end
     

    if strcmp(measure, 'mi')

        shuffled_sig_amp = shuffle_esc(filt_sig_pac, Fs);
        shf_pacmat_final(s,:,:) = find_pac_nofilt(shuffled_sig_amp, Fs, measure, filt_sig_mod, ph_freq_vec, amp_freq_vec,'n');
        
    end
    
    if strcmp(measure, 'cfc')
          
        shuffled_sig1 = shuffle_esc(sig_pac, Fs);
        shf_pacmat_final(s,:,:) = find_pac_nofilt(shuffled_sig1, Fs,measure, sig_mod, ph_freq_vec, amp_freq_vec,'n', 0, width, nfft);
        
    end
    
    % Display current computational step to user
    if waitbar == 1
        if s == 1
            fprintf('%03i%% ', floor((s/num_shf)*100));
        else
            fprintf('\b\b\b\b\b%03i%% ', floor((s/num_shf)*100));
        end
        if s == num_shf
            fprintf('\n');
        end
    end
end

%Find mean and standard deviation of shuffled data sets
if strcmp(measure, 'mi')
    for i =1:ybins
        for j=1:xbins
            [shf_data_mean(i,j), shf_data_std(i,j)] = normfit(shf_pacmat_final(:,i,j));
        end
    end
    
else
    shf_data_mean = squeeze (mean (shf_pacmat_final, 1));
    shf_data_std = squeeze (std (shf_pacmat_final, 1));
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate PAC measures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(measure, 'esc')
    [pacmat, freqvec_ph, freqvec_amp] = find_pac_nofilt(filt_sig_pac, Fs, measure, filt_sig_mod, ph_freq_vec, amp_freq_vec, 'n', 0);
end

if strcmp(measure, 'mi')
    [pacmat, freqvec_ph, freqvec_amp] = find_pac_nofilt(filt_sig_pac, Fs, measure, filt_sig_mod, ph_freq_vec, amp_freq_vec, 'n', 0);
end

if strcmp(measure, 'cfc')
    [pacmat, freqvec_ph, freqvec_amp] = find_pac_nofilt(sig_pac, Fs, measure, sig_mod, ph_freq_vec, amp_freq_vec, 'n', 0, width, nfft);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute significance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if num_shf ~= 0 
for i = 1:size(pacmat,1)
    for j = 1:size(pacmat,2)
        [h, p] = my_sig_test(pacmat(i,j), squeeze(shf_pacmat_final(:,i,j)), alpha);
        if h == 0
            pacmat(i,j) = 0;
        end
    end
end
pac.shf_data_mean=shf_data_mean;
pac.shf_data_std=shf_data_std;
end


pac.pacmat=pacmat;
pac.freqvec_ph=freqvec_ph;
pac.freqvec_amp=freqvec_amp;
pac=relat_shaf(pac);

