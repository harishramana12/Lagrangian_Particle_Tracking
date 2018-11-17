%%
clc;clear;close all;


num = 351;
load('Body_Info.mat','u_inf','v_inf','x_c','y_c','cyl_rad');
gridfil = sprintf('%s/%s/%s.mat','Run_data','Query_data','Grid_info');
load(gridfil)
%xq = X(1,:);
xq = [30];

for i = 1:1:length(xq)
    Vxsum  = zeros(1,size(Y,1));
    Vysum  = zeros(1,size(Y,1));
    Vxsum = Vxsum';
    Vysum = Vysum';
   for j = 1:1:num
      
       
       fil = sprintf('%s/%s/%s_%d.mat','Run_data','Query_data','velocitydata',j)
       load(fil);
       [~,idx] = min(abs(X(1,:)-xq(i)));
       x_plot = X(:,idx);
       y_plot = Y(:,idx);
       Vx_s = Vx_source(:,idx);
       Vy_s = Vy_source(:,idx);
       Vx_v = Vx_vor(:,idx);
       Vy_v = Vy_vor(:,idx);
       Vx = Vx_s+Vx_v;
       Vy = Vy_s+Vy_v;

       Vxsum = Vxsum+Vx+u_inf;
       Vysum = Vysum+Vy+v_inf;
%        figure(1);hold on;
%        plot(Vx,y_plot,'--r');
       
   end
    
    Vxavg = (Vxsum)/num;
    Vyavg = (Vysum)/num;
    Vavg = sqrt((Vxavg.^2)+(Vyavg.^2));
    figure(1);hold on;
    plot(Vxavg,y_plot,'--b');
    figure(2);hold on;
    plot(Vyavg,y_plot,'-r');
    figure(3);
    plot(Vavg,y_plot,':k')
    
end
