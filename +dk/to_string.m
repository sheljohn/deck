function s = to_string( v, fmt )
%
% s = to_string( v, fmt )
%
% Convert input to string representation.
% Second input is used to print numeric values.
%
% Inputs can be arrays (logical or numeric), in which case they should be 
% printed in a way that can be copy-pasted in the console to define a new 
% variable.
%
% If input is a cell, then to_string is called on each element and the function
% returns a cellstring.
%
% If you want more control over the string representation of arrays, cell arrays 
% and even tables, check out dk.util.array2string.
%
% JH

    if nargin < 2, fmt = '%g'; end

    % Input is a string, do nothing
    if ischar(v)
        s = v;
    
    % Input is numeric
    elseif isnumeric(v)
        switch numel(v)
            case 0
                s = '';
            case 1
                s = sprintf( fmt, v );
            otherwise
                s = dk.util.array2string( v, [], 'num', fmt );
        end
        
    % Input is logical
    elseif islogical(v)
        switch numel(v)
            case 0
                s = '';
            case 1
                s = {'false','true'};
                %s = {'0','1'};
                s = s{1+v};
            otherwise
                s = dk.util.array2string( double(v), [], 'num', '%d' );
        end
        
    % Input is a cell, apply to each element (returns a cell of strings)
    elseif iscell(v)
        s = dk.cellfun( @(x) dk.to_string(x,fmt), v, false );
        
    % Other unsupported cases
    else
        error( 'Dont know how to convert value to string.' );
    end

end
