

data2plot{8} = oscillations(1, :);
data2plot{2}=condition2;
data2plot{3}=condition3;


figure
distributionPlot(data2plot,'showMM',6,'color',{'k'});
set(gca,'TickDir','out')
f=plotSpread(data2plot,'spreadWidth',1);
set(f{1},'color','k','marker','*')

