clc;close all;clear all;

% Reproduce the plot in Fig. 1 of the paper
% "A Geometric Analysis of Phase Retrieval",
% by Ju Sun, Qing Qu, and John Wright.
% 
% This function calls grad_descent.m 
% 
% Code written by Ju Sun, Qing Qu and John Wright. 
% Last updated: Sun 17 Apr 2016 02:51:45 PM EDT  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(1,'twister'); 

n = 100; % data dimension
m = round(5*n*log(n)) ; % number of sample points
times = 100; % simulation times
A = 1/sqrt(2)*(randn(n,m)+1i*randn(n,m)); % sensing matrix
x = zeros(n,1); x(1) = 1; %optimal solution (up to global phase difference)
y_sq = abs(A'*x).^2; % generate the measurement
tol = 1e-5; % stopping criteria for gradient-descent algorithm
eta = 0.8;     % line search parameter
Err = zeros(times,1);
F_Val = zeros(times,1);
for t = 1:times
    fprintf('#simulation = %d\n',t);
    z_0 = randn(n,1) + 1i*randn(n,1);  % random initialization
    [z,f_val,err] = grad_descent(y_sq,A,z_0,x,eta,tol); % optimize the problem via wirtinger gradient descent
    Err(t) = err;
    F_Val(t) = f_val;
end

figure;
str1 = '$$  -\log_{10}(||\mathbf z_\star - \mathbf x \mathrm{e}^{\mathrm{i} \phi(\mathbf z)}||)$$';
str2 = 'Iterate Distance $$||\mathbf z_\star - \mathbf x \mathrm{e}^{\mathrm{i}\phi(\mathbf z)}||$$';
str3 = '$$  -\log_{10}(f(\bf z_\star))$$';
str4 = 'Function Value $$f(\mathbf z_\star)$$'; 

subplot(1,2,1); 
stem([1:times],-log10(Err));
xlabel('Simulation Number');
ylabel(str1,'Interpreter','latex');
title(str2,'Interpreter','latex');
subplot(1,2,2); 
stem([1:times],-log10(F_Val));
xlabel('Simulation Number');
ylabel(str3,'Interpreter','latex'); 
title(str4, 'Interpreter','latex');
