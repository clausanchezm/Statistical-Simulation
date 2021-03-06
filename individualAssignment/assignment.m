load dataIndSSA2022.mat
%% Task 1a.1: Visualising 
%figure
%histogram(task1_data)
%figure
%boxplot(task1_data)
%x = zeros(1,length(task1_data));
%plot(x, task1_data)
A = sort(task1_data);
%figure
%plot(x, A)
%figure
%scatter(x, A)

%from the histogram we can say it ressembles a normal distribution but
%right skewed, or even it is normally distributed but in logarithmic scale
%
%the boxwhisker graph doesn't really reflect any insights, just that there are many
%data points in the 4th quartile, shown by the red lines that would
%normally correspond to outliers 
%the scatter plot doesnt give too much intuition about the data either,
%given the amount of data points its hard to determine the consistency of
%the data. 

%% Task 1a2: Removing Outliers
%histogram(A, 20)
%A first approach to remove outliers was to simplify the histogram into 20
%bins. At the end of the tail we can see a very small last bin. Tehy have
%values of 100 and the last value of the continuos tail was 80, so we might
%infer that it is an outlier. Additionally, the very first bin of the
%histogram is much smaller than the second bin, this might be just a
%property of the normal distribution but they could also be outliers. 

%another way we can check is computing the 1st and 3rd interquatiles(they
% correspond the 25% and 75% of the sorted data) and 
%observe which data points are outside of this and by how much. 
% 
B = A;
ub = prctile(A, 95); 
lb = prctile(A, 1);
indicesLow =find(A < lb);
indicesHigh =find(A > ub);
B(indicesLow) = NaN; 
B(indicesHigh) = NaN; 
figure
histogram(B)
title("IQR data")
%I explored a bit with the threholds in the previous block of code, taking
%25&75 removed too much of the data, since its normal distributed outside
% range5-95% is considered an outlier. Afterwards the following method also
% returns a very neat histogram. The threshold that ressembled the most to
% this method were between 1 and 95
outliers = rmoutliers(A); 
figure
histogram(outliers);
title("RMmethod data")


%% Task1a3: Metrics

p = [2, 9, 25, 50, 75, 91, 98];
P = prctile(outliers, p); 
outliersNorm = outliers/ max(outliers); 
PNORM = prctile(outliersNorm, p);

skeness = @(x) (sum((x-mean(x)).^3)./length(x)) ./ (var(x,1).^1.5);
skewnessD = skeness(outliers);
% skewness = 0.53 meaning its indeed right skewed, 

% P=10.7066   13.2621   17.4966   23.4115   30.4260 37.6070   43.3425
%as we can see the percentiles are not equally spaced, The first three
%percentiles have a difference of 3 units and the next 4 of 7 units 

%    0.1358    0.2115    0.3024    0.4200    0.5601    0.7190    0.8853
% normalizing the data without outliers, gave us actually an an almost 
% equally spaced sequence, proving that the data follows a normal
% distribution

% M = mean(outliers)
% medium = median(outliers)
% V = var(outliers)
% V^1/2
%

% M = mean(outliersNorm)
% medium = median(outliersNorm)
% V = var(outliersNorm)
% V^1/2

%given that the variance is 106.35 we can already conclude that the data is
% very sparse nevertheless, the mean (24.48) and the medium (23.23) have very
%similar value, inducing some similarity to the normal distribution

%normalizing our data, we obtain as mean = 0.4426 and the medium as 0.4200,
%so very similar values again and that the variance is 0.0348, intuitevely
%I would say this means data is now less sparse, but the behavoirs of the
%data should be perserved after dividing them all by a scalar

%% Task 1b: Reason what distribution it is  

% I would hypothesize it follows a normal distribution, it has a bell
% shape, with a tail, in this case we saw it was right skewed so even after
% removing outliers, it can be seen that the symmetry around the mean is
% slightly shifted to the left
% and the mean and medium are almost the same, additionally, when
% normalizing the data we obtain a valid seven percent test.

%there are actually many different distributions that follow a similar
%shape to ours, for instance Gamma distribution or Erlangs, nevertheless,
%no test was perform tocheck teh suitability of these distributions thus it
%is a more valid reasoning to expect a normal distribution as some tests
%were performed and they were positive. 


%% Task2a: estimate MLE param 
% this is like a gradient descent problem to which we have to find the best
% suited parameter given the distribution we are testing and the data we
% have% given the independence of the data points we can compute their
% joint probability 
%TODO; talk a bit more 

% Load the data task2_data from dataIndSSA2022.mat and sort it in increasing
% order 
load("dataIndSSA2022.mat");
A2 = sort(task2_data);
histogram(A2)

% The Parameters of the Lognormal distribution are ?? and ??; very similar to
% normal distribution but we talk about 'logaritmic values', the MLE param
% are computed similarly, but applying the natural log to all data
% points
%given the indepenceof our data we can compute their joint probabilities by
%multiplication, after some rearranging we arrive to the following to
%estimate the mean and variance by MLE 
% Estimated ??; first estimate mean, then variance, we need mean for the var
% = std^2
mu = (1 ./ length(A2) )* sum(log(A2));
sigSquared = (1 ./ length(A2) )* sum((log(A2) - mu).^2);
std = sqrt(sigSquared);
% test to check if obtained mu and sigma are the same as when computed with
% inbuilt function. They are the same! :)
% param = lognfit(A2);

%function to obtain the logarithmic normal probability density fucntion 
logPDF = @(x) (1 ./ (x * std * sqrt(2 * pi))) .* exp(- ((log(x) - mu).^2)/ (2 * sigSquared));
%% Task 2: Part b

x = 0:0.01:120;
h = histogram(A2, 61, 'Normalization', 'pdf');
hold on
pdf = logPDF(x);
plot(x, pdf, 'LineWidth', 3)
hold off
%In this graph I just plotted the expected PDF (red line) against our
%empiricalpdf, they follow the same shape


%% Task 2c: X^2 test

[Y, E] = discretize(A2, 61);
chi = zeros(1, length(E));
chiSq = 0;

for i = 1: length(E)-1
    chi(i) = integral(logPDF, E(i), E(i+1)); 
end
for i = 1: length(E)
    if chi(i) == 0 
        chiSq = chiSq + 0; 
    else 
    chiSq = chiSq + (((h.Values(i) - chi(i))^2)/chi(i)) ;
    end
end 
chiSq

%given 60 degrees of Freedom and the significance level of
%0.05, teh confidence level is 0.95 thus the corresponding critical
%values is 43.188
%Hence we haveno reason to conclude it is not logarithmic normal
%distribute, since our chisquared is lower than the C.V


%% Task3a: Random generator 

a1 = 0; 
a2 = 63308; 
a3 = -183326;
b1 = 86098; 
b2 = 0; 
b3 = -539608;
m1= 2^31 -1; 
m2 = 2145483479; 
%add the param to the initial values of arrays genereated , thus we will
%start at i=4 in the for loop 
Xn(1) = a1; 
Xn(2) = a2; 
Xn(3) = a3; 
Yn(1) = b1; 
Yn(2) = b2; 
Yn(3) = b3; 
Zn = zeros(1, length(Xn));
for i = 4:10000 
    Xn(i) = mod((a1 * Xn(i-1) + a2 * Xn(i-2) + a3 * Xn(i-3)), m1);
    Yn(i) = mod((b1 * Yn(i-1) + b2 * Yn(i-2) + b3 * Yn(i-3)), m2);
    
    Zn(i) = mod(Xn(i) - Yn(i), m1);
end

%normalize the data so U~(0,1) 
zMax = max(Zn);
Zn = Zn/ zMax; 
A3 = sort(Zn);
figure
histogram(Zn)
title("numbers generated")
%they do seem uniformly distributed 

%% Task 3b: K-S TEST
%hypothesing a uniform distribution; fHat will be the CDF where x = [0, 1]
fHat = zeros(size(A3));
plusD = zeros(size(A3)); 
minusD = zeros(size(A3)); 
for i = 1: length(A3)
    if A3(i) < 0
        fHat(i) = 0; 
    elseif A3(i) > 1
        fHat(i) = 1; 
    else 
        fHat(i) = A3(i); %given that our a, b are 0 &1, the CDF is the datavalue
    end
    plusD(i) = i/ length(A3) - fHat(i); 
    minusD(i) = fHat(i) - (i-1)/length(A3);
end

maxPlus = max(plusD); 
maxMinus = max(minusD); 
d = max(maxMinus, maxPlus);

%given that the know all parameters, variance, mean and D+, D-, we ar ethe
%in the first case of the table in slide 17.Lecture 5, hence outr critical
% value is 1.358,  and our value obtained d = 0.0133, thus we have no
% reason to reject our null hypothesis which was that the distribution of
% the numbers generated is uniform. 



%% TAsk 3c: POKER TEST 

%given the generated numbers, we split them into sequence of 5 digits (thus
%multiply the decimal by 10 ) which will represent the "hand" in poker and
%we get their pattern from them. 10k numbers generated  -> 2k trials
trials = reshape(floor(10* Zn), 2000, 5);
%possible patterns = 7 
freq = zeros(1,7); 
for i = 1: length(trials)
    j = getPattern(trials(i,:));
    freq(j) = freq(j) + 1; 
end
%from slides
expectedProb = [0.3024, 0.5040, 0.1080, 0.072, 0.009, 0.0045, 0.001]; 
%observedProb = freq/ N 
obsProb = freq/2000; 

xSq =0; 
for i = 1: length(expectedProb)
    if obsProb(i) == 0
        xSq = xSq + 0; 
    else 
        xSq = xSq + ((expectedProb(i)- obsProb(i).^2)/obsProb(i));
    end
end
xSq

%given the 7 patterns; 7 bins; we have 6 DOF, and alpha is stil 0.05 thus
%CV = 12.592.  And our chi squared value obtained is 3.3606 hence tehre is
%no reason to reject that our data is unformily distributed 


% alldif, onepair, twopairs, trio, fullHouse, fourOfAKind, fiveOfAKind
%b corresponds to the index to where the sequence will be categorized in
%test
%retrieve all distinct values of sequence, depending on the length could be
% all differen, pairs etc 
function b = getPattern(x)
    d = unique(x); 
    if length(d)== 5    %all different values 
        b = 1; 
    elseif length(d) == 4 %only one different so only one pair
        b = 2; 
    elseif length(d)== 3 %either two pairs or trio
        if twoPair(x)
            b = 3; 
        else 
            b= 4; 
        end
    elseif length(d)== 2 %either fullhouse or fourofakind
        if fourOfAKind(x)
            b = 5; 
        else
            b= 6; 
        end 
    elseif length(d) == 1
        b = 7; 
    end 
end

%if there are 3distintc digits, eitehr two pairs or three of a kind (trio)
function b = twoPair(x)
    r = unique(x);
    s = zeros(1, length(r));
    %see how many of the distinct there are 
    for i =1: length(r)
        s(i) = length(find(x == r(i))); 
    end 
    %if there are two pairs, the maximum repetition is 2 else its a trio
    if max(s) == 2
        b = true; 
    else 
        b = false; 
    end 
end 

%if distintcs = 2 then fullHouse or Fourofakind
function b = fourOfAKind(x)
    r = unique(x);
    s = zeros(1, length(r));
    for i = 1: length(s)
        s(i) = length(find(x==s(i)));
    end 
    if max(s)== 4
        b = true;
    else
        b = false; 
    end 
end 