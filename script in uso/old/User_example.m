

x=DeNoiseWavelet(hp');
y=DeNoiseWavelet(pfc');
u=[x(2000:2400) y(2000:2400)];

f=200/1024:200/1024:200;
f=f';

nFreqs=1024;
metric='diag'; % 'euc'; 'info'
maxIP=50;
alg=1;
alpha=0.05;
criterion=1;

c=PDC_computation(u,nFreqs,metric,maxIP,alg,alpha,criterion);
plot(f,c.c12,'r',f,c.c21,'b')
