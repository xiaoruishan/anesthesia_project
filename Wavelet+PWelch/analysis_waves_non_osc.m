clear all

%% load parameters

save_file = 1;
path = get_path;
parameters = get_parameters;
% experiments = get_experiment_list_Cg_juvenile;
experiments = get_experiment_list;


% animal_number = 1:23;
animal_number = [601:611 301:312];
% animal_number = [107:109 112 113];


window = 0.15; % the time window, in seconds, in which the power spectrum will be computed - for fast frequencies
window1 = 1; % as above, but bigger window, for frequencies below beta (included)
window2 = 3; % for delta only
noverlap = 0;
nfft = 6400;
fs = 3200;

%% load and analyze non oscillatory sharpwaves

for n = [2:4 7:17 19 21:22]
    
    experiment = experiments(animal_number(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SharpWaves1Chan'));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'nonOscwaves1'));
    %% compute power for different frequency bands in variable time window around the peak of the sharp wave
    
    PowerNonOsc = zeros(5,size(nonOscwaves1,2),601);
    
    for gg = 1 : size(nonOscwaves1,2)    
        for mm = 1 : 5    
            [PowerNonOsc(mm,gg,:),~] = pWelchSpectrum(sharpwaves1chan(mm,4801-250:4801+250,nonOscwaves1(gg)),window,noverlap,nfft,fs,0.95,300); % 160 ms
        end
    end
    
    
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'PowerNonOsc'),'PowerNonOsc');   
end

%% load analysis results

p = 0;
x = 0;

for n = [1:4 7:17 19 21:22];
    
    experiment = experiments(animal_number(n));
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'PowerNonOsc'));
    
    if n < 12
        p = p + 1;
        for ff = 1:5    
            WT1(ff,p,:) = mean(PowerNonOsc(ff,:,:));
            number1WT(p,1) = size(PowerNonOsc,2);
        end
    else  
        x = x + 1;
        for ff = 1:5    
            DISC1(ff,x,:) = mean(PowerNonOsc(ff,:,:));
            number1DISC(x,1) = size(PowerNonOsc,2);
        end
    end
        
end

for hh = 1:5
    WT(hh,:) = squeeze(mean(WT1(hh,:,:)));
    DISC(hh,:) = squeeze(mean(DISC1(hh,:,:)));
end

semwt1 = squeeze(std(WT1,0,2)/sqrt(size(WT1,2)));
semdisc1 = squeeze(std(DISC1,0,2)/sqrt(size(DISC1,2)));

figure
boundedline(linspace(100,300,401),WT(4,201:601),2*semwt1(4,201:601),'b')
hold on
boundedline(linspace(100,300,401),DISC(4,201:601),2*semdisc1(4,201:601),'r')

spindleWT = squeeze(mean(WT1(:,:,301:601),3));
spindleDISC = squeeze(mean(DISC1(:,:,301:601),3));
