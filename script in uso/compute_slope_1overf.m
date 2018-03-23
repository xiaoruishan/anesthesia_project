

slope = zeros(60, size(minutePower, 3), 2);

X = log10(linspace(20, 40, 161));

for animale = 1 : size(minutePower,3)
    for minuti = 1 : 60
        Y = log10(minutePower(minuti, 160:320, animale));
        slope(minuti, animale, :) = robustfit(X(:), Y(:));
    end
end

slope(:, :, 1) = [];

% figure; boundedline(linspace(1,60,60), median(slope,2), mad(slope,0,2)./sqrt(size(slope,2)));
% hold on; ylim([-2.2 -0.8]); plot([15 15],get(gca,'ylim'),'r','linewidth',3)
% title('1/f slope'); ylabel('1/f slope'); xlabel('Time (minutes)'); set(gca,'FontSize',20); set(gca,'TickDir','out')

quartodora(1,:) = median(slope(1:15,:));
quartodora(2,:) = median(slope(16:30,:));
quartodora(3,:) = median(slope(31:45,:));
quartodora(4,:) = median(slope(46:60,:));
xvalues = repmat([1 2]', 1, size(quartodora,2));

% figure; scatter(xvalues(1,:),quartodora(4,:),'s','filled','k'); hold on; scatter(xvalues(2,:),quartodora(2,:),'s','filled','k')
% plot(xvalues,vertcat(quartodora(4,:),quartodora(2,:)),'k'); xlim([0.5 2.5]); set(gca,'xtick',[]); set(gca,'xticklabel',[]);  set(gca,'TickDir','out')
% scatter([1 2]', median(quartodora,2), 's', 'filled', 'r'); plot([1 2]',median(quartodora,2),'r', 'linewidth', 3);
% title(strcat('1/f slope p=',num2str(signrank(quartodora(4,:),quartodora(2,:))))); ylabel('1/f slope'); xlabel('Pre vs Post'); set(gca,'FontSize',20)

figure; xvalues = repmat(linspace(8, 53, 4)', 1, size(quartodora, 2)); scatter(xvalues(:), quartodora(:), 'o', 'filled', 'k'); 
hold on; plot(xvalues, quartodora, 'Color', [0.5 0.5 0.5], 'linewidth', 0.5); alpha(0.3)
boundedline(linspace(1, 60, 60), median(slope, 2), mad(slope, 0, 2) ./ sqrt(size(slope, 2)));
ylim([-3 -0.5]); plot([15 15],get(gca,'ylim'),'r','linewidth',3);
title('1/f slope'); ylabel('1/f slope'); xlabel('Time (minutes)'); set(gca,'FontSize',20)

