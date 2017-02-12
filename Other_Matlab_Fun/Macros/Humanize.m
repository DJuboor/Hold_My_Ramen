function [ y ] = Humanize( x , E)
%This Function takes in a single integer and feeds back an integer with a +- E%
%error
%temp = [0,0];

a = x * (E / 100);
rand_error = a.*randn(100,1) + x;

[rows,~] = size(rand_error);

data = [];
for i = 1:rows
    if rand_error(i) > x
        data =[data, rand_error(i)];
    end
end

y = datasample(data,1);
end

