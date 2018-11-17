%%
clc;
clear;close all;

% Time steps:
num = 351;
folder_name = 'Run_data';


xmin = 0;
xmax = 50;
numx = 50;
x = linspace(xmin,xmax,numx);
%x = [-10 0 x]; 

ymin = -15;
ymax = 20;
numy = 400;
y = linspace(ymin,ymax,numy);

[X,Y] = meshgrid(x,y);

dirname = sprintf('%s/%s','Run_data','Query_data');
mkdir Run_data/Query_data ;
filname = sprintf('%s/%s',dirname,'Grid_info.mat');
save(filname,'X','Y');

load('Body_Info.mat');
numdelh = length(x_con);
h = (2*pi)/numdelh;
sig = (h)/(2*pi);
%%

for i = 1:1:num
   
    

    fprintf('calculation of velocity field for time step: %d',i);
    fprintf('\n');
    fil_read = sprintf('%s/vorticitydata_%d.mat',folder_name,i);
    load(fil_read);
    fil_write = sprintf('%s/%s_%d.mat',dirname,'velocitydata',i);
    
    Vx_source = zeros(size(X));
    Vy_source = zeros(size(X));
    Vx_vor = zeros(size(X));
    Vy_vor = zeros(size(X));
    
    
    
    for m = 1:1:size(X,1)
        
        for n = 1:1:size(X,2)

              
              
              %% Source contribution:  
  
              for M = 1:1:length(lambda_write)
              
                len_t = sqrt(((x_b(M+1)-x_b(M))^2)+((y_b(M+1)-y_b(M))^2));
                cphij = (x_b(M+1)-x_b(M))/(len_t);
                sphij = (y_b(M+1)-y_b(M))/(len_t);
                at = -(X(m,n)-x_b(M))*cphij -(Y(m,n)-y_b(M))*sphij;
                bt = (X(m,n)-x_b(M))^2 + (Y(m,n)-y_b(M))^2;
                ct = -cphij;
                cty = -sphij;
                dt = (X(m,n)-x_b(M));
                dty = (Y(m,n)-y_b(M));
                et = (X(m,n)-x_b(M))*sphij -(Y(m,n)-y_b(M))*cphij;
                
                
                I1t = (ct/2)*log((len_t*len_t+(2*at*len_t)+bt)/(bt));
                I1ty = (cty/2)*log((len_t*len_t+(2*at*len_t)+bt)/(bt));
                I2t = ((dt-(at*ct))/(et))*(atan((len_t+at)/et));
                I2ty = ((dty-(at*cty))/(et))*(atan((len_t+at)/et));
                I3t = ((dt-(at*ct))/(et))*(atan(at/et));
                I3ty = ((dty-(at*cty))/(et))*(atan(at/et));
                
                It = I1t+I2t-I3t;
                It = It*((lambda_write(M))/(2*pi));
           
                Ity = I1ty+I2ty-I3ty;
                Ity = Ity*((lambda_write(M))/(2*pi));
                
                Vx_source(m,n) = Vx_source(m,n)+It;
                Vy_source(m,n) = Vy_source(m,n)+Ity;
                
                  
              end
              
              
              %% Vorticity contribution
              
              for N = 1:1:length(gammav)
              
                  rij(m,n) = sqrt((X(m,n)-xcon_n(N))^2+(Y(m,n)-ycon_n(N))^2);
                  
                  if(rij(m,n) > sig)
                    Vx_vor(m,n) = Vx_vor(m,n)+((1/(2*pi))*gammav(N)*(1/(rij(m,n)*rij(m,n)))*(Y(m,n)-ycon_n(N)));
                    Vy_vor(m,n) = Vy_vor(m,n)-((1/(2*pi))*gammav(N)*(1/(rij(m,n)*rij(m,n)))*(X(m,n)-xcon_n(N)));
                  end
        
                  if(rij(m,n) <= sig)
            
                    Vx_vor(m,n) = Vx_vor(m,n)+((1/(2*pi))*gammav(N)*(1/(rij(m,n)*sig))*(Y(m,n)-ycon_n(N)));
                    Vy_vor(m,n) = Vy_vor(m,n)-((1/(2*pi))*gammav(N)*(1/(rij(m,n)*sig))*(X(m,n)-xcon_n(N)));    
                  end  
                  
              end

        end
    end
    


 fil_write
 save(fil_write,'Vx_source','Vy_source','Vx_vor','Vy_vor');

    
end
