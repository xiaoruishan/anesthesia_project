function plotStimulationCSD(experiment,Frequency,CSCs)


k=7; % ? % should be parameter
h=50*0.001; %um
n=2; % should be parameter


countss=0;
for ss=CSCs
    countss=countss+1;
    superMat=[];
    if Frequency >4 % if Frequency is too high, the waveformData file will become HUGE, therefore do not save it
        save_data=0;
    else
        save_data=1;
    end
    [waveformData]=getStimulationWaveformSquareStim(experiment,ss,Frequency,0,save_data);
    for pp = 1:size(fieldnames(waveformData),1)-1
        superMat=[superMat;waveformData.(['period' num2str(pp)])];
    end
    signal(countss,:)=mean(superMat);
end
for ii = 1+2:16-2 % CSC
    for jj=1:length(signal(3,:))
        CSD_data(ii-2,jj)=-(1/(k*(h^2)))*...
            (n*signal(ii-2,jj)+...
            n*signal(ii+2,jj)...
            -signal(ii-1,jj)...
            -signal(ii+1,jj)...
            -n*signal(ii,jj));
    end
end
f1= figure;
figure(f1)
hold on
colormap jet
imagesc(waveformData.time,[-14:-3],flipud(CSD_data));
caxis([-4000,4000])
for pp=3:14
    plot(waveformData.time,((signal(pp,:))/50)-pp*1,'k')
end
hold off

f2=figure;
figure(f2)
hold on
colormap jet
CSCrange = [experiment.HPreversal-3:experiment.HPreversal+3];
imagesc(waveformData.time,(CSCrange-(experiment.HPreversal)),CSD_data(fliplr(CSCrange)-3,:));
caxis([-4000,4000])
for pp=CSCrange
    plot(waveformData.time,((signal(pp,:))/50)-(pp-experiment.HPreversal),'k')
end
hold off