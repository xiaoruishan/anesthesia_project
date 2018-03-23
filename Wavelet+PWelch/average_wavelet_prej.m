

clear all

path = get_path;
experiments = get_experiment_list_Cg_juvenile;
animal = 1:23;
time_window = 1600; % half time window of the wavelet
fs = 3200;
wild = 0;
ge = 0;

for n = 1:length(animal);
    
    clearvars powersharp & powerpresharp & powerPFC & powerprePFC & wavesharp & wavepresharp & wavePFC & waveprePFC & sharpWaves1 & sharpPFC1 & sharpPFCpre1 & empty
    
    experiment = experiments(animal(n));
    empty = [];
    
%     load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpWaves1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFC1'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharpPFCpre1'));
    
    if exist('sharpPFC1', 'var')
        sharpPFC = sharpPFC1;
        sharpPFCpre = sharpPFCpre1;
    end
    
    clearvars sharpPFC1 & sharpPFCpre1
    
    for jjj = 1:size(sharpPFC,3)
        if any(sharpPFC(1,:,jjj)) < 1
            empty = [empty jjj];
        end
    end
    
    for qqq = 1:length(empty)
%         sharpwaves1(:,:,empty(qqq)-(qqq-1)) = [];
         sharpPFC(:,:,empty(qqq)-(qqq-1)) = [];
         sharpPFCpre(:,:,empty(qqq)-(qqq-1)) = [];
    end
    
%     powersharp = zeros(100,3201,size(sharpwaves1,3)); powerpresharp = powersharp;
     powerPFC = zeros(81,3201,size(sharpPFC,3)); powerprePFC = powerPFC;
     
    for kk = 1:size(sharpPFC,3)
%             [wavesharp, periodsharp, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpwaves1(4,4801-time_window:4801+time_window,kk)'],'S0', 1/300, 'MaxScale', 1);
%             [wavepresharp, ~, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpwaves1(4,1601-time_window:1601+time_window,kk)'],'S0', 1/300, 'MaxScale', 1);
             [wavePFC, periodPFC, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpPFC(1,1601-time_window:1601+time_window,kk)'],'S0', 1/100, 'MaxScale', 1);
             [waveprePFC, ~, ~, ~] = wt([linspace(-time_window,time_window,3201)'/fs sharpPFCpre(1,1601-time_window:1601+time_window,kk)'],'S0', 1/100, 'MaxScale', 1);
%             powersharp(:,:,kk) = abs((wavesharp)).^2;
%             powerpresharp(:,:,kk) = abs((wavepresharp)).^2;
             powerPFC(:,:,kk) = abs((wavePFC)).^2;
             powerprePFC(:,:,kk) = abs((waveprePFC)).^2;
    end
    
    if n < 13
        wild = wild+1
%         avgsharp(:,:,wild) = mean(powersharp,3);
%         avgpresharp(:,:,wild) = mean(powerpresharp,3);
         avgPFC(:,:,wild) = mean(powerPFC,3);
         avgPFCpre(:,:,wild) = mean(powerprePFC,3);
    else
        ge = ge+1
%         davgsharp(:,:,ge) = mean(powersharp,3);
%         davgpresharp(:,:,ge) = mean(powerpresharp,3);
         davgPFC(:,:,ge) = mean(powerPFC,3);
         davgPFCpre(:,:,ge) = mean(powerprePFC,3);
    end
    
    
end

for p = 1:20
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    lim = [min(min((avgsharp(:,:,p)./avgpresharp(:,:,p)))) 0.6*max(max((avgsharp(:,:,p)./avgpresharp(:,:,p))))];
    imagesc(linspace(-time_window,time_window,3201),flip(1./periodsharp),avgsharp(:,:,p)./avgpresharp(:,:,p),lim);
    subplot(2,1,2)
    lim = [min(min((avgPFC(:,:,p)./avgPFCpre(:,:,p)))) 0.8*max(max((avgPFC(:,:,p)./avgPFCpre(:,:,p))))];
    imagesc(linspace(-time_window,time_window,3201),flip(1./periodPFC),avgPFC(:,:,p)./avgPFCpre(:,:,p),lim);
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
avgppfc = avgPFCpre(:,:,3);

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


