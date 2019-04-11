function plota_ef(index,nodes, elementos,factor)




figure(1);

if index,
   colorline = '-ro';'-mo',...
                
else
   colorline = '-bs';
   clf;
end


n_nos = length(nodes( :,1)) ;
n_e   = length(elementos( :,1)) ;


xmax = -1e3;
xmin = 1e3;

ymax = -1e3;
ymin = 1e3;

for ie=1:n_e

    % comprimento do elemento
    ind1 = elementos(ie,3);
    ind2 = elementos(ie,4);  
    
    xno1 = nodes(ind1,2);
    yno1 = nodes(ind1,3);
    
    xno2 = nodes(ind2,2) ;
    yno2 = nodes(ind2,3);
    
    
    
    plot([ xno1 xno2 ], [yno1  yno2], colorline,'MarkerFaceColor','k','MarkerSize',5);    

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

if index,
   title_string = sprintf('Displacements factor: %2.2e x',factor)
   title(title_string)
end