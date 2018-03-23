function R= main_function_CutGlue_nmPLV_cross(Experiment,Path,BandLow,BandHigh,nm,fs,cross,flag_phase)
%written by Xiaxia,05.01.2017
% cross frequency phase phase coupling   n:m PLV
% 
% input:
%     BandLow------low frqueny band, for example [4 12]
%     BandHigh-----high frquency band, for example [30 48]
%     nm-----------set different ratios to calculate PLV, n high signal
%                  circles in m low signal circles, usually, set
%                  n:m=1:1,2:1,3:1,... ... 20:1

%                  nm=zeros(20,2);
%                  for i=1:20
%                       nm(i,1)=i;
%                       nm(i,2)=1;
%                       end

%     fs-----------Sampling frquency
%     cros---------'aa','ab','bb','ba'
%     flag_phase---'Hilbert' or 'Wavelet', methods used to extract the
%                   phase, recommend 'Hilbert'

% output:
%     R-------R.pval, significant distribution detected by Reiley
%             R.rval, mean vector length

th_r=2;
n=size(nm,1);
for iExperiment=1:length(Experiment)
    filename=Experiment(iExperiment).name;
    
    if strcmp(cross,'aa')
        Experiment(iExperiment).chan_num{1}= Experiment(iExperiment).HPreversal; % for spike
        Experiment(iExperiment).chan_num{2}= Experiment(iExperiment).HPreversal; % for LFP
    end
    if strcmp(cross,'ab')
        Experiment(iExperiment).chan_num{1}= Experiment(iExperiment).HPreversal; % for spike
        Experiment(iExperiment).chan_num{2}= Experiment(iExperiment).PL; % for LFP
    end
    if strcmp(cross,'ba')
        Experiment(iExperiment).chan_num{1}= Experiment(iExperiment).PL;% for spike
        Experiment(iExperiment).chan_num{2}= Experiment(iExperiment).HPreversal;% for LFP
    end
    if strcmp(cross,'bb')
       Experiment(iExperiment).chan_num{1}= Experiment(iExperiment).PL;% for spike
       Experiment(iExperiment).chan_num{2}= Experiment(iExperiment).PL;% for LFP
    end
    
    % low LFPs, chan_num{1}, filtered CutGlue Signal
       SigLFP_low=load(strcat(Path.temp,'\cutandglued_fs_',num2str(fs),'_',num2str(BandLow(1)),'_',num2str(BandLow(2)),'_thr',num2str(th_r),'\',filename,'\CSC',num2str(Experiment(iExperiment).chan_num{1}),'.mat'));
       signal_low=SigLFP_low.cutandglued_signal.xn;
    
     % high LFPs, chan_num{2}, filtered CutGlue Signal  
       SigLFP_high=load(strcat(Path.temp,'\cutandglued_fs_',num2str(fs),'_',num2str(BandHigh(1)),'_',num2str(BandHigh(2)),'_thr',num2str(th_r),'\',filename,'\CSC',num2str(Experiment(iExperiment).chan_num{2}),'.mat'));
       signal_high=SigLFP_high.cutandglued_signal.xn;
       
       pval=[];rval=[];z=[];
      for seg=1:(size(signal_high,1))
          signal_low_seg=detrend(signal_low(seg,:));
          signal_high_seg=detrend(signal_high(seg,:));
          
          % extract phase
          if strcmp(flag_phase,'Hilbert')
              [~,signal_phase_low]=HilbertTransf(signal_low_seg);
              [~,signal_phase_high]=HilbertTransf(signal_high_seg);
          end
          if strcmp(flag_phase,'Wavelet')
              signal_phase_low= FiltPhaseWAV(signal_low_seg',fs, BandLow,7);
              signal_phase_low=signal_phase_low';

              signal_phase_high= FiltPhaseWAV(signal_high_seg',fs, BandHigh,7);
              signal_phase_high=signal_phase_high';
          end
          
          % calculate nmPLV
          for h=1:n
              diff_phase=nm(h,1)*signal_phase_low-nm(h,2)*signal_phase_high;
              diff_phase=mod(diff_phase,2*pi);
              
              % relay test
              [pval(h,seg),z(h,seg)]=circ_rtest(diff_phase');
              rval(h,seg)=circ_r(diff_phase');
          end
      end
      
      R.pval{iExperiment,1}=pval;
      R.rval{iExperiment,1}=rval;
      %R.z{iExperiment,1}=z;
end
          
              
              
              
              
