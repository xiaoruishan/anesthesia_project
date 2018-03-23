
clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
animal = [501:538 551:568 571:588];%700:732 101:186];%800:812 900:912 1000:1005 ]; % above 900 is intCA1

%% load PPC

CSC=17:32;

for n=1:length(animal)
    experiment = experiments(animal(n));
    for channel=1:length(CSC)
        load(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name, filesep, 'PPC', num2str(CSC(channel)), '.mat'));
        ppcbeta(n,channel)=PPC(2);
        ppctheta(n,channel)=PPC(1);
        ppcgamma(n,channel)=PPC(3);
    end
end

ppc=ppcbeta;

wt=nanmean(ppc(1:38,1:4),2);
ge=nanmean(ppc(39:56,1:4),2);
micro=nanmean(ppc(57:end,1:4),2);
deepwt=nanmean(ppc(1:38,13:16),2);
deepge=nanmean(ppc(39:56,13:16),2);
deepmicro=nanmean(ppc(57:end,13:16),2);


[a,b]=ttest2(wt,ge)
[a,b]=ttest2(wt,micro)
[a,b]=ttest2(ge,micro)

[a,b]=ttest2(deepwt,deepge)
[a,b]=ttest2(deepwt,deepmicro)
[a,b]=ttest2(deepge,deepmicro)


%% MUA firing rate

for n=1:length(animal)
    experiment = experiments(animal(n));
    for channel=1:length(CSC)
        load(strcat(path.output,filesep,'results',filesep,'MUAfiringrate',filesep,experiment.name, filesep, 'MUAfiringrate', num2str(CSC(channel)), '.mat'));
        FiringRate(n,channel)=MUAfiringrate;
    end
end

wt=log10(nanmean(FiringRate(1:38,1:4),2)./(15*60));
ge=log10(nanmean(FiringRate(39:56,1:4),2)./(15*60));
micro=log10(nanmean(FiringRate(57:end,1:4),2)./(15*60));

deepwt=log10(nanmean(FiringRate(1:38,13:16),2)./(15*60));
deepge=log10(nanmean(FiringRate(39:56,13:16),2)./(15*60));
deepmicro=log10(nanmean(FiringRate(57:end,13:16),2)./(15*60));

[a,b]=ttest2(wt,ge)
[a,b]=ttest2(wt,micro)
[a,b]=ttest2(ge,micro)

[a,b]=ttest2(deepwt,deepge)
[a,b]=ttest2(deepwt,deepmicro)
[a,b]=ttest2(deepge,deepmicro)


%% load PLV

for n=1:length(animal)
    experiment = experiments(animal(n));
    CSC = experiment.HPreversal;
    for channel=1:length(CSC)
        if exist(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name, filesep, 'sharpPLV_5std.mat'))
            load(strcat(path.output,filesep,'results',filesep,'PPC&PCDI&PLV',filesep,experiment.name, filesep, 'sharpPLV_5std.mat'))
            phasetheta(n,channel)=PLV.phase_rad{1,1};
%             phasebeta(n,channel)=PLV.phase_rad{2,1};
%             phasegamma(n,channel)=PLV.phase_rad{3,1};
            strengththeta(n,channel)=PLV.rvl{1,1};
%             strengthbeta(n,channel)=PLV.rvl{2,1};
%             strengthgamma(n,channel)=PLV.rvl{3,1};
%             pvaluetheta(n,channel)=PLV.p{1,1};
%             pvaluebeta(n,channel)=PLV.p{2,1};
%             pvaluegamma(n,channel)=PLV.p{3,1};
%         else
%             pvaluetheta(n,channel)=1;
%             pvaluebeta(n,channel)=1;
%             pvaluegamma(n,channel)=1;
        end
    end
end

for channel=1:16
    nonlockedbeta(channel,1)=nnz(pvaluebeta(1:37,channel)>0.05)/37;
    genonlockedbeta(channel,1)=nnz(pvaluebeta(38:end,channel)>0.05)/16;
    nonlockedgamma(channel,1)=nnz(pvaluegamma(1:37,channel)>0.05)/37;
    genonlockedgamma(channel,1)=nnz(pvaluegamma(38:end,channel)>0.05)/16;
    nonlockedtheta(channel,1)=nnz(pvaluetheta(1:37,channel)>0.05)/37;
    genonlockedtheta(channel,1)=nnz(pvaluetheta(38:end,channel)>0.05)/16;
end

nonlockedbeta=reshape(nonlockedbeta,4,4);
genonlockedbeta=reshape(genonlockedbeta,4,4);
nonlockedtheta=reshape(nonlockedtheta,4,4);
genonlockedtheta=reshape(genonlockedtheta,4,4);
nonlockedgamma=reshape(nonlockedgamma,4,4);
genonlockedgamma=reshape(genonlockedgamma,4,4);

figure
imagesc(genonlockedtheta./nonlockedtheta,[0 3])
figure
imagesc(genonlockedbeta./nonlockedbeta,[0 3])
figure
imagesc(genonlockedgamma./nonlockedgamma,[0 3])



%% plot PLV values

figure
for n=1:length(animal)%53
    experiment=experiments(animal(n));
    age(n,:)=experiment.age;
    if n>86%experiment.age==8%
        polarplot(phasetheta(n),strengththeta(n),'g*')
        hold on
%     elseif experiment.age==9%n < 53
%         polarplot(phasetheta(n),strengththeta(n),'r*')
    else
        polarplot(phasetheta(n),strengththeta(n),'r*')
        hold on
    end
end

figure
for n = 1:53
    if n < 38
        polarplot(phase_deep(n),strength_deep(n),'b*')
        hold on
    else
        polarplot(phase_deep(n),strength_deep(n),'r*')
    end
end
