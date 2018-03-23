
clear all

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
animal = [501:537 551:566];

for n=1:length(animal)
    experiment = experiments(animal(n));
    CSChp = experiment.HPreversal;
    load(strcat(path.output,filesep,'results',filesep,'PDC',filesep,experiment.name, ...
        filesep, strcat('sharpPDC17',num2str(CSChp),'.mat')));
    PDC1 = PDC;
    load(strcat(path.output,filesep,'results',filesep,'PDC',filesep,experiment.name, ...
        filesep, strcat('sharpPDC29',num2str(CSChp),'.mat')));
    hptosup = zeros(1024,length(PDC)); suptohp=hptosup; hptodeep=hptosup; deeptohp=hptosup;
    for oscillation=1:length(PDC1)
        if numel(PDC1{1,oscillation})>0
            PDC1{1,oscillation}.c12(isnan(PDC1{1,oscillation}.c12))=0;
            PDC1{1,oscillation}.c21(isnan(PDC1{1,oscillation}.c21))=0;
            hptosup(:,oscillation) = PDC1{1,oscillation}.c12;
            suptohp(:,oscillation) = PDC1{1,oscillation}.c21;
        end
    end
    for oscillation=1:length(PDC)
        if numel(PDC{1,oscillation})>0
            PDC{1,oscillation}.c12(isnan(PDC{1,oscillation}.c12))=0;
            PDC{1,oscillation}.c21(isnan(PDC{1,oscillation}.c21))=0;
            hptodeep(:,oscillation) = PDC{1,oscillation}.c12;
            deeptohp(:,oscillation) = PDC{1,oscillation}.c21;
        end
    end
    hptosup(isnan(hptosup))=0;
    hptodeep(isnan(hptodeep))=0;
    suptohp(isnan(suptohp))=0;
    deeptohp(isnan(deeptohp))=0;
    Hptosup(:,n)=mean(hptosup,2);
    Suptohp(:,n)=mean(suptohp,2);
    Hptodeep(:,n)=mean(hptodeep,2);
    Deeptohp(:,n)=mean(deeptohp,2);
    display(strcat('mancano', num2str(length(animal)-n),' animali'))
end

%%

wtsup = mean(Suptohp(:,1:37),2);
wtdeep = mean(Deeptohp(:,1:37),2);
wthpsup = mean(Hptosup(:,1:37),2);
wthpdeep = mean(Hptodeep(:,1:37),2);

gesup = mean(Suptohp(:,38:end),2);
gedeep = mean(Deeptohp(:,38:end),2);
gehpsup = mean(Hptosup(:,38:end),2);
gehpdeep = mean(Hptodeep(:,38:end),2);

semwt=std(Suptohp(:,1:37),0,2)./sqrt(37);
semge=std(Suptohp(:,38:end),0,2)./sqrt(16);
figure; boundedline(linspace(1/1024,50,321),wtsup(1:321,1),semwt(1:321,1),'b');
hold on; boundedline(linspace(1/1024,50,321),gesup(1:321,1),semge(1:321,1),'r');

semwt=std(Deeptohp(:,1:37),0,2)./sqrt(37);
semge=std(Deeptohp(:,38:end),0,2)./sqrt(16);
figure; boundedline(linspace(1/1024,50,321),wtdeep(1:321,1),semwt(1:321,1),'b'); 
hold on; boundedline(linspace(1/1024,50,321),gedeep(1:321,1),semge(1:321,1),'r');

semwt=std(Hptosup(:,1:37),0,2)./sqrt(37);
semge=std(Hptosup(:,38:end),0,2)./sqrt(16);
figure; boundedline(linspace(1/1024,50,321),wthpsup(1:321,1),semwt(1:321,1),'b'); 
hold on; boundedline(linspace(1/1024,50,321),gehpsup(1:321,1),semge(1:321,1),'r');

semwt=std(Hptodeep(:,1:37),0,2)./sqrt(37);
semge=std(Hptodeep(:,38:end),0,2)./sqrt(16);
figure; boundedline(linspace(1/1024,50,321),wthpdeep(1:321,1),semwt(1:321,1),'b'); 
hold on; boundedline(linspace(1/1024,50,321),gehpdeep(1:321,1),semge(1:321,1),'r');

[a,b]=ttest2(mean(Hptosup(27:321,1:37)),mean(Hptosup(27:321,38:end)))




