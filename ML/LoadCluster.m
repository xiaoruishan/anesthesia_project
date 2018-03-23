%% same old stuff

% clear all
path=get_path;
experiments=get_experiment_list;
animal=1:38;


%% load stuff 
propertiesPFC = []; information = []; propertiesHP = [];
for n=1:length(animal)
    experiment=experiments(animal(n));
    age = experiment.age;
    CSC=experiment.PL(1);% PL(1) PL(4) HPreversal
    if strcmp(experiment.Exp_type,'AWA')
        periodo = 1;
    else
        periodo = 1:3;
    end
        
    for period=periodo
        load(strcat(path.output,filesep,'results\OscProperties\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        PFCentropy = OscProperties(:,1);
        HPentropy = OscProperties(:,2);
        duration = OscProperties(:,3);
        PFCpower = OscProperties(:,84:2003); % delete power below 4hz (noise, since the window is 1s) and above 100hz
        PFCpower = squeeze(sum(reshape(PFCpower,size(PFCpower,1),size(PFCpower,2)/120,[]),2)); % reduce frequency definition by a factor of 16 (become 1hz resolution)
        HPpower = OscProperties(:,3285:5204); % delete power below 4hz (noise, since the window is 1s) and above 100hz
        HPpower = squeeze(sum(reshape(HPpower,size(HPpower,1),size(HPpower,2)/120,[]),2)); % reduce frequency definition by a factor of 16 (become 1hz resolution)
        Coherence = OscProperties(:,6486:8405); % delete coherence below 4hz (noise, since the window is 1s) and above 100hz
        Coherence = squeeze(sum(reshape(Coherence,size(Coherence,1),size(Coherence,2)/120,[]),2)); % reduce frequency definition by a factor of 16 (become 1hz resolution)
        
        load(strcat(path.output,filesep,'results',filesep,'OscFiring',filesep,experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        OscFiring = reshape(OscFiring,3,length(OscFiring)/3);
        
        load(strcat(path.output,filesep,'results',filesep,'OscWavelets',filesep,experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))      
        
        OscProperties = horzcat(PFCentropy, mean(OscFiring(1:2,:))', PFCpower, OscWavelets(:,1:end/2));
        OscProperties1 = horzcat(HPentropy, OscFiring(3,:)', HPpower, OscWavelets(:,end/2+1:end));
        propertiesPFC_HP = horzcat(duration, PFCentropy, HPentropy, PFCpower, HPpower, OscWavelets, Coherence);
        propertiesPFC = vertcat(propertiesPFC, OscProperties);
        propertiesHP = vertcat(propertiesHP, OscProperties1);
        
    clearvars spectra wavelet
    end
end


clearvars -except propertiesPFC_HP propertiesPFC propertiesHP information propertiesLEC propertiesOB propertiesOB_LEC