function plot_bar_new(m_nodes,m_elem,u_global,plotfactor)


ngl = 2;
n_nodes = size(m_nodes,1);
n_elem  = size(m_elem,1);

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




f1=figure(1);
clf;

xmax = -1e3;
xmin = 1e3;

ymax = -1e3;
ymin = 1e3;

for ie=1:n_elem

    % comprimento do elemento
    ind1 = m_elem(ie,1);
    ind2 = m_elem(ie,2);  
    
    
    
    xno1 = m_nodes(ind1,1);
    yno1 = m_nodes(ind1,2);
    
    xno2 = m_nodes(ind2,1) ;
    yno2 = m_nodes(ind2,2);
    
    xnno1 = m_nodes2(ind1,1);
    ynno1 = m_nodes2(ind1,2);
    
    xnno2 = m_nodes2(ind2,1) ;
    ynno2 = m_nodes2(ind2,2);
    
    
    
    plot([ xno1 xno2 ], [yno1  yno2], '-bo','MarkerFaceColor','k','MarkerSize',5);    

    
    plot([ xnno1 xnno2 ], [ynno1  ynno2], '-rs','MarkerFaceColor','k','MarkerSize',5);    

   if(xmax < xno1) xmax = xno1; end;
   if(xmax < xno2) xmax = xno2; end;
   if(xmin > xno1) xmin = xno1; end
   if(xmin > xno2) xmin = xno2; end
   
   if(ymax < yno1) ymax = yno1;end  
   if(ymax < yno2) ymax = yno2;end
   if(ymin > yno1) ymin = yno1;end
   if(ymin > yno2) ymin = yno2;end
    hold on;
   
end

axis([xmin-.1 xmax+.1 ymin-.1 ymax+.1]);

   title_string = sprintf('Displacements factor: %2.2e x',plotfactor)
   title(title_string)
