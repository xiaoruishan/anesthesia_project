function MCgetBaselineProperties(experiment,save_data,repeatCalc)
Path = get_path;
for CSC=1:32
    if repeatCalc==0 &&...
            exist(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,['CSC' num2str(CSC)],'.mat')) && ...
            exist(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name,filesep,['CSC' num2str(CSC)],'.mat')) && ...
            exist(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikePhase',filesep,experiment.name,filesep,['CSC' num2str(CSC)],'.mat')) && ...
            exist(strcat(Path.output,filesep,'results',filesep,'BaselinePower',filesep,experiment.name,filesep,['CSC' num2str(CSC)],'.mat'));
        disp([' All done for: ' experiment.name ', CSC' num2str(CSC)])
    else
        %% if any missing, load signal and calculate the missing ones
        [baselineStructure] = getBaselineSignal(experiment, CSC, 1);
        if repeatCalc == 1 || ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikeTimes',filesep,experiment.name,filesep,['CSC' num2str(CSC)],'.mat'));
            getBaselineMUASpikeTimes(baselineStructure,experiment,CSC,save_data,repeatCalc);
        end
        clearvars baselineStructure
        if repeatCalc == 1 || ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineMUAspikePhase',filesep,experiment.name,filesep,['CSC' num2str(CSC)],'.mat'));
            disp(['Calculating MUA spike phases for Animal: ' experiment.name ', CSC' num2str(CSC)])
            MCgetBaselineMUASpikePhase(experiment,CSC,save_data)
        end
    end
end
end