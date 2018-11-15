function [lambda,Vts] = compute_body_source_strength(x_b,y_b,x_con,y_con,theta_conrad,Vn,Vt)

rhs_vec = -Vn';

%% LHS Matrix:

%% Preallocation phase:

radi = zeros(1,length(x_con));
cos_phii = zeros(size(radi));
sin_phii = zeros(size(radi));

radj = zeros(length(x_con),length(x_b)-1);
cos_phij = zeros(size(radj));
sin_phij = zeros(size(radj));
a = zeros(size(radj));
b = zeros(size(radj));
c = zeros(size(radj));
d = zeros(size(radj));
Sj = zeros(size(radj));
e = zeros(size(radj));
I1_ij = zeros(size(radj));
I2_ij = zeros(size(radj));
I3_ij = zeros(size(radj));
I_ij = zeros(size(radj));

cvind= zeros(size(radj));
dvind = zeros(size(radj));
I1ind_ij = zeros(size(radj));
I2ind_ij = zeros(size(radj));
I3ind_ij = zeros(size(radj));
Iind_ij = zeros(size(radj));


%% Compute phase:

for i  = 1:1:length(x_con)
    
    radi(i) = sqrt(((x_b(i+1)-x_b(i))^2)+((y_b(i+1)-y_b(i))^2));
    cos_phii(i) = (x_b(i+1)-x_b(i))/(radi(i));
    sin_phii(i) = (y_b(i+1)-y_b(i))/(radi(i));
    
    for j = 1:1:length(x_b)-1

        if(i ~= j)
        
      radj(i,j) = sqrt(((x_b(j+1)-x_b(j))^2)+((y_b(j+1)-y_b(j))^2));
      cos_phij(i,j) = (x_b(j+1)-x_b(j))/(radj(i,j));
      sin_phij(i,j) = (y_b(j+1)-y_b(j))/(radj(i,j));  
        
      a(i,j) = (-(x_con(i)-x_b(j))*cos_phij(i,j))-((y_con(i)-y_b(j))*sin_phij(i,j));
      b(i,j) = (x_con(i)-x_b(j))^2 + (y_con(i)-y_b(j))^2 ;
      c(i,j) = (sin_phii(i)*cos_phij(i,j))-(cos_phii(i)*sin_phij(i,j));
          
      d(i,j) = ((y_con(i)-y_b(j))*cos_phii(i))-((x_con(i)-x_b(j))*sin_phii(i)) ;
      Sj(i,j) = radj(i,j);
      e(i,j)  = ((x_con(i)-x_b(j))*(sin_phij(i,j)))-((y_con(i)-y_b(j))*(cos_phij(i,j)));
      
      I1_ij(i,j) = (c(i,j)/2)*log((Sj(i,j)*Sj(i,j)+(2*a(i,j)*Sj(i,j))+b(i,j))/(b(i,j)));
      I2_ij(i,j) = ((d(i,j)-(a(i,j)*c(i,j)))/(e(i,j)))*(atan((Sj(i,j)+a(i,j))/e(i,j)));
      I3_ij(i,j) = ((d(i,j)-(a(i,j)*c(i,j)))/(e(i,j)))*(atan(a(i,j)/e(i,j)));
      
      I_ij(i,j) = I1_ij(i,j)+I2_ij(i,j)-I3_ij(i,j);
      I_ij(i,j) = I_ij(i,j)*(1/(2*pi));
        
        else
            
            I_ij(i,j) = (1/2);
            
        end
      
        end
    
        
    
end

lambda = I_ij\rhs_vec;
theta_con = (theta_conrad)*(180/pi);

figure(4);hold on;
plot(theta_con,lambda,':rx');

%% Induced velocity at panels:


for i = 1:1:length(x_con)
    
    for j = 1:1:length(x_con)
    
        if(i~=j)
        
           cvind(i,j) = -(sin_phii(i)*sin_phij(i,j)) - (cos_phii(i)*cos_phij(i,j)) ;
           dvind(i,j) = ((y_con(i)-y_b(j))*sin_phii(i))+((x_con(i)-x_b(j))*cos_phii(i)) ;
           
           I1ind_ij(i,j) = (cvind(i,j)/2)*log((Sj(i,j)*Sj(i,j)+(2*a(i,j)*Sj(i,j))+b(i,j))/(b(i,j)));
           I2ind_ij(i,j) = ((dvind(i,j)-(a(i,j)*cvind(i,j)))/(e(i,j)))*(atan((Sj(i,j)+a(i,j))/e(i,j)));
           I3ind_ij(i,j) = ((dvind(i,j)-(a(i,j)*cvind(i,j)))/(e(i,j)))*(atan(a(i,j)/e(i,j)));
      
           Iind_ij(i,j) = I1ind_ij(i,j)+I2ind_ij(i,j)-I3ind_ij(i,j);
           Iind_ij(i,j) = Iind_ij(i,j)*((lambda(j))/(2*pi));
            
        end
        
        if(i == j)
        
            Iind_ij(i,j) = Vt(i);
            
        end
    end
end

Vts = sum(Iind_ij,2);
figure(5);hold on;
plot(theta_con,Vts,'--b+');

end