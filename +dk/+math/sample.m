function z = sample( x, y, n )
%
% z = sample( x, y, n )
%
% Sample n realisations of 1-d distribution y defined at points x.
%
% Example:
%
% x = linspace(-1,2,300);
% y = humps(x); % use Matlab's humps function
% y = y - min(y);
% y = y / trapz(x,y); % make it a "density"
% z = ksdensity(dk.math.sample( x, y, 1000 ),x);
% 
% plot( x, y, 'k-', x, z, 'r--' );
%
% JH

    x = [x(:); x(1)];
    y = cumsum(y(:) - min(y));
    y = [0; y] / y(end);
    
    u = rand(n,1);
    k = dk.math.upper_bound( y, u );
    k = k(:);
    
    w = (u - y(k-1)) ./ max( y(k)-y(k-1), eps );
    z = (1-w) .* x(k-1) + w .* x(k);
    
end