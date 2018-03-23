function []=EnvAmpCorr(Experiment,exp_num,Path,Parameters)

%% Johanna Koastka 26.1.18
%calculates amplitude envelope correlation , phase correlation and Intersite Phase clustering
% for baseline vs. maipulation within animal, for the whole trace



band=linspace(2,50,25);
for inum=1:length(exp_num)
    f=exp_num(inum)
    
    fname{1}=Experiment(f).name1
    fname{2}=Experiment(f).name2

    for iname=1:2
    foldername=fname{iname};
    
    %% get LFP of one region and respiration
    chanOB=Experiment(f).OBchannels;
    chanLEC=Experiment(f).LECchannels;
    
   

    
    clear 'chan1LFP' 'chan2LFP' 'chan3LFP'
    
    
    clear signal_theta signal_RR signal_LFP fs
     %load first LFP
     
    load(strcat(Path.temp,filesep,'nlx_load_LFP_LPdown100',filesep,foldername,filesep,'CSC',mat2str(chanOB),'.mat'))
    fs=fsOutput;
    fs=round(fs);
    signal_LFP_OB=signal_LFP-mean(signal_LFP);
    if iname==1
        signal_LFP_OB=signal_LFP_OB(1:15*60*fs);% first 15 min of baseline signal
    elseif length(signal_LFP)/60/fs>=45
              signal_LFP_OB=signal_LFP_OB(30*60*fs:45*60*fs); % 30 to 45 min after maipulation
    else
        endTime=length(signal_LFP_OB)/60/fs; % exception if signal is shorter than 45 min
        signal_LFP_OB=signal_LFP_OB(30*60*fs:endTime*60*fs);
    end

    
    clear  signal_LFP
    load(strcat(Path.temp,filesep,'nlx_load_LFP_LPdown100',filesep,foldername,filesep,'CSC',mat2str(chanLEC),'.mat'))
    signal_LFP_LEC=signal_LFP-mean(signal_LFP);
    if iname==1
        signal_LFP_LEC=signal_LFP_LEC(1:15*60*fs);% first 15 min of baseline signal
    elseif length(signal_LFP)/60/fs>=45
              signal_LFP_LEC=signal_LFP_LEC(30*60*fs:45*60*fs); % 30 to 45 min after maipulation
    else
        endTime=length(signal_LFP)/60/fs; % exception if signal is shorter than 45 min
        signal_LFP_LEC=signal_LFP_LEC(30*60*fs:endTime*60*fs);
     end


    winpoints=3*fs;
    for iband = 1:length(band)-1
        clear chan1LFP chan2LFP chan1LFP_CAG NR1 chan2LFP_CAG NR2
        chan1LFP(iband,:)=ZeroPhaseFilter(signal_LFP_OB,fs, [band(iband) band(iband+1)]); 
        chan2LFP(iband,:)=ZeroPhaseFilter(signal_LFP_LEC,fs,[band(iband) band(iband+1)]); 
    

        %region1 - OB - oscill
        NR1=floor(length(chan1LFP(iband,:))/winpoints) ;
        chan1LFP_CAG=reshape(chan1LFP(iband,1:NR1*winpoints),[NR1, winpoints])' ;
       
        %region2 - LEC - oscill
        NR2=floor(length(chan2LFP(iband,:))/winpoints) ;
        chan2LFP_CAG=reshape(chan2LFP(iband,1:NR2*winpoints),[NR2, winpoints])' ;
   
        clear  Ampcor AmplOB AmplLEC
 
        
        for iwin=1:NR1
            [AmplOB(iwin,:),PhaseOB(iwin,:)]=hilbert_transf(chan1LFP_CAG(:,iwin));
            [AmplLEC(iwin,:),PhaseLEC(iwin,:)]=hilbert_transf(chan2LFP_CAG(:,iwin));
            Ampcor(iwin)=corr(AmplOB(iwin,:)',AmplLEC(iwin,:)','type','Spearman'); % Amplitude correlation
            Ampcor2(iwin)=corr(AmplOB(iwin,:)',AmplLEC(iwin,:)','type','Pearson');
            ISPC(iwin)=abs(mean(exp(1i*(PhaseOB(iwin,:)-PhaseLEC(iwin,:))))); %Intersite Phase clustering: Mike X. Cohen book ( he uses Wavelets though)
            Phasecorr(iwin)=corr(PhaseOB(iwin,:)',PhaseLEC(iwin,:)','type','Spearman'); %Phase correlation
            Phasecorr2(iwin)=corr(PhaseOB(iwin,:)',PhaseLEC(iwin,:)','type','Pearson');
        end
        AmpCorBand(inum,iname,iband)=mean(Ampcor);
        AmpCorBand2(inum,iname,iband)=mean(Ampcor2);
        IPSCBand(inum,iname,iband)=mean(ISPC);
        PhaseCorrBand(inum,iname,iband)=mean(Phasecorr);
        PhaseCorrBand2(inum,iname,iband)=mean(Phasecorr2);
        PLI(inum,iname,iband)=abs(mean(sign(imag(cpsd(chan1LFP(iband,:),chan2LFP(iband,:),winpoints))))); % Phase lag index. Mike X. Cohen book
    
    end
    end
end
MeanAmpCorBand=squeeze(mean(AmpCorBand,1));
STDAmpCorBand=squeeze(std(AmpCorBand,1)/sqrt(length(exp_num)));

MeanAmpCorBand2=squeeze(mean(AmpCorBand2,1));
STDAmpCorBand2=squeeze(std(AmpCorBand2,1)/sqrt(length(exp_num)));

MeanIPSC=squeeze(mean(IPSCBand,1));
STDIPSC=squeeze(std(IPSCBand,1)/sqrt(length(exp_num)));

MeanPhaseCorrBand=squeeze(mean(PhaseCorrBand,1));
STDPhaseCorrBand=squeeze(std(PhaseCorrBand,1)/sqrt(length(exp_num)));

MeanPhaseCorrBand2=squeeze(mean(PhaseCorrBand2,1));
STDPhaseCorrBand2=squeeze(std(PhaseCorrBand2,1)/sqrt(length(exp_num)));

MeanPLI=squeeze(mean(PLI,1));
STDPLI=squeeze(std(PLI,1)/sqrt(length(exp_num)));


figure
plot(band(1:end-1),MeanAmpCorBand(1,:),'b')
hold on
plot(band(1:end-1),MeanAmpCorBand(1,:)-STDAmpCorBand(1,:),'b-')
plot(band(1:end-1),MeanAmpCorBand(1,:)+STDAmpCorBand(1,:),'b-')
plot(band(1:end-1),MeanAmpCorBand(2,:),'r')
hold on
plot(band(1:end-1),MeanAmpCorBand(2,:)-STDAmpCorBand(2,:),'r-')
plot(band(1:end-1),MeanAmpCorBand(2,:)+STDAmpCorBand(2,:),'r-')
 xlabel('Frequency [Hz]')
ylabel('Amplitude envelope correlation  (Spearman)')
legend(' Baseline','' , '', 'urethan')
set(gca,'TickDir','out')


figure
plot(band(1:end-1),MeanAmpCorBand2(1,:),'b')
hold on
plot(band(1:end-1),MeanAmpCorBand2(1,:)-STDAmpCorBand2(1,:),'b-')
plot(band(1:end-1),MeanAmpCorBand2(1,:)+STDAmpCorBand2(1,:),'b-')
plot(band(1:end-1),MeanAmpCorBand2(2,:),'r')
hold on
plot(band(1:end-1),MeanAmpCorBand2(2,:)-STDAmpCorBand2(2,:),'r-')
plot(band(1:end-1),MeanAmpCorBand2(2,:)+STDAmpCorBand2(2,:),'r-')
 xlabel('Frequency [Hz]')
ylabel('Amplitude envelope correlation (Pearson)')
legend(' Baseline','' , '', 'urethan')
set(gca,'TickDir','out')

figure
plot(band(1:end-1),MeanIPSC(1,:),'b')
hold on
plot(band(1:end-1),MeanIPSC(1,:)-STDIPSC(1,:),'b-')
plot(band(1:end-1),MeanIPSC(1,:)+STDIPSC(1,:),'b-')
plot(band(1:end-1),MeanIPSC(2,:),'r')
hold on
plot(band(1:end-1),MeanIPSC(2,:)-STDIPSC(2,:),'r-')
plot(band(1:end-1),MeanIPSC(2,:)+STDIPSC(2,:),'r-')
 xlabel('Frequency [Hz]')
ylabel('Intersite phase clustering')
legend(' Baseline','' , '', 'urethan')
set(gca,'TickDir','out')

figure
plot(band(1:end-1),MeanPLI(1,:),'b')
hold on
plot(band(1:end-1),MeanPLI(1,:)-STDPLI(1,:),'b-')
plot(band(1:end-1),MeanPLI(1,:)+STDPLI(1,:),'b-')
plot(band(1:end-1),MeanPLI(2,:),'r')
hold on
plot(band(1:end-1),MeanPLI(2,:)-STDPLI(2,:),'r-')
plot(band(1:end-1),MeanPLI(2,:)+STDPLI(2,:),'r-')
 xlabel('Frequency [Hz]')
ylabel('Phase lag index')
legend(' Baseline','' , '', 'urethan')
set(gca,'TickDir','out')

figure
plot(band(1:end-1),MeanPhaseCorrBand(1,:),'b')
hold on
plot(band(1:end-1),MeanPhaseCorrBand(1,:)-STDPhaseCorrBand(1,:),'b-')
plot(band(1:end-1),MeanPhaseCorrBand(1,:)+STDPhaseCorrBand(1,:),'b-')
plot(band(1:end-1),MeanPhaseCorrBand(2,:),'r')
hold on
plot(band(1:end-1),MeanPhaseCorrBand(2,:)-STDPhaseCorrBand(2,:),'r-')
plot(band(1:end-1),MeanPhaseCorrBand(2,:)+STDPhaseCorrBand(2,:),'r-')
 xlabel('Frequency [Hz]')
ylabel('Phase correlation (Spearman)')
legend(' Baseline','' , '', 'urethan')
set(gca,'TickDir','out')

figure
plot(band(1:end-1),MeanPhaseCorrBand2(1,:),'b')
hold on
plot(band(1:end-1),MeanPhaseCorrBand2(1,:)-STDPhaseCorrBand2(1,:),'b-')
plot(band(1:end-1),MeanPhaseCorrBand2(1,:)+STDPhaseCorrBand2(1,:),'b-')
plot(band(1:end-1),MeanPhaseCorrBand2(2,:),'r')
hold on
plot(band(1:end-1),MeanPhaseCorrBand2(2,:)-STDPhaseCorrBand2(2,:),'r-')
plot(band(1:end-1),MeanPhaseCorrBand2(2,:)+STDPhaseCorrBand2(2,:),'r-')
 xlabel('Frequency [Hz]')
ylabel('Phase correlation (Pearson)')
legend(' Baseline','' , '', 'urethan')
set(gca,'TickDir','out')

end