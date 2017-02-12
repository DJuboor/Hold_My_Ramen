function [error,Filter,operations ] = ML2FINALGeneticMechl( filterSize, xdata, ydata )
%UNTITLED7 Summary of this function goes here
%   simple training using MSE
 
[r,c] = size(xdata);
 
%initialize filter
Filter = randi([1,c+51],1,filterSize);
operations = randi([1,6],1,(filterSize-1));
 
error = Eval_Error(Filter,operations,xdata,ydata);
 
%stability of each index starts at 1
Ostab = operations./operations;
Fstab = Filter./Filter;
 
for i = 1:100
    %error
    [Filter2, operations2,Fstab2,Ostab2] = Mutate(Filter,operations,Fstab,Ostab);
    error2 = Eval_Error(Filter2,operations2, xdata, ydata);
    if(abs(error2)<abs(error))
        error = error2; %unsurpress to see error upon iteration
        Filter = Filter2;
        operations = operations2;
        Ostab = Ostab2;
        Fstab = Fstab2;
    end
    if(isnan(error))
        error = error2;
        Filter = Filter2;
        operations = operations2;
    end
    if error ==0
        i %on what iteration did it figure out the answer?
        break;
    end
end
 
 
 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ error ] = Eval_Error( Filter,Operations, data, target )
%UNTITLED6 Summary of this function goes here
%   for now this will just give a positive fitness if the MSE decreases.
%   update later with divergence measures instead of classification stuff
 
%data is in rows.
 
%first we gotta make an input list that is as long as the filter
[r,c] = size(data);
%i = -5:(10)/(length(Filter)-c-1):5; %this is the extra stuff i need to complete input
i = -5:.2:5; %this is 51 elements
 
error = 0;
for k = 1:r
    inputs = [data(k,:) i];
   
    guess = ForwardPass(Filter,inputs,Operations);
    %guess = logsig(guess);%for classification if i want
    %error = error + (target(k)-guess)^2;
    %error = error + (abs(target(k))-abs(guess))/(abs(target(k))+abs(guess));
    error = error + abs((target(k)-guess)/target(k));
end
error = error/r;
 
 
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ out] = Dictionary( x1,x2,operation )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 
%possible operations are + - * / ^ . this should be expanded to add ()
%later as well as follow order of operations. also need to add cos and sin.
%overall this whole thing just needs to be more robust lol
 
%I should also add a "stop" operation that makes it so it doesn't evaluate
%anything further down the line
 
DIVISION = 1;
MULTIPLICATION = 2;
ADDITION = 3;
SUBTRACTION = 4;
POWER = 5;
MOD = 6;
 
switch operation
    case DIVISION
        out = x1/x2;
    case MULTIPLICATION
        out = x1*x2;
    case ADDITION
        out = x1+x2;
    case SUBTRACTION
        out = x1-x2;
    case POWER
        out = x1^x2;
    case MOD
        out = x1+x2;% mod(x1,x2); %fix this later
    otherwise
        out = 0;'error'
end
   
   
   
   
 
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ Filter, operations,Fstab,Ostab ] = Mutate( Filter, operations, Fstab, Ostab )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
 
%Fstab refers to the stability of each filter index.
%Ostab refers to the stability of each operations index.
%the less stability, the more mutations will happen
alpha = 30;
 
for i = 1:length(Filter)
    if randi([1,100])>Fstab(i)%if it is unstable enough to mutate
        Filter(i) = randi([1,length(Filter)]);
        Fstab(i) = Fstab(i)+alpha;
    end
end
 
for i = 1:length(Ostab)
    if randi([1,100])>Ostab(i)
        operations(i) = randi([1,6]);%there are only 6 possible operations atm
        Ostab(i) = Ostab(i)+alpha;
    end
end
 
 
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ out ] = ForwardPass( filter,inputs,operations )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 
%the filter vector should be a vector of length same as inputs where each element
%points to an index in inputs.
%operations should be a vector of length one less than inputs
%where each element designates
%an operation to be done eg ^ * / - + %.  possible values of any element in
%operations should be between 1 and  6.
 
inputs = inputs(filter); %filter essentially acts as a permutation vector
out = inputs(1);
%note, this does not follow order of operations. i should figure out how to
%make it follow order of operations and also add parenthases to options.
%but that's for later
for i = 1:(length(inputs)-1)
    out = Dictionary(out,inputs(i+1), operations(i));
end
 
end