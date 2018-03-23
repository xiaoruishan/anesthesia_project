%% SampEn 
DownsampleFactor=160; % fs=1000;
param.fs=32000/DownsampleFactor;
param.win_sec=1; param.th_r=2;param.DownsampleFactor=DownsampleFactor;
param.ExtractModeArray=[];param.flag_CutData=1;param.Band=[1 90];
Electrodes=[];

load('D:\Project-DISC1 in PFC-Neonatal\Experiment list\Experiment_Xiaxia_add.mat')
main_function_CutGlue_SE(Experiment,Path,param,Electrodes);
