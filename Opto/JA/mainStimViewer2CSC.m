% function mainStimViewer(animal, period, CSC, class, ff, plottype)
% period = [], --> run all periods
% plottype = 1, plot in subplot,
% plottype = 2, plot individual figures
clearvars -except experiments
animal = 2007;
% CSC=8;
period = [];
stimulusType = {'ramp'};
Frequency=[];
plottype=1;

experiment = experiments(animal);
CSC1=20;
CSC2=experiment.HPreversal+2;

scrsz = get(0,'ScreenSize');
% CSC2=experiment.HPreversal+2;
% CSC2=24;
parameters=get_parameters;
cutSignal=[3,3];
%% Load signal 1
stimStructure1 = getStimulusSignal(experiment,CSC1,stimulusType{1}, Frequency, 100);
samplingrate = stimStructure1.samplingrate;
SignalRaw1ds = stimStructure1.signal;
% SignalRaw1ds = stimStructure1.signal(:,cutSignal(1)*samplingrate:end-cutSignal(2)*samplingrate);
% time = stimStructure1.time(cutSignal(1)*samplingrate:end-cutSignal(2)*samplingrate);
time = stimStructure1.time;

% signalA = stimStructure1.signalA(:,cutSignal(1)*samplingrate:end-cutSignal(2)*samplingrate);
signalA = stimStructure1.signalA;

% signalD = stimStructure1.signalD(:,cutSignal(1)*samplingrate:end-cutSignal(2)*samplingrate);
signalD = stimStructure1.signalD;

stimproperties = stimStructure1.StimProperties;
clearvars stimStructure1
stimStructure1 = getStimulusSignal(experiment,CSC1,stimulusType{1}, Frequency, 1);
samplingrateMUA=stimStructure1.samplingrate;
% SignalRaw1 = stimStructure1.signal(:,cutSignal(1)*samplingrateMUA:end-cutSignal(2)*samplingrateMUA);
SignalRaw1 = stimStructure1.signal;
% timeMUA=stimStructure1.time(cutSignal(1)*samplingrateMUA:end-cutSignal(2)*samplingrateMUA);
timeMUA=stimStructure1.time;

clearvars stimStructure1,

%% Load signal 2
stimStructure2 = getStimulusSignal(experiment,CSC2,stimulusType{1}, Frequency, 100);
% SignalRaw2ds = stimStructure2.signal(:,cutSignal(1)*samplingrate:end-cutSignal(2)*samplingrate);
SignalRaw2ds = stimStructure2.signal;

clearvars stimStructure2
stimStructure2 = getStimulusSignal(experiment,CSC2,stimulusType{1}, Frequency, 1);
% SignalRaw2=stimStructure2.signal(:,cutSignal(1)*samplingrateMUA:end-cutSignal(2)*samplingrateMUA);
SignalRaw2=stimStructure2.signal;
clearvars stimStructure2,

plotwindow = [-3 6];
% plotwindow = [-1.5 4.5];

stimStart = cell2mat(stimproperties(:,1))'/10^6;
powerCorrection = analogCorrection(signalA); % analog correction





%% check if period is empty
if isempty(period)
    period = 1:size(stimStart,2);
end

%% Plotting
f1 = figure('Color', 'white');
f2 = figure('Color', 'white');
f3 = figure('Color', 'white');

hold on

for pp = period
    figure(f1)
    clf
    disp([num2str(pp) '/' num2str(length(stimStart))])
    
    %% load period signal and apply filters
    signalLFP1 = ZeroPhaseFilter(SignalRaw1ds(pp,:), samplingrate, parameters.FrequencyBands.LFP);
    signalTheta1 = ZeroPhaseFilter(SignalRaw1ds(pp,:), samplingrate, parameters.FrequencyBands.theta);
    signalBeta1 = ZeroPhaseFilter(SignalRaw1ds(pp,:), samplingrate, parameters.FrequencyBands.beta);
    signalGamma1 = ZeroPhaseFilter(SignalRaw1ds(pp,:), samplingrate, parameters.FrequencyBands.gamma);
    signalMUA1 = ZeroPhaseFilter(SignalRaw1(pp,:), samplingrateMUA, parameters.FrequencyBands.MUA);
    
    %% DIGITAL AND ANALOG PLOT
    if plottype == 2
        figure()
        hold on
    elseif plottype == 1
        subplot(7,1,1)
        hold on
    end
    plot(time,signalD(pp,:)*20, 'b')
    plot(time,signalA(1,:)*powerCorrection,'r');
    xlim([plotwindow(1) plotwindow(2)])
    hold off
    %% LFP PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,2)
    end
    plot(timeMUA,SignalRaw1(pp,:),'k')
    % plot(time,signalLFP)
    
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-300 300])
    % ylim([-200 200])
    title('LFP (raw trace)')
    
    %% LFP WAVELET
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,3)
    end
    plotWavelet(time, signalLFP1,[4 100])
    colormap jet
    title('Wavelet (4-100 Hz)')
    
    %% THETA PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,4)
    end
    plot(time,signalLFP1,'k')
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-100 100])
    title('LFP (4-100 Hz)')
    
    %% BetaLowGamma PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,5)
    end
    plot(time,signalBeta1,'k')
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-50 50])
    title('Beta (12-30 Hz)')
    
    %% HighGamma PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,6)
    end
    plot(time,signalGamma1,'k')
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-50 50])
    title('Gamma (30-100 Hz)')
    
    %% MUA PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,7)
    end
    plot(timeMUA,signalMUA1,'k')
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-50 50])
    title('MUA (500-5000 Hz)')
    
    %%% Figure 2
    
    figure(f2)

    clf
    
    %% load period signal and apply filters
    signalLFP2 = ZeroPhaseFilter(SignalRaw2ds(pp,:), samplingrate, parameters.FrequencyBands.LFP);
    signalTheta2 = ZeroPhaseFilter(SignalRaw2ds(pp,:), samplingrate, parameters.FrequencyBands.theta);
    signalBeta2 = ZeroPhaseFilter(SignalRaw2ds(pp,:), samplingrate, parameters.FrequencyBands.beta);
    signalGamma2 = ZeroPhaseFilter(SignalRaw2ds(pp,:), samplingrate, parameters.FrequencyBands.gamma);
    signalMUA2 = ZeroPhaseFilter(SignalRaw2(pp,:), samplingrateMUA, parameters.FrequencyBands.MUA);
    
    %% DIGITAL AND ANALOG PLOT
    if plottype == 2
        figure()
        hold on
    elseif plottype == 1
        subplot(7,1,1)
        hold on
    end
    plot(time,signalD(pp,:)*20, 'b')
    plot(time,signalA(1,:)*powerCorrection,'r');
    xlim([plotwindow(1) plotwindow(2)])
    hold off
    %% LFP PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,2)
    end
    plot(timeMUA,SignalRaw2(pp,:),'k')
    % plot(time,signalLFP)
    
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-300 300])
    % ylim([-200 200])
    title('LFP (raw trace)')
    
    %% LFP WAVELET
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,3)
    end
    plotWavelet(time, signalLFP2,[4 100])
    colormap jet
    title('Wavelet (4-100 Hz)')
    
    %% THETA PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,4)
    end
    plot(time,signalLFP2,'k')
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-100 100])
    title('LFP (4-100 Hz)')
    
    %% BetaLowGamma PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,5)
    end
    plot(time,signalBeta2,'k')
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-50 50])
    title('Beta (12-30 Hz)')
    
    %% HighGamma PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,6)
    end
    plot(time,signalGamma2,'k')
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-50 50])
    title('Gamma (30-100 Hz)')
    
    %% MUA PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,7)
    end
    plot(timeMUA,signalMUA2,'k')
    xlim([plotwindow(1) plotwindow(2)])
    ylim([-50 50])
    title('MUA (500-5000 Hz)')
    
    
    
    
    
    
    
    figure(f3)
    clf
    set(f3,'position',scrsz);

    %% DIGITAL AND ANALOG PLOT
    if plottype == 2
        figure()
        hold on
    elseif plottype == 1
        subplot(7,1,1)
        hold on
    end
    plot(time,signalD(pp,:)*20, 'b')
    plot(time,signalA(1,:)*powerCorrection,'r');
    xlim([plotwindow(1) plotwindow(2)])
    hold off
    %% LFP PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,2)
    end
    % plot(timeMUA,SignalRaw1(pp,:),'k')
    plot(time,signalLFP1,'k')
    
    xlim([plotwindow(1) plotwindow(2)])
    % ylim([-300 300])
    ylim([-100 100])
    title('LFP (raw trace)')
    
    %% LFP WAVELET
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,3)
    end
    plotWavelet(time, signalLFP1,[4 100])
    colormap jet
    title('Wavelet (4-100 Hz)')
    
    %% LFP PLOT, PFC
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,4)
    end
    % plot(timeMUA,SignalRaw2(pp,:),'k')
    plot(time,signalLFP2,'k')
    
    xlim([plotwindow(1) plotwindow(2)])
    % ylim([-300 300])
    ylim([-100 100])
    title('LFP (raw trace)')
    
    %% LFP WAVELET
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,5)
    end
    plotWavelet(time, signalLFP2,[4 100])
    colormap jet
    title('Wavelet (4-100 Hz)')
    
    %% HighGamma PLOT
    if plottype == 2
        figure()
    elseif plottype == 1
        subplot(7,1,6)
    end
    plotWaveletCoh(signalLFP1,signalLFP2,time,[4 100])
    colormap jet
    title('WaveletCoherence (4-100')
    
    %% MUA PLOT
    % if plottype == 2
    %     figure()
    % elseif plottype == 1
    %     subplot(7,1,7)
    % end
    % plot(timeMUA,signalMUA2,'k')
    % xlim([plotwindow(1) plotwindow(2)])
    % ylim([-50 50])
    % title('MUA (500-5000 Hz)')
    try
        reply1=input('Next event (Enter)');
    catch
        reply1=input('Next event (Enter)');
    end
end