clear all

experiments = get_experiment_list;
parameters = get_parameters;
animal= 201 : 203;
save_data = 1;
downsampling_factor = 100;
fs = 32000 / downsampling_factor;
fifteen_min = fs * 60 * 15;
threshold = 5;
bands = [4 12;12 30;30 50];
windowSize = 1;
overlap = 0;
nfft = 2^13;

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = 1 : 32;
    CSC4LFP = [experiment.PL experiment.HPreversal];
    if strcmp(experiment.Exp_type,'ISO')
        repetitions = 1:4;
    else
%         if animal(n)>25
%             repetitions=1:7;
%         else
        repetitions = 1;
%         end
    end
    for period = flip(repetitions)
        TimePoints = [fifteen_min*(period-1)+1 fifteen_min*period];
        timepoints = [round(TimePoints(1) / (512 / downsampling_factor)) round(TimePoints(2) / (512 / downsampling_factor))];
        for channel = 1 : length(CSC)
            CSC2save = str2num(strcat('15', num2str(CSC(channel)), num2str(period)));
            [~, MUA, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, 1, 0);
            getMUAtimestamps(experiment, MUA, threshold, CSC2save, save_data)
%             getFiringRate_LZComp(experiment,MUA,threshold,CSC2save,save_data);
%             getBaselineISI(experiment,MUA,threshold,CSC2save,save_data);
            getBaselineFiringRate(experiment,MUA,threshold,CSC2save,save_data);
            if ismember(CSC(channel), CSC4LFP)
                if strcmp(experiment.Exp_type,'ISO') && period==4
                    [time, LFP, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, downsampling_factor, 0);
%                     getSecondPower(LFP, fs, experiment, CSC2save, save_data);
                    getBaselineOscComponents(time,LFP,fs,experiment,CSC2save,save_data);
                    getBaselineSlowOscPower(time, LFP,fs,experiment,CSC2save,save_data);
                    getBaselineOscPower(time, LFP,fs,experiment,CSC2save,save_data);
                    getMinutePower(LFP,fs,experiment,CSC2save,save_data);
%                     getBaselinePPC_PCDI_PLV(experiment,LFP,MUA,bands,fs,downsampling_factor,time,threshold,CSC2save,save_data);
                    getPPC_spectrum(experiment,LFP,MUA,fs,downsampling_factor,time,threshold,CSC2save,save_data);
%                     SampleEntropyFull(experiment, LFP, CSC2save, save_data)
                    lfp=ZeroPhaseFilter(LFP,fs,parameters.FrequencyBands.LFP);
                    N=length(lfp);
                    rms=zeros(1,N);
                    win=0.2*fs;
                    halfwin=round(win/2);
                    for i=halfwin:N-halfwin;
                        rms(i)=norm(lfp(i-halfwin+1:i+halfwin))/sqrt(win);
                    end
                    num_sd=parameters.osc_detection.thr_sd;   %number of standard deviations
                    thr=calc_noise_thresh(rms,num_sd);
                    if CSC(channel)==experiment.PL(4)
                        [~, LFP2,~ ,~]= nlx_load_Opto(experiment, experiment.HPreversal, timepoints, downsampling_factor, 0);
                        getInfoTheoryOsc(time, LFP, LFP2, fs, experiment, save_data, CSC2save)
                        getInfoTheoryOscNorm(time, LFP, LFP2, fs, experiment, save_data, CSC2save)
                        getBaselineCoherence(LFP,LFP2,fs,experiment,save_data,CSC2save)
                        getBaselineCoherenceOsc(time,LFP,LFP2,fs,experiment,save_data,CSC2save)
                        getBaselineGrangerPDC(LFP,LFP2,fs,experiment,save_data,CSC2save)
                    end
                    clearvars LFP lfp N rms win halfwin num_sd
                else
                    [time,LFP,~,~]=nlx_load_Opto(experiment,CSC(channel),timepoints,downsampling_factor, 0);
                    getBaselineOscComponentsAwake(time,LFP,fs,experiment,CSC2save,save_data,thr);
                    getPPC_spectrum(experiment,LFP,MUA,fs,downsampling_factor,time,threshold,CSC2save,save_data);
                    getBaselineSlowOscPower(time, LFP,fs,experiment,CSC2save,save_data); % THIS DIDNT RUN FOR THE FIRST THREE ANIMALS PORCHIDDIO!!!!!
                    getBaselineOscPower(time,LFP,fs,experiment,CSC2save,save_data);
                    getMinutePower(LFP,fs,experiment,CSC2save,save_data);
                    if CSC(channel)==experiment.HPreversal
                        [~,LFP2,~,~]=nlx_load_Opto(experiment,experiment.PL(1),timepoints,downsampling_factor, 0);
                        getBaselineCoherenceOsc(time,LFP,LFP2,fs,experiment,save_data,CSC2save)
                        getBaselineCoherence(LFP,LFP2,fs,experiment,save_data,CSC2save)
                        getBaselineGrangerPDC(LFP,LFP2,fs,experiment,save_data,CSC2save)
                    end
                end
            end
        end
        display(strcat('mancano ', num2str(length(animal)-n),' animali e ', num2str(length(repetitions)-period), ' periodi'))
    end
end
