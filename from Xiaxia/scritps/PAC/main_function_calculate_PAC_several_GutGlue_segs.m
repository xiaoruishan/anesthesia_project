function pacwin= main_function_calculate_PAC_several_GutGlue_segs(Experiment,Path,band,rangePhase,rangeAmplitude,cross,measure,fs,Merge_num)
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

th_r=2;flag_signal='xndetrend';
for iExperiment=1:length(Experiment)
    iExperiment
    filename=Experiment(iExperiment).name
    Experiment(iExperiment).chan_num{1}= Experiment(iExperiment).PL;
    Experiment(iExperiment).chan_num{2}= Experiment(iExperiment).HPreversal;
    PFCChannel=Experiment(iExperiment).chan_num{1};
    HPChannel=Experiment(iExperiment).chan_num{2};
    
    %%%%%%%%% load cut glued signal
   
    PFC_filtered=load(strcat(Path.temp,'\cutandglued_fs_',num2str(fs),'_',num2str(band(1)),'_',num2str(band(2)),'_thr',num2str(th_r),'\',filename,'\CSC',num2str(PFCChannel),'.mat'));
    HP_filtered=load(strcat(Path.temp,'\cutandglued_fs_',num2str(fs),'_',num2str(band(1)),'_',num2str(band(2)),'_thr',num2str(th_r),'\',filename,'\CSC',num2str(HPChannel),'.mat'));
    
    HP=eval(strcat('HP_filtered.cutandglued_signal.',flag_signal));
    PFC=eval(strcat('PFC_filtered.cutandglued_signal.',flag_signal));
    segs=size(HP,1);
    Merge_segs=floor(2*segs/Merge_num-1);
    for Merge_seg=1:Merge_segs
        %Tem=(Merge_seg-1)*Merge_num+1:Merge_seg*Merge_num;
        Tem=floor(Merge_seg-1)*Merge_num/2+1:(Merge_seg+1)*Merge_num/2;
    if strcmp(cross,'aa')
        X1=HP(Tem,:);
        X2=HP(Tem,:);
    end
    if strcmp(cross,'ab')
        X1=HP(Tem,:);
        X2=PFC(Tem,:);
    end
    if strcmp(cross,'ba')
        X2=HP(Tem,:);
        X1=PFC(Tem,:);
    end
    if strcmp(cross,'bb')
        X1=PFC(Tem,:);
        X2=PFC(Tem,:);
    end
    pacwin{iExperiment,Merge_seg}=find_pac_shf_several_CutGlue_segs(X2,fs,measure,X1,rangePhase,rangeAmplitude);    
    end
    %pacwin=relat_shaf_win(pacwin{iExperiment});
end

