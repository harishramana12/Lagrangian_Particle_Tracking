%% Radius of cylinder is assumed to be 1.0 by default
clc;clear;close all;
Re = 10000;
k = 0.1;
numfiles = 501;

std  = sqrt((2*k)/Re);
load('Body_Info.mat');

figure(1);hold on;
plot(x_con,y_con,'r');
xinner_c = x_con+(std*cos(theta_conrad));
yinner_c = y_con+(std*sin(theta_conrad));
xouter_c = xinner_c+(std*cos(theta_conrad));
youter_c = yinner_c+(std*sin(theta_conrad));
plot(xinner_c,yinner_c,'k-');
plot(xouter_c,youter_c,'b:');



for i = 1:1:(length(theta_b)-1)
    
    A_inner(i) = ((theta_b(i+1)-theta_b(i))/(2*pi))*pi*((1+std)^2 - 1);
    A_outer(i) = ((theta_b(i+1)-theta_b(i))/(2*pi))*pi*((1+2*std)^2 - (1+std)^2);
    
    
    
end

A_inner = abs(A_inner);
A_outer = abs(A_outer);

%% Find zeta(qj) and its derivative at each timestep for all sector elements:

for i = 1:1:501
    
   fprintf('drag calculation for time step no:%d',i); 
   fprintf('\n');
   fil = sprintf('Run_data_50s/%s_%d.mat','vorticitydata',i);
   load(fil);
   
   
   
   %% values of r and theta for all elements:
   r = sqrt((xcon_n-x_c).^2 + (ycon_n-y_c).^2);
   theta = atan2((ycon_n-y_c),(xcon_n-x_c));
   
   zeta_area1 = zeros(size(x_con));
   zeta_area2 = zeros(size(x_con));
   %%
   % Note: the greater and less than sign will change depending on the way
   % the body co-ordinates are written.
   for j = 1:1:(length(theta_b)-1)
   
      for k = 1:1:length(xcon_n)
       
         if(((r(k)>=1) && (r(k)<= (1+std))) && ((theta(k)<=theta_b(j)) && (theta(k)>=theta_b(j+1))))
             fprintf('vortex lying in 1st circle');
             fprintf('\n');
             zeta_area1(j)  = zeta_area1(j)+gammav(k);
             figure(1);hold on;
             plot(xcon_n(k),ycon_n(k),'b+');
         end
         
         if(((r(k)>=(1+std)) && (r(k)<= (1+2*std))) && ((theta(k)<=theta_b(j)) && (theta(k)>=theta_b(j+1))))
             fprintf('vortex lying in 2nd circle');
             fprintf('\n');
             zeta_area2(j)  = zeta_area2(j)+gammav(k);
             plot(xcon_n(k),ycon_n(k),'rx');
         end

          
      end
       
     
      
   end
    
   
   zeta_area1 = (zeta_area1)./(A_inner);
   zeta_area2 = (zeta_area2)./(A_outer);
   
   mkdir Drag_data
   filnamwrite = sprintf('Drag_data/%s_%d.mat','vorticityl1',i);
   save(filnamwrite,'zeta_area1','zeta_area2','theta_conrad','Re');
   
   
end