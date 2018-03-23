function S=DeNoiseWavelet(signal)
% Xiaxia, delete noise by Wavelet transform
% Input
%      signal, column

wname='db4'; % wave that uesed
N=1;         % deep of decompose

[THR,SORH,KEEPAPP] = ddencmp('den','wp',signal);
S=wdencmp('gbl',signal, wname,N,THR,SORH,KEEPAPP) ;
