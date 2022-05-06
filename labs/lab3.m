load data_practical_goodness_of_fit.mat
%scatter(data, x)
%seems normal 
M = mean(data); 
V = var(data);
%hold on 
h = histogram(data, 15);
%y = normpdf(x,M,V);

%
[Y, E] =  discretize(data, 15);

chi = zeros(length(data));
chiSq = 0;
for i= 1 :length(E)-1
    chi(i)= ((normcdf(E(i+1), M, V^1/2)-(normcdf(E(i), M, V^1/2)))* length(data)); 
end

for i=1 : length(E)
    chiSq = chiSq + (h.Values(i)- chi(i))^2/ chi(i); 
end 

chiSq

  










