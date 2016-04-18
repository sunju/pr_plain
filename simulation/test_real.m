
clc;clear all;close all;

% Reproduce the result in real image exp around Fig. 4 of 
% "A Geometric Analysis of Phase Retrieval",
% by Ju Sun, Qing Qu, and John Wright.
% 
% This function calls grad_descent.m for line-search gradient descent 
% This function depends on the manopt_cur package. 
% 
% 
% Code written by Ju Sun, Qing Qu and John Wright. 
% Last updated: Mon 18 Apr 2016 11:41:20 AM EDT   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('manopt_cur')); 

% Below X is n1 x n2 x 3; i.e. we have three n1 x n2 images, one for each of the 3 color channels
namestr = 'columbiacampus' ;
stanstr = 'jpg'      ;
X       = mat2gray(imread([namestr,'.',stanstr])) ;
n1      = size(X,1)                               ;
n2      = size(X,2)                               ;
X = rgb2gray(X);
x = X(:);

n = n1*n2;
m = round(5*n*log(n));

Times = 10;
Time = zeros(Times,2);
Err = zeros(Times,2);
for T = 1:Times
    A = randn(n,m);
    y_sq = abs(A'*x).^2;
    z_init = 1/sqrt(2)*randn(n,1)+1i*1/sqrt(2)*randn(n,1);
    
    manifold = euclideancomplexfactory(n,1);
    problem.M = manifold;
    problem.cost = @(z) 1/(2*m)*sum( (y_sq - abs(A'*z).^2).^2  );
    problem.egrad = @(z) 1/m*A*( ( abs(A'*z ).^2 - y_sq ) .*(A'*z) );
    problem.ehess = @(z,u) 1/m*A*((2*abs(A'*z).^2 - y_sq).*(A'*u)) + 1/m*A* ((A'*z).^2 .*(A.'*conj(u)));

    tic;
    
    % tuning these parameters may affect the running time 
    options.tolgradnorm = 1e-6; 
    options.maxiter = 1e3; 
    
    [z,zcost,info,options] = trustregions(problem,z_init,options);
    time = toc
    Time(T,1) = time;
    err = norm(x - exp(-1i*angle(x'*z))*z)/norm(x)
    Err(T,1) = err;
    
    tic;
    [z,f_val,err] = grad_descent(y_sq,A,z_init,x, 0.8, 1e-6);
    time = toc
    Time(T,2) = time;
    err = norm(x - exp(-1i*angle(x'*z))*z)/norm(x)
    Err(T,2) = err;
    
end

Time_TRM = mean(Time(:,1))
Err_TRM = mean(Err(:,1))

Time_Grad = mean(Time(:,2))
Err_Grad = mean(Err(:,2))

