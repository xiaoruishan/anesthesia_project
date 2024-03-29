clear all

experiments = get_experiment_list;
parameters = get_parameters;
animal = [1 : 38    201 : 217];
save_data = 1;
downsampling_factor = 100;
fs = 32000 / downsampling_factor;
fifteen_min = fs * 60 * 15;
threshold = 5;
windowSize = 1;
overlap = 0;
nfft = 2^13;
median_power = 1;

for n = 1 : length(animal)
    experiment = experiments(animal(n));
    CSC = 1 : 32; % 
    CSC4LFP = [experiment.HPreversal experiment.PL([1 4])]; % 
    if strcmp(experiment.Exp_type,'AWA')
        repetitions = 1;
    else
%         if animal(n)>25
%             repetitions=1:7;
%         else
        repetitions = 1 : 3;
%         end
    end
    for period = repetitions
        if ismember(animal(n), 218 : 220) && period == 2
            TimePoints = [(fifteen_min * (period -1) +1) fifteen_min * period * 10];
        else
            TimePoints = [(fifteen_min * (period -1) +1) fifteen_min * period];
        end
        timepoints = [round(TimePoints(1) / (512 / downsampling_factor)) round(TimePoints(2) / (512 / downsampling_factor))];
        for channel = 1 : length(CSC)
            CSC2save = str2num(strcat('15', num2str(CSC(channel)), num2str(period)));
%             [~, MUA, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, 1, 0);
%             getMUAtimestamps(experiment, MUA, threshold, CSC2save, save_data)
%             getFiringRate_LZComp(experiment,MUA,threshold,CSC2save,save_data);
%             getBaselineISI(experiment,MUA,threshold,CSC2save,save_data);
%             getBaselineFiringRate(experiment,MUA,threshold,CSC2save,save_data);
            if ismember(CSC(channel), CSC4LFP)
                if strcmp(experiment.Exp_type,'URE') && period == 1
                    [time, LFP, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, downsampling_factor, 0);
%                     getSecondPower(LFP, fs, experiment, CSC2save, save_data);
%                     getBaselineOscComponents(time,LFP,fs,experiment,CSC2save,save_data);
%                     getBaselineSlowOscPower(time, LFP, fs, experiment, CSC2save, save_data);
%                     getBaselineOscPower(time, LFP,fs,experiment,CSC2save,save_data);
                    getMinutePower(LFP, fs, experiment, CSC2save, save_data, median_power);
                    getMinutePowerOsc(LFP, time, fs, experiment, CSC2save, save_data, median_power);
%                     getBaselinePPC_PCDI_PLV(experiment,LFP,MUA,bands,fs,downsampling_factor,time,threshold,CSC2save,save_data);
%                     getPPC_spectrum(experiment, LFP, MUA, fs, downsampling_factor, time, threshold, CSC2save, save_data);
%                     SampleEntropyFull(experiment, LFP, CSC2save, save_data)
%                     thr = getOscThr(LFP, fs);
%                     getMinuteOscComponents(time, LFP, thr / 2, fs, experiment, CSC2save, save_data)
%                     getMinuteOsc(time, fs, experiment, CSC2save, save_data)
%                     if CSC(channel)==experiment.PL(4)
%                         [~, LFP2,~ ,~]= nlx_load_Opto(experiment, experiment.HPreversal, timepoints, downsampling_factor, 0);
%                         getInfoTheoryOsc(time, LFP, LFP2, fs, experiment, save_data, CSC2save)
%                         getInfoTheoryOscNorm(time, LFP, LFP2, fs, experiment, save_data, CSC2save)
%                         getBaselineCoherence(LFP,LFP2,fs,experiment,save_data,CSC2save)
%                         getBaselineCoherenceOsc(time,LFP,LFP2,fs,experiment,save_data,CSC2save)
%                         getBaselineGrangerPDC(LFP,LFP2,fs,experiment,save_data,CSC2save)
%                     end
                    clearvars LFP lfp N rms win halfwin num_sd
                else
                    [time,LFP, ~, ~] = nlx_load_Opto(experiment, CSC(channel), timepoints, downsampling_factor, 0);
%                     getMinuteOscComponents(time, LFP, thr / 2, fs, experiment, CSC2save, save_data)
%                     getBaselineOscComponentsAwake(time,LFP,fs,experiment,CSC2save,save_data,thr);
%                     getPPC_spectrum(experiment,LFP,MUA,fs,downsampling_factor,time,threshold,CSC2save,save_data);
%                     getBaselineSlowOscPower(time, LFP,fs,experiment,CSC2save,save_data);
%                     getBaselineOscPower(time,LFP,fs,experiment,CSC2save,save_data);
                    getMinutePowerOsc(LFP, time, fs, experiment, CSC2save, save_data, median_power);
                    getMinutePower(LFP,fs,experiment,CSC2save,save_data, median_power);
%                     getMinuteOsc(time, fs, experiment, CSC2save, save_data)
%                     if CSC(channel)==experiment.PL(4)
%                         [~, LFP2,~ ,~]= nlx_load_Opto(experiment, experiment.HPreversal, timepoints, downsampling_factor, 0);
%                         getInfoTheoryOsc(time, LFP, LFP2, fs, experiment, save_data, CSC2save)
%                         getInfoTheoryOscNorm(time, LFP, LFP2, fs, experiment, save_data, CSC2save)
%                         getBaselineCoherence(LFP,LFP2,fs,experiment,save_data,CSC2save)
%                         getBaselineCoherenceOsc(time,LFP,LFP2,fs,experiment,save_data,CSC2save)
%                         getBaselineGrangerPDC(LFP,LFP2,fs,experiment,save_data,CSC2save)
%                     end
                end
            end
        end
        display(strcat('mancano ', num2str(length(animal)-n),' animali e ', num2str(length(repetitions) - period), ' periodi'))
    end
end
