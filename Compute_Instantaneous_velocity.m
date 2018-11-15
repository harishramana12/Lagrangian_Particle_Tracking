%% Assumes radius of cylinder = 1;
num = 351;
xlim_l = 0;
xlim_h = 40;
nx = 400;


ylim_l = -5;
ylim_h = 15;
ny = 200;

x = linspace(xlim_l,xlim_h,nx);
y = linspace(ylim_l,ylim_h,ny);

load('Body_Info.mat');

[X,Y] = meshgrid(x,y);
figure(1);hold on;
surf(X,Y,ones(size(X)));
folder_name = 'Run_data';

%% Time stepping:

for i = 1:1:num
   
    fprintf('calculation of velocity field for time step: %d',i);
    fprintf('\n');
    fil_read = sprintf('%s/vorticitydata_%d.mat',folder_name,i);
    load(fil_read);
    
    Vx_source = zeros(size(X));
    Vy_source = zeros(size(X));
    Vx_vor = zeros(size(X));
    Vy_vor = zeros(size(X));
    
    s1 =1;
    
    
    for m = 1:1:size(X,1)
        
        for n = 1:1:size(X,2)
            
            if(sqrt((X(m,n)-x_c)^2+(Y(m,n)-y_c)^2)>1)
            
              xfp(s1) =X(m,n);
              yfp(s1) = Y(m,n);
                s1 = s1+1;
             
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
            end
        end
    end
    
%  figure(2);hold on;
%  plot(xfp,yfp,'k+');

    

 fil_read 
 save(fil_read,'Vx_source','Vy_source','-append');

    
end