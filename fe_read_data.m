%------------------------------------------------------------------------------|
% function read_data
% 
% This is a very simple parsing function that reads data from a text file for 
% use in a finite element code (only bar and beam elements)
%
% Author: Prof. Carlos Eduardo de Souza
% Federal University of Santa Maria, Brazil.
% Date: 16.04.18
%------------------------------------------------------------------------------| 
function [  ngl, plotfactor, ...
            n_nodes, m_nodes, ...
            n_elem , m_elem, ...
            n_cc   , m_cc, ...
            n_force, m_force, ...
            n_mat  , m_mat, ...
            n_sec  , m_sec] =fe_read_data(filename)

%

disp('|----------------------------|')
disp('| input data file reading    |')
disp('|----------------------------|')
% opens the file for reading ('r')
fid=fopen(filename,'r');

                          
% reading loop                         
while feof(fid)~=1    
   
   %reads a line
   line=fgetl(fid);
   
   
   % identifies the command
   command = [];
   
   if ~isempty(line) 
      
      if ~strfind(line,',')
         
         command = line   ;  
         
      else
   
         % split the line at commas
         linsplit = strread(line,'%s','delimiter',',');
         
         command  = char(linsplit(1));
      end
   end
   
   
   
   if command

      switch (command)

         case 'ngl'

            ngl = str2num(char(linsplit{2}));

         case 'plotfactor'

            plotfactor = str2num(char(linsplit{2}));
            
         case 'nodes'

            %disp('--------------------')
            %disp('reading nodes matrix')


            [n_nodes,m_nodes] = read_command_matrix(fid);


         case 'elements'

            %disp('--------------------')
            %disp('element matrix')


            [n_elem,m_elem] = read_command_matrix(fid);


         case 'materials'

            %disp('--------------------')
            %disp('reading materials')

            [n_mat,m_mat] = read_command_matrix(fid);

         case 'sections'

            %disp('--------------------')
            %disp('reading section properties')

            [n_sec,m_sec] = read_command_matrix(fid);

         case 'bconditions'

            %disp('--------------------')
            %disp('reading boundary conditions')

            [n_cc,m_cc] = read_command_matrix(fid);

         case 'forces'

            %disp('--------------------')
            %disp('reading nodal forces (and moments)')

            [n_force,m_force] = read_command_matrix(fid);

         otherwise


      end
   end
   %disp('--------------------')
         
   clear linsplit
   
end % end of while 1

fclose(fid);


disp('|----------------------------|')
disp('| end of input data reading  |')
disp('|----------------------------|')

end
% end of read_data function


%------------------------------------------------------------------------------|
% This function actually reads a block of data, and saves it into a matrix.
% The structure of each block dependens on the type of data being read.
function [n_lines,data_matrix] = read_command_matrix(fid)

   data_matrix = [];
   n_lines = 0;
   
   while 1    
      
      line=fgetl(fid);
      
      linsplit = strread(line,'%s','delimiter',',');
      
      if strcmp(char(linsplit(1)), 'end')
         break
      end
      
      n_lines = n_lines+1;
      
      nstr = length(linsplit);
     
     
      
      for istr=1:nstr
         data_matrix(n_lines,istr) = str2num(char(linsplit{istr}))  ;      
      end
   end         
   
   %size(data_matrix)
end
