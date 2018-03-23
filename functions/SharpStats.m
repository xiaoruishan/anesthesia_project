function BasicStats = SharpStats(esperimenti, parametri);

path = get_path;
experiments = get_experiment_list_Christoph;
example = 'mean std';

for ii = 1 : length(esperimenti)
    
%% load data
    experiment_number = esperimenti(ii);
    experiment = experiments(experiment_number);
    filename = strcat('SharpPower');
    load(strcat(path.output, filesep, 'results', filesep, 'SharpPower', filesep, experiment.name, filesep, filename));

%% create matrix with data you want to analyze

    data(ii,1)  = mean(SharpPower.delta);
    data(ii,2)  = mean(SharpPower.theta);
    data(ii,3)  = mean(SharpPower.beta);
    data(ii,4)  = mean(SharpPower.lowgamma);
    data(ii,5)  = mean(SharpPower.highgamma);
    data(ii,6)  = mean(SharpPower.ripple);
    data(ii,7)  = mean(SharpPower.peakdelta);
    data(ii,8)  = mean(SharpPower.peaktheta);
    data(ii,9)  = mean(SharpPower.peakbeta);
    data(ii,10) = mean(SharpPower.peaklowgamma);
    data(ii,11) = mean(SharpPower.peakhighgamma);
    data(ii,12) = mean(SharpPower.peakripple);
    data(ii,13) = mean(SharpPower.peakslow);
    data(ii,14) = mean(SharpPower.peakfast);
    
    name_data = 'data';
    
    % the last row is the standard deviation of the column
    % the forelast is the mean of the column
    
    
end

%% mean & std
if ii>1
    mean_std(1,:) = mean(data(1:ii,:));
    mean_std(2,:) = std(data(1:ii,:));
else
    mean_std(1,:) = (data(1:ii,:));
    mean_std(2,:) = 0; 
end
%% structure

BasicStats = struct('example', example, 'DeltaPower', [mean_std(1,1) mean_std(2,1)], ... 
            'ThetaPower', [mean_std(1,2) mean_std(2,2)], 'BetaPower', [mean_std(1,3) mean_std(2,3)], ...
            'LowGammaPower', [mean_std(1,4) mean_std(2,4)], 'HighGammaPower', [mean_std(1,5) mean_std(2,5)], ...
            'RipplePower', [mean_std(1,6) mean_std(2,6)], 'PeakDelta', [mean_std(1,7) mean_std(2,7)], ... 
            'PeakTheta', [mean_std(1,8) mean_std(2,8)], 'PeakBeta', [mean_std(1,9) mean_std(2,9)], ... 
            'PeakLowGamma', [mean_std(1,10) mean_std(2,10)], 'PeakHighGamma', [mean_std(1,11) mean_std(2,11)], ... 
            'PeakRipple', [mean_std(1,12) mean_std(2,12)], 'PeakSlow', [mean_std(1,13) mean_std(2,13)], ... 
            'PeakFast', [mean_std(1,14) mean_std(2,14)], 'data',data)

end