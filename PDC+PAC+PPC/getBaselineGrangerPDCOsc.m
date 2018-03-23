function getBaselineGrangerPDCOsc(time,signal1,signal2,fs,experiment,save_data,CSC)
Path = get_path;

param.minwindowN=40;
param.win_sec=1;
param.nfreqs=1024;
param.metric ='diag';
param.maxIP=50;
param.alg=1;
param.alpha=0.05;
param.criterion=1;
param.win_points=fs;

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6)';

[CUTNGLUED]=CutNGlueXY(signal1,signal2,oscTimes,fs,param);
clearvars signal1 signal2

nWindows=floor(length(CUTNGLUED.xn)/(fs));
signalX=reshape(CUTNGLUED.xn(1:nWindows*fs),fs,nWindows);
signalY=reshape(CUTNGLUED.yn(1:nWindows*fs),fs,nWindows);

clearvars signal1 signal2
countSegments=0;
for nsegment=1:nWindows
    segmentX=DeNoiseWavelet(signalX(:,nsegment));
    segmentY=DeNoiseWavelet(signalY(:,nsegment));
    segments=[segmentX,segmentY];
    clearvars segmentX segmentY
    c=PDC_computation(segments,param.nfreqs,param.metric,param.maxIP,param.alg,param.alpha,param.criterion);
    if ~isempty(c)
        countSegments=countSegments+1;
        cXtoY(countSegments,:)=c.c12';
        cYtoX(countSegments,:)=c.c21';
    end
end
cXtoY(isnan(cXtoY))=0 ;
cYtoX(isnan(cYtoX))=0 ;

grangerPDC.XtoY=cXtoY;
grangerPDC.YtoX=cYtoX;
grangerPDC.freq=(200/1024:200/1024:200);

if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineGrangerPDC',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'BaselineGrangerPDC',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'BaselineGrangerPDC',filesep,experiment.name,filesep,'osc',num2str(CSC)),'grangerPDC')
end
end
