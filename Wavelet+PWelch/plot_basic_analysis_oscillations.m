

figure
bar(1, wtm(1,1), 'facecolor', 'b');
hold on
bar(2, wtc(1,1), 'facecolor', 'g');
bar(3, discm(1,1), 'facecolor', 'y');
bar(4, discc(1,1), 'facecolor', 'r');
errorbar([wtm(1,1) wtc(1,1) discm(1,1) discc(1,1)], [2*wtm(2,1) 2*wtc(2,1) 2*discm(2,1) 2*discc(2,1)],'.','LineWidth',3, 'Color', 'k');
Labels = {'WT Mattia', 'WT Christoph', 'GE - Mattia', 'GE - Christoph'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels, 'FontSize', 11);
title('Oscillation Duration (s) with 95% CI', 'FontSize', 18)
ylabel('Seconds', 'FontSize', 18)

figure
bar(1, wtm(1,2), 'facecolor', 'b');
hold on
bar(2, wtc(1,2), 'facecolor', 'g');
bar(3, discm(1,2), 'facecolor', 'y');
bar(4, discc(1,2), 'facecolor', 'r');
errorbar([wtm(1,2) wtc(1,2) discm(1,2) discc(1,2)], [2*wtm(2,2) 2*wtc(2,2) 2*discm(2,2) 2*discc(2,2)],'.','LineWidth',3, 'Color', 'k');
Labels = {'WT Mattia', 'WT Christoph', 'GE - Mattia', 'GE - Christoph'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels, 'FontSize', 11);
title('Oscillation Amplitude with 95% CI', 'FontSize', 18)
ylabel('Volts', 'FontSize', 18)

figure
bar(1, wtm(1,3), 'facecolor', 'b');
hold on
bar(2, wtc(1,3), 'facecolor', 'g');
bar(3, discm(1,3), 'facecolor', 'y');
bar(4, discc(1,3), 'facecolor', 'r');
errorbar([wtm(1,3) wtc(1,3) discm(1,3) discc(1,3)], [2*wtm(2,3) 2*wtc(2,3) 2*discm(2,3) 2*discc(2,3)],'.','LineWidth',3, 'Color', 'k');
Labels = {'WT Mattia', 'WT Christoph', 'GE - Mattia', 'GE - Christoph'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels, 'FontSize', 11);
title('Oscillation Occurrence with 95% CI', 'FontSize', 18)
ylabel('Events/min', 'FontSize', 18)

figure
bar(1, wtm(1,4), 'facecolor', 'b');
hold on
bar(2, wtc(1,4), 'facecolor', 'g');
bar(3, discm(1,4), 'facecolor', 'y');
bar(4, discc(1,4), 'facecolor', 'r');
errorbar([wtm(1,4) wtc(1,4) discm(1,4) discc(1,4)], [2*wtm(2,4) 2*wtc(2,4) 2*discm(2,4) 2*discc(2,4)],'.','LineWidth',3, 'Color', 'k');
Labels = {'WT Mattia', 'WT Christoph', 'GE - Mattia', 'GE - Christoph'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels, 'FontSize', 11);
title('Theta Power with 95% CI', 'FontSize', 18)
ylabel('µV^2', 'FontSize', 18)

figure
bar(1, wtm(1,5), 'facecolor', 'b');
hold on
bar(2, wtc(1,5), 'facecolor', 'g');
bar(3, discm(1,5), 'facecolor', 'y');
bar(4, discc(1,5), 'facecolor', 'r');
errorbar([wtm(1,5) wtc(1,5) discm(1,5) discc(1,5)], [2*wtm(2,5) 2*wtc(2,5) 2*discm(2,5) 2*discc(2,5)],'.','LineWidth',3, 'Color', 'k');
Labels = {'WT Mattia', 'WT Christoph', 'GE - Mattia', 'GE - Christoph'};
set(gca, 'XTick', 1:5, 'XTickLabel', Labels, 'FontSize', 11);
title('Beta Power with 95% CI', 'FontSize', 18)
ylabel('µV^2', 'FontSize', 18)

figure
bar(1, wtm(1,6), 'facecolor', 'b');
hold on
bar(2, wtc(1,6), 'facecolor', 'g');
bar(3, discm(1,6), 'facecolor', 'y');
bar(4, discc(1,6), 'facecolor', 'r');
errorbar([wtm(1,6) wtc(1,6) discm(1,6) discc(1,6)], [2*wtm(2,6) 2*wtc(2,6) 2*discm(2,6) 2*discc(2,6)],'.','LineWidth',3, 'Color', 'k');
Labels = {'WT Mattia', 'WT Christoph', 'GE - Mattia', 'GE - Christoph'};
set(gca, 'XTick', 1:6, 'XTickLabel', Labels, 'FontSize', 11);
title('Gamma Power with 95% CI', 'FontSize', 18)
ylabel('µV^2', 'FontSize', 18)