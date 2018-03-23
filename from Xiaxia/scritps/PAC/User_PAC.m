
%-------------
range1=[1:2:20];
range2=[30:2:200];

fs=500;
cross='ab'; 
measure='mi';
band=[0 200];
Merge_num=40;

tic
R_PAC_ab.Christoph= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Christoph_P8_P10,Path,band,range1,range2,cross,measure,fs,Merge_num);
R_PAC_ab.Xiaxia= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Xiaxia_P8_P10,Path,band,range1,range2,cross,measure,fs,Merge_num);
R_PAC_ab.Xiaxia_new= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Xiaxia_P8_P10_new,Path,band,range1,range2,cross,measure,fs,Merge_num);
toc
save('R_PAC_ab_1.mat','R_PAC_ab');

%--------------------
fs=500;
cross='aa'; 
measure='mi';
band=[0 200];
Merge_num=40;

tic
R_PAC_aa.Christoph= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Christoph_P8_P10,Path,band,range1,range2,cross,measure,fs,Merge_num);
R_PAC_aa.Xiaxia= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Xiaxia_P8_P10,Path,band,range1,range2,cross,measure,fs,Merge_num);
R_PAC_aa.Xiaxia_new= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Xiaxia_P8_P10_new,Path,band,range1,range2,cross,measure,fs,Merge_num);
toc
save('R_PAC_aa_1.mat','R_PAC_aa');


%--------------------
fs=500;
cross='bb'; 
measure='mi';
band=[0 200];
Merge_num=40;

tic
R_PAC_bb.Christoph= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Christoph_P8_P10,Path,band,range1,range2,cross,measure,fs,Merge_num);
R_PAC_bb.Xiaxia= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Xiaxia_P8_P10,Path,band,range1,range2,cross,measure,fs,Merge_num);
R_PAC_bb.Xiaxia_new= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Xiaxia_P8_P10_new,Path,band,range1,range2,cross,measure,fs,Merge_num);
toc
save('R_PAC_bb_1.mat','R_PAC_bb');

%--------------------
fs=500;
cross='ba'; 
measure='mi';
band=[0 200];
Merge_num=40;

tic
R_PAC_ba.Christoph= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Christoph_P8_P10,Path,band,range1,range2,cross,measure,fs,Merge_num);
R_PAC_ba.Xiaxia= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Xiaxia_P8_P10,Path,band,range1,range2,cross,measure,fs,Merge_num);
R_PAC_ba.Xiaxia_new= main_function_calculate_PAC_several_GutGlue_segs(Experiment_Xiaxia_P8_P10_new,Path,band,range1,range2,cross,measure,fs,Merge_num);
toc
save('R_PAC_ba_1.mat','R_PAC_ba');
%-------------

