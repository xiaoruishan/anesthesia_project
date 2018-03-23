
variable=percentage_deep;
wt=variable(1:38);
ge=variable(39:55);
micro=variable(56:end);


% deep_variable=halfwidth;
% wt=variable(find(halfwidth(:,1)~=0),1);
% ge=variable(find(halfwidth(:,2)~=0),2);
% micro=variable(56:end);
% deepwt=variable(find(halfwidth(:,3)~=0),3);
% deepge=variable(find(halfwidth(:,4)~=0),4);
% deepmicro=deep_variable(56:end);

data2plot{1}=wt;%*(375/512);
data2plot{2}=ge;%*(375/512);
data2plot{3}=micro;%*(375/512);
% data2plot{4}=gamma_deep(39:55,1);%*(375/512);
% data2plot{3}=deepwt;
% data2plot{4}=deepge;
% data3plot{2}=deepmicro;

figure
f=distributionPlot(data2plot,'showMM',6,'color',{'y','b','g'});
set(gca,'TickDir','out')
f=plotSpread(data2plot,'spreadWidth',1);
set(f{1},'color','k','marker','*')
% ylim([0 10])
% 
% figure
% f=distributionPlot(data2plot,'showMM',6,'color',{'y','b','y','b'});
% % set(f{4}{1},'color','k','marker','*')
% hold on
% f=plotSpread(data2plot,'spreadWidth',1.4);
% set(f{1},'color','k','marker','*')
% set(gca,'TickDir','out')
% ylim([0 12])
% 
% axis xy
% 
% %% stuff for cell number
% 
% data2plot{1}=wt*140625/10^6;
% data2plot{2}=ge*140625/10^6;
% data2plot{3}=micro*140625/10^6;
% 
% plot(1,prctile(wt*140625/10^6,25),'o','color','r')
% plot(1,prctile(wt*140625/10^6,75),'o','color','r')
% plot(2,prctile(ge*140625/10^6,75),'o','color','r')
% plot(2,prctile(ge*140625/10^6,25),'o','color','r')
% plot(3,prctile(micro*140625/10^6,25),'o','color','g')
% plot(3,prctile(micro*140625/10^6,75),'o','color','g')


%% other stuff 


% figure
% f=distributionPlot(data2plot,'showMM',6,'color',{'y','b','y','b'});
% hold on
% f=plotSpread(data2plot,'spreadWidth',1.4)
% set(f{1},'color','k','marker','*')
% ylim([-0.5 1.2])

% figure
% f=distributionPlot(data3plot,'showMM',6,'color',{'y','b','y','b'});
% hold on
% f=plotSpread(data3plot,'spreadWidth',1.4)
% set(f{1},'color','k','marker','*')
% ylim([-0.5 1.2])

% figure
% f=distributionPlot(data2plot,'showMM',6,'addSpread',1,'color',{'y','b'});
% set(f{4}{1},'color','k','marker','*')


% figure
% f=distributionPlot(data3plot,'showMM',6,'addSpread',1)
% set(f{4}{1},'color','g','marker','x')
% 
% figure; boxplot(theta(1:56),condition(1:56))
% figure;boxplot(theta([1:38 57:end]),condition([1:38 57:end]))

% figure
% subplot(2,2,1)
% boxplot(theta(1:56),condition(1:56))
% 
% subplot(2,2,3)
% boxplot(theta([1:38 57:end]),condition([1:38 57:end]))
% 
% subplot(2,2,2)
% f=distributionPlot(data2plot,'showMM',6,'addSpread',1,'color',{'y','k'});
% set(f{4}{1},'color','g','marker','*')
% ylim([0 80])
% 
% subplot(2,2,4)
% f=distributionPlot(data3plot,'showMM',6,'addSpread',1,'color',{'y','k'});
% set(f{4}{1},'color','g','marker','*')
% ylim([0 80])
% 
% set(f{4}{1},'color','g','marker','x')