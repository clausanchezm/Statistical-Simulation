%% Task 3: Part a

% Given parameter values
a1 = 0;
a2 = 63308;
a3 = -183326;
b1 = 86098;
b2 = 0;
b3 = -539608;
m1 = 2147483647;
m2 = 2145483479;

X(1) = 0;
X(2) = 63308;
X(3) = -183326;
Y(1) = 86098;
Y(2) = 0;
Y(3) = -539608;

% Generate 10,000 random numbers
for n = 4:10000 % Start from 4 due to X(n-3) and Y(n-3)
    X(n) = mod((a1 * X(n-1) + a2 * X(n-2) + a3 * X(n-3)), m1);
    Y(n) = mod((b1 * Y(n-1) + b2 * Y(n-2) + b3 * Y(n-3)), m2);
    
    Z(n) = mod(X(n) - Y(n), m1);
end

% Store the data
zMax = max(Z);
Z = Z / zMax;
histogram(Z)

%% Task 3: Part b

function y = twoPair(x)
   u = unique(x);
   for i =1 : length(u)
       l = find(x == u(i));
       if length(l)==3
           return 3
       elseif length(l)==2
           return 2
       end 
   end 
end 


%% Task 3: Part b


data_sorted = sort(generated_data);
N = length(data_sorted);
% normalize data
X = data_sorted;
X = X/max(X(:));

histogram(X);

for i = 1:N
    % Observed distribution
    F_o(i) = i / N;

    % Hypothesized distribution
    if X(i)<0
        F_h(i) = 0;
    elseif X(i)>1
        F_h(i) = 1;
    else
        F_h(i) = X(i);
    end

    % D is KS test statistic
    D(i)= abs(F_o(i) - F_h(i));

end

Dmax = max(D);
critical = 1.36/sqrt(10000);
Dmax
critical

% Order the data in increasing order
data_sorted = sort(generated_data);

% Sample size
N = length(data_sorted);

% X(i) are ordered from smallest to largest value
X = data_sorted;

% mu = mean of the distribution
% mu = mean(data_sorted);

% sigma = standard deviation of the distribution
% sigma = std(data_sorted);

% F is CDF of the uniform distribution
% F = @(x)(0.5 * (1 + erf(x - mu ./ (sigma * sqrt(2)))));

for i = 1:N
    % Observed distribution
    F_o(i) = i ./ N;

    % Hypothesized distribution
    if X(i)<0
        F_h = 0;
    elseif X(i)>1
        F_h = 1;
    else
        F_h = X(i);
    end

    % D is KS test statistic
%     D = max(abs(F_o - F_h));
    D_plus = max(i./N - F_h);
    D_minus = max(F_h - (i-1)./N);
    D = max(D_plus, D_minus);

end

D