
%------------------------------------------------------------------------------| 
% The present file is an academic code for beam analysis (2D)
% 
% Author: Prof. Carlos Eduardo de Souza
% Federal University of Santa Maria, Brazil.

% DEM-1091 - Introduction to the Finite Element Method
% Date: 170511
%
% Use: fe_bar(filename)
%
%------------------------------------------------------------------------------| 

function fe_bar(inputfile)


clc
   
if nargin < 1, 
   disp('      ');
   disp('WARNING! ');
   disp('Please inform the name of the input file.');   
   disp('For example: ');   
   disp('   >>fe_beam_class06 (''model01.dat'')');
   disp('      ');
   
   return;
end


% reading data from a file
[  ngl    , plotfactor,...
   n_nodes, m_nodes, ...
   n_elem , m_elem, ...
   n_cc   , m_cc, ...
   n_force, m_force, ...
   n_mat  , m_mat, ...
   n_sec  , m_sec] =fe_read_data(inputfile);

   
%--------------------

% aqui, o numero de nos eh igual ao numero de m_elem mais 1.

% pre-processing
%
% loop on elements

% global stiffness matrix
K_global = zeros(n_nodes*ngl, n_nodes*ngl );
% u_global = zeros(n_nodes*ngl, 1);
f_global = zeros(n_nodes*ngl, 1);

%
for ie=1:n_elem;
  
   fprintf(' computing stiffness matrix of element %2d\n',ie);
    
   %element nodal indexes
    
   ind1 = m_elem(ie,3);
   ind2 = m_elem(ie,4);
    
    
   xno1 = m_nodes(ind1,2);
   xno2 = m_nodes(ind2,2);
   dx   = xno2 - xno1;
   
   yno1 = m_nodes(ind1,3);
   yno2 = m_nodes(ind2,3);
   dy   = yno2 - yno1;
    
   % element length
   L_e = (dx^2+ dy^2)^.5;

   %--- element properties
   ind_prop = m_elem(ie,2);
   A_e = m_sec(ind_prop,3);
   ind_mat = m_sec(ind_prop,2);
   E_e = m_mat(ind_mat,2);
    
   % assembly of finite element stiffness matrix
   K_bar = K_elem_bar(A_e,L_e,E_e);
       
   %----
  
   % compute the rotation matrix
   T = rotation_matrix(dx,dy);
    
   K_e_rot = T' * K_bar *  T;
    
   % global stiffness matrix superposition
    
   K11 = K_e_rot(1:2,1:2);
   K12 = K_e_rot(1:2,3:4);
   K21 = K_e_rot(3:4,1:2);
   K22 = K_e_rot(3:4,3:4);
    
   % NOTA: esse 3 pode ser trocado por 'ngl', pois  exatamente 
   % o numero de graus de liberdade.
   i1_i   = (ind1-1)*ngl + 1;  
   i1_f   = (ind1-1)*ngl + 2;  
   i2_i   = (ind2-1)*ngl + 1; 
   i2_f   = (ind2-1)*ngl + 2;
   % 1 1 
   K_global(i1_i:i1_f,i1_i:i1_f) =  K_global(i1_i:i1_f,i1_i:i1_f) + K11;
    
   % 1 2 
   K_global(i1_i:i1_f,i2_i:i2_f) =  K_global(i1_i:i1_f,i2_i:i2_f) + K12;

   % 2 1
   K_global(i2_i:i2_f,i1_i:i1_f) =  K_global(i2_i:i2_f,i1_i:i1_f) + K21;
    
   % 2 2 
   K_global(i2_i:i2_f,i2_i:i2_f) =  K_global(i2_i:i2_f,i2_i:i2_f) + K22;
   
    
end

% aplying boundary conditions
disp('Aply boundary conditions')

for i=1:n_cc,
   % 
   gdrl = (m_cc(i,1)-1)*ngl + m_cc(i,2);
   
   K_global(gdrl, :    ) = 0.;
   K_global(   :, gdrl ) = 0.;
   K_global(gdrl, gdrl ) = 1.;
end

% criar o vetor de forca global
disp('Aply external forces')

for i=1:n_force,
   % 
   gdrl = (m_force(i,1)-1)*ngl + m_force(i,2);
   
   f_global(gdrl, 1 ) =f_global(gdrl, 1 )+ m_force(i,3);
end

%f_global
%K_global
%-------------------------
% solucao

disp('linear system solution')
%u_global = linsolve(K_global,f_global);
u_global = K_global\f_global

%  cond(K_global)

%-------------------------
plot_bar_new(m_nodes(:,2:3), m_elem(:,3:4), u_global,plotfactor)

f1=figure(1);

analise = strrep (inputfile, '.', '_')
saida = ([ analise '_svd'] );
set(f1,'PaperPositionMode','auto');
print(f1,'-dpng',[ saida '.png'],'-r100');
%----
% repeat u_nodal
%-------------------------
% pos-processamento
u_nodal  = zeros(n_nodes,2);
m_nodes2 = zeros(n_nodes,2);


      
for in=1:n_nodes

    gdl_x = (in-1)*ngl + 1;  % dir x
    gdl_y = (in-1)*ngl + 2;  % dir y
    
    u_nodal(in,1) = u_global(gdl_x);
    u_nodal(in,2) = u_global(gdl_y);
    
    m_nodes2(in,1) = m_nodes(in,1) + plotfactor*u_global(gdl_x);
    m_nodes2(in,2) = m_nodes(in,2) + plotfactor*u_global(gdl_y);
end

%-------------------------
% loop on elements
% here, there are 2 options:
% 1 - use the previously saved comuted data
% 2 - recompute everything
% 


f_e = zeros(n_elem, 2);
stress = zeros(n_elem, 3);

for ie=1:n_elem,
  
      
   %indice dos nos do elemento
   ind1 = m_elem(ie,3);
   ind2 = m_elem(ie,4);
    
    
   xno1 = m_nodes(ind1,2);
   xno2 = m_nodes(ind2,2);
   dx   = xno2 - xno1;
   
   yno1 = m_nodes(ind1,3);
   yno2 = m_nodes(ind2,3);
   dy   = yno2 - yno1;
    
   % comprimento do elemento
   L_e = (dx^2+ dy^2)^.5;

   %--- propriedades do elemento
   ind_prop = m_elem(ie,2);
   A_e = m_sec(ind_prop,3);
   I_e = m_sec(ind_prop,4);
   c_e = m_sec(ind_prop,5);
   
   ind_mat = m_sec(ind_prop,2);
   E_e = m_mat(ind_mat,2);
   % montagem da matriz do elemento
        
   K_bar = K_elem_bar(A_e,L_e,E_e);
    
   % compute the rotation matrix
   T = rotation_matrix(dx,dy);
   
   % u_elemento
   u_elemento = zeros(2*ngl,1);
   
   i1_i   = (ind1-1)*ngl + 1;  
   i1_f   = (ind1-1)*ngl + 2;  
   i2_i   = (ind2-1)*ngl + 1; 
   i2_f   = (ind2-1)*ngl + 2;
   u_elemento(1:2) = u_global(i1_i:i1_f);
   u_elemento(3:4) = u_global(i2_i:i2_f);
   
   % desgira
    
   u_e_local = T * u_elemento;
    
   % forcas
   f_e(ie,1:2) = K_bar * u_e_local;
    
   %f_e(ie,2) = -f_e(ie,1:2); 
   %tensoes
   % no1
   sig_N  =  - f_e(ie,1) / A_e;
    
    
   stress(ie,1)  = sig_N;
   
   % novo comprimento:
   
   nxno1 = m_nodes(ind1,2)+u_elemento(1);
   nxno2 = m_nodes(ind2,2)+u_elemento(3);
   ndx   = nxno2 - nxno1;
   
   nyno1 = m_nodes(ind1,3)+u_elemento(2);
   nyno2 = m_nodes(ind2,3)+u_elemento(4);
   ndy   = nyno2 - nyno1;
   % comprimento do elemento
   nL_e = (ndx^2+ ndy^2)^.5;
  
   def  =   (nL_e - L_e)/L_e;
   stress(ie,2)  =  def * E_e;   
   stress(ie,3)  =   m_mat(ind_mat,5) / abs(stress(ie,2) );   
    
end


%  
fe_write_results_bar(u_nodal,f_e, stress );

end


%esperado:
% A = b*h;
% Iner = b * h ^3 / 12;
% F = 1e2;
% len = 1;
% M = F * len;
% sig = M * .5 * h / Iner
% flecha = F * len^3/(3 * 200E9 * Iner )
%Iner = b * h ^3 / 12;
%Fv = q_d;
%len = 1;
%M = Fv * len^2 / 2
%sig = M * .5 * h / Iner
%flecha = Fv * len^3/(8 * 200E9 * Iner )


function K_bar = K_elem_bar(A_e,L_e,E_e)

    
   K_bar      =  (E_e * A_e / L_e) * [ 1 -1
                       -1  1];
end


function T = rotation_matrix(dx,dy)

  %----
   % rotacao
   if(dx~= 0) 
      theta = atan(dy/dx)   ;
   else
      theta = sign(dy)*pi/2.;
   end
      
   cs = cos(theta);
   ss = sin(theta);
    
   T = [   cs  ss    0   0   
            0   0    cs  ss ];
    

end

