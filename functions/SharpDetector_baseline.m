function SharpDetector_baseline(experiment, signal_filt, average, stdev, threshold, save_data, visual_inspection)

path = get_path;

% filename = strcat('CSC',num2str(CSC(2)));
% filename = 'CSC16';
% load(strcat(path.output, 'results', filesep, 'BaselineOscAmplDurOcc', filesep, experiment.name, filesep, filename));
% oscTimes = round((OscAmplDurOcc.(['baseline']).OscTimes- time_to_subtract)*fs/10^6);
% 
% oscVector = [];
% 
% for ss = 1:length(oscTimes)
%     osciVector = oscTimes(1,ss):oscTimes(2,ss);
%     oscVector = [oscVector osciVector];
% end

difference = signal_filt(1,:)-signal_filt(2,:);
[~,sharptimepoints] = findpeaks(difference,'MinPeakHeight',average + threshold*stdev,'MinPeakDistance',300);


if visual_inspection < 1
    
%     nonOscwaves = [];
    sharpwaves = zeros(2,9601,length(sharptimepoints));
    sharpPFC = zeros(2,9601,length(sharptimepoints)); %sharpPFCpre = sharpPFC; sharpPFCpost = sharpPFC;
    
    for zzz = 1:length(sharptimepoints)
        if  sharptimepoints(zzz)-4800>0 & sharptimepoints(zzz)+4800<length(signal_filt)
            sharpwaves(1,:,zzz) = signal_filt(1,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
            sharpwaves(2,:,zzz) = signal_filt(2,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
            sharpPFC(1,:,zzz) = signal_filt(3,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
            sharpPFC(2,:,zzz) = signal_filt(4,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
%             sharpPFC(2,:,zzz) = signal_filt(4,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
%             sharpPFC(3,:,zzz) = signal_filt(5,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
%             sharpPFC(4,:,zzz) = signal_filt(6,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
%             sharpPFCpre(:,:,zzz) = signal_filt(3,sharp_timepoints(zzz)-4800:sharp_timepoints(zzz)-1600);
%             sharpPFCpost(:,:,zzz) = signal_filt(3,sharp_timepoints(zzz)+1600:sharp_timepoints(zzz)+4800);
            
%             if ~ismember(sharp_timepoints(zzz),oscVector)
%                 nonOscwaves = [nonOscwaves zzz];
%             end
            
        end
    end
    
else
    
    p = 0;
    q = 0;
    nonOscwaves1 = [];
    nonOscwaves2 = [];
    
    for zzz = 1:length(sharptimepoints)
        if  sharptimepoints(zzz)-4800>0 & sharptimepoints(zzz)+4800<length(signal_filt)
            
            figure('units','normalized','outerposition',[0.5 0.5 0.5 0.5])
            plot(signal_filt(1,sharptimepoints(zzz)-1000:sharptimepoints(zzz)+1000))
            ylim([-350 350])
            hold on
            plot(signal_filt(2,sharptimepoints(zzz)-1000:sharptimepoints(zzz)+1000))
            hold off
            choice = questdlg('What type of "sharpy" wave is this one?', ...
                'Sharp Wave Classifier', ...
                'Type 1','Type 2','Nothing at all','Type 1');
            
            switch choice
                case 'Type 1'
                    p = p + 1;
                    sharptimepoints1(1,p) = sharptimepoints(zzz);
                    sharpwaves1(1,:,p) = signal_filt(1,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
                    sharpwaves1(2,:,p) = signal_filt(2,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
                    sharpPFC1(:,:,p) = signal_filt(3,sharptimepoints(zzz)-1600:sharptimepoints(zzz)+1600);
                    sharpPFCpre1(:,:,p) = signal_filt(3,sharptimepoints(zzz)-4800:sharptimepoints(zzz)-1600);
                    sharpPFCpost1(:,:,p) = signal_filt(3,sharptimepoints(zzz)+1600:sharptimepoints(zzz)+4800);
                    
                    if ~ismember(sharptimepoints(zzz),oscVector)
                        nonOscwaves1 = [nonOscwaves1 p];
                    end
                    
                case 'Type 2'
                    q = q + 1;
                    sharptimepoints2(1,q) = sharptimepoints(zzz);
                    sharpwaves2(1,:,q) = signal_filt(1,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
                    sharpwaves2(2,:,q) = signal_filt(2,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
                    sharpPFC2(:,:,q) = signal_filt(3,sharptimepoints(zzz)-1600:sharptimepoints(zzz)+1600);
                    sharpPFCpre2(:,:,q) = signal_filt(3,sharptimepoints(zzz)-4800:sharptimepoints(zzz)-1600);
                    sharpPFCpost2(:,:,q) = signal_filt(3,sharptimepoints(zzz)+1600:sharptimepoints(zzz)+4800);
                    
                    if ~ismember(sharptimepoints(zzz),oscVector)
                        nonOscwaves2 = [nonOscwaves2 q];
                    end
            end
            close
        end
    end
end

if save_data > 0
    
    mkdir(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name));
    
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SharpWaves1'),'sharpwaves');
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFC1'),'sharpPFC');
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFCpre1'),'sharpPFCpre1');
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFCpost1'),'sharpPFCpost1');
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'nonOscwaves1'),'nonOscwaves1');
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharptimepoints1'),'sharptimepoints');
    
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SharpWaves2'),'sharpwaves2');
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFC2'),'sharpPFC2');
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFCpre2'),'sharpPFCpre2');
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFCpost2'),'sharpPFCpost2');
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'nonOscwaves2'),'nonOscwaves2');
%     save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharptimepoints2'),'sharptimepoints2');
    
end

end