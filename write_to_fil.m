function write_to_fil(t,gammav,xcon_n,ycon_n,lambda_write)

mkdir Run_data;
fil_name = sprintf('Run_data/vorticitydata_%d.mat',t);
save(fil_name,'gammav','xcon_n','ycon_n','lambda_write');


end