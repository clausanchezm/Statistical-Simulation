function [bs] = LFSR(seed, q, r)
%LFSR Summary of this function goes here
%  Pseudorandom generator


bs= zeros(2^length(seed), length(seed));
bs(1, :) = seed; 
for i = 1: 2^length(seed)
    %copying the first 4 digits, as we only change the last one
    bs(i+1, 1:length(seed)-1) = bs(i, 2:length(seed));
    if bs(i,q) == bs(i,r)
        bs(i+1, length(seed)) = 0;
    else
        bs(i+1, length(seed)) = 1;
    end      
end 

end

