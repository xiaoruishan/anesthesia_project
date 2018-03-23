function [average,stdev] = getMeanSDsignalprej(signal_filt)

difference = signal_filt(1,:)-signal_filt(2,:);
average = mean(difference);
stdev = std(difference);

end


