
clear all

path = get_path;
experiments = get_experiment_list;

animal = [601:642 301:325];%[501:537 551:566];%

%% load power spectrum of sharpwaves
q = 0;
p = 0;
for n = [1:4 7:11 43:48 50 52 53]%[1:4 7:48 50 52 53 55:length(animal)]%1:length(animal)%
    
    experiment = experiments(animal(n));
    load(strcat(path.output, 'results', filesep, 'SharpStuff',filesep,'power',filesep,experiment.name));
    during = PFC{1};
    pre = PFC{2};
    post = PFC{3};
    
    if n < 43
        q = q+1;
        PFCpre(:,q) = mean(pre,2);
        PFCduring(:,q) = mean(during,2);
        PFCpost(:,q) = mean(post,2);
    else
        p =  p+1;
        dPFCpre(:,p) = mean(pre,2);
        dPFCduring(:,p) = mean(during,2);
        dPFCpost(:,p) = mean(post,2);
    end
end

sem = std(log(PFCpre),0,2)/sqrt(size(PFCpre,2));
dsem = std(log(dPFCpre),0,2)/sqrt(size(dPFCduring,2));


figure
boundedline(linspace(1,100,201), log(mean(PFCpre,2)),sem,'b')
hold on
boundedline(linspace(1,100,201), log(mean(dPFCpre,2)),dsem,'r')