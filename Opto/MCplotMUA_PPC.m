function MCplotMUA_PPC(experiments,expType,StimArea,stimulusType,RespArea,channels)
%% By Mattia - based on Joachim's plot_StimulationMUASpikePhase function


Path = get_path;
parameters=get_parameters;
freqBands={'theta','beta','gamma'};

if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
    Frequency = parameters.stimFreq;
elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
    Frequency = 0;
end
for freq = Frequency
    countCSC=0;
    for n_animal = 1:length(experiments);
        experiment=experiments(n_animal);
        if ~isempty(experiment.animal_ID) && experiment.expression(1)==1 && strcmp(experiment.Exp_type,expType{1}) && strcmp(experiment.IUEarea,StimArea)
            if strcmp(RespArea, 'HP')
                csc=experiment.HPreversal-2:experiment.HPreversal+2;
            elseif strcmp(RespArea, 'PFCL2')
                csc=17:24;
            else
                csc=25:32;
            end
            if strcmp(channels,'responding')
                [csc1,~,~]=MCgetRespondingRamp(experiment,0,0);
                csc=csc(ismember(csc,csc1));
            elseif strcmp(channels,'other')
                [csc1,~,~]=MCgetRespondingRamp(experiment,0,0);
                csc=csc(~ismember(csc,csc1));
            end
            for channel=1:length(csc)
                CSC=csc(channel);
                if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
                    loadName = ['CSC' num2str(CSC) '_' stimulusType{1} num2str(freq)];
                elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
                    loadName = ['CSC' num2str(CSC) '_' stimulusType{1}];
                end
                clearvars MUAspikePhase baselinePhase
                load(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikePhase',filesep,experiment.name,filesep,loadName));
                load(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name,filesep,loadName));
                % generate vector with spiketimes
                spikeTimes=[];
                for ss=1:size(fieldnames(spikeTimeData),1)
                    spikeTimes=[spikeTimes spikeTimeData.(['P' num2str(ss)])];
                end
                spikeTimes=spikeTimes(1,:);
                real_spikes=find(spikeTimes<2.99 | spikeTimes>3.01);
                spikeTimes=spikeTimes(real_spikes);
                %                     if length(spikeTimes)==length(MUAspikePhase.theta)
                clearvars Tpre Tpost Tstim
                Tpre=spikeTimes<0;
                Tstim=spikeTimes<3 & spikeTimes>0;
                % preStim
                if nnz(Tpre)>10 && nnz(Tstim)>10
                    countCSC=countCSC+1;
                    for freqbands = 1:length(freqBands)
                        clearvars Phases
                        Phases = MUAspikePhase.(freqBands{freqbands});
                        Phases=Phases(real_spikes);
                        Phases=Phases(Tpre);
                        [PPC.(freqBands{freqbands}).preStim(countCSC),PCDI.(freqBands{freqbands}).preStim(countCSC)]=getPPC_PCDI_PLV(Phases);
                    end
                    % stim
                    for freqbands = 1:length(freqBands)
                        clearvars Phases
                        Phases = MUAspikePhase.(freqBands{freqbands});
                        Phases=Phases(real_spikes);
                        Phases=Phases(Tstim);
                        [PPC.(freqBands{freqbands}).Stim(countCSC),PCDI.(freqBands{freqbands}).Stim(countCSC)]=getPPC_PCDI_PLV(Phases);
                    end
                end
                %                     end
            end
        end
    end
end
disp(['Number of Channels: ' num2str(countCSC)])

figure
subplot(1,3,1)
average_change=-(median(PPC.theta.preStim)-median(PPC.theta.Stim))./median(horzcat(PPC.theta.preStim,PPC.theta.Stim));
scatter([0.2 0.8],[median(PPC.theta.preStim) median(PPC.theta.Stim)],75,'s','filled','r')
line([0.2 0.8],[median(PPC.theta.preStim) median(PPC.theta.Stim)],'linewidth',3,'color','r')
xvalues=vertcat(repmat(0.2,countCSC,1),repmat(0.8,countCSC,1));
theta=horzcat(PPC.theta.preStim,PPC.theta.Stim)';
p=signrank(PPC.theta.preStim,PPC.theta.Stim);
title(strcat('PPC theta p=',num2str(p),' average change: ',num2str(average_change)))
hold on
scatter(xvalues,theta,25,'s','filled','k')
line(reshape(xvalues,countCSC,2)',reshape(theta,countCSC,2)','linewidth',1,'color','k')
xlim([0 1])
ylabel('PPC')
x=([0.2 0.8]);
xlabel={'pre','during'};
set(gca,'XTick',x)
set(gca,'XTickLabel',xlabel)
set(gca,'FontSize', 12)

subplot(1,3,2)
average_change=-(median(PPC.beta.preStim)-median(PPC.beta.Stim))./median(horzcat(PPC.beta.preStim,PPC.beta.Stim));
scatter([0.2 0.8],[median(PPC.beta.preStim) median(PPC.beta.Stim)],75,'s','filled','r')
line([0.2 0.8],[median(PPC.beta.preStim) median(PPC.beta.Stim)],'linewidth',3,'color','r')
xvalues=vertcat(repmat(0.2,countCSC,1),repmat(0.8,countCSC,1));
beta=horzcat(PPC.beta.preStim,PPC.beta.Stim)';
p=signrank(PPC.beta.preStim,PPC.beta.Stim);
title(strcat('PPC beta p=',num2str(p),' average change: ',num2str(average_change)))
hold on
scatter(xvalues,beta,25,'s','filled','k')
line(reshape(xvalues,countCSC,2)',reshape(beta,countCSC,2)','linewidth',1,'color','k')
xlim([0 1])
ylabel('PPC')
x=([0.2 0.8]);
xlabel={'pre','during'};
set(gca,'XTick',x)
set(gca,'XTickLabel',xlabel)
set(gca,'FontSize', 12)

subplot(1,3,3)
average_change=-(median(PPC.gamma.preStim)-median(PPC.gamma.Stim))./median(horzcat(PPC.gamma.preStim,PPC.gamma.Stim));
scatter([0.2 0.8],[median(PPC.gamma.preStim) median(PPC.gamma.Stim)],75,'s','filled','r')
line([0.2 0.8],[median(PPC.gamma.preStim) median(PPC.gamma.Stim)],'linewidth',3,'color','r')
xvalues=vertcat(repmat(0.2,countCSC,1),repmat(0.8,countCSC,1));
gamma=horzcat(PPC.gamma.preStim,PPC.gamma.Stim)';
p=signrank(PPC.gamma.preStim,PPC.gamma.Stim);
title(strcat('PPC gamma p=',num2str(p),' average change: ',num2str(average_change)))
hold on
scatter(xvalues,gamma,25,'s','filled','k')
line(reshape(xvalues,countCSC,2)',reshape(gamma,countCSC,2)','linewidth',1,'color','k')
xlim([0 1])
ylabel('PPC')
x=([0.2 0.8]);
xlabel={'pre','during'};
set(gca,'XTick',x)
set(gca,'XTickLabel',xlabel)
set(gca,'FontSize', 12)

figure
subplot(1,3,1)
average_change=-(median(PCDI.theta.preStim)-median(PCDI.theta.Stim))./median(horzcat(PCDI.theta.preStim,PCDI.theta.Stim));
scatter([0.2 0.8],[median(PCDI.theta.preStim) median(PCDI.theta.Stim)],75,'s','filled','r')
line([0.2 0.8],[median(PCDI.theta.preStim) median(PCDI.theta.Stim)],'linewidth',3,'color','r')
xvalues=vertcat(repmat(0.2,countCSC,1),repmat(0.8,countCSC,1));
theta=horzcat(PCDI.theta.preStim,PCDI.theta.Stim)';
p=signrank(PCDI.theta.preStim,PCDI.theta.Stim);
title(strcat('PCDI theta p=',num2str(p),' average change: ',num2str(average_change)))
hold on
scatter(xvalues,theta,25,'s','filled','k')
line(reshape(xvalues,countCSC,2)',reshape(theta,countCSC,2)','linewidth',1,'color','k')
xlim([0 1])
ylabel('PCDI')
x=([0.2 0.8]);
xlabel={'pre','during'};
set(gca,'XTick',x)
set(gca,'XTickLabel',xlabel)
set(gca,'FontSize', 12)

subplot(1,3,2)
average_change=-(median(PCDI.beta.preStim)-median(PCDI.beta.Stim))./median(horzcat(PCDI.beta.preStim,PCDI.beta.Stim));
scatter([0.2 0.8],[median(PCDI.beta.preStim) median(PCDI.beta.Stim)],75,'s','filled','r')
line([0.2 0.8],[median(PCDI.beta.preStim) median(PCDI.beta.Stim)],'linewidth',3,'color','r')
xvalues=vertcat(repmat(0.2,countCSC,1),repmat(0.8,countCSC,1));
beta=horzcat(PCDI.beta.preStim,PCDI.beta.Stim)';
p=signrank(PCDI.beta.preStim,PCDI.beta.Stim);
title(strcat('PCDI beta p=',num2str(p),' average change: ',num2str(average_change)))
hold on
scatter(xvalues,beta,25,'s','filled','k')
line(reshape(xvalues,countCSC,2)',reshape(beta,countCSC,2)','linewidth',1,'color','k')
xlim([0 1])
ylabel('PCDI')
x=([0.2 0.8]);
xlabel={'pre','during'};
set(gca,'XTick',x)
set(gca,'XTickLabel',xlabel)
set(gca,'FontSize', 12)

subplot(1,3,3)
average_change=-(median(PCDI.gamma.preStim)-median(PCDI.gamma.Stim))./median(horzcat(PCDI.gamma.preStim,PCDI.gamma.Stim));
scatter([0.2 0.8],[median(PCDI.gamma.preStim) median(PCDI.gamma.Stim)],75,'s','filled','r')
line([0.2 0.8],[median(PCDI.gamma.preStim) median(PCDI.gamma.Stim)],'linewidth',3,'color','r')
xvalues=vertcat(repmat(0.2,countCSC,1),repmat(0.8,countCSC,1));
gamma=horzcat(PCDI.gamma.preStim,PCDI.gamma.Stim)';
p=signrank(PCDI.gamma.preStim,PCDI.gamma.Stim);
title(strcat('PCDI gamma p=',num2str(p),' average change: ',num2str(average_change)))
hold on
scatter(xvalues,gamma,25,'s','filled','k')
line(reshape(xvalues,countCSC,2)',reshape(gamma,countCSC,2)','linewidth',1,'color','k')
xlim([0 1])
ylabel('PCDI')
x=([0.2 0.8]);
xlabel={'pre','during'};
set(gca,'XTick',x)
set(gca,'XTickLabel',xlabel)
set(gca,'FontSize', 12)

end
