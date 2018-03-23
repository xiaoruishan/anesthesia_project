
%% set array with animal number

borders = strfind(information(:,2)',[3 4]);
borders = [borders length(information)];
animal = [];
for border = 1:length(borders)
    if border == 1
        animal(1:borders(1)) = border;
    else 
        animal(borders(border-1)+1:borders(border)) = border;
    end
end
animal = animal';

%% create matrix from which to extract usual parameters

prop_reduced = horzcat(properties(:,1:5), sum(properties(:,6:165),2), sum(properties(:,166:525),2), ...
    sum(properties(:,526:1925),2), sum(properties(:,1926:2085),2), sum(properties(:,2086:2445),2), ...
    sum(properties(:,2446:3845),2), sum(properties(:,3846:4005),2), sum(properties(:,4006:4365),2), sum(properties(:,4366:5765),2));

%%
for animale = 1:max(animal)
    for period = 1:max(information(:,2))
        for type_osc = 1:max(hier_c)
            proportion_osc(animale, period, type_osc) = nnz(animal == animale & ...
            information(:,2) == period & hier_c == type_osc) / nnz(animal == animale & ...
            information(:,2) == period);
            osc_prop(animale, period, type_osc, :) = nanmedian(prop_reduced(animal == animale & ...
                information(:,2) == period & hier_c == type_osc,:));
        end
    end
end

%% extract values for cluster 2 and only first and last 15'

EntropyPFC = osc_prop(:,[1 4],2,1);
EntropyHP = osc_prop(:,[1 4],2,2);
Duration = osc_prop(:,[1 4],2,3);
FiringSup = osc_prop(:,[1 4],2,4);
FiringDeep = osc_prop(:,[1 4],2,5);
ThetaPFC = osc_prop(:,[1 4],2,2);
BetaPFC = osc_prop(:,[1 4],2,7);
GammaPFC = osc_prop(:,[1 4],2,8);
ThetaHP = osc_prop(:,[1 4],2,9);
BetaHP = osc_prop(:,[1 4],2,10);
GammaHP = osc_prop(:,[1 4],2,11);
Thetacoherence = osc_prop(:,[1 4],2,12);
Betacoherence = osc_prop(:,[1 4],2,13);
Gammacoherence = osc_prop(:,[1 4],2,14);


signrank(Gammacoherence([1:2 4:end],1),Gammacoherence([1:2 4:end],2))



