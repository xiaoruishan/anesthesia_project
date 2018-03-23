function BaselineTimePoints = gimmeBaselineSignal(experiment,save_data,repeatCalc,stimulation)

path = get_path;

if stimulation == 0
    [~, signalD, ~,~] = nlx_load_Opto(experiment,'Stim1D',[],10,0);
    BaselineTimePoints(1,1) = 1;
    BaselineTimePoints(1,2) = round(length(signalD)/2);
    BaselineTimePoints(1,3) = round(length(signalD)/2)+1;
    mkdir(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name));
    save(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints'),'BaselineTimePoints');
else
    
if repeatCalc < 1 & exist(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'))
    BaselineTimePoints = load(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints.mat'));
    BaselineTimePoints = BaselineTimePoints.BaselineTimePoints;
else
    [~, signalD, ~,~] = nlx_load_Opto(experiment,'Stim1D',[],10,0);
    signalD = digital2binary(signalD);
    stimStart                   = find(diff(signalD)==1);
    stimBreaks                  = find(diff(stimStart)>10^6);
    stimEnd                     = find(diff(signalD)==-1);
    
    security_factor = 9600; % number of points of distance from "edges" of the portion of the signal to analyze - 9600 points correspond to 3 seconds
    baseline_begin = stimEnd(1,stimBreaks(1)) + security_factor;
    stimulation_begin = stimStart(1,stimBreaks(1)+1) - security_factor;
    stimulation_end = stimEnd(1,end) + security_factor;
    
    BaselineTimePoints(1,1) = baseline_begin;
    BaselineTimePoints(1,2) = stimulation_begin;
    BaselineTimePoints(1,3) = stimulation_end;
    
    clearvars signalD
    
    if save_data > 0
        mkdir(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name));
        save(strcat(path.output,filesep,'results',filesep,'BaselineTimePoints',filesep,experiment.name,filesep,'BaselineTimePoints'),'BaselineTimePoints');
    end
end
end
end


