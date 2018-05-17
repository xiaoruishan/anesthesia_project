function getMinutePower(signal,fs,experiment,CSC,save_data)
Path=get_path;
parameters=get_parameters;
        
%% calc power on full signal
minute=fs*60;
n_minutes=floor(length(signal)./minute);
pWelch=zeros(n_minutes,3201);
for periods=1:n_minutes
    signal_minute=signal(minute*(periods-1)+1:minute*periods);
    [pWelch(periods,:),~,~]=pWelchSpectrum(signal_minute,5,[],parameters.powerSpectrum.nfft,fs,0.95,250);
end


if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data == 1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'MinutePower',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'MinutePower',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'MinutePower',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'pWelch')
end