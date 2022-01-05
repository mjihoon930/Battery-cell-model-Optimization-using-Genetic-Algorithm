function J = cal_J(true_data_1,true_data_2,dt,t_final,theta,w,ROM_order)

%set evaluation time
t_eval = 0:dt:t_final;
idx = t_final*10 + 2;

%Input current vs t for the true model_1
t_true_1 = true_data_1.ans.I.time(1:idx);
I_true_1 = true_data_1.ans.I.signals.values(1:idx);
u_1      = I_true_1;

%Input current vs t for the true model_2
t_true_2 = true_data_2.ans.I.time(1:idx);
I_true_2 = true_data_2.ans.I.signals.values(1:idx);
u_2     = I_true_2;

%Output equations for true model_1
y_true_1 = true_data_1.ans.csn.signals.values(1:idx);

%Output equations for true model_2
y_true_2 = true_data_2.ans.csn.signals.values(1:idx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%simulate the reduced-order model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initial condition from the true model
for i = 1:ROM_order
    
x_0_1(1,1) = true_data_1.C_avg_n;
x_0_1(1,i) = 0;

x_0_2(1,1) = true_data_2.C_avg_n;
x_0_2(1,i) = 0;

end

%ROM_1
[t_r_1,x_r_1,y_r_1] = ROM_sim(u_1,x_0_1,theta,t_true_1,ROM_order);

%ROM_2
[t_r_2,x_r_2,y_r_2] = ROM_sim(u_2,x_0_2,theta,t_true_2,ROM_order);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate the objective function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y_true_eval_1 = interp1(t_true_1,y_true_1,t_eval);
y_r_eval_1    = interp1(t_r_1,y_r_1,t_eval);

y_true_eval_2 = interp1(t_true_2,y_true_2,t_eval);
y_r_eval_2    = interp1(t_r_2,y_r_2,t_eval);

%objective function (J)
J = w*norm(y_true_eval_1 - y_r_eval_1) + w*norm(y_true_eval_2 - y_r_eval_2);






