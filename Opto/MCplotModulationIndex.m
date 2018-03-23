function MCplotModulationIndex(experiments,expType,StimArea,RespArea,channels)
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
modulation_index=(GoodSpikes(:,2)-GoodSpikes(:,1))./(GoodSpikes(:,1)+GoodSpikes(:,2));
firing_pre=log(GoodSpikes(:,1));

figure
title(strcat(expType{1},' - ',StimArea,' to ', RespArea))
hold on
histogram(modulation_index,linspace(-1,1,10));
ylabel('counts')
xlabel('OMI')
set(gca,'TickDir','out');
set(gca,'FontSize',20)

% modulation_index(firing_pre==-Inf)=[];
% firing_pre(firing_pre==-Inf)=[];
% figure
% model=fitlm(firing_pre,modulation_index);
% plot(model)
% hold on
% delete(findall(gcf,'type','legend'))
% title(strcat(expType{1},' - ',StimArea,' to ', RespArea))
% dim=[.2 .5 .3 .3];
% annotation('textbox',dim,'String',strcat('p = ',num2str(model.Coefficients.pValue(2))),'FitBoxToText','On');
% xlabel('Firing Rate pre stim')
% ylabel('OMI')
end
