%% Part a

% Given parameter values
a1 = 0;
a2 = 63308;
a3 = -183326;
b1 = 86098;
b2 = 0;
b3 = -539608;
m1 = 2147483647;
m2 = 2145483479;

X_3(1) = 0;
X_3(2) = 2;
X_3(3) = 549;
Y_3(1) = 8785;
Y_3(2) = 0;
Y_3(3) = -53548;

% Generate 10,000 random numbers
for n = 4:10000 % Start from 4 due to X(n-3) and Y(n-3)
    X_3(n) = mod((a1 * X_3(n-1) + a2 * X_3(n-2) + a3 * X_3(n-3)), m1);
    Y_3(n) = mod((b1 * Y_3(n-1) + b2 * Y_3(n-2) + b3 * Y_3(n-3)), m2);
    
    Z(n) = mod(X_3(n) - Y_3(n), m1);
end


% Store the data
random_data = Z;
%% Part b

data_sorted = sort(random_data);
N = length(data_sorted);
% normalize data btewwn 0 and 1
X_3 = data_sorted;
X_3 = X_3/max(X_3(:));

histogram(X_3);

for i = 1:N
    % Observed distribution
    fOriginal(i) = i / N;

    % Hypothesized distribution
    if X_3(i)<0
        FHat(i) =     0;
    elseif X_3(i) > 1
        FHat(i) = 1;
    else
        FHat(i) = X_3(i);
    end

    % D is KS test statistic
    plusD(i)= abs(fOriginal(i) - FHat(i));
    minusD(i) = FHat(i) - (i -1)./N ;

end

Dmax = max(plusD);
critical_3 = 1.36/sqrt(10000);
Dmax
critical_3


%% part c

