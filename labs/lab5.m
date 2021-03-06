%  OUTPUTS
%  D        Average delay
%  W        Average waiting time
%  B        Average utilization

mu = 14;
lambda= 10; 
rho = mu/lambda;
avgWT= 1 / (mu*(1- rho));
nCI = 100; %how many CI we want from n
n = 1000;
m = 10000; %customers completions

wTimes = zeros(1, n);
bTimes = zeros (1, n);

%actually we need to compute 100 CI, from 1000 runs of this simulation (
%which each somulation has 10000 observations) 
for i = 1:n
    [d, w, b] =  MM1queueSimulation(m, lambda, mu);
    wTimes(i) = w; 
    bTimes(i) = b; 
end 

%computing mean and var from the averages 
wMean = mean(wTimes);
wVar = var(wTimes);
bMean = mean(bTimes);
bVar = var(bTimes);

%getting the critical values 
a = (1- (5/2))/10;
dof = n -1; 
CV = tinv(a, dof);

waitCI= wMean + 1.984*sqrt(wVar/n);
bCI = bMean + 1.984*sqrt(bVar/n);



lambda2 = 13; 
mu2 = 10; 
m2 = 10000; %# of observations 
n2 = 20; % # of runs
boot = 100; % taking 100 bootstrap samples

for i = 1:n2
    [d2, w2, b2] = MM1queueSimulation(n2, lambda2, mu2);
end 


