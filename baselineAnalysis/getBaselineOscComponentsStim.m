function getBaselineOscComponentsStim(time,signal,fs,experiment,CSC,save_data)
%% calc oscTimes,Ampl,Duration, and occurence
Path = get_path;
%% Detect osc & calculate power
for bb = 1:2
    [oscStart, oscEnd] = detection_discont_events(signal(bb,:), fs);
    %         plot_event_detection(.signal(bb,:),.time(bb,:),.fs,oscStart,oscEnd);
    [OscStructure] = getOscInformation_baseline(time(bb,:),signal(bb,:), fs,oscStart,oscEnd);
    OscAmplDurOcc.(['baseline' num2str(bb)]) = OscStructure;
end
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