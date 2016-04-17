function [z,f,err] = grad_descent(y_sq,A,z_0,x,mu,eta,tol)
	[n,m] = size(A);
	z = z_0;
	Max_Iter = 1e5;
	iter = 1;
	err = inf;
	fn_val = @(z) 1/2 * mean((abs(A'*z).^2 - y_sq).^2); 


	while(err > tol) 
		 yz = A'*z;
		 z_old = z;
		 f_old =  fn_val(z);
		 grad =  1/m* A*( ( abs(yz).^2-y_sq ) .* yz ); 
		 norm_grad = norm(grad)^2;
		 
		 %back-tracking line-search
		 alpha = 1; 
		 while( f_old<= fn_val(z-alpha*grad) + alpha * eta*norm_grad )
		     alpha = alpha*0.5;
		 end
		 
		 z = z -  alpha * grad;
		 f = fn_val(z); 
		 iter_diff = norm(z_old - z);
		 func_diff = abs(f - f_old);
		 err = norm(x - exp(-1i*angle(x'*z))*z)/norm(x);
		 if norm(z-z_old)<=1e-8 || iter>Max_Iter
		     break;
		 end
		 fprintf('Iter = %d, Iter_Diff = %f, Func_Diff = %f, Err = %f \n',iter,iter_diff,func_diff,err);
		 iter = iter + 1;       
	end

end

