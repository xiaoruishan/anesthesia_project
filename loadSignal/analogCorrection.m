function [correction] = analogCorrection(signalA)
    maxPower = max(signalA(1,:));
    correction = (round(-0.0001*(maxPower)^2 + 0.6228*maxPower - 3.2176))/maxPower; % The formula is generated from measurements from laser
end