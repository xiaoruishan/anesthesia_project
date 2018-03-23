
clear all

path = get_path;
experiments = get_experiment_list;
animals = [501:536 551:565];
save_data = 0;
ExtractModeArray = [];
downsampling_factor = 10;
windowSize = 0.25;
fs = 3200;
overlap = 0;
nfft = 2^13;
SWRtype2 = [1:2 4 7:11 43:45 47:48 50 52:53];

for animal = 1:36
    
    experiment = experiments(animals(animal));
    channels = [experiment.PL(1) experiment.PL(4) experiment.HPreversal];
    load(strcat(path.output, 'results', filesep, 'BaselineTimePoints', filesep, experiment.name, filesep, 'BaselineTimePoints'));
        
    for channel = 1:3
        CSC = channels(channel);
        [~, signal, ~, ~] = nlx_load_Opto(experiment, CSC, ExtractModeArray, downsampling_factor, save_data);
        signal_baseline1 = signal(1,BaselineTimePoints(1):BaselineTimePoints(2));
        signal_baseline2 = signal(1,BaselineTimePoints(3):end);
        clearvars signal
        if animal < 37
            signal_baseline = signal_baseline1;
        else
            signal_baseline = horzcat(signal_baseline1,signal_baseline2);
        end
        clearvars signal_baseline1 signal_baseline2
        signal_filt(channel,:) = ZeroPhaseFilter(signal_baseline,3200,[1 300]);
        clearvars signal_baseline
    end
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
    if exist('sharptimepoints1')
        sharptimepoints = sharptimepoints1;
    end
    clear sharptimepoints1
    
%     if ismember(animal,SWRtype2)
%         load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints2'));
%         sharptimepoints = horzcat(sharptimepoints,sharptimepoints2);
%         clear sharptimepoints2
%     end
    
    
%     for event = 1:size(sharptimepoints,2)
%         if sharptimepoints(event)-1200>0 && sharptimepoints(event)+1200<length(signal_filt)
%             sharp_matrixpre(:,event) = sharptimepoints(event)-1199:sharptimepoints(event)-400;
%             sharp_matrix(:,event) = sharptimepoints(event)-399:sharptimepoints(event)+400;
%             sharp_matrixpost(:,event) = sharptimepoints(event)+401:sharptimepoints(event)+1200;
%         end
%     end

    for event = 1:size(sharptimepoints,2)
        if sharptimepoints(event)-1200>0 && sharptimepoints(event)+1200<length(signal_filt)
            sharp_matrix(:,event) = sharptimepoints(event)-399:sharptimepoints(event)+400;
            sharp_matrixpre(:,event) = sharptimepoints(event)-1199:sharptimepoints(event)-400;
            sharp_matrixpost(:,event) = sharptimepoints(event)+401:sharptimepoints(event)+1200;
        end
    end
    
    nnz_matrixpre = find(sharp_matrixpre);
    nnz_matrix = find(sharp_matrix);
    nnz_matrixpost = find(sharp_matrixpost);
    sharp_vectorpre = sharp_matrixpre(nnz_matrixpre);
    sharp_vector = sharp_matrix(nnz_matrix);
    sharp_vectorpost = sharp_matrixpost(nnz_matrixpost);
    num_events = length(sharp_vector)./800;
    clearvars sharp_matrix sharp_matrixpre sharp_matrixpost
    
    Suppre = signal_filt(1,sharp_vectorpre);
    Sup = signal_filt(1,sharp_vector);
    Suppost = signal_filt(1,sharp_vectorpost);
    Deeppre = signal_filt(2,sharp_vectorpre);
    Deep = signal_filt(2,sharp_vector);
    Deeppost = signal_filt(2,sharp_vectorpost);
    CG = signal_filt(2,sharp_vector);
    HPpre = signal_filt(3,sharp_vectorpre);
    HP = signal_filt(3,sharp_vector);
    HPpost = signal_filt(3,sharp_vectorpost);
    clear signal_filt
    
    [imag_cohpre,aaa]=ImCohere(HPpre,Suppre,windowSize,overlap,nfft,fs);
    [imag_coh,~]=ImCohere(HP,Sup,windowSize,overlap,nfft,fs);
    [imag_cohpost,~]=ImCohere(HPpost,Suppost,windowSize,overlap,nfft,fs);
    [deepimag_cohpre,~]=ImCohere(HPpre,Deeppre,windowSize,overlap,nfft,fs);
    [deepimag_coh,~]=ImCohere(HP,Deep,windowSize,overlap,nfft,fs);
    [deepimag_cohpost,~]=ImCohere(HPpost,Deeppost,windowSize,overlap,nfft,fs);
    [interimag_cohpre,~]=ImCohere(Deeppre,Suppre,windowSize,overlap,nfft,fs);
    [interimag_coh,~]=ImCohere(Deep,Sup,windowSize,overlap,nfft,fs);
    [interimag_cohpost,~]=ImCohere(Deeppost,Suppost,windowSize,overlap,nfft,fs);


    
    clear SWR_delta & SWR_theta & SWR_gamma & PL_delta & PL_theta & PL_gamma & sharptimepoints & CG_delta & CG_theta & CG_gamma
    
    coherence1stbaseline = {imag_coh, imag_cohpre, imag_cohpost, deepimag_coh, deepimag_cohpre, deepimag_cohpost...
                interimag_coh, interimag_cohpre, interimag_cohpost};
%     coherence1sec = {imag_coh, deepimag_coh, interimag_coh};
    
    save(strcat(path.output,filesep,'results',filesep,'correlation',filesep,experiment.name,filesep,'coherence1stbaseline'),'coherence1stbaseline');
    clear corr_delta & corr_theta & corr_gamma & corr_delta_cg & corr_theta_cg & corr_gamma_cg & imag_coh & imag_coh_cg
    
    display(strcat('mancano', num2str(length(animals)-animal),' animali'))                  
end    
