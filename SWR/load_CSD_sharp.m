
clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812 900:912 1000:1005 501:536]; % above 900 is intCA1

for n=1:length(animal)
    
    experiment=experiments(animal(n));
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_CSD'))
    csd(:,:,n)=CSD;
    age(n,:)=experiment.age;  
end

age1=age(47:end);
age(47:end)=[];
p10=find(age==10);
p9=find(age==9);
p8=find(age==8);
p101=find(age1==10)+46;
p91=find(age1==9)+46;
p81=find(age1==8)+46;

figure; imagesc(mean(csd(:,:,p10),3),[-1 1]*10^4)
xlim([1550 1650]); axis=gca; axis.XTickLabel={'','-75','','-25','','0','','25','','50','','75'}; 
xlabel('Time (ms)'); ylabel('Channel')
title('Current source density - 100ms around a SWR - P10 dorHP')
figure; imagesc(mean(csd(:,:,p9),3),[-1 1]*10^4)
xlim([1550 1650]); axis=gca; axis.XTickLabel={'','-75','','-25','','0','','25','','50','','75'}; 
xlabel('Time (ms)'); ylabel('Channel')
title('Current source density - 100ms around a SWR - P9 dorHP')
figure; imagesc(mean(csd(:,:,p8),3),[-1 1]*10^4)
xlim([1550 1650]); axis=gca; axis.XTickLabel={'','-75','','-25','','0','','25','','50','','75'}; 
xlabel('Time (ms)'); ylabel('Channel')
title('Current source density - 100ms around a SWR - P8 dorHP')
figure; imagesc(mean(csd(:,:,p101),3),[-1 1]*10^4)
xlim([1550 1650]); axis=gca; axis.XTickLabel={'','-75','','-25','','0','','25','','50','','75'}; 
xlabel('Time (ms)'); ylabel('Channel')
title('Current source density - 100ms around a SWR - P10 intHP')
figure; imagesc(mean(csd(:,:,p91),3),[-1 1]*10^4)
xlim([1550 1650]); axis=gca; axis.XTickLabel={'','-75','','-25','','0','','25','','50','','75'}; 
xlabel('Time (ms)'); ylabel('Channel')
title('Current source density - 100ms around a SWR - P9 intHP')
figure; imagesc(mean(csd(:,:,p81),3),[-1 1]*10^4)
xlim([1550 1650]); axis=gca; axis.XTickLabel={'','-75','','-25','','0','','25','','50','','75'}; 
xlabel('Time (ms)'); ylabel('Channel')
title('Current source density - 100ms around a SWR - P8 intHP')