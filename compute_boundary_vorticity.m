function gammav = compute_boundary_vorticity(x_b,y_b,x_con,y_con,Vts,theta_conrad)

for i = 1:1:length(x_b)-1
    
    radius(i) = sqrt((x_b(i+1)-x_b(i))^2 + (y_b(i+1)-y_b(i))^2 );
    gammav(i) = (Vts(i))*radius(i);
    
end

theta_con = (theta_conrad)*(180/pi);

figure(6);hold on;
plot(theta_con,gammav,'--b+');


end