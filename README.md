# Summary
This set of Matlab codes reproduce the figures and experimental results published in our paper: 
> **A Geometric Analysis of Phase Retrieval**.   
> Ju Sun, Qing Qu, John Wright. http://arxiv.org/abs/1602.06664. 

+ Folder **grad_heuristic**: to reproduce the results in Figure 1. Run *test_gd.m* to start. 
+ Folder **landscape**: to reproduce Figure 2 and Figure 5. 
+ Folder **simulation**: to reproduce the plot in Figure 4, as well as the comparison of TRM with gradient descent on an Columbia campus image (columbiacampus.jpg). 
	- Run *test_real.m* to start the real image experiments; try to tune the TRM parameters by setting the options before calling the TRM (the gradient descent algorithm converges very slowly -- we set a high error tolerance to allow early stopping; the reference parameter setting for TRM is very conservative)
	- Run *test_fix_ins_ratio.m* to start to geometry test as described in Fig. 4. 

Note that the TRM implementation is based on the [Manopt package](http://www.manopt.org/), with changes to the conjugate gradient routine. The changes are contained in the file: 

> manopt_cur/manopt/solvers/trustregions/tCG_CUR.m 

Compared to *tCG.m* which is originally called by *trustregions.m*, the modified version explicitly checks for presence of negative curvature(s) when the gradient is small; if present, the negative curvature direction is used as the initial search direction for the (truncated) conjugate gradient algorithm. With this modification, [ridable saddle points](http://arxiv.org/abs/1510.06096) can be properly skipped. 

Codes written by Ju Sun, Qing Qu, and John Wright. For questions or bug reports please send email to Ju Sun, sunjunus@gmail.com 

Thanks to bug reporters: 
