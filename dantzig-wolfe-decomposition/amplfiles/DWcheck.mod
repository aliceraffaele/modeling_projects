

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
          
var x{p in 1..m, 1..ni[p]} >= 0;   

param numberOfvertices{1..m} integer >= 0; 
param numberOfInitialVertices{p in 1..m}; #DATA
param initial_vertices{p in 1..m, 1..numberOfvertices[p], 1..ni[p]}; #DATA

minimize cost: sum{p in 1..m, i in 1..ni[p]} x[p,i]*c[p,i];


subject to coupledconstraint{j in 1..ki[0]}:
		sum{p in 1..m}(sum{i in 1..ni[p]} A[0,p,j,i]*x[p,i])  <= b[0,j];
		
subject to singleconstraints{p in 1..m,j in 1..ki[p]}:
		sum{i in 1..ni[p]} A[p,p,j,i]*x[p,i] <= b[p,j];