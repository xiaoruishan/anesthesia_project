function firing = getOscPropertiesMUA(time,signal,fs,experiment,CSC)
Path=get_path;

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);


%%
threshold = 5;
thr=std(signal)*threshold;
for oscillation = 1:size(oscTimes,2)
    try MUA = signal(oscTimes(1,oscillation) : oscTimes(2,oscillation));
        [peakLoc,~]=peakfinderOpto(MUA,thr/2,-thr,-1,false);
        firing(oscillation) = numel(peakLoc)/(length(MUA)/fs);
    catch
        firing(oscillation) = 0;
    end
end
