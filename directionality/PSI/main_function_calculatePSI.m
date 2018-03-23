function [psi_all] = main_function_calculatePSI(Experiment,Path,freqband)
%written by Sabine Gretenkord - last modified 24.10.2016

%Loads Neuralynx (.ncs) data: two selected channels (PL and HP),
%Downsamples after appropriate filtering (Nyquist frequency)
%Filters the signal so that the output can be considered LFP data (<300 Hz)
%Saves data in the 'Temp' folder

%required functions: load_nlx,filter_downsample,ZeroPhaseFilterZeroPadding
%found here: Q:\directionality meeting\Scripts\LoadFilterDownsample

for iExperiment=1:length(Experiment)
    
    Experiment(iExperiment).chan_num{1}= Experiment(iExperiment).PLchoice;
    Experiment(iExperiment).chan_num{2}= Experiment(iExperiment).HPchoice;
    
    
    for iChan=1:2
        if Experiment(iExperiment).chan_num{iChan}~=0
            
            %load LFP
            thisChannel=Experiment(iExperiment).chan_num{iChan};
            File= strcat(Path.temp,filesep,'nlx_load_LFP',filesep,Experiment(iExperiment).name,...
                filesep,'CSC',num2str(thisChannel),'.mat')
            LFP{iChan}=  load(File) ;
            
            %segment entire LFP
            winLength=LFP{iChan}.fs;
            remainder=mod(  length(LFP{1}.Samples)  ,winLength);
            Samples_cut=LFP{1}.Samples(1: length(LFP{1}.Samples)-remainder);
            LFP{iChan}.Samples_segmented=reshape(  Samples_cut,[], winLength)';
            
            %cut and glue of oscillatory periods
            %load simultanous oscillations
            load( strcat(Path.output,filesep,'simOsc',filesep,Experiment(iExperiment).name,'.mat') )
            
            %cut and glu
            param.minwindowN=50;
            param.filterdata=0;
            param.win_sec=1;
            param.fs=LFP{iChan}.fs;
            
            LFP_onechan= LFP{iChan}.Samples;
            timestamps_samp= simOsc_StartEnd_samp;
            
            [cagOut,Nwindows,winpoints]=...
                cutandglue_forDirectionality(param, LFP_onechan,  timestamps_samp);
            LFP{iChan}.Samples_cutandglued=cagOut.xndetrend';
                       
        end
    end

    %     %PSI on entire trace - segmented data
    %     %reformat data for psi cohen
    %     clear data
    %     data(1,:,:)=LFP{1}.Samples_segmented;
    %     data(2,:,:)=LFP{2}.Samples_segmented;
    %
    %     permtest=0
    %     psi=data2psiX(data, LFP{1}.fs,[4 30],permtest)
    
    
    %PSI on cut and glue signal
    %reformat data for psi cohen
    clear data
    data(1,:,:)=LFP{1}.Samples_cutandglued;
    data(2,:,:)=LFP{2}.Samples_cutandglued;
    
    permtest=1
    psi=data2psiX(data,param.fs,freqband,permtest)
    psi_all(iExperiment)=psi(1,2);
    
    clearvars -except Experiment iExperiment Path freqband psi_all
    
end

end

permtest = 1;
psi=data2psiX(data,3200,[40 60],permtest);
psi_all(iExperiment)=psi(1,2);



