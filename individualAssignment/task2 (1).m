%% Task 2: Part a

% Load the data task2_data from dataIndSSA2022.mat
load("dataIndSSA2022.mat");

% Order the data in increasing order
task2_sorted = sort(task2_data);

% Mean
meanValue = mean(task2_sorted);
meanSquared = meanValue .^2;

% Variance
variance = var(task2_sorted);

% Parameters of the Lognormal distribution are μ and σ

% mu (μ) (i.e. mean of logarithmic values)
% mu = log(meanSquared ./ sqrt(variance + meanSquared));
mu = 1 ./ length(task2_sorted) * sum(log(task2_sorted));
mu;

% sigma (σ)	(i.e. standard deviation of logarithmic values)
sigma = sqrt(1 ./ length(task2_sorted) * sum((log(task2_sorted) - mu).^2));
sigma;

% CHECK: mu and sigma are switched
% mleAns = mle(task2_sorted,'Distribution','Lognormal');
% param = lognfit(task2_sorted);

%% Task 2: Part b

%  histfit(task2_sorted,length(task2_sorted),'lognormal'); % TEST

% Variable X
x = 0:0.01:110;

% TEST
% y_lognormal=lognpdf(y,mu,sigma);
% figure
% plot(y,y_lognormal)

figure

histogram(task2_sorted, 'Normalization','pdf', 'BinEdges', x);
hold on

% Probability Density Function (PDF) of the lognormal distribution
pdf = exp(-(log(x)- mu).^2 ./ (2 * sigma.^2)) ./ (x * sigma * sqrt(2 * pi));

plot(x, pdf, 'LineWidth', 1.5);
hold off

%% Task 2: Part c

% [Y,E] = discretize(X,N) divides the data in X into N bins of uniform width, and also returns the bin edges E.
% [Y, E] = discretize(task2_sorted, 20);
% 
% chiSquared = sum();