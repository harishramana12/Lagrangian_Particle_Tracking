function [x_con,y_con,theta_conrad] =  compute_surface_normal_and_tangents(x_b,y_b,theta_b,x_c,y_c)

% control points:
x_con = zeros(size(x_b)-1);
y_con = zeros(size(y_b)-1);


for i=1:1:length(x_b)-1
    
    x_con(i) = (x_b(i)+x_b(i+1))/2;
    y_con(i) = (y_b(i)+y_b(i+1))/2;
    theta_conrad(i) = (theta_b(i)+theta_b(i+1))/2; 

end

figure(1);hold on;
plot(x_b,y_b,'--bx')
plot(x_con,y_con,'ro')

%% RHS Vector:

radius = zeros(1,length(x_b)-1);
ang_cos = zeros(1,length(x_b)-1);
ang_sin = zeros(1,length(x_b)-1);
Normal_x = zeros(1,length(x_b)-1);
Normal_y = zeros(1,length(x_b)-1);
tangent_x = zeros(1,length(x_b)-1);
tangent_y = zeros(1,length(x_b)-1);
rhs_vec = zeros(1,length(x_b)-1);

for i=1:1:length(x_b)-1
    
    radius(i) = sqrt((x_b(i+1)-x_b(i))^2 + (y_b(i+1)-y_b(i))^2);
    ang_cos(i) = (x_b(i+1)-x_b(i))/radius(i);
    ang_sin(i) = (y_b(i+1)-y_b(i))/radius(i);
    
    Normal_x(i) =  -ang_sin(i);
    Normal_y(i) = ang_cos(i);
    tangent_x(i) = ang_cos(i);
    tangent_y(i) = ang_sin(i);

    
end

figure(2);hold on;
plot(x_b,y_b,'--b+');
quiver(x_con,y_con,Normal_x,Normal_y,0.1);
quiver(x_con,y_con,tangent_x,tangent_y,0.1);

delete Body_Info.mat;
save('Body_Info.mat','Normal_x','Normal_y','tangent_x','tangent_y','x_con','y_con','x_b','y_b','x_c','y_c','theta_conrad','theta_b');

end