clc;close all;clear all;

% Reproduce the function landscape in Fig. 2 and Fig. 5 of the paper
% "A Geometric Analysis of Phase Retrieval",
% by Ju Sun, Qing Qu, and John Wright.
% 
% See comments on choice to produce different landscapes 
%
% Code written by Ju Sun, Qing Qu and John Wright. 
% Last updated: Sun 17 Apr 2016 02:51:45 PM EDT  
%
% Part of the coded diffraction model codes adapted from: 
% http://www-bcf.usc.edu/~soltanol/matlab/WF_1D_CDP.m
% maintained by Professor Mahdi Soltanolkotabi. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%plotting the function landscape of phase retrieval
rng(1,'twister'); % fix the seed for random number generation

n = 2;
m = 200; %sample numbers
x1 = [-1.5:0.0075:1.5];
x2 = [-1.5:0.0075:1.5];
x = [1;0]; %ground truth

choice = 2;   

% 1 = Gaussian measurement, quadractic loss, Fig 2
% 2 = Coded Diffraction, quadractic loss, Fig 5 

switch choice 
	case 1 
		A = randn(n,m);
		A = @(z) A' * z; 
	case 2 
		Mask = randsrc(n,m,[1i -1i 1 -1]);
		temp = rand(size(Mask));
		Mask = Mask.* ( (temp <= 0.2)*sqrt(3) + (temp > 0.2)/sqrt(2) );
		A = @(z)  reshape(fft(conj(Mask) .* repmat(z,[1 m])), [], 1);

end 

y_sq = abs(A(x)).^2;
f = zeros(length(x1),length(x2));

for i = 1:length(x1)
    for j = 1:length(x2)
    	
        z = [x1(i);x2(j)];
       
        f(i,j) = 1/2 * mean( (y_sq- abs(A(z)).^2).^2 );
    end
end


figure;
subplot(1,2,1);
mesh(x2,x1,f);
grid on; 

subplot(1,2,2);
imagesc(x1,x2,f'); 
