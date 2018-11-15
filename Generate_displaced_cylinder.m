%%
clc;clear;close all;
x_c = 4;
y_c = 3;
r = 1.0;
N_panel = 50;
deltheta = (2*pi)/(N_panel-1);
theta= (pi+(deltheta/2)):-(deltheta):(-pi+(deltheta/2));
theta_deg = theta*(180/pi);
%theta(N_panel+1) = theta(1);

x = (x_c)+(r*cos(theta));
y = (y_c)+(r*sin(theta));

figure(1);hold on;
plot(x,y,'--bx');

%%
fil = 'circular_cylinder.txt';
fid = fopen(fil,'w');

for i = 1:1:length(x)
    
    fprintf(fid,'%d %d %d %d %d',x(i),y(i),theta(i),x_c,y_c);
    fprintf(fid,'\n');
    
end
