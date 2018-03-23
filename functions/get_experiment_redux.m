function experiment = get_experiment_redux(exp_num)
% function creates the selected experiment plus correlated parameters from
% the specified excel file
% input variable optional (vector), if not defined: all experiments are selected,
% if defined: selected experiments will be used

Path='Q:\Personal\Mattia\PyrProject\ExperimentPlanRedux.xlsx';
ExcelSheet='InfoandDevMil';
xlRange='A1:DZ1000';
[~,~,InfoandDevMil] = xlsread(Path,ExcelSheet,xlRange); % Import recording summary from excel sheet

[~,idxC_n_experiment]=find(strcmp(InfoandDevMil,'n_experiment'));
[~,idxC_animalID]=find(strcmp(InfoandDevMil,'animal_ID'));
[~,idxC_Exp_type]=find(strcmp(InfoandDevMil,'Exp_type'));
[~,idxC_Alive_recording]=find(strcmp(InfoandDevMil,'Alive recording'));
[~,idxC_Path]=find(strcmp(InfoandDevMil,'Path'));
[~,idxC_Age]=find(strcmp(InfoandDevMil,'Age'));
[~,idxC_IUEconstruct]=find(strcmp(InfoandDevMil,'construct'));
[~,idxC_IUEarea]=find(strcmp(InfoandDevMil,'target'));
[~,idxC_IUEage]=find(strcmp(InfoandDevMil,'age (E)'));
[~,idxC_channels]=find(strcmp(InfoandDevMil,'Channels'));
[~,idxC_HPchannels]=find(strcmp(InfoandDevMil(:,idxC_channels:idxC_channels+1),'HP'));
idxC_HPchannels=idxC_HPchannels+idxC_channels-1;
[~,idxC_HPreversal]=find(strcmp(InfoandDevMil,'HP reversal'));
[~,idxC_PFCchannels]=find(strcmp(InfoandDevMil(:,idxC_channels:idxC_channels+1),'PFC'));
idxC_PFCchannels=idxC_PFCchannels+idxC_channels-1;
[~,idxC_PFC_Cg]=find(strcmp(InfoandDevMil,'PFC_Cg'));
[~,idxC_PFC_PL]=find(strcmp(InfoandDevMil,'PFC_PL'));
[~,idxC_PFC_IL]=find(strcmp(InfoandDevMil,'PFC_IL'));

for row=6:1000
    if isa(InfoandDevMil{row,idxC_n_experiment},'numeric') && ~isnan(InfoandDevMil{row,idxC_n_experiment})
        experiment(InfoandDevMil{row,idxC_n_experiment}).animal_ID=InfoandDevMil{row,idxC_animalID};
        experiment(InfoandDevMil{row,idxC_n_experiment}).Exp_type=InfoandDevMil{row,idxC_Exp_type};
        experiment(InfoandDevMil{row,idxC_n_experiment}).name=InfoandDevMil{row,idxC_Alive_recording};
        experiment(InfoandDevMil{row,idxC_n_experiment}).path=InfoandDevMil{row,idxC_Path};
        experiment(InfoandDevMil{row,idxC_n_experiment}).age=InfoandDevMil{row,idxC_Age};
        experiment(InfoandDevMil{row,idxC_n_experiment}).IUEconstruct=InfoandDevMil{row,idxC_IUEconstruct};
        experiment(InfoandDevMil{row,idxC_n_experiment}).IUEarea=InfoandDevMil{row,idxC_IUEarea};
        experiment(InfoandDevMil{row,idxC_n_experiment}).IUEage=InfoandDevMil{row,idxC_IUEage};
        TempHPchannels = textscan(InfoandDevMil{row,idxC_HPchannels}, '%f %f', 'delimiter','-');
        experiment(InfoandDevMil{row,idxC_n_experiment}).HPchannels=TempHPchannels{1,1}:TempHPchannels{1,2};
        experiment(InfoandDevMil{row,idxC_n_experiment}).HPreversal=InfoandDevMil{row,idxC_HPreversal};
        try
            experiment(InfoandDevMil{row,idxC_n_experiment}).HPreversal=str2num(InfoandDevMil{row,idxC_HPreversal});
        end
        TempPFCchannels = textscan(InfoandDevMil{row,idxC_PFCchannels}, '%f %f', 'delimiter','-');
        experiment(InfoandDevMil{row,idxC_n_experiment}).PFCchannels=TempPFCchannels{1,1}:TempPFCchannels{1,2};
        experiment(InfoandDevMil{row,idxC_n_experiment}).Cg=InfoandDevMil{row,idxC_PFC_Cg};
        experiment(InfoandDevMil{row,idxC_n_experiment}).PL=InfoandDevMil{row,idxC_PFC_PL};
        experiment(InfoandDevMil{row,idxC_n_experiment}).IL=InfoandDevMil{row,idxC_PFC_IL};
        try
            experiment(InfoandDevMil{row,idxC_n_experiment}).Cg=str2num(InfoandDevMil{row,idxC_PFC_Cg});
            experiment(InfoandDevMil{row,idxC_n_experiment}).PL=str2num(InfoandDevMil{row,idxC_PFC_PL});
            experiment(InfoandDevMil{row,idxC_n_experiment}).IL=str2num(InfoandDevMil{row,idxC_PFC_IL});
        end
    end
end

if exist('exp_num','var')
    experiment=experiment(exp_num);
end