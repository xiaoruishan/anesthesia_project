
clear all

path = get_path;
experiments = get_experiment_list;

animal = [601:642 801:814];


%% load power spectrum of sharpwaves

intHP = 0;
dorHP = 0;

for n = [1:4 7:length(animal)];
    
    experiment = experiments(animal(n));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, 'power', filesep, experiment.name));
    PowerSWR = PowerSpectrums{1};
    PowerpreSWR = PowerSpectrums{2};
    PowerRip = PowerSpectrums{3};
    PowerpreRip = PowerSpectrums{4};
    
    if n < 42
        intHP = intHP + 1;
            SWR(intHP,:) = mean(PowerSWR,2);
            preSWR(intHP,:) = mean(PowerpreSWR,2);
            Rip(intHP,:) = mean(PowerRip,2);
            preRip(intHP,:) = mean(PowerpreRip,2);

    else  
        dorHP = dorHP + 1;
            dorSWR(dorHP,:) = mean(PowerSWR,2);
            dorpreSWR(dorHP,:) = mean(PowerpreSWR,2);
            dorRip(dorHP,:) = mean(PowerRip,2);
            dorpreRip(dorHP,:) = mean(PowerpreRip,2);

    end
        
end

semSWR = std(SWR)/sqrt(size(SWR,1));
sempreSWR = std(preSWR)/sqrt(size(preSWR,1));
semRip = std(Rip)/sqrt(size(Rip,1));
sempreRip = std(preRip)/sqrt(size(preRip,1));

dorsemSWR = std(dorSWR)/sqrt(size(dorSWR,1));
dorsempreSWR = std(dorpreSWR)/sqrt(size(dorpreSWR,1));
dorsemRip = std(dorRip)/sqrt(size(dorRip,1));
dorsempreRip = std(dorpreRip)/sqrt(size(dorpreRip,1));



figure
boundedline(linspace(1,300,601),mean(SWR),semSWR,'b')
hold on
boundedline(linspace(1,300,601),mean(dorSWR),dorsemSWR,'r')

figure
boundedline(linspace(80,300,441),mean(Rip(:,161:601)),semRip(:,161:601),'b')
hold on
boundedline(linspace(80,300,441),mean(dorRip(:,161:601)),dorsemRip(:,161:601),'r')
xlim([80 300])

figure
boundedline(linspace(1,300,601),mean(dorSWR),dorsemSWR,'b')
hold on
boundedline(linspace(1,300,601),mean(dorpreSWR),dorsempreSWR,'r')

figure
boundedline(linspace(1,300,601),mean(dorRip),dorsemRip,'b')
hold on
boundedline(linspace(1,300,601),mean(dorpreRip),dorsempreRip,'r')


figure
bar(1, mean(mean(dorRip(:,240:501),2)), 'facecolor', 'b');
hold on
bar(2, mean(mean(Rip(:,240:501),2)), 'facecolor', 'g'); 
errorbar([mean(mean(dorRip(:,240:501),2)) mean(mean(Rip(:,240:501),2))], ...
        [mean(dorsemRip(240:501))/sqrt(size(dorRip,1)) ...
        mean(semRip(240:501))/sqrt(size(Rip,1))],...
        '.','LineWidth',5, 'Color', 'k');
plot(1.5, mean(dorRip(:,240:501),2),'x', 'LineWidth',2,'Color', 'k')
plot(2.5, mean(Rip(:,240:501),2),'x', 'LineWidth',2,'Color', 'k')
Labels = {'Ripple dorHP', 'Ripple intHP'};
ylim([0 4])
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'FontSize', 14);
title('RippleBand (120-250 Hz) Power', 'FontSize', 14)
ylabel('µV^2', 'FontSize', 14)

[h,intHP] = ttest2(mean(dorRip(:,240:501),2),mean(Rip(:,240:501),2))

%% load sharp wave morphology characteristics

intHP = 0;
dorHP = 0;

rev2 = [1:2 4 7:14 16:17 19 21:22];

for n = [1:4 7:17 19 21:22];
    
    experiment = experiments(animal_number(n));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharp_morphology'));

    if ismember(n,rev2)
        load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharp_morphology2'));
    end

    
    if n < 12
        intHP = intHP + 1;
        WT(intHP,:) = nanmean(sharp_morphology);
        if ismember(n,rev2)
            WT2(intHP,:) = nanmean(sharp_morphology2);
        end
               
    else
        dorHP = dorHP + 1;
        DISC(dorHP,:) = nanmean(sharp_morphology);
        if ismember(n,rev2)
            DISC2(dorHP,:) = nanmean(sharp_morphology2);
        end
        
        
    end
    
    
end







for hh = 1:5
    WT1(hh,:) = mean(PowerPre(hh,:,:));
    WT2(hh,:) = mean(FWT2(hh,:,:));
    DISC1(hh,:) = mean(FDISC1(hh,:,:));
    DISC2(hh,:) = mean(FDISC2(hh,:,:));
end

WT1 = squeeze(WT1);
WT2 = squeeze(WT2);
DISC1 = squeeze(DISC1);
DISC2 = squeeze(DISC2);
semwt1 = squeeze(std(PowerPre,0,2)/sqrt(size(PowerPre,2)));
semwt2 = squeeze(std(FWT2,0,2)/sqrt(size(FWT2,2)));
semdisc1 = squeeze(std(FDISC1,0,2)/sqrt(size(FDISC1,2)));
semdisc2 = squeeze(std(FDISC2,0,2)/sqrt(size(FDISC2,2)));


figure
boundedline(linspace(100,300,401),WT1(4,201:601),semwt1(4,201:601),'b')
hold on
boundedline(linspace(100,300,401),DISC1(4,201:601),semdisc1(4,201:601),'r')

spindleWT1 = squeeze(mean(PowerPre(4,:,300:600),3));
spindleDISC1 = squeeze(mean(FDISC1(4,:,300:600),3));

[h,intHP] = ttest2(spindleWT1,spindleDISC1)



        MWT1(n,:) = mean(PowerSpectrum1{2});
        DWT1(n,:) = mean(PowerSpectrum1{3});
        FWT2(n,:) = mean((PowerSpectrum2{1}));
        MWT2(n,:) = mean(PowerSpectrum2{2});
        DWT2(n,:) = mean(PowerSpectrum2{3});  
        number1WT(n,1) = size((PowerSpectrum1{1}),1);
        number2WT(n,1) = size((PowerSpectrum2{1}),1);
        
        MDISC1(n-11,:) = mean(PowerSpectrum1{2});
        DDISC1(n-11,:) = mean(PowerSpectrum1{3});
        FDISC2(n-11,:) = mean((PowerSpectrum2{1}));
        MDISC2(n-11,:) = mean(PowerSpectrum2{2});
        DDISC2(n-11,:) = mean(PowerSpectrum2{3});    
        number1DISC(n-11,1) = size((PowerSpectrum1{1}),1);
        number2DISC(n-11,1) = size((PowerSpectrum2{1}),1);


        
FastWT1 = mean(PowerPre([1:4 7:11],:));
MediumWT1 = mean(MWT1([1:4 7:11],:));
DeltaWT1 = mean(DWT1([1:4 7:11],:));
FastWT2 = mean(FWT2([1:4 7:11],:));
MediumWT2 = mean(MWT2([1:4 7:11],:));
DeltaWT2 = mean(DWT2([1:4 7:11],:));

FastDISC1 = mean(FDISC1([1:6 8 10:11],:));
MediumDISC1 = mean(MDISC1([1:6 8 10:11],:));
DeltaDISC1 = mean(DDISC1([1:6 8 10:11],:));
FastDISC2 = mean(FDISC2([1:6 8 10:11],:));
MediumDISC2 = mean(MDISC2([1:6 8 10:11],:));
DeltaDISC2 = mean(DDISC2([1:6 8 10:11],:));


rippledisc = Fastfreq_DISC(:,1:601);
ripdisc = mean(Fastfreq_DISC(:,1:601));
semdisc = std(rippledisc)/sqrt(size(rippledisc,1));
ripplewt = Fastfreq_WT(:,1:601);
ripwt = mean(Fastfreq_WT(:,1:601));
semSWR = std(ripplewt)/sqrt(size(ripplewt,1));

figure
boundedline(linspace(1,300,601),ripdisc(1,1:601),2*semdisc(1,1:601),'g')
hold on
boundedline(linspace(1,300,601),ripwt(1,1:601),2*semSWR(1,1:601),'b')
title('Sharp Wave - Power Plot (1-300 Hz) - 250ms', 'FontSize', 14)
ylabel('Power with 95% CI - logscale', 'FontSize', 14)
xlabel('Frequency (Hz)', 'FontSize', 14)

figure
boundedline(linspace(150,300,301),ripdisc(1,300:600),2*semdisc(1,300:600),'g')
hold on
boundedline(linspace(150,300,301),ripwt(1,300:600),2*semSWR(1,300:600),'b')
% boundedline(linspace(150,300,301),ripwts(1,300:600),2*semwts(1,300:600),'y')
% boundedline(linspace(150,300,301),ripdiscs(1,300:600),2*semdiscs(1,300:600),'r')
title('Sharp Wave - Power Plot (150-300 Hz) - 250ms', 'FontSize', 14)
ylabel('Power with 95% CI', 'FontSize', 14)
xlabel('Frequency (Hz)', 'FontSize', 14)


figure
boundedline(linspace(50,150,201),ripdisc(1,100:300),2*semdisc(1,100:300),'g')
hold on
boundedline(linspace(50,150,201),ripwt(1,100:300),2*semSWR(1,100:300),'b')
title('Sharp Wave - Power Plot (50-150 Hz) - 250ms', 'FontSize', 14)
ylabel('Power with 95% CI', 'FontSize', 14)
xlabel('Frequency (Hz)', 'FontSize', 14)

mediodisc = Mediumfreq_DISC;
semdisc1 = std(mediodisc)/sqrt(size(mediodisc,1));
mediowt = Mediumfreq_WT;
semwt1 = std(mediowt)/sqrt(size(mediowt,1));

figure
boundedline(linspace(5,50,91),mediodisc(1,10:100),2*semdisc1(1,10:100),'g')
hold on
boundedline(linspace(5,50,91),mediowt(1,10:100),2*semwt1(1,10:100),'b')
title('Sharp Wave - Power Plot (5-50 Hz) - 1s', 'FontSize', 14)
ylabel('Power with 95% CI - logscale', 'FontSize', 14) % meglio logscale probabilmente
xlabel('Frequency (Hz)', 'FontSize', 14)

deltumdisc = Deltafreq_DISC;
semdisc2 = std(deltumdisc)/sqrt(size(deltumdisc,1));
deltumwt = Deltafreq_WT;
semwt2 = std(deltumwt)/sqrt(size(deltumwt,1));

figure
boundedline(linspace(1,5,9),deltumdisc(1,2:10),2*semdisc2(1,2:10),'g')
hold on
boundedline(linspace(1,5,9),deltumwt(1,2:10),2*semwt2(1,2:10),'b')
title('Sharp Wave - Power Plot (1-5 Hz) - 3s', 'FontSize', 14)
ylabel('Power with 95% CI', 'FontSize', 14)
xlabel('Frequency (Hz)', 'FontSize', 14)

%% plot and stats on the power bands

for n = 1:length(animal_number)
    
    experiment = experiments(animal_number(n));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'PowerSpectrum'));
    
    if n < 13
        Ripfreq_WT(n,:) = mean((PowerSpectrum{1})); % 150-300
        RipfreqWT(n,1) = mean(Ripfreq_WT(n,301:601));
        HighGfreqWT(n,1) = mean(Ripfreq_WT(n,101:300)); % 50-150
        Mediumfreq_WT(n,:) = mean(PowerSpectrum{2});
        LowGWT(n,1) = mean(Mediumfreq_WT(n,61:100)); % 30-50
        BetafreqWT(n,1) = mean(Mediumfreq_WT(n,25:60)); % 12-30
        ThetafreqWT(n,1) = mean(Mediumfreq_WT(n,9:24)); % 4-12
        Deltafreq_WT(n,:) = mean(PowerSpectrum{3});
        DeltafreqWT(n,1) = mean(Deltafreq_WT(n,2:8)); % 1-4

         
    else
        Ripfreq_DISC(n-12,:) = mean((PowerSpectrum{1})); % 150-300
        RipfreqDISC(n-12,1) = mean(Ripfreq_DISC(n-12,301:601));
        HighGfreqDISC(n-12,1) = mean(Ripfreq_DISC(n-12,101:300)); % 50-150
        Mediumfreq_DISC(n-12,:) = mean(PowerSpectrum{2});
        LowGDISC(n-12,1) = mean(Mediumfreq_DISC(n-12,61:100)); % 30-50
        BetafreqDISC(n-12,1) = mean(Mediumfreq_DISC(n-12,25:60)); % 12-30
        ThetafreqDISC(n-12,1) = mean(Mediumfreq_DISC(n-12,9:24)); % 4-11
        Deltafreq_DISC(n-12,:) = mean(PowerSpectrum{3});
        DeltafreqDISC(n-12,1) = mean(Deltafreq_DISC(n-12,2:8)); % 1-4;
    end
    
    
end


sem_ripWT = 2*std(RipfreqWT)/sqrt(length(RipfreqWT));
sem_ripDISC = std(RipfreqDISC)/sqrt(length(RipfreqDISC));

figure
bar(1, mean(RipfreqWT), 'facecolor', 'b');
hold on
bar(2, mean(RipfreqDISC), 'facecolor', 'g'); 
errorbar([mean(RipfreqWT) mean(RipfreqDISC)], [sem_ripWT sem_ripDISC],'.','LineWidth',5, 'Color', 'k');
plot(1.5, RipfreqWT,'x', 'LineWidth',2,'Color', 'k')
plot(2.5, RipfreqDISC,'x', 'LineWidth',2,'Color', 'k')
Labels = {'WT', 'DISC'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'FontSize', 14);
title('RippleBand (150-300 Hz) Power', 'FontSize', 14)
ylabel('µV^2', 'FontSize', 14)

[h,intHP] = ttest2(RipfreqDISC,RipfreqWTfake)

%% count sharpwaves

for n = 1:length(animal_number)
    
    experiment = experiments(animal_number(n));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SharpTimepoints'));
    
    
    if n < 13
        WTwaves(n,1) = length(sharp_timepoints);
    else
        DISCwaves(n-12,1) = length(sharp_timepoints);
    end
    
end

WTsharp_waves = mean(WTwaves);
semWT = std(WTwaves)/sqrt(length(WTwaves));

DISCsharp_waves = mean(DISCwaves);
semDISC = std(DISCwaves)/sqrt(length(DISCwaves));


occurrence_wt = WTwaves(:,1)./(WTwaves(:,2)/(3200*60));
sem_occWT = std(occurrence_wt)/sqrt(length(occurrence_wt));
occurrence_disc = DISCwaves(:,1)./(DISCwaves(:,2)/(3200*60));
sem_occDISC = std(occurrence_disc)/sqrt(length(occurrence_disc));
occurrence(1,1) = mean(occurrence_wt);
occurrence(1,2) = mean(occurrence_disc);
sem(1,1) = sem_occWT;
sem(1,2) = sem_occDISC;

figure
bar(1, occurrence(1), 'facecolor', 'b');
hold on
bar(2, occurrence(2), 'facecolor', 'g'); 
errorbar(occurrence, sem,'.','LineWidth',5, 'Color', 'k');
plot(1.4, occurrence_wt,'x', 'LineWidth',2,'Color', 'k')
plot(2.4, occurrence_disc,'x', 'LineWidth',2,'Color', 'k')
Labels = {'Wild Type', 'DISC - dual hit'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'FontSize', 14);
title('Deep Layers - N° of Interneurons', 'FontSize', 14)
ylabel('Interneuron N°', 'FontSize', 14)

[h,intHP] = ttest2(occurrence_wt,occurrence_disc)



%% load power spectrum of sharpPFC

path = get_path;
parameters = get_parameters;
experiments = get_experiment_list_Cg_juvenile;

animal_number = 1:23;

PFCspectrum_wt = zeros(12,601);
PFCspectrum_disc = zeros(11,601);

for n = 1:length(animal_number)
    
    experiment = experiments(animal_number(n));
    load(strcat(path.output, 'results', filesep, 'SharpPFC', filesep, experiment.name, filesep, 'SharpPFC'));
    
    
    if n < 13
        PFCspectrum_wt(n,:) = mean(SharpPFC.sharp_pfc_power);
    else
        PFCspectrum_disc(n-12,:) = mean(SharpPFC.sharp_pfc_power);
    end
    
end

PFCwt = mean(PFCspectrum_wt);
semSWR = std(PFCspectrum_wt)/sqrt(size(PFCspectrum_wt,1));

PFCdisc = mean(PFCspectrum_disc);
semdisc = std(PFCspectrum_disc)/sqrt(size(PFCspectrum_disc,1));

figure
boundedline(linspace(10,50,81),PFCwt(20:100),semSWR(20:100));
hold on
boundedline(linspace(10,50,81),PFCdisc(20:100),semdisc(20:100),'r');

figure
boundedline(linspace(1,10,20),PFCwt(1:20),semSWR(1:20));
hold on
boundedline(linspace(1,10,20),PFCdisc(1:20),semdisc(1:20),'r');


