function [S,f_A]=FFT_kaksi(ungefiltert,samplingrate,oscStart,oscEnd,osc)
% für gefilterte Spur
% lfp=filtern(ungefiltert,samplingrate,[2,100]);
% lfp=lfp';

%Whitening
% wungefiltert=WhitenSignal(ungefiltert);
% lfp=wungefiltert;

% %für ungefilterte Spur
lfp=ungefiltert';









lfp=lfp(oscStart(osc):oscEnd(osc));
%lfp noise
% lfp=lfp(oscEnd(osc):oscEnd(osc)+oscEnd(osc)-oscStart(osc));
% lfp=lfp(1:1+oscEnd(osc)-oscStart(osc));
windowlength=1;
Frequency=samplingrate;

% hamwin=hamming(length(lfp));
% h_lfp=lfp.*hamwin;


n=0;
for i=1:0.01*samplingrate:length(lfp)-windowlength*samplingrate;
    n=n+1;
    Rohdaten_gefiltertA=lfp(round(i):round(i+windowlength*samplingrate));
    hamwin=hamming(length(Rohdaten_gefiltertA));
    Rohdaten_gefiltertA=Rohdaten_gefiltertA.*hamwin;




nFFTA = 8*(2^(nextpow2(length(Rohdaten_gefiltertA))));
NumUniquePtsA = ceil((nFFTA+1)/2);
f_A = (0:NumUniquePtsA-1)*Frequency/nFFTA;
            
FFT_Rohdaten_gefiltertA = fft(Rohdaten_gefiltertA,nFFTA) ;
FFT_Rohdaten_gefiltertA = FFT_Rohdaten_gefiltertA(1:NumUniquePtsA);
FFT_Rohdaten_gefiltertA_Ampl = abs(FFT_Rohdaten_gefiltertA)/length(Rohdaten_gefiltertA);
FFT_Rohdaten_gefiltertA_Power = (FFT_Rohdaten_gefiltertA_Ampl.^2);
if rem(nFFTA, 2)
FFT_Rohdaten_gefiltertA_Power(2:end) = FFT_Rohdaten_gefiltertA_Power(2:end)*2;
else
FFT_Rohdaten_gefiltertA_Power(2:end -1) = FFT_Rohdaten_gefiltertA_Power(2:end -1)*2;
end

S(n,:)=FFT_Rohdaten_gefiltertA_Power;

end

S=mean(S,1);
% figure
% hold on
% % plot(f_A,FFT_Rohdaten_gefiltertA_Power)
% plot(f_A,S,'k--')
% xlim([0,50])