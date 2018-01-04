function c = rdb2( n, signed )
%
% c = rdb2( n=64, signed=false )
%

    if nargin < 1, n = 64; end
    if nargin < 2, signed = false; end
    
    method = 'linear';
    w = [0.5,0.2,0.5,0.9];
    r = dk.clr.palette(hsv2rgb([0,.9,.8]),w);
    b = dk.clr.palette(hsv2rgb([.6,.9,.8]),w);
    g = 0.1*[1 1 1];
    t = [0,.15,.45,.65,1];
    
    if signed
        if mod(n,2)==0, n=n+1; end
        C = [ ...
            -t(5), b.lightest; ...
            -t(4), b.lighter; ...
            -t(3), b.normal; ...
            -t(2), b.darkest; ...
            -t(1), g; ...
            +t(2), r.darkest; ...
            +t(3), r.normal; ...
            +t(4), r.lighter; ...
            +t(5), r.lightest ...
        ];
        x = linspace(-1,1,n)';
    else
        C = [ ...
            -t(1), g; ...
            +t(2), r.darkest; ...
            +t(3), r.normal; ...
            +t(4), r.lighter; ...
            +t(5), r.lightest  ...
        ];
        x = linspace(0,1,n)';
    end

    c = interp1( C(:,1), C(:,2:4), x, method );

end
