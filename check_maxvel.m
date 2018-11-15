num = 351;

for i = 1:1:num
   
    
    fil_read = sprintf('%s/vorticitydata_%d.mat',folder_name,i);
    load(fil_read);

    V_total = (Vx_source).^2 + (Vy_source).^2;
    maxvel(i) = max(max(V_total))
    
end