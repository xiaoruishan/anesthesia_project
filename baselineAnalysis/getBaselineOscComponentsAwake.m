 function getBaselineOscComponentsAwake(time,signal,fs,experiment,CSC,save_data,thr)
%% calc oscTimes,Ampl,Duration, and occurence
Path = get_path;
%% Detect osc & calculate power
[oscStart, oscEnd] = detection_discont_events_awa(signal,fs,thr);
[OscStructure] = getOscInformation_baseline(time,signal, fs,oscStart,oscEnd);
OscAmplDurOcc.(['baseline']) = OscStructure;

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'OscAmplDurOcc')
end
end