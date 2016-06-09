function [h,color_scale] = image( img, varargin )

    % parse inputs
    opt = dk.obj.kwArgs( varargin );
    
    color_scale    = opt.get('color_scale',    [] );
    adapt_scale    = opt.get('adapt_scale',    isempty(color_scale) );
    
    title_str      = opt.get('title',          '' );
    label_x        = opt.get('xlabel',         '' );
    label_y        = opt.get('ylabel',         '' );
    label_c        = opt.get('clabel',         '' );
    remove_ticks   = opt.get('remove_ticks',   isempty(label_x) && isempty(label_y) );
    
    scale_func     = opt.get('scale_func',     @(x) max(abs(dk.math.truncate(x(:),2))) );
    cmap_name      = opt.get('cmap',          'bgr' );
    subpos         = opt.get('subplot',       {} );
    
    maxwidth       = opt.get('maxwidth',      50000 );
    maxheight      = opt.get('maxheight',     50000 );
    maxsize        = [ maxheight, maxwidth ];
    
    cmap_unsigned  = eval(sprintf('dk.ui.cmap.%s(128,false)', cmap_name));
    cmap_signed    = eval(sprintf('dk.ui.cmap.%s(256,true)',  cmap_name));
    
    
    % quick aliases
    if opt.get('positive',false)
        color_scale = [0,1];
        adapt_scale = true;
    end
    if opt.get('negative',false)
        color_scale = [-1,0];
        adapt_scale = true;
    end
    if opt.get('signed',false)
        color_scale = [-1,1];
        adapt_scale = true;
    end
    
    % subplot if asked
    if ~isempty(subpos)
        subplot(subpos{:});
    end
    
    % plot image
    if iscell(img)
        
        % x and y axes are given
        x = img{1}; nx = numel(x);
        y = img{2}; ny = numel(y);
        
        % transpose image if needed
        img = img{3};
        assert( nx*ny == numel(img), 'Size mismatch between x-y axis and image.' );
        if size(img,1) ~= ny && size(img,2) == ny
            img = img';
        end
        
        % resize image if needed
        img = check_size(img,maxsize);
        
        % if image was reized, adapt x and y
        if size(img,1) ~= ny, y = interp1( linspace(0,1,ny), y, linspace(0,1,size(img,1)) ); end
        if size(img,2) ~= nx, x = interp1( linspace(0,1,nx), x, linspace(0,1,size(img,2)) ); end
        
        % draw image
        imagesc(x,y,img); set(gca,'YDir','normal');
        
        % round values for display
        %x = dk.math.round( x(get(gca,'xtick')), 1 );
        %y = dk.math.round( y(get(gca,'ytick')), 1 );
        
        %set( gca, 'xticklabel', arrayfun(@num2str,x,'UniformOutput',false) );
        %set( gca, 'yticklabel', arrayfun(@num2str,y,'UniformOutput',false) );
        
    else
        h = imagesc(check_size( img, maxsize )); 
    end
    
    % remove ticks
    if remove_ticks
        set(gca,'xtick',[],'ytick',[]);
    else
        xlabel(label_x);
        ylabel(label_y);
    end
    
    % set color-scale
    if isempty(color_scale)
    [p1,p99] = dk.util.deal_vector(prctile( img(:), [1 99] ));
    if (p1 < -eps) && (p99 > eps)
        color_scale = [-1 1];
    elseif p1 < -eps
        color_scale   = [-1 0];
        cmap_unsigned = flipud(cmap_unsigned); % reverse colormap
    else
        color_scale = [0 1];
    end
    end
    color_scale = sort(color_scale);
    
    % set colormap
    if abs(sum(color_scale)) / sum(abs(color_scale)) < 1e-3
        colormap( gca, cmap_signed );
    else
        colormap( gca, cmap_unsigned );
    end
    
    % adapt color-scale
    if adapt_scale
        color_scale = scale_func(img) * color_scale;
    end
    
    % remaining options
    cb = colorbar(gca); caxis( color_scale ); title(title_str);
    if ~isempty(label_c), cb.Label.String = label_c; end;
    
end

function img = check_size(img,maxsize)

    imgsize = size(img);
    maxsize = min( imgsize, maxsize );
    
    if ~all( imgsize == maxsize )
        warning( 'Input image is too large and will be resized for display.' );
        img = imresize( img, maxsize, 'bicubic' );
    end
    
end
