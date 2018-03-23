

clear all

path = get_path;
experiments = get_experiment_list;
% animals = [601:642 301:325];
animals = [501:536 551:565];

for animal = 1:length(animals)%[1:4 7:42 43:48 50 52 53 55:length(animals)];
    
    experiment = experiments(animals(animal));
    load(strcat(path.output,filesep,'results',filesep,'correlation',filesep,experiment.name,filesep,'cross_coherence'))
    coherence = cross_coherence;
    
%     if animal < 37
%         load(strcat(path.output,filesep,'results',filesep,'correlation',filesep,experiment.name,filesep,'coherence1stbaseline'))
%         coherence = coherence1stbaseline;
%         clearvars coherence1stbaseline
%     else
%         load(strcat(path.output,filesep,'results',filesep,'correlation',filesep,experiment.name,filesep,'coherence'))
%     end
    
    if animal < 37
        imag_coh(:,animal) = mean(cross_coherence{27},2);
        imag_cohpre(:,animal) = mean(cross_coherence{28},2);
        imag_cohpost(:,animal) = mean(cross_coherence{29},2);
        deepimag_coh(:,animal) = mean(cross_coherence{30},2);
        deepimag_cohpre(:,animal) = mean(cross_coherence{31},2);
%         deepimag_cohpost(:,animal) = mean(cross_coherence{6},2);
%         interimag_coh(:,animal) = mean(cross_coherence{7},2);
%         interimag_cohpre(:,animal) = mean(cross_coherence{8},2);
%         interimag_cohpost(:,animal) = mean(cross_coherence{9},2);

%         f = mean(cross_coherence{3},2);
%         corr_delta(:,animal-36) = mean(abs(mean(cross_coherence{4}),2);
%         corr_theta(:,animal-36) = mean(abs(mean(cross_coherence{5}),2);
%         corr_gamma(:,animal-36) = mean(abs(mean(cross_coherence{6}),2);
%         corr_delta_cg(:,animal-36) = mean(abs(mean(cross_coherence{7}),2);
%         corr_theta_cg(:,animal-36) = mean(abs(mean(cross_coherence{8}),2);
%         corr_gamma_cg(:,animal-36) = mean(abs(mean(cross_coherence{9}),2);
    else
        aimag_coh(:,animal-36) = mean(cross_coherence{27},2);
        aimag_cohpre(:,animal-36) = mean(cross_coherence{28},2);
        aimag_cohpost(:,animal-36) = mean(cross_coherence{29},2);
        adeepimag_coh(:,animal-36) = mean(cross_coherence{30},2);
        adeepimag_cohpre(:,animal-36) = mean(cross_coherence{31},2);
%         adeepimag_cohpost(:,animal-36) = mean(cross_coherence{6},2);
%         ainterimag_coh(:,animal-36) = mean(cross_coherence{7},2);
%         ainterimag_cohpre(:,animal-36) = mean(cross_coherence{8},2);
%         ainterimag_cohpost(:,animal-36) = mean(cross_coherence{9},2);
%         acorr_delta(:,animal-36) = mean(abs(mean(cross_coherence{4}),2);
%         acorr_theta(:,animal-36) = mean(abs(mean(cross_coherence{5}),2);
%         acorr_gamma(:,animal-36) = mean(abs(mean(cross_coherence{6}),2);
%         acorr_delta_cg(:,animal-36) = mean(abs(mean(cross_coherence{7}),2);
%         acorr_theta_cg(:,animal-36) = mean(abs(mean(cross_coherence{8}),2);
%         acorr_gamma_cg(:,animal-36) = mean(abs(mean(cross_coherence{9}),2);
    end
    clearvars coherence
    
end

clearvars -except imag_coh imag_cohpre imag_cohpost aimag_coh aimag_cohpre...
           aimag_cohpost deepimag_coh deepimag_cohpre deepimag_cohpost...
           adeepimag_coh adeepimag_cohpre adeepimag_cohpost interimag_coh...
           interimag_cohpre interimag_cohpost ainterimag_coh ainterimag_cohpre...
           ainterimag_cohpost
