
# DANTZIG-WOLFE DECOMPOSITION
# Bounded Problem

param N; #total number of variables     DATA
param K; #total number of constraints   DATA
param m; #number of systems             DATA 

param ni{1..m}; #subdivision of variables, nj[j] = dimension;               DATA
param ki{0..m}; #subdivision of constraints in sets of ki[i] constraints;   DATA

#only two checks if parameters are set up in the right way
check: sum{j in 1..m} ni[j] = N;
check: sum{i in 0..m} ki[i] = K; 



param b{i in 0..m,1..ki[i]}; #all constraint values, subdivised          DATA
param c{i in 1..m,1..ni[i]}; #all cost values, subdivised                DATA

set index = {0..m,1..m}; #index (i,j) of matrices A[i,j] 
set iindex within index; #specify what matrices   DATA

param A{(i,j) in iindex, 1..ki[i], 1..ni[j]};#Matrices A[i,j] DATA

#cost of subproblem m
param cost_subproblem{1..m,1..ni[m]};  #        RUN
#to calculate it, you need the following:
#dual variable y (of coupling constraints)
param dual_cost_y{1..ki[0]}; #                  RUN
#dual variabls z (of simple constraints)
param dual_cost_z{1..m}; #                      RUN

var x{p in 1..m, 1..ni[p]} >= 0;   


# THE m SUBPROBLEMS:

minimize Reduced_Cost{p in 1..m}:
   sum{i in 1..ni[p]} cost_subproblem[p,i]*x[p,i];


subject to Set_constraint{p in 1..m,j in 1..ki[p]}:
	sum{i in 1..ni[p]} A[p,p,j,i]*x[p,i] <= b[p,j];



# RESTRICTED MASTER PROBLEM 




#number of vertices of set Q(i) (subproblem i), 
param numberOfvertices{1..m} integer >= 0;  #                     RUN
#changes during execution, 


#vertices values to corresponding lambdas, 
#introduced with the RUN file
param vertices{p in 1..m, 1..numberOfvertices[p], 1..ni[p]}; #    RUN

param numberOfInitialVertices{p in 1..m}; #DATA
param initial_vertices{p in 1..m, 1..numberOfvertices[p], 1..ni[p]}; #DATA





#c_i*v_ik
param restricted_master_cost{p in 1..m, 1..numberOfvertices[p]};# RUN

param restricted_couple_cost{p in 1..m, 1..numberOfvertices[p], 1..ki[0]};#RUN


var lambda{p in 1..m, 1..numberOfvertices[p]} >= 0;


minimize Total_Restricted_Cost:
   sum{p in 1..m, k in 1..numberOfvertices[p]} 
      restricted_master_cost[p,k]*lambda[p,k];

subject to Restricted_Coupled {j in 1..ki[0]}:
	sum{p in 1..m, k in  1..numberOfvertices[p]} 
		restricted_couple_cost[p,k,j]*lambda[p,k] = b[0,j];
      

subject to Convex{p in 1..m}: 
	sum{k in 1..numberOfvertices[p]} lambda[p,k] = 1;


#to check if the initial values are admissible



#
#var y{1..m,1..ki[0]}; 

#nothing to maximize, only to check if B^-1*b>=0
#
#maximize nothing: 0;

#
#subject to couple{i in 1..ki[0]}:
#	sum{p in 1..m, j in 1..numberOfvertices[p]}
#		restricted_couple_cost[p,j,i]*y[p,j] = b[0,i];
		
#subject to convex2{p in 1..m}:
#	sum{i in 1..numberOfvertices[p]} y[p,i] = 1;


