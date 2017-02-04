%%%%% Experimental Data %%%%%


exp_temp = [ 61.78 59.6 58.14 56.96 56.22 55.78 55.41 55.29 55.37 55.54 55.92];
exp_x1 = [0.091 0.19 0.288 0.401 0.501 0.579 0.687 0.756 0.84 0.895 0.954];
exp_x2 = [0.909 0.81 0.712 0.599 0.499 0.421 0.313 0.244 0.16 0.105 0.046];
exp_y1 = [0.177 0.312 0.412 0.505 0.578 0.631 0.707 0.76 0.829 0.88 0.946];
exp_y2 = [0.823 0.688 0.588 0.495 0.422 0.369 0.293 0.24 0.171 0.12 0.054];

%% Van Laar Model
tic;
%clc, clear all

%%% CONSTANT INPUTS: %%%
Precision = 0.01;

%General Constants
P_total = 760;  % in mmHg

%for component 1 (Acetone)
A_1 = 7.1174;
B_1 = 1210.595;
C_1 = 229.664;
Gamma_inf_1 = 1.86;

%for component 2 (Methanol)
A_2 = 8.08097;
B_2 = 1582.271;
C_2 = 239.726;
Gamma_inf_2 = 1.78;
%^^^ in mmHg and deg C standards

%%% Van Laar Computations Given ^ %%%

%Set the amount of samples / precision of our predictions
x1 = [0:Precision:1];
x2 = 1 - x1;

%Antoine to find Pvap of sample in mmHg
Antoine = @(T,A,B,C)10^(A-(B/(T+C)));  

%Compute Pi_vap with a symbolic T
syms T
P1_vap = vpa(Antoine(T,A_1,B_1,C_1),6); 
P2_vap = vpa(Antoine(T,A_2,B_2,C_2),6); 

%Calculate Gamma_i using equilibrium relation
A_12 = log(Gamma_inf_1);
A_21 = log(Gamma_inf_2);

%Van_Laar_Gammas
Gamma_1 = exp(A_12.*((A_21.*x2)./(A_12.*x1+A_21.*x2)).^2);
Gamma_2 = exp(A_21.*((A_12.*x1)./(A_12.*x1+A_21.*x2)).^2);

%Calculate the Partial molar fraction with a symbolic T
Y_1 = vpa((x1.*Gamma_1.*P1_vap)./P_total,6);
Y_2 = vpa((x2.*Gamma_2.*P2_vap)./P_total,6);   

%Find squared error assuming ideal conditions (Y_1 + Y_2 == 1)
error = vpa((1-(Y_1+Y_2)).^2,6);
[~,c] = size(error);

%Evaluate to minimize error to ideal (error = 0) and compute temperature
%for each sample at these ideal conditions

Solution_Temperatures = zeros(1,c-2); %Preallocation for faster compute

parfor i = 2:c  %Queues parallel processing pools

   temp = error(i);
   temp = vpa(solve(temp,T),4);
   Solution_Temperatures(i) = temp; 

end

Y_1_soln = [];
parfor i = 2:length(Y_1)
   temp = matlabFunction(Y_1(i));
   temp = temp(Solution_Temperatures(i));
   Y_1_soln = [Y_1_soln, temp];
end
toc;

%Clean up the data because the calculations get wonky when the composition		
%== 0 		
x1 = x1(2:length(x1));		
x2 = x2(1:length(x2)-1);		
Solution_Temperatures = Solution_Temperatures(2:length(Solution_Temperatures));		
Solution_Temperatures_VL = Solution_Temperatures;

%Plots:
figure
subplot(1,2,1)
grid on
hold on 
plot(Y_1_soln, Solution_Temperatures, 'b', 'LineWidth',2)
plot(x1, Solution_Temperatures, 'r', 'LineWidth',2)
title('T-x-y diagram')
plot(x1(79), Solution_Temperatures(79), 'redo', 'MarkerFaceColor', 'Yellow')
plot(exp_x1, exp_temp, 'sk', 'LineWidth', 2) 
plot(exp_y1, exp_temp, 'dk', 'LineWidth', 2) 
legend('Temp vs X','Temp vs Y','Azeotrope (55.3810^{\circ}C)','Experimental X Data','Experimental Y Data', 'Location', 'Best')
xlabel('Mole Fraction of Acetone')
ylabel('Temperature ^{\circ}C')
xlim([0,1])
ylim([55,64.2])

subplot(1,2,2)
hold on
grid on
plot(x1, Y_1_soln, 'k', 'LineWidth', 2)
plot(fliplr(x1), x2, 'k:', 'LineWidth', 2)
plot(x1(79), Y_1_soln(79), 'redo', 'MarkerFaceColor', 'Yellow')
legend('Vapor vs Liquid','45^{\circ} Reference','Azeotrope (.790)', 'Location', 'Best')
title('VLE Behavior of the Binary System')
xlabel('Acetone Liquid Mole Fraction')
ylabel('Acetone Vapor Mole Fraction')
xlim([0,1])
ylim([0,1])

annotation('textbox', [0 0.9 1 0.1], ...
    'String', 'Van Laar:', ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')

%clearvars -except Solution_Temperatures_Wilson Solution_Temperatures_VL Solution_Temperatures_TCM
%% Two-Constant Margules Model
tic;

Precision = 0.01;
%General Constants
P_total = 760;  % in mmHg

%for component 1
A_1 = 7.1174;
B_1 = 1210.595;
C_1 = 229.664;
Gamma_inf_1 = 1.86;

%for component 2
A_2 = 8.08097;
B_2 = 1582.271;
C_2 = 239.726;
Gamma_inf_2 = 1.78;
%^^^ in mmHg and deg C standards


%%% Two-Constant Margules Computations Given ^ %%%

%Set the amount of samples / precision of our predictions
x1 = [0:Precision:1];
x2 = 1 - x1;

%Antoine to find Pvap of sample in mmHg
Antoine = @(T,A,B,C)10^(A-(B/(T+C)));  

%Compute Pi_vap with a symbolic T
syms T
P1_vap = vpa(Antoine(T,A_1,B_1,C_1),6); 
P2_vap = vpa(Antoine(T,A_2,B_2,C_2),6); 

%Calculate Gamma_i using equilibrium relation
A_12 = log(Gamma_inf_1);
A_21 = log(Gamma_inf_2);

%Two-Constant Margules Gammas
Gamma_1 = exp(x2.^2.*(A_12+2.*(A_21-A_12).*x1));
Gamma_2 = exp(x1.^2.*(A_21+2.*(A_12-A_21).*x2));

%Calculate the Partial molar fraction with a symbolic T
Y_1 = vpa((x1.*Gamma_1.*P1_vap)./P_total,6);
Y_2 = vpa((x2.*Gamma_2.*P2_vap)./P_total,6);   

%Find squared error assuming ideal conditions (Y_1 + Y_2 == 1)
error = vpa((1-(Y_1+Y_2)).^2,6);
[~,c] = size(error);

%Evaluate to minimize error to ideal (error = 0) and compute temperature
%for each sample at these ideal conditions

Solution_Temperatures = zeros(1,c-2); %Preallocation for faster compute

parfor i = 2:c      %Queues parallel processing pools

   temp = error(i);
   temp = vpa(solve(temp,T),4);
   Solution_Temperatures(i) = temp; 

end

Y_1_soln = [];
parfor i = 2:length(Y_1)
   temp = matlabFunction(Y_1(i));
   temp = temp(Solution_Temperatures(i));
   Y_1_soln = [Y_1_soln, temp];
end

toc;

%Clean up the data because the calculations get wonky when the composition
%== 0 

x1 = x1(2:length(x1));
x2 = x2(1:length(x2)-1);
Solution_Temperatures = Solution_Temperatures(2:length(Solution_Temperatures));
Solution_Temperatures_TCM = Solution_Temperatures;

%Plots:
figure
subplot(1,2,1)
grid on
hold on 
plot(Y_1_soln, Solution_Temperatures, 'b', 'LineWidth',2)
plot(x1, Solution_Temperatures, 'r', 'LineWidth',2)
title('T-x-y diagram')
plot(x1(79), Solution_Temperatures(79), 'redo', 'MarkerFaceColor', 'Yellow')
plot(exp_x1, exp_temp, 'sk', 'LineWidth', 2) 
plot(exp_y1, exp_temp, 'dk', 'LineWidth', 2) 
legend('Temp vs X','Temp vs Y','Azeotrope (55.3786^{\circ}C)','Experimental X Data','Experimental Y Data', 'Location', 'Best')
xlabel('Mole Fraction of Acetone')
ylabel('Temperature ^{\circ}C')
xlim([0,1])
ylim([55,64.2])

subplot(1,2,2)
hold on
grid on
plot(x1, Y_1_soln, 'k', 'LineWidth', 2)
plot(fliplr(x1), x2, 'k:', 'LineWidth', 2)
plot(x1(79), Y_1_soln(79), 'redo', 'MarkerFaceColor', 'Yellow')
legend('Vapor vs Liquid','45^{\circ} Reference','Azeotrope (.790)', 'Location', 'Best')
title('VLE Behavior of the Binary System')
xlabel('Acetone Liquid Mole Fraction')
ylabel('Acetone Vapor Mole Fraction')
xlim([0,1])
ylim([0,1])

annotation('textbox', [0 0.9 1 0.1], ...
    'String', 'Two-Constant Margules:', ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')

%clearvars -except Solution_Temperatures_Wilson Solution_Temperatures_VL Solution_Temperatures_TCM
%% Wilson Model
tic;

Precision = 0.01;
%General Constants
P_total = 760;  % in mmHg

%for component 1
A_1 = 7.1174;
B_1 = 1210.595;
C_1 = 229.664;
Gamma_inf_1 = 1.86;
MW_1 = 58.08; %In g/mol
sp_gr_1 = 0.7899; %Specific gravity of component 1
bp_1 = 56.2; %Boiling point of Component 1 in deg C

%for component 2
A_2 = 8.08097;
B_2 = 1582.271;
C_2 = 239.726;
Gamma_inf_2 = 1.78;
MW_2 = 32.04; %In g/mol
sp_gr_2 = 0.7914; %Specific gravity of component 2
bp_2 = 64.9; %Boiling point of Component 2 in deg C
%^^ ABC and Gamma in mmHg and deg C standards ^^

%%% Wilson Computations Given ^ %%%

%Set the amount of samples / precision of our predictions
x1 = [0:Precision:1];
x2 = 1 - x1;

%Antoine to find Pvap of sample in mmHg
Antoine = @(T,A,B,C)10^(A-(B/(T+C)));  

%Compute Pi_vap with a symbolic T
syms T
P1_vap = vpa(Antoine(T,A_1,B_1,C_1),6); 
P2_vap = vpa(Antoine(T,A_2,B_2,C_2),6); 

%Compute Molar Volume_i in m^3/mol
DPW = 0.99823; %Density of pure water in g/cm^3
Density_1 = sp_gr_1 * DPW; 
Density_2 = sp_gr_1 * DPW;
MV_1 = MW_1 / Density_1; %Molar Volume of component 1 in cm^3/mol
MV_2 = MW_2 / Density_2; %Molar Volume of component 2 in cm^3/mol

%Compute Wilson lambdas (Using Lamb at inf solution relationship)
syms lamb_12 lamb_21
eqn1 = -log(lamb_12)+1-lamb_12 ==log(Gamma_inf_1);
eqn2 = -log(lamb_21)+1-lamb_21 ==log(Gamma_inf_2);
Lamb_12 = vpa(solve(eqn1,lamb_12),6);
Lamb_21 = vpa(solve(eqn2,lamb_21),6);

%Wilson Gammas
Gamma_1 = exp(-log(x1+x2.*Lamb_12)+x2.*((Lamb_12./(x1+x2.*Lamb_12))-(Lamb_21./(x1.*Lamb_21+x2))));
Gamma_2 = exp(-log(x2+x1.*Lamb_21)-x1.*((Lamb_12./(x1+x2.*Lamb_12))-(Lamb_21./(x1.*Lamb_21+x2))));

%Calculate the Partial molar fraction with a symbolic T
Y_1 = vpa((x1.*Gamma_1.*P1_vap)./P_total,6);
Y_2 = vpa((x2.*Gamma_2.*P2_vap)./P_total,6);   

%Find squared error assuming ideal conditions (Y_1 + Y_2 == 1)
error = vpa((1-(Y_1+Y_2)).^2,6);
[~,c] = size(error);

%Evaluate to minimize error to ideal (error = 0) and compute temperature
%for each sample at these ideal conditions

Solution_Temperatures = zeros(1,c-2); %Preallocation for faster compute
		
parfor i = 2:c    %Queues parallel processing pools

   temp = error(i);
   temp = vpa(solve(temp,T),4);
   Solution_Temperatures(i) = temp; 

end

Y_1_soln = [];
parfor i = 2:length(Y_1)
   temp = matlabFunction(Y_1(i));
   temp = temp(Solution_Temperatures(i));
   Y_1_soln = [Y_1_soln, temp];
end

toc;

%Clean up the data because the calculations get wonky when the composition
%== 0 

x1 = x1(2:length(x1));
x2 = x2(1:length(x2)-1);
Solution_Temperatures = Solution_Temperatures(2:length(Solution_Temperatures));
Solution_Temperatures_Wilson = Solution_Temperatures;

%Plots:
figure
subplot(1,2,1)
grid on
hold on 
plot(Y_1_soln, Solution_Temperatures, 'b', 'LineWidth',2)
plot(x1, Solution_Temperatures, 'r', 'LineWidth',2)
title('T-x-y diagram')
plot(x1(79), Solution_Temperatures(79), 'redo', 'MarkerFaceColor', 'Yellow')
plot(exp_x1, exp_temp, 'sk', 'LineWidth', 2) 
plot(exp_y1, exp_temp, 'dk', 'LineWidth', 2) 
legend('Temp vs X','Temp vs Y','Azeotrope (55.3442^{\circ}C)','Experimental X Data','Experimental Y Data', 'Location', 'Best')
xlabel('Mole Fraction of Acetone')
ylabel('Temperature ^{\circ}C')
xlim([0,1])
ylim([55,64.2])

subplot(1,2,2)
hold on
grid on
plot(x1, Y_1_soln, 'k', 'LineWidth', 2)
plot(fliplr(x1), x2, 'k:', 'LineWidth', 2)
plot(x1(79), Y_1_soln(79), 'redo', 'MarkerFaceColor', 'Yellow')
legend('Vapor vs Liquid','45^{\circ} Reference','Azeotrope (.790)', 'Location', 'Best')
title('VLE Behavior of the Binary System')
xlabel('Acetone Liquid Mole Fraction')
ylabel('Acetone Vapor Mole Fraction')
xlim([0,1])
ylim([0,1])

annotation('textbox', [0 0.9 1 0.1], ...
    'String', 'Wilson:', ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')


%clearvars -except Solution_Temperatures_Wilson Solution_Temperatures_VL Solution_Temperatures_TCM