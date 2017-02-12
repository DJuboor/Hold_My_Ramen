function [ExpectedReturn, PercentError] = MECHLSupervised1( D , C, a , V )
%   Inputs:
% "D" must be a 2xN matrix where the first row is the independent
% variable and the second row is the dependent varialble
% 
% "C" must be a 1x2 matrix with two arbitrary values (doesn't matter) 
% 
% "a" must be a single scaling value between 0 and 1 (Suggested value
% of 0.0001) If NAN, INF, or abnormal number: the function is not converging and "a" must be
% smaller.
% 
% "V" must be an independent variable point for which you want to
% estimate the dependent output
%
% % % TESTING DATA % % 
x = 1:100; 
y = x*5 + 3;
for i = 1:length(y)
y(i) = y(i) + 3*randn();
end
D = [x;y];
C=[rand,rand];
clear x y


    %Hypothesis definition
     Yhyp=@(x,A,B,C)(C*x.^2 + B*x + A);
    %Error definition
     errord=@(m,x,y)(sum((1/(2*m))*(x-y).^2));
    %Error derivative
     errorderiv=@(m,x,y,z)(sum((1/m)*(x-y).*z));
    %Percent Error
     perror=@(part,whole)((part/whole)*100);
     
Theta0=C(1,1);
Theta1=C(1,2);
Theta2=C(1,3);
Xi=D(1,:);
Yi=D(2,:);
InitialError=errord(length(D),Xi,Yi);
DeltaError=100;
Error=0;
P=0;

% Plot the initial guessed function
x = 1:100;
% yb = x*Theta1+Theta0;
% plot(yb)
% hold on

% while DeltaError >= 0.001
        %Test loop
         for i=1:3  

    Yh=Yhyp(Xi,Theta0,Theta1,Theta2);
    
    % Theta0 gradient decent
    TempTheta0=errorderiv(length(D),Yh,Yi,1)*a;
   
    %Theta1 gradient decent
    TempTheta1=errorderiv(length(D),Yh,Yi,Xi)*a;
    
    %Theta2 gradient decent
    TempTheta2=errorderiv(length(D),Yh,Yi,Xi)*a;
    
    %Simultaneous update
    
    Theta0=Theta0-TempTheta0;
    Theta1=Theta1-TempTheta1;
    Theta2=Theta2-TempTheta2;

    %Error assessment
    Error1=errord(length(D),Yh,Yi);
    DeltaError= Error-Error1
    Error=Error1;
    PercentError =perror(Error,InitialError);
    P=[P,PercentError];
    

        end

 
ExpectedReturn = Theta2*V^2+Theta1*V+Theta0;

% Plot the Error
figure(1)
plot(P)
%   hold on

% Plot the initial Y data set
figure(2)
plot(D(2,:))
hold on

% Plot the new function with updated thetas
Ya = x.^2*Theta2+x*Theta1+Theta0; 
hold on
plot(Ya)

end
