function [OscMatrix] = getMinuteOscInformation(time,signal, fs, oscStart, oscEnd)
% filter trace
parameters = get_parameters;
signalLFP = ZeroPhaseFilter(signal, fs, parameters.FrequencyBands.LFP);

oscDiff = oscEnd - oscStart;
[Ampl, ~] = HilbertTransf(signalLFP);
medianAmp = median(Ampl);

durOsc = [];
amplOsc = [];
amplOsc_max = [];
all_prop_Osc = [];

for osc = 1 : length(oscStart)
    durOsc(osc) = oscDiff(osc) / fs;
    amplOsc(osc) = median(Ampl(oscStart(osc) : oscEnd(osc)));
    amplOsc_max(osc) = max(Ampl(oscStart(osc) : oscEnd(osc)));
    all_prop_Osc(osc,:) = [durOsc(osc), amplOsc(osc), amplOsc_max(osc)];
end


medianDurOsc = 0;
medianAmplOsc = 0;
medianAmplOsc_max = 0;
occurrenceOsc = 0;

if ~isempty(durOsc)

    medianDurOsc = median(durOsc);
    medianAmplOsc = median(amplOsc);
    medianAmplOsc_max = median(amplOsc_max);
    durRecording = (length(time) / fs) / 60;    %minutes
    occurrenceOsc = length(oscStart) / durRecording;
    
end

OscMatrix = cat(1, medianAmp, medianDurOsc, medianAmplOsc, medianAmplOsc_max, occurrenceOsc);

end