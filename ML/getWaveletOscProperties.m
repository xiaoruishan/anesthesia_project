function getWaveletOscProperties(time, signal1, signal2, fs, experiment, CSC, save_data)
Path=get_path;
parameters=get_parameters;

load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC',num2str(CSC)));
oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);

%%
wavelet1 = zeros(7,61,size(oscTimes,2)); wavelet2 = wavelet1;

for oscillation = 1:size(oscTimes,2)
    center = (oscTimes(1,oscillation) + oscTimes(2,oscillation)) / 2;
    try
        LFP = signal1(center-2*fs : center + 2*fs);
        timeVector = time(center-2*fs : center + 2*fs);
        [wav, ~, ~, ~] = wt([timeVector' , LFP'],'S0', 1/100,'MaxScale', 1);
        wav(1,:) = mean(wav(1:13,:)); wav(2,:) = mean(wav(14:25,:)); wav(3,:) = mean(wav(26:30,:));
        wav(4,:) = mean(wav(31:38,:)); wav(5,:) = mean(wav(39:44,:)); wav(6,:) = mean(wav(45:53,:)); 
        wav(7,:) = mean(wav(54:68,:)); wav(8:end,:) = [];
        wav = squeeze(sum(reshape(wav,size(wav,1),size(wav,2)/61,[]),2));
        wavelet1(:,:,oscillation)=abs(wav).^2;
        LFP2 = signal2(oscTimes(1,oscillation) : oscTimes(2,oscillation));
        [wav, ~, ~, ~] = wt([timeVector' , LFP'],'S0', 1/100,'MaxScale', 1);
        wav(1,:) = mean(wav(1:13,:)); wav(2,:) = mean(wav(14:25,:)); wav(3,:) = mean(wav(26:30,:));
        wav(4,:) = mean(wav(31:38,:)); wav(5,:) = mean(wav(39:44,:)); wav(6,:) = mean(wav(45:53,:)); 
        wav(7,:) = mean(wav(54:68,:)); wav(8:end,:) = [];
        wav = squeeze(sum(reshape(wav,size(wav,1),size(wav,2)/61,[]),2));
        wavelet2(:,:,oscillation)=abs(wav).^2;
    catch
    end
end

wavelet1 = reshape(wavelet1, size(wavelet1,1) * size(wavelet1,2),size(wavelet1,3));
wavelet2 = reshape(wavelet2, size(wavelet2,1) * size(wavelet2,2),size(wavelet2,3));
OscWavelets = vertcat(wavelet1, wavelet2)';

%% save data

if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'OscWavelets',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'OscWavelets',filesep,experiment.name));
    end
    save(strcat(Path.output,filesep,'results',filesep,'OscWavelets',filesep,experiment.name,filesep,['CSC' num2str(CSC)]),'OscWavelets')
end