
clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
animal = [501:537 552:566 571:578];

for n=1:length(animal)
    experiment = experiments(animal(n));
%     load(strcat(path.output,filesep,'results',filesep,'PAC',filesep,experiment.name, ...
%         filesep, 'PAC1729.mat'));
%     PAC1 = PAC;
%     load(strcat(path.output,filesep,'results',filesep,'PAC',filesep,experiment.name, ...
%         filesep, 'PAC2917.mat'));
%     PAC2 = PAC;
    if animal(n)<570
        load(strcat(path.output,filesep,'results',filesep,'PAC',filesep,experiment.name, ...
        filesep, 'PAC1717.mat'));
    else
        load(strcat(path.output,filesep,'results',filesep,'PAC',filesep,experiment.name, ...
        filesep, 'PAC1818.mat'));
    end
    PAC3 = PAC;
%     load(strcat(path.output,filesep,'results',filesep,'PAC',filesep,experiment.name, ...
%         filesep, 'PAC2929.mat'));
    for segment=1:length(PAC3)
        pac3(:,:,segment) = PAC3{1,segment}.relat_mi;
    end
%     for segment=1:length(PAC2)
%         pac2(:,:,segment) = PAC2{1,segment}.relat_mi;
%     end
%         for segment=1:length(PAC1)
%         pac1(:,:,segment) = PAC1{1,segment}.relat_mi;
%     end
%     for segment=1:length(PAC)
%         pac(:,:,segment) = PAC{1,segment}.relat_mi;
%     end
    suptosup(:,:,n) = mean(pac3,3);
%     suptodeep(:,:,n) = mean(pac1,3);
%     deeptosup(:,:,n) = mean(pac2,3);
%     deeptodeep(:,:,n) = mean(pac,3);
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
    clearvars pac pac1 pac2 pac3
end

wtS2S = mean(suptosup(:,:,1:37),3);
wtS2D = mean(suptodeep(:,:,1:37),3);
wtD2S = mean(deeptosup(:,:,1:37),3);
wtD2D = mean(deeptodeep(:,:,1:37),3);
geS2S = mean(suptosup(:,:,38:52),3);
geS2D = mean(suptodeep(:,:,39:end),3);
geD2S = mean(deeptosup(:,:,39:end),3);
geD2D = mean(deeptodeep(:,:,39:end),3);
microS2S = mean(suptosup(:,:,53:end),3);
%% dataset for stats

wtbeta2gamma = squeeze(mean(mean(suptosup(21:end,13:end,1:37))));
wttheta2gamma = squeeze(mean(mean(suptosup(:,4:12,1:37))));
gebeta2gamma = squeeze(mean(mean(suptosup(21:end,12:end,39:end))));
getheta2gamma = squeeze(mean(mean(suptosup(:,4:12,39:end))));

%% plot
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,wtS2S,[0 3.5])
colormap('jet')
axis xy
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,wtS2D,[0 3.5])
colormap('jet')
axis xy
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,wtD2S,[0 3.5])
colormap('jet')
axis xy
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1 ,1}.freqvec_amp,wtD2D,[0 3.5])
colormap('jet')
axis xy
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,geS2S,[0 3.5])
colormap('jet')
axis xy
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,geS2D,[0 3.5])
colormap('jet')
axis xy
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,geD2S,[0 3.5])
colormap('jet')
axis xy
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1 ,1}.freqvec_amp,geD2D,[0 3.5])
colormap('jet')
axis xy
figure; imagesc(PAC3{1,1}.freqvec_ph,PAC3{1,1}.freqvec_amp,microS2S,[0 3.5])
colormap('jet')
axis xy


