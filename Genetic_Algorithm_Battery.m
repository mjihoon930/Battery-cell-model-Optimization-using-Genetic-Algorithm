clear all
close all
clc

%weight setting
w = 1;

%time setting
dt = 0.1;
t_final = 2000;

%filename:
filename_1 = 'FDM_N_50_(2).mat';
filename_2 = 'FDM_N_50_fs.mat';

ROM_order = 2;
nvars = ROM_order*(ROM_order+1)/2 + ROM_order + ROM_order-1 + 1;
PopulationSize_Data = nvars*20;
CrossoverFraction_Data = 0.8;
MaxGenerations_Data = 2000;
MaxStallGenerations_Data = 200;
FunctionTolerance_Data  = 1e-10;

pd = load('ROM_data_p.mat');
InitialPopulation_Data = pd.population; %[-0.277997224781770,-0.0209951606568305,-0.357782685347223,-0.0870247140971465,-0.320163123861005,-0.273257246688678,-0.212974176651196];

[theta,fval,exitflag,output,population,scores] = GA_solver(filename_1,filename_2,dt,t_final,w,nvars,PopulationSize_Data,CrossoverFraction_Data,MaxGenerations_Data,MaxStallGenerations_Data,FunctionTolerance_Data,InitialPopulation_Data,ROM_order);


%Comparison result
t_eval = 0:dt:t_final;

true_data_1 = load(filename_1);
true_data_2 = load(filename_2);

for i = 1:ROM_order

x_0_1(1,1) = true_data_1.C_avg_n;
x_0_1(1,i) = 0;

x_0_2(1,1) = true_data_2.C_avg_n;
x_0_2(1,i) = 0;

end

%model 1
t_true_1 = true_data_1.ans.I.time;
I_true_1 = true_data_1.ans.I.signals.values;
u_1      = I_true_1;
y_true_1 = true_data_1.ans.csn.signals.values;

[t_r_1,x_r_1,y_r_1] = ROM_sim(u_1,x_0_1,theta,t_true_1,ROM_order);

y_true_eval_1 = interp1(t_true_1,y_true_1,t_eval);
y_r_eval_1    = interp1(t_r_1,y_r_1,t_eval);

%model 2
t_true_2 = true_data_2.ans.I.time;
I_true_2 = true_data_2.ans.I.signals.values;
u_2      = I_true_2;
y_true_2 = true_data_2.ans.csn.signals.values;

[t_r_2,x_r_2,y_r_2] = ROM_sim(u_2,x_0_2,theta,t_true_2,ROM_order);

y_true_eval_2 = interp1(t_true_2,y_true_2,t_eval);
y_r_eval_2    = interp1(t_r_2,y_r_2,t_eval);

figure(1)
plot(t_eval , y_r_eval_1)
hold on
plot(t_eval , y_true_eval_1)
hold off

figure(2)
plot(t_eval , y_r_eval_2)
hold on
plot(t_eval , y_true_eval_2)
hold off

save ROM_data
saveFileName = ['ROM_data','.mat'];
save(saveFileName)

%y = 0.05.*sin(0.3*t) + sin(0.003*t); case (1)

%y = exp(-0.0055*t).*5.*sin(0.02*pi*t); case (3)
