function MCplotStimRasterPlot(experiment,stimulusType,StimArea,channels)

parameters=get_parameters;
Path=get_path;

if strcmp(StimArea, 'HP')
    chan=1:16;
elseif strcmp(StimArea, 'PFCL2')
    chan=17:24;
elseif strcmp(StimArea, 'PFCL5')
    chan=25:32;
end

if isnumeric(channels)
    csc=channels;
else
    [csc,~,~]=MCgetRespondingRamp(experiment,0,0);
    csc=csc(ismember(csc,chan));
end

if ~isnan(csc)
    for CSC=csc
        binsize = parameters.plotStimulationRasterPlot.binsize; %sec
        nbins = (parameters.(['Window_' stimulusType{1}])(4)+abs(parameters.(['Window_' stimulusType{1}])(1)))/binsize;
        Frequency = 0;
        loadName = ['CSC' num2str(CSC) '_' stimulusType{1}];
        h = figure();
        % load stimStructure & plot the stimulation period
        stimStructure = getStimulusSignal(experiment,CSC,stimulusType{1},0,10);
        figure(h)
        subplot(5,1,1)
        % Stimulus on/off
        hold on
        title([experiment.name,', stimulus= ',stimulusType{1},', ',num2str(Frequency),'Hz, CSC' num2str(CSC)], 'interpreter', 'none');
        plot(stimStructure.time,stimStructure.signalD(1,:)*50,'b');
        plot(stimStructure.time,stimStructure.signalA(1,:),'r');
        xlim([parameters.(['Window_' stimulusType{1}])(1) parameters.(['Window_' stimulusType{1}])(4)])
        hold off
        clearvars stimStructure
        
        % RasterPlot
        subplot(5,1,[2:3])
        load(strcat(Path.output,filesep,'results',filesep,'StimulationMUAspikeTimes',filesep,experiment.name,filesep,loadName));
        
        
        psth = [];
        n_elements = [];
        hold on
        title('RasterPlot')
        for pp = 1:length(fieldnames(spikeTimeData))
            %% detect all spikes in period window
            peakLoc = spikeTimeData.(['P' num2str(pp)])(1,:);
            % peakfinderOpto(signal_400_1500,0 ,-thr,-1); %% Plots signal + marks the detected peaks
            psth = [psth peakLoc];
            [n_elements(pp,:), ~] = histc(peakLoc,parameters.(['Window_' stimulusType{1}])(1):binsize:parameters.(['Window_' stimulusType{1}])(4));
            % peakLoc_all{pp,:} = peakLoc;
            scatter(peakLoc,zeros(1,length(peakLoc))+pp,5,'k','s', 'filled')
            xlim([parameters.(['Window_' stimulusType{1}])(1) parameters.(['Window_' stimulusType{1}])(4)])
        end
        hold off
        
        subplot(5,1,4)
        % PSTH
        hold on
        title('Peristimulus time histogram')
        hist(psth,nbins)
        xlim([parameters.(['Window_' stimulusType{1}])(1) parameters.(['Window_' stimulusType{1}])(4)])
        ylim([0 50]);
        hold off
        
        subplot(5,1,5)
        hold on
        title('SpikeProbability')
        % spikeprobability
        n_elements(n_elements >0) = 1;
        SpikeProb = mean(n_elements,1);
        plot(parameters.(['Window_' stimulusType{1}])(1):binsize:parameters.(['Window_' stimulusType{1}])(4),SpikeProb)
        bar(parameters.(['Window_' stimulusType{1}])(1):binsize:parameters.(['Window_' stimulusType{1}])(4),SpikeProb)
        ylim([0 1])
        xlim([parameters.(['Window_' stimulusType{1}])(1) parameters.(['Window_' stimulusType{1}])(4)])
        hold off
    end
end
end