
theta1 = mean(imag_cohpost(11:22,:),1);
theta2 = mean(aimag_cohpost(11:22,:),1);
alpha1 = mean(imag_cohpost(22:32,:),1);
alpha2 = mean(aimag_cohpost(22:32,:),1);
beta1 = mean(imag_cohpost(32:80,:),1);
beta2 = mean(aimag_cohpost(32:80,:),1);
lowg1 = mean(imag_cohpost(80:129,:),1);
lowg2 = mean(aimag_cohpost(80:129,:),1);
highg5 = mean(imag_cohpost(129:257,:),1);
highg6 = mean(aimag_cohpost(129:257,:),1);

[a,b] = ttest2(theta1,theta2)


subplot(2,3,6)
hold on
bar(1, mean(theta1), 'facecolor', 'b');
bar(2, mean(theta2), 'facecolor', 'r');
bar(4, mean(alpha1), 'facecolor', 'b');
bar(5, mean(alpha2), 'facecolor', 'r');
bar(7, mean(beta1), 'facecolor', 'b');
bar(8, mean(beta2), 'facecolor', 'r');
bar(10, mean(lowg1), 'facecolor', 'b');
bar(11, mean(lowg2), 'facecolor', 'r');
bar(7, mean(highg1), 'facecolor', 'b');
bar(8, mean(highg2), 'facecolor', 'r');

errorbar([mean(theta1) mean(theta2) 0 mean(alpha1) mean(alpha2) 0 mean(beta1) mean(beta2)...
        0 mean(lowg1) mean(lowg2) 0 mean(highg1) mean(highg2)], [std(theta1)/6 ...
        std(theta2)/4 0 std(alpha1)/6 std(alpha2)/4 0 std(beta1)/6 std(beta2)/4 0 ...
        std(lowg1)/6 std(lowg2)/4 0 std(highg1)/6 std(highg2)/4],'.','LineWidth',3, 'Color', 'k');
Labels = {'Theta(4-8hz)', 'Alpha 8-12hz)', 'Beta(12-30hz)', 'LowG(30-50hz)', 'HighG(50-100hz)'};
set(gca, 'XTick', linspace(1.5,13.5,5), 'XTickLabel', Labels, 'FontSize', 8);
title('HP-PL  layers SWR (250ms)', 'FontSize', 18)
ylabel('Imag Coherence', 'FontSize', 18)
