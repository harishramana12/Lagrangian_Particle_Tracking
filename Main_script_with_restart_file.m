%% LTEM simulation script with specified restart file:
clc;
clear;
close all;

filno = 251;
% rtfil = sprintf('%s/%s_%d.mat','Run_\data','vorticitydata',fileno);
% load(rtfil);

%%

T = 25; % total time
t = 0.1;
time_index = 171;
tstart = (time_index-1)*t + t;
Re = 100;
q_inf = 1;
alpha = 0;
u_inf = (q_inf)*(cos(alpha));
v_inf = (q_inf)*(sin(alpha));

load('Body_Info.mat');

%%
cyl_rad = (x_b-x_c).^2+(y_b-y_c).^2;
cyl_rad = sqrt(cyl_rad(1));
num = length(x_con);
h = (2*pi)/num;
sig = (h)/(2*pi);

%%
%% Recursive procedure for further  time steps:

for time = tstart:t:T

    fprintf('Vorticity field computation for step number: %d',time_index+1);
    time_index
    [Vn,Vt] = compute_surface_normal_veloctiy(u_inf,v_inf,time_index,sig);
    [lambda,Vts] = compute_body_source_strength(x_b,y_b,x_con,y_con,theta_conrad,Vn,Vt);
    gammav_bound = compute_boundary_vorticity(x_b,y_b,x_con,y_con,Vts,theta_conrad);
    
    %% Apped the newly produced wall vorticity to the existing set:
    fil_to_append = sprintf('Run_data/vorticitydata_%d.mat',time_index);
    load(fil_to_append);
    gammav  = [gammav gammav_bound];
    xcon_n = [xcon_n x_con];
    ycon_n = [ycon_n y_con];
    [xcon_n,ycon_n,gammav] = convect_vortices(xcon_n,ycon_n,x_c,y_c,cyl_rad,gammav,t,sig,Re,u_inf,v_inf);
    time_index = time_index+1; 
    write_to_fil(time_index,gammav,xcon_n,ycon_n);
    
end