function [error,Filter,operations ] = TrainFilterBasic( filterSize, data, target )
%UNTITLED7 Summary of this function goes here
%   simple training using MSE

[r,c] = size(data);

%initialize filter
Filter = randi([1,c+51],1,filterSize);
operations = randi([1,6],1,(filterSize-1));

error = Eval_Error(Filter,operations,data,target);

%stability of each index starts at 1
Ostab = operations./operations;
Fstab = Filter./Filter;

for i = 1:2000
    %error
    [Filter2, operations2,Fstab2,Ostab2] = Mutate(Filter,operations,Fstab,Ostab);
    error2 = Eval_Error(Filter2,operations2, data, target);
    if(abs(error2)<abs(error))
        error = error2%unsuppressed for error looking
        Filter = Filter2;
        operations = operations2;
        Ostab = Ostab2;
        Fstab = Fstab2;
    else
        %there should also be a decay factor on stability
        %eventually it should be dependant on the operations being used but for now
        %it will just be generic number
        ind = find(Ostab>20);
        Ostab(ind) = Ostab(ind)-15;
        ind = find(Fstab>20);
        Fstab(ind) = Fstab(ind)-15;
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

