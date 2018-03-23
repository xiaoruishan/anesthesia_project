
clear all

path=get_path;
parameters=get_parameters;
experiments=get_experiment_list;
animal=[501:538 551:568 571:588];
CSCs=20;
phases=[];
edges=linspace(-pi,pi,21);
bin=zeros(74,length(edges)-1);

for n=1:length(animal)
    experiment=experiments(animal(n));
    for channel=1:length(CSCs)
        CSC=CSCs(channel);
        if exist(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name, filesep, 'PLV',num2str(CSC),'.mat'))
            load(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name, filesep, 'PLV',num2str(CSC),'.mat'))
                phases=PLV.details{2,1};
        end
    end
    [count,~]=histcounts(phases,edges);
    count=count/length(phases);
    bin(n,:)=count;
    phases=[];
end

figure; bar(linspace(-185,185,20),nanmean(bin(1:38,:)),'hist')
figure; bar(linspace(-185,185,20),nanmean(bin(39:56,:)),'hist')
figure; bar(linspace(-185,185,20),nanmean(bin(57:end,:)),'hist')


for kk=57:74
    bar(linspace(-180,180,20),bin(kk,:),'hist')
    ylim([0 0.20])
    xlim([-185 185])
    k=waitforbuttonpress
end

figure; boundedline(linspace(-pi,pi,30),mean(bin(1:37,:)),std(bin(1:37,:))/sqrt(37),'b');
hold on
boundedline(linspace(-pi,pi,30),mean(bin(38:end,:)),std(bin(38:end,:))/sqrt(37),'r');

figure; bar(linspace(-180,180,20),bin(71,:),'hist')
xlim([-185 185])
ylim([0 0.20])
xticks([-180 -120 -60 0 60 120 180])
xticklabels({-180 -120 -60 0 60 120 180})

figure; bar(linspace(-180,180,20),bin(2,:))



figure; plot(count/length(phases))
hold on
plot(gecount/length(gephases))
