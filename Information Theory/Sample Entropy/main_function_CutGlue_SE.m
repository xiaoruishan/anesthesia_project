function main_function_CutGlue_SE(Experiment,Path,params,electrodes,flag_time_path)

fs=params.fs;
th_r=params.th_r;
ExtractModeArray=params.ExtractModeArray;
DownsampleFactor=params.DownsampleFactor;
flag_CutData=params.flag_CutData;
Band=params.Band;

for iExperiment=1:length(Experiment)
    iExperiment
    filename=Experiment(iExperiment).name;
    experiment=Experiment(iExperiment);
    %experiment.PL=19; 
    % use co-occuring LFP
    sim_StartEnd=load( strcat(Path.Results,'\simOsc_fs_',num2str(fs),'_thr',num2str(th_r),'\',filename,'.mat') );
    %StartEnd_samp=simOsc_StartEnd.simOsc_StartEnd_samp;
    StartEnd_samp=sim_StartEnd.simOsc_StartEnd_samp;
    if flag_CutData
        EndTime=StartEnd_samp(:,2)/fs; % s
        StartEnd_samp=StartEnd_samp(1:max(find(EndTime<15*60)),:);
    end
    
    if isempty(electrodes)
        Electrodes=[experiment.HPreversal experiment.PL];
    else
        Electrodes=[experiment.HPreversal electrodes];
    end
    
    % load signal
    for csc=1:length(Electrodes)
        CSC=Electrodes(csc);
        File= strcat(Experiment(iExperiment).path,filesep,Experiment(iExperiment).name,'\CSC',num2str(CSC),'.ncs');
        
        if nargin < 5
            [TimeStamps, Samples, samplingrate] = load_nlx(File,ExtractModeArray);
        else
            [TimeStamps, Samples, samplingrate] = load_nlx_stimulation_baseline(experiment, CSC,flag_time_path);
        end
        
        [~, Samples, ~] = filter_downsample(TimeStamps, Samples, samplingrate, DownsampleFactor);
        
        for iband=1:size(Band,1)
            band=Band(iband,:);
            ySamples=ZeroPhaseFilter(Samples,fs,band);
            
            % cut and glue
            [CutGlu,~,~]=cutandglue(params,ySamples,StartEnd_samp);
            yCutGlu=CutGlu.xn;
            
            SE=[];
            for seg=1:(size(yCutGlu,1))
                r=0.2*std(yCutGlu(seg,:));
                SE(seg)= SampEn( 2, r, yCutGlu(seg,:));
            end
            
            % save the results
            if ~exist(  strcat(strcat(Path.output,filesep,'SampEn',filesep,filename))  )
                mkdir(strcat(Path.output,filesep,'SampEn',filesep,filename))
            end
            % mkdir(strcat(Path.output,filesep,'Firing_rate',filesep,filename))
            cd(strcat(Path.output,filesep,'SampEn',filesep,filename))
            save(strcat('SE_band',num2str(band(1)),'_',num2str(band(2)),'_CSC',num2str(CSC)),'SE')
        end
        
    end
end



















