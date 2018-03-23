function Path = get_path
%% Defines Paths for all tools
% The Path for neuralynx data is defined in get_experiment_list.m
Path.source = 'Q:\Personal\Mattia\AnestProject\analysis\';% code, copy toolboxes, data except neuralynx files
Path.output = 'Q:\Personal\Mattia\AnestProject\analysis\';% matlab output (figures, mat files with results), Excel sheets, etc...
Path.temp   = 'Q:\Personal\Mattia\AnestProject\analysis\';% here we save temporary files (e.g. filtered signals) to speed up the routines, this folder has to be cleared after finishing project
Path.signal = 'Q:\Personal\Mattia\AnestProject\analysis\nlx_load_Opto';
% addpath(Path.source) % Adds all m-files in the analysis folder structure
end