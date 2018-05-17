%% same old scripts

clear all
path=get_path;
experiments=get_experiment_list;
animal=1:2:38;

%% load stuff 

spike_triggered_pl = zeros(length(animal),2000); spike_triggered_hp = spike_triggered_pl;
for n=1:length(animal)
    experiment=experiments(animal(n));
%     CSC=experiment.IL(1);% PL(1) PL(4) HPreversal
    if strcmp(experiment.Exp_type,'AWA')
        repetitions=1;
    else
        repetitions=1;
    end
    num_spikesPL = 0; num_spikesHP = 0;
    for period=repetitions
        PL = []; HP = [];
        for channel = 29:32 % 29:32 str2num(experiment.PL)
            load(strcat(path.output,filesep,'results\MUAtimestamps\',experiment.name,filesep,'MUAtimestamps15',num2str(channel),num2str(period),'.mat'))
            PL = [PL round(peakLoc./32)];
        end
        PL =  unique(PL);
        for channel =  experiment.HPreversal-1 : experiment.HPreversal+1 % experiment.HPreversal-1 : experiment.HPreversal+1 experiment.nameDead
            load(strcat(path.output,filesep,'results\MUAtimestamps\',experiment.name,filesep,'MUAtimestamps15',num2str(channel),num2str(period),'.mat'))
            HP = [HP round(peakLoc./32)];
        end
        HP = unique(HP);
        for k = 1:length(HP)
            spikes = zeros(1,2000);
            pfc = PL - HP(k) + 500;
            pfc(pfc <= 0 | pfc >= 2000) = [];
            spikes(pfc) = 1;
            spike_triggered_pl(n,:) = spike_triggered_pl(n,:) + spikes;
            num_spikesPL = num_spikesPL + sum(spikes);
        end
        for k = 1:length(PL)
            spikes = zeros(1,2000);
            hp = HP - PL(k) + 500;
            hp(hp <= 0 | hp >= 2000) = [];
            spikes(hp) = 1;
            spike_triggered_hp(n,:) = spike_triggered_hp(n,:) + spikes;
            num_spikesHP = num_spikesHP + sum(spikes);
        end
    end
    if num_spikesPL > 10
        spike_triggered_pl(n,:) = spike_triggered_pl(n,:) ./ num_spikesPL;
    else
        spike_triggered_pl(n,:) = zeros(1, 2000);
    end
    if num_spikesHP > 10
        spike_triggered_hp(n,:) = spike_triggered_hp(n,:) ./ num_spikesHP;
    else
        spike_triggered_hp(n,:) = zeros(1, 2000);
    end
end

figure; boundedline(linspace(-500,1500,2000),smooth(median(spike_triggered_pl),20)*10^4, ...
    mad(smooth(spike_triggered_pl,20))*10^4./sqrt(size(spike_triggered_pl,1)))
hold on; title('Spike-triggered firing rate'); ylabel('Nomalized FR'); xlabel('Time (milliseconds)'); 
set(gca,'FontSize',20); set(gca,'TickDir','out')
boundedline(linspace(-500,1500,2000),smooth(median(spike_triggered_hp),20)*10^4, ...
    mad(smooth(spike_triggered_hp,20))*10^4./sqrt(size(spike_triggered_hp,1)),'r')
xlim([-500 500]); y = get(gca,'ylim'); plot([0 0], y, 'k', 'linewidth', 2);

