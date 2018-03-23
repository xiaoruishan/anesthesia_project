function getSharpWaves(baselineStructure,experiment,CSC,save_data)
% Primitive sharpwave detection script. detect sharpwaves using threshold
% crossings
Path = get_path;
parameters=get_parameters;

for bb=1:2
% for bb =1
    signalLFP=ZeroPhaseFilterZeroPadding(baselineStructure.signal(bb,:),baselineStructure.samplingrate,[parameters.FrequencyBands.LFP]);
    thr = std(signalLFP)*parameters.osc_detection.sharpWaveThreshold;
%     [peakLocPositive, ~] = peakfinderOpto(signalLFP,(max(signalLFP)-min(signalLFP))/5,thr,1);
%     [peakLocNegative, ~] = peakfinderOpto(signalLFP,(max(signalLFP)-min(signalLFP))/5,-thr,-1);
    [peakLocPositive, AmplPositive] = peakfinderOpto(signalLFP,0,thr,1);
    [peakLocNegative, AmplNegative] = peakfinderOpto(signalLFP,0,-thr,-1);
    peakLocPositive=peakLocPositive./baselineStructure.samplingrate*10^6+baselineStructure.time(bb,1); % convert to true time
    peakLocNegative=peakLocNegative./baselineStructure.samplingrate*10^6+baselineStructure.time(bb,1); % convert to true time
    SPWdata.(['baseline' num2str(bb)]).SPWlocationPositive = peakLocPositive;
    SPWdata.(['baseline' num2str(bb)]).SPWlocationNegative = peakLocNegative;
    SPWdata.(['baseline' num2str(bb)]).SPWamplitudePositive = AmplPositive-mean(signalLFP);
    SPWdata.(['baseline' num2str(bb)]).SPWamplitudeNegative = AmplNegative-mean(signalLFP);
end

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineSPWtimes',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'BaselineSPWtimes',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'BaselineSPWtimes',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'SPWdata')
end
end
% XXXX=round((OscAmplDurOcc.(['baseline' num2str(bb)]).OscTimes-baselineStructure.time(bb,1))*baselineStructure.samplingrate/10^6);
% 
% figure
% hold on
% plot(baselineStructure.time(1,:),baselineStructure.signal(1,:),'k')
% plot(peakLocNegative,ones(size(peakLocNegative,2),1)','*r')
% plot(oscStart,ones(size(oscStart,2),1)'-2,'*b')
% 
% % plot(((oscStart-baselineStructure.time(bb,1))*baselineStructure.samplingrate/10^6),ones(size(oscStart,2),1)'-2,'*b')
% hold off
% 
% 
% figure
% hold on
% plot(1:length(baselineStructure.signal(1,:)),baselineStructure.signal(1,:),'k')
% % plot(peakLocNegative,ones(size(peakLocNegative,2),1)','*r')
% plot(XXXX,ones(size(XXXX,2),1)'-2,'*b')
% hold off

