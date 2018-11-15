function [xcon_n,ycon_n,gammav] = convect_vortices(x_con,y_con,x_c,y_c,cyl_rad,gammav,t,sig,Re,u_inf,v_inf,lambda)

ux = zeros(1,length(x_con));
uy = zeros(1,length(x_con));

for i = 1:1:length(x_con)
    
    for j = 1:1:length(x_con)
    
        if(i ~= j)
        
        rij(i,j) = sqrt((x_con(i)-x_con(j))^2+(y_con(i)-y_con(j))^2);
        
        if(rij(i,j) > sig)
            ux(i) = ux(i)+((1/(2*pi))*gammav(j)*(1/(rij(i,j)*rij(i,j)))*(y_con(i)-y_con(j)));
            uy(i) = uy(i)-((1/(2*pi))*gammav(j)*(1/(rij(i,j)*rij(i,j)))*(x_con(i)-x_con(j)));
        end
        
        if(rij(i,j) <= sig)
            
         ux(i) = ux(i)+((1/(2*pi))*gammav(j)*(1/(rij(i,j)*sig))*(y_con(i)-y_con(j)));
         uy(i) = uy(i)-((1/(2*pi))*gammav(j)*(1/(rij(i,j)*sig))*(x_con(i)-x_con(j)));    
        end  
        end
    end
    
end

[ux_source,uy_source] = Influence_of_source_on_vortex(x_con,y_con,gammav,lambda);

ux = ux+u_inf+ux_source;
uy = uy+v_inf+uy_source;

%% Update positions of vortices:

fprintf('\n');
fprintf('The value of t is:%f',t);
fprintf('\n');
xcon_n = x_con + (ux*t);
ycon_n = y_con + (uy*t);

stddev  = sqrt(2*t/Re);
meanval = 0;
eta = stddev*randn(1,2) + [meanval,meanval];
eta(1);
eta(2);

xcon_n = xcon_n + eta(1);
ycon_n = ycon_n+eta(2);

figure(6);hold on;
plot(xcon_n,ycon_n,'rx');


for i = 1:1:length(xcon_n)
    
    r_vorticity = sqrt((xcon_n(i) - x_c)^2 +(ycon_n(i) - y_c)^2);
    
    if(r_vorticity < cyl_rad )
    fprintf('Eliminating vorticity as it crosses body');
    xcon_n(i) = nan;
    ycon_n(i) = nan;
    gammav(i) = nan;

    end

end

xcon_n(isnan(xcon_n)) = [];
ycon_n(isnan(ycon_n)) = [];
gammav(isnan(gammav)) = [];

figure(7);
plot(xcon_n,ycon_n,'b+')
end
