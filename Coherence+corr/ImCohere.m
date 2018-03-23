% imaginary coherence by Sebastian Bitzenhofer 2015, adhusted routine from
% Andreas Schulz (Magdeburg)
function [Cxy,f]=ImCohere(x1,x2,Window,noverlap,nfft,fs)

% input:
% x1 - signal 1 as vector
% x2 - signal 2 as vector (same size as x1)
% window - signals are segmented to calculate psd and csd with
% pwelch.m and cpsd.m, see pwelch
% noverlap - overlap of segments, see pwelch
% nfft - window size used for fft, see pwelch
% fs - sampling frequency
% 
% output:
% Cxy - imaginary part of coherency
% f - vector of frequencies (in hertz) at which coherency is estimated

Window = floor(Window*fs);

% calculate psd and csd
[Pxx,~] = pwelch(x1, hanning(Window), noverlap, nfft, fs); %psd
[Pyy,~] = pwelch(x2, hanning(Window), noverlap, nfft, fs); %psd
[Pxy,f] = cpsd(x1, x2, hanning(Window), noverlap, nfft, fs); %csd

% calculate coherency = complex valued coherence
%Cxy = (abs(Pxy).^2)./(Pxx.*Pyy); %Real value coherence
Cxy = Pxy./sqrt(Pxx.*Pyy); % coherency
Cxy=abs(imag(Cxy)); %imaginary part of coherency
% Cxy=imag(Cxy); %imaginary part of coherency



% Original Python script from Magdeburg
% if typ=='magnitude': #magnitude squared, not the magnitude of the pointer !!
%         cf=mlab.cohere(x1,x2, NFFT=nf, Fs=sr, noverlap=noverlap)
% 
%     elif typ=='complex':
% 
%         [Pxx,f]=mlab.psd(x1,NFFT=nf,Fs=sr,noverlap=noverlap)
%         [Pyy,f]=mlab.psd(x2,NFFT=nf,Fs=sr,noverlap=noverlap)
%         [Pxy,f]=mlab.csd(x1,x2,NFFT=nf,Fs=sr,noverlap=noverlap)
% 
%         # ist der Betrag wie cohere !!!
%         #np.absolute(Pxy**2 / (Pxx * Pyy))
% 
%         # ist korrect fuer den betrag, aber ist nicht identisch mt cohere (magnitude squared)
%         Cxy=Pxy/ np.sqrt(Pxx*Pyy) # 