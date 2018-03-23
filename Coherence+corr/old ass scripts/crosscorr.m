


clear all

path = get_path;
experiments = get_experiment_list;
% animals = [801:814 400:405 407:415 419:427];
% animals = [601:642 301:325];
animals = [501:536 551:565];
delta = [1 8];
theta = [8 12];
gamma = [12 30];


for animale = 1:length(animals)%[1:4 7:42 43:48 50 52 53 55:length(animals)]
    
    experiment = experiments(animals(animale));
    
    clear HP & PFCsup
    
%     load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'Spikes'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpWaves1'));
    
%     HP_MUA = squeeze(spikes{1});
%     Sup1_MUA = squeeze(spikes{2});
%     Deep2_MUA = squeeze(spikes{5});


    SWR_delta = reshape(ZeroPhaseFilter(sharpwaves(1,:,:),3200,delta),1,9601,size(sharpwaves,3));
    SWR_theta = reshape(ZeroPhaseFilter(sharpwaves(1,:,:),3200,theta),1,9601,size(sharpwaves,3));
    SWR_gamma = reshape(ZeroPhaseFilter(sharpwaves(1,:,:),3200,gamma),1,9601,size(sharpwaves,3));
    PFC_delta = reshape(ZeroPhaseFilter(sharpPFC(1,:,:),3200,delta),1,9601,size(sharpwaves,3));
    PFC_theta = reshape(ZeroPhaseFilter(sharpPFC(1,:,:),3200,theta),1,9601,size(sharpwaves,3));
    PFC_gamma = reshape(ZeroPhaseFilter(sharpPFC(1,:,:),3200,gamma),1,9601,size(sharpwaves,3));
    
    clear sharpwaves & sharpPFC
    
    for event = 1:size(SWR_delta,3)    
        corr_delta(:,event) = xcorr(SWR_delta(1,:,event),PFC_delta(1,:,event),300);
        corr_theta(:,event) = xcorr(SWR_theta(1,:,event),PFC_theta(1,:,event),200);
%         corr_gamma(:,event) = xcorr(SWR_gamma(1,:,event),PFC_gamma(1,:,event),100);
%         corr_lfp_sup(:,event) = xcorr(sharpwaves(1,:,event),sharpPFC(1,:,event),100);
%         corr_lfp_deep(:,event) = xcorr(sharpwaves(1,:,event),sharpPFC(4,:,event),100);
%         corr_spikes_sup(:,event) = xcorr(HP_MUA(:,event),Sup1_MUA(:,event),100);
%         corr_spikes_deep(:,event) = xcorr(HP_MUA(:,event),Deep2_MUA(:,event),100);
    end
    
    if animale < 37
        WT1(:,animale) = mean(abs(corr_delta),2);
        WT2(:,animale) = mean(abs(corr_theta),2);
%         WT3(:,animale) = mean(abs(corr_gamma),2);
%         WT1(:,animale) = mean(abs(corr_lfp_sup),2);
%         WT2(:,animale) = mean(abs(corr_lfp_deep),2);
%         WT3(:,animale) = mean(abs(corr_spikes_sup),2);
%         WT4(:,animale) = mean(abs(corr_spikes_deep),2);
    else
        GE1(:,animale) = mean(abs(corr_delta),2);
        GE2(:,animale) = mean(abs(corr_theta),2);
%         GE3(:,animale) = mean(abs(corr_gamma),2);
%         GE1(:,animale-36) = mean(abs(corr_lfp_sup),2);
%         GE2(:,animale-36) = mean(abs(corr_lfp_deep),2);
%         GE3(:,animale-36) = mean(abs(corr_spikes_sup),2);
%         GE4(:,animale-36) = mean(abs(corr_spikes_deep),2);
    end
    
    clear corr_delta & corr_theta & corr_gamma & corr_lfp_sup & corr_lfp_deep & corr_spikes_sup & corr_spikes_deep
    
    display(strcat('mancano', num2str(length(animals)-animale),' animali'))        

end

figure
plot(linspace(-300/3200,300/3200,601),mean(WT1,2),'linewidth',3)
hold on
plot(linspace(-300/3200,300/3200,601),mean(GE1,2),'linewidth',3)

figure
for cc = 1:36
    plot(linspace(-100/3200,100/3200,201),GE3(:,cc)./mean(GE3(:,cc)),'linewidth',3)
%     xlim([-0.03 +0.03])
    hold on
    k = waitforbuttonpress
end

