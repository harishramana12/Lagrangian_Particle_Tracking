%% 
file_no = 301;

filname = sprintf('%s/%s_%d.mat','Run_data','vorticitydata',file_no);
load(filname);

for i = 1:1:length(gammav)
    
   if(gammav(i)>0)
       figure(1);hold on;
       plot(xcon_n(i),ycon_n(i),'rx');
   else
       figure(1);hold on;
       plot(xcon_n(i),ycon_n(i),'b+');
   end
    
end