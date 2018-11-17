%%
clc;
clear;close all;
num_image = 351;

for i = 1:1:num_image
    
   figure(1); 

   fil = sprintf('%s/vorticitydata_%d.mat','Run_data',i);
   load(fil);
   plot(xcon_n,ycon_n,'bo')
   xlim([0 20]);
   ylim([-4 8]);
   pause(0.1);
   
end
