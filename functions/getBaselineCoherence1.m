function getBaselineCoherence(signal1, signal2, time, windowSize, overlap, nfft, fs, experiment, CSC1, CSC2, save_data, baseline)
Path=get_path;
path=Path;
%% load oscillation vectors, and cut and glue the signal

% load(strcat(Path.output,filesep,'results',filesep,'BaselineOscAmplDurOcc',filesep,experiment.name,filesep,'CSC17'));% num2str(CSC)]));
% oscTimes=round((OscAmplDurOcc.(['baseline']).OscTimes-time(1,1))*fs/10^6);
%
% [signal1, ~]=CutNGlueX(signal1,fs, oscTimes(1,:),oscTimes(2,:),windowSize);
% [signal2, ~]=CutNGlueX(signal2,fs, oscTimes(1,:),oscTimes(2,:),windowSize);

%% load sharp vector, and cut & glue the signal

load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'sharptimepoints1'));
if exist('sharptimepoints1')
    sharptimepoints = sharptimepoints1;
    clear sharptimepoints1
end
fifteen_min = fs*60*15;
sharptimepoints = sharptimepoints(sharptimepoints<(fifteen_min));
sharptimepoints = sharptimepoints/10;

SharpStart1 = sharptimepoints-0.45*fs;
SharpEnd1 = sharptimepoints-0.15*fs;
SharpStart2 = sharptimepoints-0.15*fs;
SharpEnd2 = sharptimepoints+0.15*fs;
SharpStart3 = sharptimepoints+0.15*fs;
SharpEnd3 = sharptimepoints+0.45*fs;

[signal11, ~]=CutNGlueX(signal1,fs, SharpStart1,SharpEnd1,windowSize);
[signal21, ~]=CutNGlueX(signal2,fs, SharpStart1,SharpEnd1,windowSize);
[signal12, ~]=CutNGlueX(signal1,fs, SharpStart2,SharpEnd2,windowSize);
[signal22, ~]=CutNGlueX(signal2,fs, SharpStart2,SharpEnd2,windowSize);
[signal13, ~]=CutNGlueX(signal1,fs, SharpStart3,SharpEnd3,windowSize);
[signal23, ~]=CutNGlueX(signal2,fs, SharpStart3,SharpEnd3,windowSize);

%% compute coherence

[Coherence1,freq]=ImCohere(signal11.xn,signal21.xn,windowSize,overlap,nfft,fs);
[Coherence2,~]=ImCohere(signal12.xn,signal22.xn,windowSize,overlap,nfft,fs);
[Coherence3,~]=ImCohere(signal13.xn,signal23.xn,windowSize,overlap,nfft,fs);
ImCoherence.freq = freq;
ImCoherence.coherencepre = Coherence1;
ImCoherence.coherence = Coherence2;
ImCoherence.coherencepost = Coherence3;

%% save data
if save_data == 0
    %     disp('DATA NOT SAVED!');
elseif save_data==1
    % data structure
    if ~exist(strcat(Path.output,filesep,'results',filesep,'Coherence',filesep,experiment.name));
        mkdir(strcat(Path.output,filesep,'results',filesep,'Coherence',filesep,experiment.name));
    end
%     save(strcat(Path.output,filesep,'results',filesep,'Coherence',filesep,experiment.name,filesep, ...
%         ['CSC' num2str(CSC1) num2str(CSC2)]),'ImCoherence')
      save(strcat(Path.output,filesep,'results',filesep,'Coherence',filesep,experiment.name,filesep, ...
        ['SharpCSC' num2str(CSC1) num2str(CSC2)]),'ImCoherence')
end