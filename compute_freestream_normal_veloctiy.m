function [Vn,Vt] = compute_freestream_normal_veloctiy(x_con,y_con,u_inf,v_inf)

load('Body_Info.mat');
Vn = (u_inf)*(Normal_x) + (v_inf)*(Normal_y);
Vt = (u_inf)*(tangent_x) + (v_inf)*(tangent_y);

figure(3);hold on;
plot(x_b,y_b,'--b+');
quiver(x_con,y_con,zeros(size(Vn)),Vn,0.9);
quiver(x_con,y_con,Vt,zeros(size(Vt)),0.9);


end