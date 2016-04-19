clc;close all;clear all;

% Reproduce the Figure 4 (left), i.e., test geometry with n = 1000 and varying m  
% "A Geometric Analysis of Phase Retrieval",
% by Ju Sun, Qing Qu, and John Wright.
% 
% This function depends on the manopt_cur package. 
% 
% 
% Code written by Ju Sun, Qing Qu and John Wright. 
% Last updated: Mon 18 Apr 2016 08:28:37 PM EDT 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('manopt_cur')); 

n = 1000;
ratio = [4:1:10];
x = zeros(n,1); x(1) = 1;
Times = 25;
Prob = zeros(length(ratio),2);
tol = 1e-3;
for k = 1:length(ratio)
    m = ratio(k)*n;
    A = 1/sqrt(2)*randn(n,m)+1i*1/sqrt(2)*randn(n,m);
    y_sq = abs(A'*x).^2;
    for T = 1:Times         
        
        z_init = 1/sqrt(2)*randn(n,1)+1i*1/sqrt(2)*randn(n,1);
        manifold = euclideancomplexfactory(n,1);
        problem.M = manifold;
        problem.cost = @(z) 1/(2*m)*sum( (y_sq - abs(A'*z).^2).^2  );
        problem.egrad = @(z) 1/m*A*( ( abs(A'*z ).^2 - y_sq ) .*(A'*z) ); 
        problem.ehess = @(z,u) 1/m*A*((2*abs(A'*z).^2-y_sq).*(A'*u)) + 1/m*A* ((A'*z).^2 .*(A.'*conj(u)));
		
		% TRM parameters
		% maxiter can be tuned to be much smaller values when measurements are enough  
        options.maxiter = 500; 
		options.tolgradnorm = 1e-6; 

        [z,zcost,info,options] = trustregions(problem,z_init, options);

        err = norm(x - exp(-1i*angle(x'*z))*z)/norm(x);

        fprintf('TRM: Ratio = %d, Times = %d, error = %f\n',ratio(k),T,err);

        if(err<tol)
            Prob(k,1) = Prob(k,1)+1;
        end
        
    end
end

figure;
plot(ratio,Prob(:,1)/Times,'b', 'LineWidth', 2);
grid on; 
