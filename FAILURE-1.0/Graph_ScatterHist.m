% -----------------------------------------------------------------
%  Graph_ScatterHist.m
% -----------------------------------------------------------------
%  This functions plots a scatter histogram graph.
% ----------------------------------------------------------------- 
%  programmers: Americo Cunha Jr - americo.cunhajr@gmail.com
%               Samuel da Silva  - sam.silva13@gmail.com
%               Yasar Yanik      - ysryanik@gmail.com
%
%  last update: July 30, 2022
% -----------------------------------------------------------------
%
%  input:
%  x1     - x data vector 1
%  x2     - x data vector 2
%  gtitle - graph title
%  xlab   - x axis label
%  ylab   - y axis label
%  xmin   - x axis minimum value
%  xmax   - x axis maximum value
%  ymin   - y axis minimum value
%  ymax   - y axis maximum value
%  gname  - graph name
%
%  output:
%  gname.eps - output file in eps format (optional)
% ----------------------------------------------------------------- 
function fig = Graph_ScatterHist(x1,x2,gtitle,...
                                 xlab,ylab,xmin,xmax,ymin,ymax,gname)
	
    % check number of arguments
    if nargin < 10
        error('Too few inputs.')
    elseif nargin > 10
        error('Too many inputs.')
    end
    
    % check arguments
    if length(x1) ~= length(x2)
        error('x1 and x2 vectors must be same length')
    end

    fig = figure('Name',gname,'NumberTitle','off');
    
    fh1 = scatterhist(x1,x2,'Color','g',...
                            'Kernel','overlay',...
                            'Location','NorthWest',...
                            'Direction','out',...
                            'Marker','d',...
                            'MarkerSize',10.0);

    set(gcf,'color','white');
    %set(gca,'position',[0.2 0.2 0.7 0.7]);
    %set(gca,'Box','on');
    %set(gca,'TickDir','out','TickLength',[.02 .02]);
    %set(gca,'XMinorTick','on','YMinorTick','on');
    %set(gca,'XGrid','off','YGrid','on');
    %set(gca,'XColor',[.3 .3 .3],'YColor',[.3 .3 .3]);
    set(gca,'FontName','Helvetica');
    set(gca,'FontSize',18);
    
    if ( strcmp(xmin,'auto') || strcmp(xmax,'auto') )
        xlim('auto');
    else
        xlim([xmin xmax]);
    end

    if ( strcmp(ymin,'auto') || strcmp(ymax,'auto') )
        ylim('auto');
    else
        ylim([ymin ymax]);
    end

    xlabel(xlab,'FontSize',18,'FontName','Helvetica');
    ylabel(ylab,'FontSize',18,'FontName','Helvetica');
    
    hold off
    
	title(gtitle,'FontSize',20,'FontName','Helvetica');
    
    saveas(gcf,gname,'png');

end
% -----------------------------------------------------------------