function [stimStructure] = getStimulusSignal(experiment,CSC, stimulusType, Frequency,downsampling_factor)
%% get periods
if strcmp(experiment.Exp_type,'blue')
    Period=[1	2	4	6	7	8	9	12	14	17	18	19	20	21	23	26	27	28	31	33	35	37	41	43	47	53	54	56	58	59];
    %Period=[2	4	6	7	9	13	14	17	18	19	21	22	23	24	27	29	31	32	33	35	40	41	45	46	52	53	56	57	58	59];
elseif strcmp(experiment.Exp_type,'both')
    Period=[3	5	10	11	13	15	16	22	24	25	29	30	32	34	36	38	39	40	42	44	45	46	48	49	50	51	52	55	57	60];
    %Period=[1	3	5	8	10	11	12	15	16	20	25	26	28	30	34	36	37	38	39	42	43	44	47	48	49	50	51	54	55	60];
elseif strcmp(experiment.Exp_type,'yellow')
    %    Period=[1	3	5	8	10	11	12	15	16	20	25	26	28	30	34	36	37	38	39	42	43	44	47	48	49	50	51	54	55	60];
    Period=[1	2	4	6	7	8	9	12	14	17	18	19	20	21	23	26	27	28	31	33	35	37	41	43	47	53	54	56	58	59];
else
    Period = experiment.(stimulusType);
end
stimStructure=[];
parameters=get_parameters;

if Frequency > 1
    Period = sortFreqPeriods(experiment,Period,Frequency)';
end
if ~isempty(Period)
    %% get structure
    if strcmp(experiment.Exp_type,'yellow')
        signalWindow=[-5 0 5 10];
    else
        signalWindow = parameters.(['Window_' stimulusType]);
    end
    stimStructure = loadStimStructure(experiment, CSC, Period, downsampling_factor, [abs(signalWindow(1)) signalWindow(4)-signalWindow(3)]);
    if ~isempty(stimStructure) % dont add the features if it is empty
        stimStructure.stimulusType=stimulusType;
        stimStructure.stimulusFrequency = Frequency;
        stimStructure.Periods=Period;
    end
else
    disp('NO STIMSTRUCTURE LOADED')
end
end