%% same old stuff

clear all
path=get_path;
experiments=get_experiment_list;
animal=101:142;


%% load stuff 
propertiesOB = []; information = []; propertiesLEC = [];
for n=1:length(animal)
    experiment=experiments(animal(n));
    OBmua = numel(experiment.nameDead);
    try
        OBlec = numel(str2num(experiment.PL));
    catch
        OBlec = numel(experiment.PL);
    end
    age = experiment.age;
    CSC=experiment.Cg;
    if strcmp(experiment.Exp_type,'AWA')
        periodo = 1;
    else
        periodo = 1:3;
    end
        
    for period=periodo
        load(strcat(path.output,filesep,'results\OscProperties\',experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
        OBentropy = OscProperties(:,1);
        LECentropy = OscProperties(:,2);
        duration = OscProperties(:,3);
        OBpower = OscProperties(:,84:2003); % delete power below 4hz (noise, since the window is 1s) and above 100hz
        OBpower = squeeze(sum(reshape(OBpower,size(OBpower,1),size(OBpower,2)/120,[]),2)); % reduce frequency definition by a factor of 16 (become 1hz resolution)
        LECpower = OscProperties(:,3285:5204); % delete power below 4hz (noise, since the window is 1s) and above 100hz
        LECpower = squeeze(sum(reshape(LECpower,size(LECpower,1),size(LECpower,2)/120,[]),2)); % reduce frequency definition by a factor of 16 (become 1hz resolution)
        Coherence = OscProperties(:,6486:8405); % delete coherence below 4hz (noise, since the window is 1s) and above 100hz
        Coherence = squeeze(sum(reshape(Coherence,size(Coherence,1),size(Coherence,2)/120,[]),2)); % reduce frequency definition by a factor of 16 (become 1hz resolution)        
        
        load(strcat(path.output,filesep,'results',filesep,'OscFiring',filesep,experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))
%         OscFiring = reshape(OscFiring,2,length(OscFiring)/2);
        
        load(strcat(path.output,filesep,'results',filesep,'OscWavelets',filesep,experiment.name,filesep,'CSC15',num2str(CSC),num2str(period),'.mat'))  

        OscProperties = horzcat(LECentropy,LECpower, OscWavelets(:,1:end/2)); %  OscFiring(1,:)', 
        OscProperties1 = horzcat(OBentropy, OBpower, OscWavelets(:,end/2+1:end)); % OscFiring(2,:)',
        propertiesOB_LEC = horzcat(duration, LECentropy, OBentropy, LECpower, OBpower, OscWavelets, Coherence);
        propertiesLEC = vertcat(propertiesLEC, OscProperties);
        propertiesOB = vertcat(propertiesOB, OscProperties1);
    end
end
clearvars -except propertiesLEC propertiesOB propertiesOB_LEC

propertiesOB_LEC = vertcat(propertiesLEC, propertiesOB);