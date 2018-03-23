

clear all

%% load two channels: equidistant from the reversal channel, one above and one under

save_file = 1;
path = get_path;
parameters = get_parameters;
experiments = get_experiment_list;
animal_number = [601:611 301:312];


for n = [1:2 4 7:14 16:17 19 21:22];
    
    clearvars -except n & save_file & path & parameters & experiments & animal_number
    
    experiment = experiments(animal_number(n));
    
    load(strcat(path.output, 'results', filesep, 'SharpStuff', filesep, experiment.name, filesep, 'SharpWaves2Chan.mat'));
    
    sharp_morphology2 = zeros(size(sharpwaves2chan,3),8);
    
    for pp = 1 : size(sharpwaves2chan,3)
        
        [upper_peak,upper_peak_idx] = max(abs(sharpwaves2chan(5,4600:5200,pp)));
        upper_peak_idx = upper_peak_idx + 4600;
%         zero_pre_upper = 4600 + find(Sharp(1,4600:upper_peak_idx,pp)<0,1,'last');
%         zero_post_upper = upper_peak_idx + find(Sharp(1,upper_peak_idx:5200,pp)<0,1);
%         width_upper = zero_post_upper - zero_pre_upper;
        first_slope_upper = sharpwaves2chan(5, upper_peak_idx, pp) - sharpwaves2chan(5, upper_peak_idx-50, pp) / 50;
        second_slope_upper = sharpwaves2chan(5, upper_peak_idx, pp) - sharpwaves2chan(5, upper_peak_idx+50, pp) / 50;
        
        [lower_peak,lower_peak_idx] = max(abs(sharpwaves2chan(4,4600:5200,pp)));
        lower_peak_idx = lower_peak_idx + 4600;
%         zero_pre_lower = 4600 + find(Sharp(2,4600:lower_peak_idx,pp)>0,1,'last');
%         zero_post_lower = lower_peak_idx + find(Sharp(2,lower_peak_idx:5100,pp)>0,1);
%         width_lower = zero_post_lower - zero_pre_lower;
        first_slope_lower = abs(sharpwaves2chan(4, lower_peak_idx, pp)) - abs(sharpwaves2chan(4, lower_peak_idx-50, pp)) / 50;
        second_slope_lower = abs(sharpwaves2chan(4, lower_peak_idx, pp)) - abs(sharpwaves2chan(4, lower_peak_idx+50, pp)) / 50;
        
        
%         [post_peak,post_peak_idx] = max(Sharp(2,zero_post_lower:zero_post_lower+500,pp));
        
%         if numel(width_lower) > 0 & width_lower > 10
%             
%             first_slope_lower = lower_peak /(lower_peak_idx - zero_pre_lower);
%             second_slope_lower = lower_peak /(zero_post_lower - lower_peak_idx);
%         else
%             first_slope_lower = NaN; second_slope_lower = first_slope_lower; width_lower = first_slope_lower;
%         end
%            
%         if numel(width_upper) > 0 & width_upper > 10
% 
%             first_slope_upper = upper_peak /(upper_peak_idx - zero_pre_upper);
%             second_slope_upper = upper_peak /(zero_post_upper - upper_peak_idx);
%         else
%             first_slope_upper = NaN; second_slope_upper = first_slope_upper; width_upper = first_slope_upper;
%         end
        
%         if numel(post_peak) > 0
% 
%             post_peak_idx = post_peak_idx + zero_post_lower;
% %             slope_post_peak = post_peak /(post_peak_idx - zero_post_lower);
%         else
%             post_peak_idx = NaN; slope_post_peak = post_peak_idx; post_peak = post_peak_idx;
%         end
 
            sharp_morphology2(pp,1) = upper_peak;
%             sharp_morphology(pp,2) = width_upper;
            sharp_morphology2(pp,3) = first_slope_upper;
            sharp_morphology2(pp,4) = second_slope_upper;
            sharp_morphology2(pp,5) = lower_peak;
%             sharp_morphology(pp,6) = width_lower;
            sharp_morphology2(pp,7) = first_slope_lower;
            sharp_morphology2(pp,8) = second_slope_lower;
%             sharp_morphology(pp,9) = post_peak;
%             sharp_morphology(pp,10) = slope_post_peak;
                   
    end
    
    save(strcat(path.output,filesep,'results',filesep,'SharpStuff',filesep,experiment.name,filesep,'sharp_morphology2'),'sharp_morphology2');
    
    
end



