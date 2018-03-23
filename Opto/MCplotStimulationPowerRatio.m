function MCplotStimulationPowerRatio(experiments,expType,StimArea,stimulusType,RespArea)
% by Mattia, based on Joachim's plotStimulationPowerRatio
Path=get_path;
parameters=get_parameters;
freqWindows = [4 12;12 30;30 100]; % add to param
if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
    Frequency = parameters.stimFreq;
%     Frequency = Frequency([4 5]);
elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
    Frequency = 0;
end
for freq = Frequency
    countAnimal=0;
    for n_animal = 1:length(experiments);
        experiment=experiments(n_animal);
        if ~isempty(experiment.animal_ID) && experiment.expression(1)==1 && strcmp(experiment.Exp_type,expType{1}) && strcmp(experiment.IUEarea,StimArea)
            if strcmp(RespArea, 'HP')
                CSC=experiment.HPreversal;
            elseif strcmp(RespArea, 'PFCL2')
                CSC=experiment.PL(1);
            elseif strcmp(RespArea, 'PFCL5')
                CSC=experiment.PL(4);
            end
            countAnimal=countAnimal+1;
            if strcmp(stimulusType{1}, 'square') || strcmp(stimulusType{1}, 'sine')
                loadname = ['CSC' num2str(CSC) '_' stimulusType{1} num2str(freq)];
            elseif strcmp(stimulusType{1},'ramp') || strcmp(stimulusType{1}, 'chirp')
                loadname = ['CSC' num2str(CSC) '_' stimulusType{1}];
            end
            if ~exist(strcat(Path.output,filesep,'results',filesep,'StimulationPower',filesep,experiment.name,filesep,loadname,'.mat'))
                stimStructure = getStimulusSignal(experiment,CSC,stimulusType{1}, freq, 10);
                [stimulationPower]=getStimulationPower(stimStructure,experiment,1,0);
            else
                stimStructure.stimulusType=stimulusType{1};
                stimStructure.stimulusFrequency=freq;
                stimStructure.CSC=CSC;
                [stimulationPower]=getStimulationPower(stimStructure,experiment,1,0);
            end
            for FREQ = 1:length(freqWindows)
                freqWindow = [find(stimulationPower.f_preStim >= freqWindows(FREQ,1),1,'first'), find(stimulationPower.f_preStim >= freqWindows(FREQ,2),1,'first')];
                
                PowerPre(countAnimal,FREQ)=trapz(stimulationPower.f_preStim(freqWindow(1):freqWindow(2)), ...
                    stimulationPower.pxx_preStim(freqWindow(1):freqWindow(2)));
                PowerPost(countAnimal,FREQ)=trapz(stimulationPower.f_preStim(freqWindow(1):freqWindow(2)), ...
                    stimulationPower.pxx_postStim(freqWindow(1):freqWindow(2)));
                %PowerNoStim(n_animal,FREQ)=mean([PowerPre PowerPost]);
                PowerStim(countAnimal,FREQ)=trapz(stimulationPower.f_preStim(freqWindow(1):freqWindow(2)), ...
                    stimulationPower.pxx_stimLastHalf(freqWindow(1):freqWindow(2))); %pxx_stimLastHalf pxx_stim
                PowerMid(countAnimal,FREQ)=trapz(stimulationPower.f_preStim(freqWindow(1):freqWindow(2)), ...
                    stimulationPower.pxx_stimFirstHalf(freqWindow(1):freqWindow(2))); %pxx_stimLastHalf pxx_stim
                RatioPowerStim(countAnimal,FREQ)=PowerStim(countAnimal,FREQ)/PowerPre(countAnimal,FREQ);
                
                SpectrumPre(countAnimal,:)=stimulationPower.pxx_preStim; %pxx_preStim
                SpectrumPost(countAnimal,:)=stimulationPower.pxx_stimLastHalf;%pxx_stimLastHalf
                
            end
            clearvars StimStructure freqSpecStructure
        end
    end
    xvalues=vertcat(repmat(0.2,countAnimal,1),repmat(0.8,countAnimal,1));
    theta=vertcat(PowerPre(:,1),PowerStim(:,1));
    p=signrank(PowerPre(:,1),PowerStim(:,1));
    figure
    subplot(1,3,1)
    title(strcat('theta p=',num2str(p)))
    hold on
    scatter(xvalues,theta,50,'s','filled','k')
    line(reshape(xvalues,countAnimal,2)',reshape(theta,countAnimal,2)','linewidth',2)
    
    beta=vertcat(PowerPre(:,2),PowerStim(:,2));
    p=signrank(PowerPre(:,2),PowerStim(:,2));
    subplot(1,3,2)
    title(strcat('beta p=',num2str(p)))
    hold on
    scatter(xvalues,beta,50,'s','filled','k')
    line(reshape(xvalues,countAnimal,2)',reshape(beta,countAnimal,2)','linewidth',2)
    
    gamma=vertcat(PowerPre(:,3),PowerStim(:,3));
    p=signrank(PowerPre(:,3),PowerStim(:,3));
    subplot(1,3,3)
    title(strcat('gamma p=',num2str(p)))
    hold on
    scatter(xvalues,gamma,50,'s','filled','k')
    line(reshape(xvalues,countAnimal,2)',reshape(gamma,countAnimal,2)','linewidth',2)
    
    clearvars theta beta gamma PowerPre PowerPost xvalues
    
    figure; boundedline(linspace(0,400,801),mean(SpectrumPost./SpectrumPre),std(SpectrumPost./SpectrumPre)./sqrt(size(SpectrumPre,1)))
    hold on
    plot(get(gca,'xlim'),[1 1],'r','linewidth',3)
    
    title('Relative Power Spectrum')
    ylabel('Relative Power')
    xlabel('Frequency (Hz)')
    set(gca,'FontSize',12)
    xlim([4 50])
    ylim([0.5 3.5])
end

end