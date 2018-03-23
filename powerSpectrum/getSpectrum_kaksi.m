function [pxx_osc, f_osc] = getSpectrum_kaksi(signal,samplingrate,oscStart,oscEnd)
signalLFP = ZeroPhaseFilter(signal,samplingrate,[4 100]);
for osc=1:length(oscStart)
[pxx_osc(osc,:),f_osc]=FFT_kaksi(signalLFP,samplingrate,oscStart,oscEnd,osc);
end
end