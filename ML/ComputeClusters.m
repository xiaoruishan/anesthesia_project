
%% transpose

% propertiesPFC = propertiesPFC';
% information = information'; % hasa to be something x 2

%% compute everything with respect to PFC or HP only
% propPFC = propertiesPFC(:,[1 3:1925]); % leave out coherence
% propHP = propertiesPFC(:,[2 1926:3845]);% the firing rate in the HP should be added

%% scaling and normalization

mean_prop = nanmean(properties);
% std_prop = std(propertiesPFC);
max_prop = max(properties);
min_prop = min(properties);
norm_prop = (properties - (repmat(mean_prop,size(properties,1),1))) ./ (repmat(max_prop-min_prop,size(properties,1),1));

%% perform PCA and spit out components that retain 99% of variance

% [coeff, score, latent, ~, explained] = pca(norm_prop);
% variance = cumsum(explained);
% variance95 = find(variance > 95,1);
% components95 = score(:,1:variance95);

%% compute k-means/medoids clustering 

% [idx, ~] = kmeans(components95, 2, 'Start', 'cluster');
% [idx,c] = kmedoids(components95,2,'Start','cluster'); % medoids instead of means

%% compute hierarchical clustering

links = linkage(norm_prop(hier_c==1,:),'ward','euclidean');
figure
dendrogram(links)

hier_b = cluster(linkage(norm_prop(hier_c==1,:),'ward','euclidean'),'maxclust',3);

%% compute t-sne and plot accordingly

Yslow = tsne(norm_prop(hier_c==1,:));
% Yfast = fast_tsne(norm_prop);

% k-means or medoids
% figure; hold on
% for k = 1 : max(idx)
%     scatter(Yslow(idx==k,1),Yslow(idx==k,2),'o','filled', 'LineWidth',3)
% end

% hierarchical
figure; hold on
for k = 1 : max(hier_b)
    scatter(Yslow(hier_b==k,1),Yslow(hier_b==k,2),'o','filled', 'LineWidth',3)
end

%% compute how many oscillation belong to each cluster depending on the 15' period

for period = 1 : max(information(:,2))
    for clust = 1 : max(idx)
        proportion(period,clust) = nnz(information(:,2) == period & idx == clust) / nnz(information(:,2)  == period);
    end
end

for period = 1 : max(information(:,2))
    for clust = 1 : max(hier_c)
        proportion(period,clust) = nnz(information(:,2) == period & hier_c == clust) / nnz(information(:,2)  == period);
    end
end
%% compute characteristics of clusters according to the usual power/coherence variables theta, beta, gamma

prop_reduced = horzcat(propertiesPFC(:,1:5), sum(propertiesPFC(:,6:165),2), sum(propertiesPFC(:,166:525),2), ...
    sum(propertiesPFC(:,526:1925),2), sum(propertiesPFC(:,1926:2085),2), sum(propertiesPFC(:,2086:2445),2), ...
    sum(propertiesPFC(:,2446:3845),2), sum(propertiesPFC(:,3846:4005),2), sum(propertiesPFC(:,4006:4365),2), sum(propertiesPFC(:,4366:5765),2));

cluster_prop(1,:) = nanmedian(prop_reduced(hier_c==1,:));
cluster_prop(2,:) = nanmedian(prop_reduced(hier_c==2,:));

EntropyPFC = cluster_prop(:,1);
EntropyHP = cluster_prop(:,2);
FiringSup = cluster_prop(:,4);
FiringDeep = cluster_prop(:,5);
Duration = cluster_prop(:,3);
ThetaPFC = cluster_prop(:,6);
BetaPFC = cluster_prop(:,7);
GammaPFC = cluster_prop(:,8);
ThetaHP = cluster_prop(:,9);
BetaHP = cluster_prop(:,10);
GammaHP = cluster_prop(:,11);
Thetacoherence = cluster_prop(:,12);
Betacoherence = cluster_prop(:,13);
Gammacoherence = cluster_prop(:,14);
tabella = table(EntropyPFC, EntropyHP, FiringSup, FiringDeep, Duration, ThetaPFC, BetaPFC, GammaPFC, ...
    ThetaHP, BetaHP, GammaHP, Thetacoherence, Betacoherence, Gammacoherence);

%% compute how many oscillation belong to each cluster depending on age

for period = min(information(:,1)) : max(information(:,1))
    for clust = 1 : max(idx)
        proportion(period,clust) = nnz(information(:,1) == period & idx == clust) / nnz(information(:,1)  == period);
    end
end

%% compute number of clusters using the elbow method

nClusters=15; % pick/set number of clusters your going to use
totSum=zeros(nClusters);  % preallocate the result
for i=1:nClusters
  [~,~,sumd]=kmedoids(prop,i);
  totSum(i)=sum(sumd);
end
figure
plot(totSum)  % plot of totals versus number (same as index)
