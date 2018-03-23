function SharpDetectorprej(experiment, signal_filt, average, stdev, threshold, save_data, visual_inspection)

path = get_path;

difference = signal_filt(1,:)-signal_filt(2,:);
[~,sharptimepoints] = findpeaks(difference,'MinPeakHeight',average + threshold*stdev,'MinPeakDistance',300);


if visual_inspection < 1
    
    sharpwaves = zeros(2,9601,length(sharptimepoints));
    sharpPFC = zeros(1,9601,length(sharptimepoints)); %sharpPFCpre = sharpPFC; sharpPFCpost = sharpPFC;
    
    for zzz = 1:length(sharptimepoints)
        if  sharptimepoints(zzz)-4800>0 & sharptimepoints(zzz)+4800<length(signal_filt)
            for ddd = 1:2
                sharpwaves(ddd,:,zzz) = signal_filt(ddd,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
            end
            sharpPFC(1,:,zzz) = signal_filt(3,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);

            
        end
    end
    
    mkdir(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name));
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SharpWaves1'),'sharpwaves');
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFC1'),'sharpPFC');
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharptimepoints1'),'sharptimepoints');
    
else
    
    p = 0;
    q = 0;
    
    for zzz = 1:length(sharptimepoints)
        if  sharptimepoints(zzz)-4800>0 & sharptimepoints(zzz)+4800<length(signal_filt)
            
            figure('units','normalized','outerposition',[0.5 0.5 0.5 0.5])
            plot(signal_filt(4,sharptimepoints(zzz)-2000:sharptimepoints(zzz)+2000))
            hold on
            plot(signal_filt(5,sharptimepoints(zzz)-2000:sharptimepoints(zzz)+2000))
            hold off
            choice = questdlg('What type of "sharpy" wave is this one?', ...
                'Sharp Wave Classifier', ...
                'Type 1','Type 2','Nothing at all','Type 1');
            
            switch choice
                case 'Type 1'
                    p = p + 1;
                    sharptimepoints1(1,p) = sharptimepoints(zzz);
                    for ddd = 1:size(signal_filt,1)-1
                        sharpwaves1(ddd,:,p) = signal_filt(ddd,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
                    end
                    sharpPFC1(:,:,p) = signal_filt(6,sharptimepoints(zzz)-1600:sharptimepoints(zzz)+1600);
                    sharpPFCpre1(:,:,p) = signal_filt(6,sharptimepoints(zzz)-4800:sharptimepoints(zzz)-1600);
                    sharpPFCpost1(:,:,p) = signal_filt(6,sharptimepoints(zzz)+1600:sharptimepoints(zzz)+4800);
                    
                    
                case 'Type 2'
                    q = q + 1;
                    sharptimepoints2(1,q) = sharptimepoints(zzz);
                    for ddd = 1:size(signal_filt,1)-1
                        sharpwaves2(ddd,:,q) = signal_filt(ddd,sharptimepoints(zzz)-4800:sharptimepoints(zzz)+4800);
                    end
                    sharpPFC2(:,:,q) = signal_filt(6,sharptimepoints(zzz)-1600:sharptimepoints(zzz)+1600);
                    sharpPFCpre2(:,:,q) = signal_filt(6,sharptimepoints(zzz)-4800:sharptimepoints(zzz)-1600);
                    sharpPFCpost2(:,:,q) = signal_filt(6,sharptimepoints(zzz)+1600:sharptimepoints(zzz)+4800);
                    
            end
            close
        end
    end
    if save_data > 0
        
        mkdir(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name));
        
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SharpWaves1'),'sharpwaves1');
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFC1'),'sharpPFC1');
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFCpre1'),'sharpPFCpre1');
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFCpost1'),'sharpPFCpost1');
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharptimepoints1'),'sharptimepoints1');
        
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'SharpWaves2'),'sharpwaves2');
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFC2'),'sharpPFC2');
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFCpre2'),'sharpPFCpre2');
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharpPFCpost2'),'sharpPFCpost2');
        save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharptimepoints2'),'sharptimepoints2');
        
    end
end



end