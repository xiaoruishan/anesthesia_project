function output=fit_noise(b,x)
%function for rms fitting

% Gaussian:
output=b(1).*exp(-((x-b(2)).^2)./(2.*b(3).^2));

end