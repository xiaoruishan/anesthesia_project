function getBaselineGrangerPDC(signal1,signal2,fs,experiment,save_data,CSC)

Path = get_path;
param.minwindowN=40;
% param.filterdata=0;
param.win_sec=1;
param.nfreqs=128;
param.metric ='diag';
param.maxIP=50;
param.alg=1;
param.alpha=0.05;
param.criterion=3;
nWindows=floor(length(signal1)/(3*fs));
signalX=reshape(signal1(1:nWindows*3*fs),3*fs,nWindows);
signalY=reshape(signal2(1:nWindows*3*fs),3*fs,nWindows);

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
    else
        cXtoY=[];
        cYtoX=[];
    end
end
cXtoY(isnan(cXtoY))=0;
cYtoX(isnan(cYtoX))=0;
grangerPDC.XtoY=cXtoY;
grangerPDC.YtoX=cYtoX;
grangerPDC.freq=(50/128:50/128:50);

if save_data == 0
    disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineGrangerPDC',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'BaselineGrangerPDC',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'BaselineGrangerPDC',filesep,experiment.name,filesep,num2str(CSC)),'grangerPDC')
end
end
