function fe_write_results_bar(u_nodal,f_e,stress)



disp('--------------------------');
disp('- results :');

%-----------------------------------


n_n = length(u_nodal(:,1));


disp('nodal displacements ');

fprintf(' n   ');
fprintf(' u_1       ');
fprintf(' u_2       ');
fprintf('\n');
for i=1:n_n

   % escreve na tela
   fprintf(' %2d',i); 
   %--- no 1
   fprintf(' %+8.3e',u_nodal(i,1));
   fprintf(' %+8.3e',u_nodal(i,2));   
   fprintf('\n');
end

%-----------------------------------


n_e = length(f_e(:,1));


disp('element forces and stresses');

fprintf(' e  ');
fprintf('  f_x1    ');
fprintf('|');
fprintf('  f_x2    ');
fprintf('|');
fprintf('  s_NT1   ');
fprintf('|');
fprintf('  s_NT2   ');
fprintf('|');
fprintf(' S_fc    ');
fprintf('\n');
for ie=1:n_e

   % escreve na tela
   fprintf(' %2d',ie); 
   %--- no 1
   fprintf(' %+10.3f',f_e(ie,1));
   fprintf(' %+10.3f',f_e(ie,2));  
   fprintf(' %+8.3e',stress(ie,1));
   fprintf(' %+8.3e',stress(ie,2));
   fprintf(' %+8.2f',stress(ie,3));
   fprintf('\n');
end

%-----------------------------------

fprintf('\n');
fprintf('\n');
end