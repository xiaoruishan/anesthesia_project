
clear all

path = get_path;
experiments = get_experiment_list_ripple;
animal = [700:732 800:812 900:912 1000:1005]; % above 900 is intCA1
fs = 3200;
downsampling_factor = 10;
half_window=1600;
zscore=zeros(97,3201,65);
for n=1:length(animal)    
    experiment=experiments(animal(n));
    age(n)=experiment.age;
    load(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'7std_wavelet'))
    wav(:,:,n)=mean(wavelet,3);
    average=mean(wav(:,1:320,n),2);
    standard=std(wav(:,1:320,n),0,2);
    zscore(:,:,n)=bsxfun(@rdivide,bsxfun(@minus,wav(:,:,n),average),standard);
end

age1=age(47:end);
age(47:end)=[];
p10=find(age==10);
p9=find(age==9);
p8=find(age==8);
p101=find(age1==10);
p91=find(age1==9);
p81=find(age1==8);

ratio=mean(zscore(:,:,p10),3)./mean(zscore(:,:,p9),3);















imagesc(linspace(-half_window/3200,half_window/3200,3201),log2(period),(zscore));
    title('wavelet 4:300 Hz')
    Yticks = 2.^(fix(log2(min(period))):fix(max(log2(period))));
    set(gca,'YLim',[log2(min(period)),log2(max(period))], ...
        'YDir','reverse', ...
        'YTickLabel',num2str(1./Yticks'), ...
        'layer','top')
    
imagesc(linspace(-half_window/3200,half_window/3200,3201),1./period,zscore);
axis xy
