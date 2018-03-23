function pacwin= PAC_computation(signal_freq,signal_amp,rangePhase,rangeAmplitude,cross,measure,fs,Merge_num)
%written by Xiaxia

% Input
%band---used for load the signal
%rangePhase: range of frequencies for low signal; for example 1:1:20
%rangeAmplitude: range of frequencies for high signal; for example
%  30:2:200
%cross--region, 'aa','ab','ba','bb'
%measure to be used - it should be: 'esc', 'mi' or 'cfc';
%fs-sampling frequency
%Merge_num, at least 40s, so if the segment=1s, need to merge 40 segments.

% Output
%pacwin.pacmat=pacmat;
%pacwin.freqvec_ph---the phase frequency band;
%pacwin.freqvec_amp---the amplitude frequency band;
%pacwin.shf_data_mean---shuffle mean;
%pacwin.shf_data_std----shuffle std;
%pacwin.relat_mi-----Zscore of the pac.pacmat
segs=size(signal_freq,1);
Merge_segs=floor(2*segs/Merge_num-1);
for Merge_seg=1:Merge_segs
    Tem=floor(Merge_seg-1)*Merge_num/2+1:(Merge_seg+1)*Merge_num/2;
    if strcmp(cross,'aa')
        X1=signal_freq(Tem,:);
        X2=signal_freq(Tem,:);
    end
    if strcmp(cross,'ab')
        X1=signal_freq(Tem,:);
        X2=signal_amp(Tem,:);
    end
    if strcmp(cross,'ba')
        X2=signal_freq(Tem,:);
        X1=signal_amp(Tem,:);
    end
    if strcmp(cross,'bb')
        X1=signal_amp(Tem,:);
        X2=signal_amp(Tem,:);
    end
    pacwin{Merge_seg}=find_pac_shf_several_CutGlue_segs(X2,fs,measure,X1,rangePhase,rangeAmplitude);
end
end

