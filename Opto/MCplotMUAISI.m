function MCplotMUAISI(experiments,expType,StimArea,stimulusType,RespArea,channels)
parameters=get_parameters;
if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
    Frequency = parameters.stimFreq;
elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
    Frequency = 0;
end
for freq = Frequency
    f1=figure;
    clearvars ISIvectorPre ISIvectorStim ISIvectorPost
    countAnimal=0;
    countCSC=0;
    for n_animal = 1:length(experiments);
        experiment=experiments(n_animal);
        if ~isempty(experiment.animal_ID) && strcmp(experiment.Exp_type,expType{1}) && strcmp(experiment.IUEarea,StimArea)
            if strcmp(RespArea,'HP')
                csc=experiment.HPreversal-2:experiment.HPreversal+2;
            elseif strcmp(RespArea,'PFCL2')
                csc=17:24;
            elseif strcmp(RespArea,'PFCL5')
                csc=25:32;
            end
            if strcmp(channels,'all')
                    [~,CSCcalc,~]=MCgetRespondingRamp(experiment,0,0);
                    CSCcalc=CSCcalc(ismember(CSCcalc,csc));
            else
                if strcmp(stimulusType{1}, 'square')
                    [CSCcalc,~,~,~] = getStimulationRespondingCSCsSquare(experiment,1,0);
                elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
                    [CSCcalc,~,~]=MCgetRespondingRamp(experiment,0,0);
                end
                CSCcalc=CSCcalc(ismember(CSCcalc,csc));
            end
            if CSCcalc > 0
                countAnimal=countAnimal+1;
                disp(experiment.animal_ID)
                for CSC=CSCcalc
                    [ISIPre,ISIStim,ISIPost,~] = getStimulationMUAISI(experiment,CSC,stimulusType,freq);
                    if numel(ISIPre)>0 && numel(ISIStim)>0 && numel(ISIPost)>0
                        countCSC=countCSC+1;
                        ISIvectorPre(countCSC,:) = ISIPre;
                        ISIvectorStim(countCSC,:) = ISIStim;
                        ISIvectorPost(countCSC,:) = ISIPost;
                        clearvars ISIPre ISIStim ISIPost
                    end
                end
            end
        end
    end
    %% Plot
    figure(f1)
    subplot(1,length(expType),1)
    hold on
    title(['Inter Stimulus Interval - n = ' num2str(countAnimal), ' mice, ' num2str(countCSC), ' channels'])
    if exist('ISIvectorPre')
        boundedline(0:parameters.spikeanalysis.ISI.binsize:1, ...
            mean(ISIvectorPre),std(ISIvectorPre,0,1)/sqrt(countCSC), ...
            '-k','transparency', 0.1);
        boundedline(0:parameters.spikeanalysis.ISI.binsize:1, ...
            mean(ISIvectorPost,1),std(ISIvectorPost,0,1)/sqrt(countCSC),...
            '-r','transparency', 0.1);
        boundedline(0:parameters.spikeanalysis.ISI.binsize:1, ...
            mean(ISIvectorStim,1),std(ISIvectorStim,0,1)/sqrt(countCSC),...
            '-b','transparency', 0.1);
        % set limits/labels
        xlim([0 0.25])
        ylim([0 max(get(gca,'YLim'))])
        ax=gca;
        ax.XTick=[0.02 0.033 0.05 0.1 0.2];
        ax.XTickLabel={'50','30','20','10','5'};
        xlabel('Frequency (Hz)')
        ylabel('Occurence/(animal*period)')
        hold off
        set(gca,'FontSize',16)
    end
end
end