%%
clc;clear;close all;
xq = [40];
num = 351;

gridfil = sprintf('%s/%s/%s.mat','Run_data','Query_data','Grid_info');
load(gridfil)
for i = 1:1:length(xq)
    
   for j = 200:1:205
       
       
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
       figure(1);hold on;
       plot(Vx,y_plot,'--r');
       
   end
    
    
end