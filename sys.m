function [x_dot] = sys(u,t,x,theta,t_map,ROM_order)

theta_last = 0;
    for i  = 1:ROM_order
        for j = 1:ROM_order
            if i<=j
                A(i,j) = theta(1,theta_last+1);
                theta_last = theta_last + 1;
            else
                A(i,j) = 0;
            end
            B(j,1) = theta(j+(ROM_order*(ROM_order+1))/2);
        end
    end

I = interp1(t_map,u,t);

%Reduced order model state-space
[x_dot] = A*[x(1) ; x(2)] + B*I;

x_dot = [x_dot(1) ; x_dot(2)];

end