function [PPC,PCDI]=getPPC_PCDI_PLV(Spikephases)
% by Mattia
% input
% SpikePhases - vector with phases of the spikes of interest, with respect
% to the frequency band of interest

SpikephasesMatrix=repmat(Spikephases,length(Spikephases),1);
PopulationAngularDistance=sum(sum(mod(abs(SpikephasesMatrix-SpikephasesMatrix'),pi)))/(length(Spikephases)*(length(Spikephases)-1));
PCDI=(pi-2*PopulationAngularDistance)/pi;
DiffPhaseMatrix=mod(abs(SpikephasesMatrix-SpikephasesMatrix'),pi);
CosDiffPhaseMatrix=cos(DiffPhaseMatrix);
PPC=(sum(sum(CosDiffPhaseMatrix))-length(Spikephases))/(length(Spikephases)*(length(Spikephases)-1));

end