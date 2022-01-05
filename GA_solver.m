function [theta,fval,exitflag,output,population,score]=GA_solver(filename_1,filename_2,dt,t_final,w,nvars,PopulationSize_Data,CrossoverFraction_Data,MaxGenerations_Data,MaxStallGenerations_Data,FunctionTolerance_Data,InitialPopulation_Data,ROM_order)

%RUN GA
options = optimoptions('ga');
options = optimoptions(options,'PopulationSize',PopulationSize_Data);
options = optimoptions(options,'CrossoverFraction',CrossoverFraction_Data);
options = optimoptions(options,'MaxGenerations',MaxGenerations_Data);
options = optimoptions(options,'MaxStallGenerations',MaxStallGenerations_Data);
options = optimoptions(options,'FunctionTolerance',FunctionTolerance_Data);
options = optimoptions(options,'InitialPopulationMatrix',InitialPopulation_Data);
options = optimoptions(options,'CrossoverFcn',@crossoversinglepoint);
options = optimoptions(options,'MutationFcn',@mutationadaptfeasible);
options = optimoptions(options,'Display','iter');
options = optimoptions(options,'PlotFcn',{ @gaplotbestf }); 
options = optimoptions(options,'UseParallel',true);
options = optimoptions(options,'UseVectorized',false);

poolobj = gcp('nocreate');  % find current pool
delete(poolobj)             % shut down the parallel pool
poolobj = parpool(36);

%load true data
true_data_1 = load(filename_1);
true_data1.ans = true_data_1.ans;
true_data1.C_avg_n = true_data_1.C_avg_n;

true_data_2 = load(filename_2);
true_data2.ans = true_data_2.ans;
true_data2.C_avg_n = true_data_2.C_avg_n;

lb = -1*ones(1,nvars);%-0.5*ones(1,nvars);
ub = 1*ones(1,nvars);%0.02*ones(1,nvars);

[theta,fval,exitflag,output,population,score] = ga(@(theta) cal_J(true_data1,true_data2,dt,t_final,theta,w,ROM_order),nvars,[],[],[],[],lb,ub,[],options);