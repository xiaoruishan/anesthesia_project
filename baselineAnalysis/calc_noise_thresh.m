function thr=calc_noise_thresh(rms,num_sd)
%calculate threshold for oscillation detection

[y,x]=hist(rms,0:0.2:200);  %histogram of rms values
y=y./max(y);                %normalize by maximum
y(1)=0;                     %set first value to zero
y_to_fit=y(1:find(y==max(y))); %fit only data from zero to peak
x_to_fit=x(1:find(y==max(y)));

pest_start=[1,x_to_fit(end),x_to_fit(end)/2];         %initial values for fitting
pest=nlinfit(x_to_fit,y_to_fit,@fit_noise,pest_start);  %gaussian fit
thr = pest(2) + num_sd * pest(3);               %mean plus num_sd times SD

% figure
% plot(x,y)
% hold on
% y_fitted = pest(1).*exp(-((x-pest(2)).^2)./(2.*pest(3).^2));
% plot(x,y_fitted,'r')
end