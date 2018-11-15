function [Vn,Vt] = compute_surface_normal_veloctiy(u_inf,v_inf,time_index,sig)

%% Normal and tangential velocity due to free-stream
load('Body_Info.mat');
Vnfs = (u_inf)*(Normal_x) + (v_inf)*(Normal_y);
Vtfs = (u_inf)*(tangent_x) + (v_inf)*(tangent_y);

%% Normal and tangential velocity due to vortices:
fil_to_read = sprintf('Run_data/vorticitydata_%d.mat',time_index);
load(fil_to_read);

uxv = zeros(size(x_con));
uyv = zeros(size(x_con));

% Outer loop over all control points:
for i = 1:1:length(x_con)
    
    for j = 1:1:length(gammav)
    
        rij(i,j) = sqrt((x_con(i)-xcon_n(j))^2+(y_con(i)-ycon_n(j))^2);
    
        if(rij(i,j) > sig)
            uxv(i) = uxv(i)+(1/(2*pi))*gammav(j)*(1/(rij(i,j)*rij(i,j)))*(-(ycon_n(j)-y_con(i)));
            uyv(i) = uyv(i)-(1/(2*pi))*gammav(j)*(1/(rij(i,j)*rij(i,j)))*(-(xcon_n(j)-x_con(i)));
        end
        
        if(rij(i,j) <= sig)
            
         uxv(i) = uxv(i)+(1/(2*pi))*gammav(j)*(1/(rij(i,j)*sig))*(-(ycon_n(j)-y_con(i)));
         uyv(i) = uyv(i)-(1/(2*pi))*gammav(j)*(1/(rij(i,j)*sig))*(-(xcon_n(j)-x_con(i)));    
        end  
        
    
    end

end

Vnv =  (uxv).*(Normal_x) + (uyv).*(Normal_y);
Vtv =   (uxv).*(tangent_x) + (uyv).*(tangent_y);

Vn = Vnv + Vnfs;
Vt =  Vtv +  Vtfs;

end