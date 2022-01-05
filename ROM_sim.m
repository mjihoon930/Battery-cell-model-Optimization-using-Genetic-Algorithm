function [t_r,x_r,y_r] = ROM_sim(u_map,x_0,theta,t_map,ROM_order)

for i  = 2:ROM_order
    C(1,1) = 1;
    C(1,i) = theta((i-1) + ((ROM_order*(ROM_order+1))/2) + ROM_order);

end

D = theta(end);

%ode45 
[t_r, x_r] = ode45(@(t,x) sys(u_map,t,x,theta,t_map,ROM_order), t_map, x_0);
x_r = x_r';

for i = 1:length(t_r)
    u_r(i,1) = interp1(t_map,u_map,t_r(i));
    y_r(i,1) = C*[x_r(1,i) ; x_r(2,i)]+D*u_r(i,1);
end