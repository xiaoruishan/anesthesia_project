

figure
model=fitlm(osc_time(2,:)./osc_time(1,:),amplitude(2,:)./amplitude(1,:));
plot(model)
hold on
delete(findall(gcf,'type','legend'))
dim=[.2 .5 .3 .3];
annotation('textbox',dim,'String',strcat('p = ',num2str(model.Coefficients.pValue(2))),'FitBoxToText','On');
title('oscillation ratio vs amplitude ratio')
xlabel('amplitude ratio')
ylabel('oscillation ratio')