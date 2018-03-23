nm=zeros(20,2);
for i=1:20
    nm(i,1)=i;
    nm(i,2)=1;
end
%%nmPLV
DownsampleFactor=80; %
fs=32000/DownsampleFactor;
cross='ab';
flag_phase='Hilbert'

BandLow=[4 12];
BandHigh=[30 48];
R_nmPLV_ab.theta_LG= main_function_CutGlue_nmPLVcross(Experiment,Path,BandLow,BandHigh,nm,fs,cross,flag_phase);

BandLow=[4 12];
BandHigh=[52 100];
R_nmPLV_ab.theta_HG= main_function_CutGlue_nmPLV_cross(Experiment,Path,BandLow,BandHigh,nm,fs,cross,flag_phase);
