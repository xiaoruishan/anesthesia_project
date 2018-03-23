function MCplotMUASpikeRatio(experiments,expType,StimArea,RespArea,channels)
%% By Mattia
Path = get_path;
parameters=get_parameters;
countAnimal=0;
GoodSpikes=[];
for n_animal = 1:length(experiments);
    experiment=experiments(n_animal);
    if ~isempty(experiment.animal_ID) && experiment.expression(1)==1 && strcmp(experiment.Exp_type,expType{1}) && strcmp(experiment.IUEarea,StimArea)
        clearvars spikes
        if strcmp(RespArea, 'HP')
            csc=experiment.HPreversal-2:experiment.HPreversal+2;
        elseif strcmp(RespArea, 'PFCL2')
            csc=17:24;
        elseif strcmp(RespArea, 'PFCL5')
            csc=25:32;
        end
        if strcmp(StimArea, 'HP')
            csc1=experiment.HPreversal-2:experiment.HPreversal+2;
        elseif strcmp(StimArea, 'PFCL2')
            csc1=17:24;
        elseif strcmp(StimArea, 'PFCL5')
            csc1=25:32;
        end
        [RespondingCSC,spikingCSC,spikes]=MCgetRespondingRamp(experiment,0,0); % get CSCs that have a minimum amount of spikes, 
        % and responding units (min amount of spikes and ratio>2)
        if strcmp(channels, 'all')
            RespondingCSC=[]; % 
        else
            RespondingCSC=RespondingCSC(ismember(RespondingCSC,csc1)); % consider as responding CSCs only units that area in the area that was stimulated
        end
        CSC=spikingCSC(~ismember(spikingCSC,RespondingCSC)); % take out responding units from the group of CSCs with a min amount of spikes
        CSC=CSC(ismember(CSC,csc)); % consider only CSC in the responding area of interest
        spikes=spikes(ismember(spikingCSC,CSC),:);
        if numel(spikes)>0
            countAnimal=countAnimal+1;
            GoodSpikes=vertcat(GoodSpikes,spikes);
        end
    end
end
channels=length(GoodSpikes);
average_change=-(median(GoodSpikes(:,1))-median(GoodSpikes(:,2)))./median(reshape(GoodSpikes,1,channels*2));
GoodSpikes=log(GoodSpikes);
disp(['Number of animals: ' num2str(countAnimal)])
disp(['Number of Channels: ' num2str(channels)])
xvalues=vertcat(repmat(0.2,channels,1),repmat(0.8,channels,1));
p=signrank(GoodSpikes(:,1),GoodSpikes(:,2));
figure
title(strcat(StimArea,' to ', RespArea,' p=',num2str(p),' average change: ',num2str(average_change)))
hold on
scatter(xvalues,reshape(GoodSpikes,2*channels,1),25,'s','filled','k')
line(reshape(xvalues,channels,2)',GoodSpikes','linewidth',1,'color','k')
scatter([0.2 0.8],[median(GoodSpikes(:,1)) median(GoodSpikes(:,2))],75,'s','filled','r')
line([0.2 0.8],[median(GoodSpikes(:,1)) median(GoodSpikes(:,2))],'linewidth',3,'color','r')
xlim([0 1])
ylabel('log MUA firing rate')
x=([0.2 0.8]);
xlabel={'pre','during'};
set(gca,'XTick',x)
set(gca,'XTickLabel',xlabel)
set(gca,'TickDir','out');
set(gca,'FontSize',20)


end
