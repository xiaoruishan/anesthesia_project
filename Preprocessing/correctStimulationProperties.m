function correctStimulationProperties(experiments,save_data,repeatCalc)
Path = get_path;
%vector used for stim on arduino
randomVars = [32, 8, 64, 8, 8, 64, 16, 8, 8, 2, 32, 4, 8, 16, 8, 32, 64, 32, 2, 64, 4, 8, 2, 4, 4, 2, 4, 4, 32, 4, 2, 4, 4, 4, 32, 8, 32, 2, 64, 4, 4, 16, 2, 2, 16, 8, 2, 16, 64, 4, 64, 2, 16, 16, 2, 64, 64, 16, 2, 32, 32, 64, 2, 16, 2, 4, 64, 64, 2, 32, 2, 32, 4, 64, 8, 8, 4, 16, 64, 32, 8, 4, 64, 16, 8, 2, 4, 16, 4, 32, 4, 32, 64, 64, 64, 8, 32, 2, 64, 4, 32, 64, 2, 4, 8, 32, 64, 16, 2, 2, 16, 64, 4, 2, 64, 16, 8, 16, 64, 4, 8, 8, 32, 2, 8, 16, 2, 8, 16, 2, 32, 32, 4, 8, 64, 16, 2, 64, 2, 32, 2, 4, 16, 4, 4, 16, 8, 32, 4, 8, 8, 16, 16, 16, 2, 64, 16, 4, 16, 8, 32, 32, 32, 32, 16, 2, 32, 8, 32, 16, 64, 32, 16, 64, 8, 32, 8, 64, 16, 8];
for n_animal = 1:length(experiments)
    if ~isempty(experiments(n_animal).animal_ID)
        experiment = experiments(n_animal);
        if  repeatCalc == 0 && exist(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected','.mat'));
            %     disp('Already calculated, loading file instead');
        else
            % load stimProperties

              load(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_raw'))
              StimProperties2 = StimulationProperties_raw;
            if ~isnan(experiment.sine)
                % correct Sine
                SinePeriod = experiment.sine;
                cutRandomVars = randomVars(1:length(SinePeriod)); %% Some Sines in early day recordings did not do all 180 recordings
                countPeriod = 0;
                for Period = SinePeriod
                    countPeriod = countPeriod + 1;
                    StimProperties2(Period,6) = num2cell(cutRandomVars(countPeriod));
                    StimProperties2{Period,8} = 'sinus';
                end
            end
            if ~isnan(experiment.ramp)
                % correct ramp
                rampPeriod = experiment.ramp;
                countPeriod = 0;
                for Period = rampPeriod
                    countPeriod = countPeriod + 1;
                    StimProperties2{Period,6} = NaN;
                    StimProperties2{Period,8} = 'ramp';
                end
            end
            if ~isnan(experiment.chirp)
                % correct chirp
                chirpPeriod = experiment.chirp;
                countPeriod = 0;
                for Period = chirpPeriod
                    countPeriod = countPeriod + 1;
                    StimProperties2{Period,6} = NaN;
                    StimProperties2{Period,8} = 'chirp';
                end
            end
            StimulationProperties_corrected = StimProperties2;
            % save
            if save_data == 0
                disp('DATA NOT SAVED');
            elseif save_data == 1
                if ~exist(strcat(Path.output,'results',filesep,'StimulationProperties', filesep, experiment.name, filesep));
                    mkdir(strcat(Path.output,filesep,'results',filesep,'StimulationProperties', filesep, experiment.name, filesep));
                end
                save(strcat(Path.output, 'results', filesep, 'StimulationProperties', filesep, experiment.name, filesep, 'StimulationProperties_corrected','.mat'),'StimulationProperties_corrected');
            end
        end
    end
end
end