%% Perform the numerical integration over body surface:

num = 501;
k = 0.1;

for i = 5:1:10
    
    filname = sprintf('Drag_data/vorticityl1_%d.mat',i);
    load(filname);
    int_cv = zeta_area1.*sin(theta_conrad);
    dtheta = theta_conrad(2)-theta_conrad(1);
    Cv(i) = (dtheta/2)*(-1/Re)*(int_cv(1)+int_cv(end)+2*sum(int_cv(2:end-1)));
    std = sqrt((2*k)/Re);
    vor_der = (zeta_area2-zeta_area1)/(std);
    
    
    
end