function experiment = get_experiment_list(exp_num)
% function creates the selected experiment plus correlated parameters from
% the specified excel file
% input variable optional (vector), if not defined: all experiments are selected,
% if defined: selected experiments will be used

Path='Q:\Personal\Mattia\AnestProject\ExperimentPlan.xlsx';
ExcelSheet='InfoandDevMil';
xlRange='A1:DZ1000';
[~,~,InfoandDevMil] = xlsread(Path,ExcelSheet,xlRange); % Import recording summary from excel sheet

[~,idxC_n_experiment]=find(strcmp(InfoandDevMil,'n_experiment'));
[~,idxC_animalID]=find(strcmp(InfoandDevMil,'animal_ID'));
[~,idxC_Exp_type]=find(strcmp(InfoandDevMil,'Exp_type'));
[~,idxC_Alive_recording]=find(strcmp(InfoandDevMil,'Alive recording'));
[~,idxC_Dead_recording]=find(strcmp(InfoandDevMil,'Dead recording'));
[~,idxC_Path]=find(strcmp(InfoandDevMil,'Path'));
[~,idxC_Age]=find(strcmp(InfoandDevMil,'Age'));
[~,idxC_IUEconstruct]=find(strcmp(InfoandDevMil,'construct'));
[~,idxC_IUEarea]=find(strcmp(InfoandDevMil,'target'));
[~,idxC_IUEage]=find(strcmp(InfoandDevMil,'age (E)'));
[~,idxC_expression]=find(strcmp(InfoandDevMil,'Expression'));
[~,idxC_expressionPFC]=find(strcmp(InfoandDevMil(:,idxC_expression:idxC_expression+4),'PL'));
idxC_expressionPFC=idxC_expressionPFC+idxC_expression-1;
[~,idxC_expressionHP]=find(strcmp(InfoandDevMil(:,idxC_expression:idxC_expression+4),'HP'));
idxC_expressionHP=idxC_expressionHP+idxC_expression-1;
[~,idxC_Stimulation]=find(strcmp(InfoandDevMil,'Stimulation'));
[~,idxC_HPelType]=find(strcmp(InfoandDevMil,'HPelType'));
[~,idxC_HPelConfig]=find(strcmp(InfoandDevMil,'HPelConfig'));
[~,idxC_HPelectrodeLoc]=find(strcmp(InfoandDevMil,'HPLocation'));
[~,idxC_PFCelType]=find(strcmp(InfoandDevMil,'PFCelType'));
[~,idxC_PFCelConfig]=find(strcmp(InfoandDevMil,'PFCelConfig'));
[~,idxC_PFCelectrodeLoc]=find(strcmp(InfoandDevMil,'PFCLocation'));
[~,idxC_STIMchannels]=find(strcmp(InfoandDevMil,'Stim x A/D'));
[~,idxC_ERRORchannels]=find(strcmp(InfoandDevMil,'Broken CSCs'));
[~,idxC_channels]=find(strcmp(InfoandDevMil,'Channels'));
[~,idxC_HPchannels]=find(strcmp(InfoandDevMil(:,idxC_channels:idxC_channels+1),'HP'));
idxC_HPchannels=idxC_HPchannels+idxC_channels-1;
[~,idxC_HPreversal]=find(strcmp(InfoandDevMil,'HP reversal'));
[~,idxC_PFCchannels]=find(strcmp(InfoandDevMil(:,idxC_channels:idxC_channels+1),'PFC'));
idxC_PFCchannels=idxC_PFCchannels+idxC_channels-1;
[~,idxC_PFC_Cg]=find(strcmp(InfoandDevMil,'PFC_Cg'));
[~,idxC_PFC_PL]=find(strcmp(InfoandDevMil,'PFC_PL'));
[~,idxC_PFC_IL]=find(strcmp(InfoandDevMil,'PFC_IL'));
[~,idxC_observedSpiking]=find(strcmp(InfoandDevMil,'Spikes'));
[~,idxC_observedLFP]=find(strcmp(InfoandDevMil,'LFP'));
[~,idxC_powerEst]=find(strcmp(InfoandDevMil,'powerEst'));
[~,idxC_square]=find(strcmp(InfoandDevMil,'square'));
[~,idxC_ramp]=find(strcmp(InfoandDevMil,'ramp'));
[~,idxC_chirp]=find(strcmp(InfoandDevMil,'chirp'));
[~,idxC_sine]=find(strcmp(InfoandDevMil,'sine'));
[~,idxC_powerEstDead]=find(strcmp(InfoandDevMil,'powerEstDead'));
[~,idxC_squareDead]=find(strcmp(InfoandDevMil,'squareDead'));
[~,idxC_rampDead]=find(strcmp(InfoandDevMil,'rampDead'));
[~,idxC_chirpDead]=find(strcmp(InfoandDevMil,'chirpDead'));
[~,idxC_sineDead]=find(strcmp(InfoandDevMil,'sineDead'));
[~,idxC_square10_10]=find(strcmp(InfoandDevMil,'square10_10'));
[~,idxC_square1_100]=find(strcmp(InfoandDevMil,'square1_100'));

[~,idxC_DM.bodyLength]=find(strcmp(InfoandDevMil,'Body length (cm)'));
[~,idxC_DM.tailLength]=find(strcmp(InfoandDevMil,'Tail length (cm)'));
[~,idxC_DM.weight]=find(strcmp(InfoandDevMil,'Weight (g)'));
[~,idxC_DM.graspingReflex]=find(strcmp(InfoandDevMil,'Grasping reflex'));
[~,idxC_DM.surfaceReflex]=find(strcmp(InfoandDevMil,'Surface righting (s)'));
[~,idxC_DM.cliffAvoidance]=find(strcmp(InfoandDevMil,'Cliff avoidance (s)'));
[~,idxC_DM.vibrissaPlacing]=find(strcmp(InfoandDevMil,'Vibrissa placing'));
[~,idxC_DM.pinnaeDetachment]=find(strcmp(InfoandDevMil,'Pinnae detachment'));
[~,idxC_DM.auditoryStartle]=find(strcmp(InfoandDevMil,'Auditory startle'));
[~,idxC_DM.eyeOpening]=find(strcmp(InfoandDevMil,'Eye opening'));


for m1=6:1000
    if isa(InfoandDevMil{m1,idxC_n_experiment},'numeric') && ~isnan(InfoandDevMil{m1,idxC_n_experiment})
        experiment(InfoandDevMil{m1,idxC_n_experiment}).animal_ID=InfoandDevMil{m1,idxC_animalID};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).Exp_type=InfoandDevMil{m1,idxC_Exp_type};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).name=InfoandDevMil{m1,idxC_Alive_recording};
        if strcmp(InfoandDevMil{m1,idxC_Dead_recording},'no')
            experiment(InfoandDevMil{m1,idxC_n_experiment}).nameDead='';
        else
            experiment(InfoandDevMil{m1,idxC_n_experiment}).nameDead=InfoandDevMil{m1,idxC_Dead_recording};
        end
        experiment(InfoandDevMil{m1,idxC_n_experiment}).path=InfoandDevMil{m1,idxC_Path};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).age=InfoandDevMil{m1,idxC_Age};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).IUEconstruct=InfoandDevMil{m1,idxC_IUEconstruct};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).IUEarea=InfoandDevMil{m1,idxC_IUEarea};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).IUEage=InfoandDevMil{m1,idxC_IUEage};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).expression=[0 0];
        if strcmp(InfoandDevMil{m1,idxC_expressionPFC},'yes')
            experiment(InfoandDevMil{m1,idxC_n_experiment}).expression(1,1)=1;
        end
        if strcmp(InfoandDevMil{m1,idxC_expressionHP},'yes')
            experiment(InfoandDevMil{m1,idxC_n_experiment}).expression(1,2)=1;
        end
        if strcmp(InfoandDevMil{m1,idxC_Stimulation}(1,1:2),'HP')
            TempHPelectrode=1;
        else
            TempHPelectrode=0;
        end
        experiment(InfoandDevMil{m1,idxC_n_experiment}).HPelectrodeType=InfoandDevMil{m1,idxC_HPelType};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).HPelectrode=[TempHPelectrode str2num(InfoandDevMil{m1,idxC_HPelConfig})];
        experiment(InfoandDevMil{m1,idxC_n_experiment}).HPelectrodeLoc=InfoandDevMil{m1,idxC_HPelectrodeLoc};
        if strcmp(InfoandDevMil{m1,idxC_Stimulation}(1,1:2),'PF')
            TempPFCelectrode=1;
        else
            TempPFCelectrode=0;
        end
        experiment(InfoandDevMil{m1,idxC_n_experiment}).PFCelectrodeType=InfoandDevMil{m1,idxC_PFCelType};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).PFCelectrode=[TempPFCelectrode str2num(InfoandDevMil{m1,idxC_PFCelConfig})];
        experiment(InfoandDevMil{m1,idxC_n_experiment}).PFCelectrodeLoc=InfoandDevMil{m1,idxC_PFCelectrodeLoc};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).STIMchannels=InfoandDevMil{m1,idxC_STIMchannels};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).ERRORchannels=(InfoandDevMil{m1,idxC_ERRORchannels});
        try
        experiment(InfoandDevMil{m1,idxC_n_experiment}).ERRORchannels=str2num(InfoandDevMil{m1,idxC_ERRORchannels});
        end
        TempHPchannels = textscan(InfoandDevMil{m1,idxC_HPchannels}, '%f %f', 'delimiter','-');
        experiment(InfoandDevMil{m1,idxC_n_experiment}).HPchannels=TempHPchannels{1,1}:TempHPchannels{1,2};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).HPreversal=InfoandDevMil{m1,idxC_HPreversal};
        try
            experiment(InfoandDevMil{m1,idxC_n_experiment}).HPreversal=str2num(InfoandDevMil{m1,idxC_HPreversal});
        end
        TempPFCchannels = textscan(InfoandDevMil{m1,idxC_PFCchannels}, '%f %f', 'delimiter','-');
        experiment(InfoandDevMil{m1,idxC_n_experiment}).PFCchannels=TempPFCchannels{1,1}:TempPFCchannels{1,2};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).Cg=InfoandDevMil{m1,idxC_PFC_Cg};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).PL=InfoandDevMil{m1,idxC_PFC_PL};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).IL=InfoandDevMil{m1,idxC_PFC_IL};
        try
            experiment(InfoandDevMil{m1,idxC_n_experiment}).Cg=str2num(InfoandDevMil{m1,idxC_PFC_Cg});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).PL=str2num(InfoandDevMil{m1,idxC_PFC_PL});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).IL=str2num(InfoandDevMil{m1,idxC_PFC_IL});
        end
        experiment(InfoandDevMil{m1,idxC_n_experiment}).observedSpiking=InfoandDevMil{m1,idxC_observedSpiking};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).observedLFP=InfoandDevMil{m1,idxC_observedLFP};
        experiment(InfoandDevMil{m1,idxC_n_experiment}).powerEst=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).square=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).ramp=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).chirp=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).sine=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).powerEstDead=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).squareDead=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).rampDead=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).chirpDead=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).sineDead=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).square10_10=NaN;
        experiment(InfoandDevMil{m1,idxC_n_experiment}).square1_100=NaN;
        try
            experiment(InfoandDevMil{m1,idxC_n_experiment}).powerEst=str2num(InfoandDevMil{m1,idxC_powerEst});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).square=str2num(InfoandDevMil{m1,idxC_square});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).ramp=str2num(InfoandDevMil{m1,idxC_ramp});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).chirp=str2num(InfoandDevMil{m1,idxC_chirp});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).sine=str2num(InfoandDevMil{m1,idxC_sine});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).powerEstDead=str2num(InfoandDevMil{m1,idxC_powerEstDead});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).squareDead=str2num(InfoandDevMil{m1,idxC_squareDead});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).rampDead=str2num(InfoandDevMil{m1,idxC_rampDead});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).chirpDead=str2num(InfoandDevMil{m1,idxC_chirpDead});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).sineDead=str2num(InfoandDevMil{m1,idxC_sineDead});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).square10_10=str2num(InfoandDevMil{m1,idxC_square10_10});
            experiment(InfoandDevMil{m1,idxC_n_experiment}).square1_100=str2num(InfoandDevMil{m1,idxC_square1_100});
        end
        
        % developmental milestones
        try
            for DM={'bodyLength',...
                    'auditoryStartle',...
                    'cliffAvoidance',...
                    'eyeOpening',...
                    'graspingReflex',...
                    'pinnaeDetachment',...
                    'surfaceReflex',...
                    'tailLength',...
                    'vibrissaPlacing',...
                    'weight'}
                X=[NaN NaN NaN NaN NaN];
                countX=0;
                for nn=0:4
                    countX=countX+1;
                    try
                        X(countX)=InfoandDevMil{m1,idxC_DM.(DM{1})+nn};
                    end
                end
                experiment(InfoandDevMil{m1,idxC_n_experiment}).developmentalMilestones.(DM{1})=X;
            end
        end
    end
end



% f=2;
% experiment(f).animal_ID         = '43878-1';
% experiment(f).name              = '2015-02-03_14-22-50';
% experiment(f).nameDead          = '';
% experiment(f).path              = 'Q:\Recording_data_2_2014_09_26\Optogenetics\';
% experiment(f).age               = [8];
% experiment(f).IUEconstruct      = 'CAG-ChR2ET/TC-2AtDimer2';
% experiment(f).IUEarea           = 'PFC';
% experiment(f).IUEage            = 14.5;
% experiment(f).expression        = [0 0]; % PFC HP
% experiment(f).HPelectrode       = [0 5 50 1 NaN]; %stimulation shank, length, spacing, shank number, shank distance
% experiment(f).HPelectrodeLoc    = 'intmCA1';
% experiment(f).PFCelectrode      = [1 3 100 1 NaN]; %stimulation shank, length, spacing, shank number, shank distance
% experiment(f).PFCelectrodeLoc   = 'PFC_L2/3';
% experiment(f).STIMchannels      = [1];
% experiment(f).ERRORchannels     = [NaN];
% experiment(f).HPchannels        = [1:16];
% experiment(f).HPreversal        = [9];
% experiment(f).PFCchannels       = [17:32];
% experiment(f).Cg                = [20];
% experiment(f).PL                = [25]; %from medial to lateral for 4shank
% experiment(f).IL                = [30];
% experiment(f).observedSpiking   = [NaN]; %CSC where effect was observed during recording.
% experiment(f).observedLFP       = [NaN]; %CSC where effect was observed during recording.
% experiment(f).powerEst          = [1:9];
% experiment(f).square            = [11:190];
% experiment(f).ramp              = [200:229];
% experiment(f).chirp             = [230:259];
% experiment(f).sine              = [260:439];
% experiment(f).powerEstDead      = [NaN];
% experiment(f).squareDead        = [NaN];
% experiment(f).rampDead          = [NaN];
% experiment(f).chirpDead         = [NaN];
% experiment(f).sineDead          = [NaN];
% experiment(f).square10_10       = [NaN];
% experiment(f).square1_100       = [NaN];


if exist('exp_num','var')
    experiment=experiment(exp_num);
end