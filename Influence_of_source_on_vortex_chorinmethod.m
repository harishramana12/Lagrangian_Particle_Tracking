function [ux_source,uy_source] = Influence_of_source_on_vortex_chorinmethod(xcon_v,ycon_v,gammav,lambda)

ux_source = zeros(size(xcon_v));
uy_source = zeros(size(ycon_v));

load('Body_Info.mat');


for i = 1:1:length(xcon_v)

   for j = 1:1:length(x_con)
      
       
       panel_len = sqrt(((x_b(j+1)-x_b(j))^2)+((y_b(j+1)-y_b(j))^2));
       dist = sqrt(((xcon_v(i)-x_con(j))^2)+((ycon_v(i)-y_con(j))^2));
       
        if(dist<(panel_len/2))
         
         %fprintf('collocated Source and vortex');
         %fprintf('\n');
         u_normalvel = lambda(j)/2;
         ux_source(i) = ux_source(i)+(u_normalvel)*(Normal_x(j));
         uy_source(i) = uy_source(i)+(u_normalvel)*(Normal_y(j));
    
        else
        
         %fprintf('Un-collocated Source and vortex');
         %fprintf('\n');
         len_t = sqrt(((x_b(j+1)-x_b(j))^2)+((y_b(j+1)-y_b(j))^2));
         cphij = (x_b(j+1)-x_b(j))/(len_t);
         sphij = (y_b(j+1)-y_b(j))/(len_t);
         at = -(xcon_v(i)-x_b(j))*cphij -(ycon_v(i)-y_b(j))*sphij;
         bt = (xcon_v(i)-x_b(j))^2 + (ycon_v(i)-y_b(j))^2;
         ct = -cphij;
         cty = -sphij;
         dt = (xcon_v(i)-x_b(j));
         dty = (ycon_v(i)-y_b(j));
         et = (xcon_v(i)-x_b(j))*sphij -(ycon_v(i)-y_b(j))*cphij;
         
         I1t = (ct/2)*log((len_t*len_t+(2*at*len_t)+bt)/(bt));
         I1ty = (cty/2)*log((len_t*len_t+(2*at*len_t)+bt)/(bt));
         I2t = ((dt-(at*ct))/(et))*(atan((len_t+at)/et));
         I2ty = ((dty-(at*cty))/(et))*(atan((len_t+at)/et));
         I3t = ((dt-(at*ct))/(et))*(atan(at/et));
         I3ty = ((dty-(at*cty))/(et))*(atan(at/et));
         
         It = I1t+I2t-I3t;
         It = It*((lambda(j))/(2*pi));
           
         Ity = I1ty+I2ty-I3ty;
         Ity = Ity*((lambda(j))/(2*pi));
         
         ux_source(i) = ux_source(i) + It;
         uy_source(i) = uy_source(i) + Ity;
            
     end

     
       
   end

end

end
