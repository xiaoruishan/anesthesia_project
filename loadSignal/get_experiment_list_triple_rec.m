function experiment = get_experiment_list_triple_rec(exp_num)
% function defines the selected experiment plus correlated parameters
% input variable optional (vector), if not defined: all experiments are selected,
% if defined: selected experiments will be used
 
%EC experiments as used for the cross-correlation analysis
%from Marco
f=1;
%experiment performed on 29/11/13, very good file
experiment(f).name = '2013-11-29_10-40-35';  
experiment(f).path = 'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 8;
experiment(f).chan_num = {[54 10 38]}; 
experiment(f).chan_name = {'LEC' 'HP' 'PL'};
experiment(f).ECchannel = 49:63;


f=2;
%experiment performed on 06/11/13
experiment(f).name = '2013-11-06_14-44-49';  
experiment(f).path = 'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 8;
experiment(f).chan_num = {[54 10 38]}; 
experiment(f).chan_name = {'LEC' 'HP' 'PL'};
experiment(f).ECchannel = 49:63;

f=3;
%experiment performed on 09/12/13
experiment(f).name = '2013-09-12_10-31-58';  
experiment(f).path = 'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 7;
experiment(f).chan_num = {[53 39]}; %offsets!
experiment(f).chan_name = {'LEC' 'HP'};
experiment(f).ECchannel = 49:63;


f=4;
%experiment performed on 05/11/13
experiment(f).name = '2013-11-05_14-36-49';  
experiment(f).path = 'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 7;
experiment(f).chan_num = {[46 13 45]}; 
experiment(f).chan_name = {'LEC' 'HP' 'PL'};
experiment(f).ECchannel = 49:63;

f=5;
%experiment performed on 22/11/13
experiment(f).name = '2013-11-22_12-50-23';  
experiment(f).path = 'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 8;
experiment(f).chan_num = {[56 9 42]}; 
experiment(f).chan_name =  {'LEC' 'HP' 'PL'};
experiment(f).ECchannel = 49:63;


%from Henrike
f=6;
%experiment performed on 24/10/14
experiment(f).name = '2014-10-24_14-27-00';  %7 Hz artifact
experiment(f).path = 'U:\Recording_data_2_2014_09_26\Henrike\PL-HP-LEC\';
experiment(f).age = 8;
experiment(f).chan_num = {[39 59 12]}; % I SWITCHED IT FROM 16 TO 12 BECAUSE 16 didn't make much sense as it was the last channel of the electrode
experiment(f).chan_name = {'LEC' 'HP' 'PL'};
experiment(f).ECchannel = 33:48;

f=7;
%experiment performed on 29/10/14
experiment(f).name = '2014-10-29_17-56-27';  
experiment(f).path = 'U:\Recording_data_2_2014_09_26\Henrike\PL-HP-LEC\';
experiment(f).age = 7;
experiment(f).chan_num = {[44 54 10]}; %csc 42 also good
experiment(f).chan_name = {'LEC' 'HP' 'PL'};
experiment(f).ECchannel = 33:48;

f=8;
%experiment performed on 05/11/14
experiment(f).name = '2014-10-30_08-18-04';  
experiment(f).path = 'U:\Recording_data_2_2014_09_26\Henrike\PL-HP-LEC\';
experiment(f).age = 7;
experiment(f).chan_num = {[43 56 12]}; %csc 45 also good
experiment(f).chan_name = {'LEC' 'HP' 'PL'};
experiment(f).ECchannel = 33:48;

f=9;
%experiment performed on 20/11/14
experiment(f).name = '2014-11-20_13-02-42';  
experiment(f).path = 'U:\Recording_data_2_2014_09_26\Henrike\PL-HP-LEC\';
experiment(f).age = 8;
experiment(f).chan_num = {[46 55 12]}; 
experiment(f).chan_name = {'LEC' 'HP' 'PL'};
experiment(f).ECchannel = 33:48;

%VMT experiments from Marco
f=10;
%experiment performed on 
experiment(f).name = '2013-05-16_10-13-27_P8';  
experiment(f).path = 'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 8;
experiment(f).chan_num = {[6 43 56]}; 
experiment(f).chan_name = {'VMT' 'PFC' 'HP'};
experiment(f).ECchannel = 1:16;


f=11;
%experiment performed on
experiment(f).name = '2013-05-17_14-15-03_P9';  
experiment(f).path =  'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 9;
experiment(f).chan_num = {[4 37 53]}; 
experiment(f).chan_name = {'VMT' 'PFC' 'HP'};
experiment(f).ECchannel = 1:16;

f=12;
%experiment performed on 
experiment(f).name = '2013-04-18_14-18-00_P8';  
experiment(f).path =  'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 8;
experiment(f).chan_num = {[14 46 58]}; 
experiment(f).chan_name = {'VMT' 'PFC' 'HP'};
experiment(f).ECchannel = 1:16;

f=13;
%experiment performed on 
experiment(f).name = '2013-04-19_15-11-17_P9';  
experiment(f).path = 'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 9;
experiment(f).chan_num = {[6 43 57]}; 
experiment(f).chan_name = {'VMT' 'PFC' 'HP'};
experiment(f).ECchannel = 1:16;


f=14;
%experiment performed on
experiment(f).name = '2013-06-21_10-20-36_P7';  
experiment(f).path =  'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 7;
experiment(f).chan_num = {[12 39 58]}; 
experiment(f).chan_name = {'VMT' 'PFC' 'HP'};
experiment(f).ECchannel = 1:16;

f=15;
%experiment performed on 
experiment(f).name = '2013-06-14_15-28-38_P8';  
experiment(f).path =  'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 8;
experiment(f).chan_num = {[12 43 56]}; 
experiment(f).chan_name = {'VMT' 'PFC' 'HP'};
experiment(f).ECchannel = 1:16;

f=16;
%experiment performed on 
experiment(f).name = '2013-05-02_15-28-21_P6';  
experiment(f).path =  'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
experiment(f).age = 6;
experiment(f).chan_num = {[16 44 58]}; 
experiment(f).chan_name = {'VMT' 'PFC' 'HP'};
experiment(f).ECchannel = 1:16;

% %example trace lidocaine experiments
% f=17;
% experiment(f).name = '2014-03-12_16-09-33_P9';  
% experiment(f).path = 'U:\Recording_data\Data_Neuralynx\Marco\RE-EC_project\';
% experiment(f).age = 8;
% experiment(f).chan_num = {[15 21]}; 
% experiment(f).chan_name = {'PL','VMT'};
% experiment(f).ECchannel = 49:63;
% %example trace lidocaine experiments, effect HP
% f=18;
% experiment(f).name = '2015-01-14_19-27-25';  
% experiment(f).path = 'U:\Recording_data_2_2014_09_26\Henrike\PL-HP-LEC\Lidocaine\';
% experiment(f).age = 8;
% experiment(f).chan_num = {[58 ]}; 
% experiment(f).chan_name = {'HP'};
% experiment(f).ECchannel = 49:63;
% %example traces lidocaine experiments VMT
% f=19;
% %experiment performed on 04/06/14, rat1, baseline
% experiment(f).name = '2015-05-21_17-44-11';  
% experiment(f).path = 'U:\Recording_data_3_2015_02_19\Henrike\HP_VMT_PFC\';
% experiment(f).age = 7;
% experiment(f).chan_num = {[8 58 40]}; 
% experiment(f).chan_name = {'PL' 'HP' 'VMT'};
% experiment(f).Group = 'Control';
% f=20;
% %experiment performed on 04/06/14, rat1, lidocaine
% experiment(f).name = '2015-05-21_17-17-46';
% experiment(f).path = 'U:\Recording_data_3_2015_02_19\Henrike\HP_VMT_PFC\';
% experiment(f).age = 7;
% experiment(f).chan_num = {[8 58 40]}; 
% experiment(f).chan_name = {'PL' 'HP' 'VMT'};
% experiment(f).Group = 'VMT inactivation';


if ~exist('exp_num','var')
    experiment=experiment;
else
    experiment=experiment(exp_num);
end

end
