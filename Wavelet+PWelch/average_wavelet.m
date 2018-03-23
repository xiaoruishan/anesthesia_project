

clear all

path = get_path;
experiments = get_experiment_list;
animal = [601:642 301:325];
type2 = [1:2 4 7:14 16:17 19 21:22];
time_window = 1600; % half time window of the wavelet
fs = 3200;
p = 0;
% q = 0;
% avgsharp = zeros(100,3201,14);
% avgPFC = zeros(81,3201,14);
for n = [1:4 7:11 43:48 50 52 53]
    p=p+1;
    clearvars powersharp & powerpresharp & powerPFC & powerprePFC & wavesharp & wavepresharp & wavePFC & waveprePFC
    
    experiment = experiments(animal(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
%     load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SharpWaves1Chan'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC1'));
%     load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFCpost1'));
%     wavesharp = zeros(100,3201,size(sharpPFC,3)-1); powersharp = wavesharp;
%     wavePFC = zeros(81,3201,size(sharpPFC,3)-1); powerPFC = wavePFC;
    for kk = 1:size(sharpPFC1,3)-1
        
%         [wavesharp(:,:,kk), periodsharp, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpwaves1(1,4801-time_window:4801+time_window,kk)'],'S0', 1/300, 'MaxScale', 1);
        [wavePFC(:,:,kk), ~, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpPFC1(1,1601-time_window:1601+time_window,kk)'],'S0', 1/100, 'MaxScale', 1);
%         powersharp(:,:,kk) = abs(wavesharp(:,:,kk)).^2;
%         powerPFC(:,:,kk) = abs(wavePFC(:,:,kk)).^2;
    end
    
%     avgsharp(:,:,n) = mean(powersharp,3);
%     avgPFC(:,:,n) = mean(powerPFC,3);
     
     if ismember(n,type2)
        
%         load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints2'));
%          load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpwaves2chan'));
        load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC2'));
%         load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFCpost2'));
        
        
         for ss = 1:size(sharpPFC2,3)
            
%              [wavesharp(:,:,kk+ss), periodsharp, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpwaves2chan(4,4801-time_window:4801+time_window,ss)'],'S0', 1/300, 'MaxScale', 1);
%              [wavesharp(:,:,kk+ss), ~, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpwaves2chan(4,4801-time_window:4801+time_window,ss)'],'S0', 1/300, 'MaxScale', 1);
            [wavePFC(:,:,kk+ss), periodPFC, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpPFC2(1,1601-time_window:1601+time_window,ss)'],'S0', 1/100, 'MaxScale', 1);
%             [wavepostPFC(:,:,kk+ss), ~, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpPFCpost2(1,4801-time_window:4801+time_window,ss)'],'S0', 1/100, 'MaxScale', 1);
            
         end
        
     end
    
    
    for zz = 1:size(wavePFC,3)
%          powersharp(:,:,zz) = abs((wavesharp(:,:,zz))).^2;
%         powerpresharp(:,:,zz) = abs((wavepresharp(:,:,zz))).^2;
        powerPFC(:,:,zz) = abs((wavePFC(:,:,zz))).^2;
%         powerpostPFC(:,:,zz) = abs((wavepostPFC(:,:,zz))).^2;
    end
    avgPFC(:,:,p) = mean(powerPFC,3);
        display(n)
end

        
    if n < 12
        p = p+1
%         avgsharp(:,:,p) = mean(powersharp,3);
%         avgpresharp(:,:,p) = mean(powerpresharp,3);
%         avgPFC(:,:,p) = mean(powerPFC,3);
        avgPFC(:,:,p) = mean(powerpostPFC,3);
    else
        q = q+1
%         davgsharp(:,:,q) = mean(powersharp,3);
%         davgpresharp(:,:,q) = mean(powerpresharp,3);
%         davgPFC(:,:,q) = mean(powerPFC,3);
        davgPFCpre(:,:,q) = mean(powerpostPFC,3);
    end
    
    
end

for p = 1:20
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    lim = [min(min((avgsharp(:,:,p)./avgpresharp(:,:,p)))) 0.6*max(max((avgsharp(:,:,p)./avgpresharp(:,:,p))))];
    imagesc(linspace(-time_window,time_window,3201),flip(1./periodsharp),avgsharp(:,:,p)./avgpresharp(:,:,p),lim);
    subplot(2,1,2)
    lim = [min(min((avgPFC(:,:,p)./avgPFC(:,:,p)))) 0.8*max(max((avgPFC(:,:,p)./avgPFC(:,:,p))))];
    imagesc(linspace(-time_window,time_window,3201),flip(1./periodPFC),avgPFC(:,:,p)./avgPFC(:,:,p),lim);
    k = waitforbuttonpress
    close
end

for p = 1:20
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    lim = [min(min((davgsharp(:,:,p)./davgpresharp(:,:,p)))) 0.6*max(max((davgsharp(:,:,p)./davgpresharp(:,:,p))))];
    imagesc(linspace(-time_window,time_window,3201),flip(1./periodsharp),davgsharp(:,:,p)./davgpresharp(:,:,p),lim);
    subplot(2,1,2)
    lim = [min(min((davgPFC(:,:,p)./davgPFCpre(:,:,p)))) 0.8*max(max((davgPFC(:,:,p)./davgPFCpre(:,:,p))))];
    imagesc(linspace(-time_window,time_window,3201),flip(1./periodPFC),davgPFC(:,:,p)./davgPFCpre(:,:,p),lim);
    k = waitforbuttonpress
    close
end

avgs = avgsharp(:,:,3);
avgps = avgpresharp(:,:,3);
avgpfc = avgPFC(:,:,3);
avgppfc = avgPFC(:,:,3);

%     figure('units','normalized','outerposition',[0 0 1 1])
%     subplot(2,1,1)
%     lim = [min(min((avgs./avgps))) 0.6*max(max(avgs./avgps))];
%     imagesc(linspace(-500,500,3201),log2(periodsharp),avgs./avgps,lim);
%     Yticks = 2.^(fix(log2(min(periodsharp))):fix(max(log2(periodsharp))));
%     set(gca,'YLim',log2([min(periodsharp),max(periodsharp)]), ...
%         'YDir','reverse', ...
%         'YTickLabel',num2str(1./Yticks'), ...
%         'layer','top')
%     title('1-300Hz Wavelet of Average Sharpwave - WT')
%
%     subplot(2,1,2)
%     lim = [min(min((avgpfc./avgppfc))) 0.8*max(max((avgpfc./avgppfc)))];
%     imagesc(linspace(-500,500,3201),log2(periodPFC),avgpfc./avgppfc,lim);
%     Yticks = 2.^(fix(log2(min(periodPFC))):fix(max(log2(periodPFC))));
%     set(gca,'YLim',log2([min(periodPFC),max(periodPFC)]), ...
%         'YDir','reverse', ...
%         'YTickLabel',num2str(1./Yticks'), ...
%         'layer','top')
%     title('1-100Hz Wavelet of Average Sharpwave - WT')
%
%
%     davgs = davgsharp(:,:,3);
%     davgps = davgpresharp(:,:,3);
%     davgpfc = davgPFC(:,:,3);
%     davgppfc = davgPFCpre(:,:,3);
%
%     figure('units','normalized','outerposition',[0 0 1 1])
%     subplot(2,1,1)
%     lim = [min(min((davgs./davgps))) 0.6*max(max(davgs./davgps))];
%     imagesc(linspace(-time_window,time_window,3201),flip(1./periodsharp),davgs./davgps,lim);
%     subplot(2,1,2)
%     lim = [min(min((davgpfc./davgppfc))) 0.8*max(max((davgpfc./davgppfc)))];
%     imagesc(linspace(-time_window,time_window,3201),flip(1./periodPFC),davgpfc./davgppfc,lim);
%
%


