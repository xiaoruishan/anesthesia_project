function [average,stdev] = getMeanSDsignal(experiment,signal_filt,channels,time_to_subtract,fs)

path = get_path;
filename = strcat('CSC',num2str(channels(1))); % loads information about when oscillations are occurring
% filename = 'CSC16';

load(strcat(path.output, 'results', filesep, 'BaselineOscAmplDurOcc', filesep, experiment.name, filesep, filename));
load(strcat(path.output, 'results', filesep, 'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'));

oscTimes = round((OscAmplDurOcc.(['baseline']).OscTimes- time_to_subtract)*fs/10^6);
[row1,column1] = find(oscTimes > BaselineTimePoints(1,1) & oscTimes < BaselineTimePoints(1,2)); % find oscillations time points in the first "baseline" window
column1 = column1-(column1(1))+1;
value1 = oscTimes(oscTimes > BaselineTimePoints(1,1) & oscTimes < BaselineTimePoints(1,2)); % find oscillations values in the first "baseline" window
oscTimes1 = accumarray([row1 column1], value1);
% [row3,column3] = find(oscTimes > BaselineTimePoints(1,3));
% column3 = column3-(column3(1))+1;
% value3 = oscTimes(oscTimes > BaselineTimePoints(1,3));
% oscTimes3 = accumarray([row3 column3], value3);

oscTimes = oscTimes1;

clearvars column1 column3 row1 row3 value1 value3 oscTimes1 oscTimes3

signalOsc = [];

for pp = 1:length(oscTimes)-1
    
    if oscTimes(1,pp) & oscTimes(2,pp) > BaselineTimePoints(1,1)
        if oscTimes(1,pp) < BaselineTimePoints(1,2) % this part here is needed to adjust the oscTime vector that I created in the part before to the original signal
            signal_osc = oscTimes(1,pp)-BaselineTimePoints(1,1) : oscTimes(2,pp)-BaselineTimePoints(1,1);
        elseif oscTimes(1,pp) > BaselineTimePoints(1,3)
            signal_osc = oscTimes(1,pp)-(BaselineTimePoints(1,3)-BaselineTimePoints(1,2)+BaselineTimePoints(1,1)) : oscTimes(2,pp)-(BaselineTimePoints(1,3)-BaselineTimePoints(1,2)+BaselineTimePoints(1,1));
        end
        signalOsc = [signalOsc signal_osc];
    end
    
end

signalOsc = signalOsc(signalOsc < length(signal_filt));
signalFiltOsc = signal_filt(:,signalOsc);

difference = signalFiltOsc(1,:)-signalFiltOsc(2,:);
average = mean(difference);
stdev = std(difference);

end


