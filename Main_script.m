%% Main script for flow simulation over circular cylinder:
clc;
clear;
close all;
delete Run_data/*.mat;
%%

T = 70; % total time
t = 0.2;
time_index = 1;
Re = 10000;
q_inf = 1;
alpha = 0;
u_inf = (q_inf)*(cos(alpha));
v_inf = (q_inf)*(sin(alpha));
%% Read in body co-ordinates: 
% since this method is grid free- we need to read in only the body
% co-ordinates:

load('circular_cylinder.txt');
x_b = circular_cylinder(:,1);
y_b = circular_cylinder(:,2);
theta_b = circular_cylinder(:,3);
x_c = circular_cylinder(:,4);
y_c = circular_cylinder(:,5);

x_c = x_c(1);
y_c = y_c(1);
cyl_rad = (x_b-x_c).^2+(y_b-y_c).^2;
cyl_rad = sqrt(cyl_rad(1));

[x_con,y_con,theta_conrad] = compute_surface_normal_and_tangents(x_b,y_b,theta_b,x_c,y_c);

num = length(x_con);
h = (2*pi)/num;
sig = (h)/(2*pi);
%% Initialise vorticity dist at body surface:

%% at t=0:

[Vn,Vt] = compute_freestream_normal_veloctiy(x_con,y_con,u_inf,v_inf);
[lambda,Vts] = compute_body_source_strength(x_b,y_b,x_con,y_con,theta_conrad,Vn,Vt);
gammav = compute_boundary_vorticity(x_b,y_b,x_con,y_con,Vts,theta_conrad);
[xcon_n,ycon_n,gammav] = convect_vortices(x_con,y_con,x_c,y_c,cyl_rad,gammav,t,sig,Re,u_inf,v_inf,lambda);
write_to_fil(time_index,gammav,xcon_n,ycon_n,lambda);

%% Recursive procedure for further  time steps:

for time = t:t:T

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
    [xcon_n,ycon_n,gammav] = convect_vortices(xcon_n,ycon_n,x_c,y_c,cyl_rad,gammav,t,sig,Re,u_inf,v_inf,lambda);
    time_index = time_index+1; 
    write_to_fil(time_index,gammav,xcon_n,ycon_n,lambda);
    
end