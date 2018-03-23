
figure
subplot(2,3,1)
semwt=std(Deeptohp(:,1:37),0,2)./sqrt(37);
semge=std(Deeptohp(:,38:end),0,2)./sqrt(16);
boundedline(linspace(1/1024,50,321),wtdeep(1:321,1),semwt(1:321,1),'b'); 
hold on; boundedline(linspace(1/1024,50,321),gedeep(1:321,1),semge(1:321,1),'r');
title('gDPC - PFC deep layers to HP', 'FontSize', 18)
ylabel('gDPC', 'FontSize', 18)
xlabel('Frequency (hz)', 'FontSize', 18)

subplot(2,3,2)
semwt=std(Suptohp(:,1:37),0,2)./sqrt(37);
semge=std(Suptohp(:,38:end),0,2)./sqrt(16);
boundedline(linspace(1/1024,50,321),wtsup(1:321,1),semwt(1:321,1),'b');
hold on; boundedline(linspace(1/1024,50,321),gesup(1:321,1),semge(1:321,1),'r');
title('gDPC - PFC sup layers to HP', 'FontSize', 18)
ylabel('gDPC', 'FontSize', 18)
xlabel('Frequency (hz)', 'FontSize', 18)

subplot(2,3,4)
semwt=std(Hptodeep(:,1:37),0,2)./sqrt(37);
semge=std(Hptodeep(:,38:end),0,2)./sqrt(16);
boundedline(linspace(1/1024,50,321),wthpdeep(1:321,1),semwt(1:321,1),'b'); 
hold on; boundedline(linspace(1/1024,50,321),gehpdeep(1:321,1),semge(1:321,1),'r');
title('gDPC - Hp to PFC deep layers', 'FontSize', 18)
ylabel('gDPC', 'FontSize', 18)
xlabel('Frequency (hz)', 'FontSize', 18)

subplot(2,3,5)
semwt=std(Hptosup(:,1:37),0,2)./sqrt(37);
semge=std(Hptosup(:,38:end),0,2)./sqrt(16);
boundedline(linspace(1/1024,50,321),wthpsup(1:321,1),semwt(1:321,1),'b'); 
hold on; boundedline(linspace(1/1024,50,321),gehpsup(1:321,1),semge(1:321,1),'r');
title('gDPC - Hp to PFC sup layers', 'FontSize', 18)
ylabel('gDPC', 'FontSize', 18)
xlabel('Frequency (hz)', 'FontSize', 18)

subplot(2,3,3)
bar(1, mean(mean(Suptohp(129:321,1:37))), 'facecolor', 'b');
hold on
bar(2, mean(mean(Suptohp(129:321,38:end))), 'facecolor', 'r');
errorbar([mean(mean(Suptohp(129:321,1:37))) mean(mean(Suptohp(129:321,38:end)))], ...
    [std(mean(Suptohp(129:321,1:37)))/sqrt(37) std(mean(Suptohp(129:321,38:end)))/sqrt(37)],'.','LineWidth',3, 'Color', 'k');
plot(1.5, mean(Suptohp(129:321,1:37)),'x', 'LineWidth',2,'Color', 'k')
plot(2.5, mean(Suptohp(129:321,38:end)),'x', 'LineWidth',2,'Color', 'k')
Labels = {'WT', 'GE'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'FontSize', 18);
title('gDPC - PFC sup layers to HP: 20-50hz', 'FontSize', 18)
ylabel('gDPC', 'FontSize', 18)

subplot(2,3,6)
bar(1, mean(mean(Hptosup(27:321,1:37))), 'facecolor', 'b');
hold on
bar(2, mean(mean(Hptosup(27:321,38:end))), 'facecolor', 'r');
errorbar([mean(mean(Hptosup(27:321,1:37))) mean(mean(Hptosup(27:321,38:end)))], ...
    [std(mean(Hptosup(27:321,1:37)))/sqrt(37) std(mean(Hptosup(27:321,38:end)))/sqrt(37)],'.','LineWidth',3, 'Color', 'k');
plot(1.5, mean(Hptosup(27:321,1:37)),'x', 'LineWidth',2,'Color', 'k')
plot(2.5, mean(Hptosup(27:321,38:end)),'x', 'LineWidth',2,'Color', 'k')
Labels = {'WT', 'GE'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'FontSize', 18);
title('gDPC - HP to PFC sup layers: 4-50hz', 'FontSize', 18)
ylabel('gDPC', 'FontSize', 18)