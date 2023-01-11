% -----------------------------------------------------------------
%  Graph_BarCurve2.m
% -----------------------------------------------------------------
%  This functions plots a bar histogram and a curve with 
%  two data series.
% ----------------------------------------------------------------- 
%  programmers: Americo Cunha Jr - americo.cunhajr@gmail.com
%               Samuel da Silva  - sam.silva13@gmail.com
%               Yasar Yanik      - ysryanik@gmail.com
%
%  last update: July 30, 2022
% -----------------------------------------------------------------
%
%  input:
%  bins1  - bins locations vector 1
%  freq1  - frequency counts vector 1
%  bins2  - bins locations vector 2
%  freq2  - frequency counts vector 2
%  x1     - x data vector 1
%  y1     - y data vector 1
%  x2     - x data vector 2
%  y2     - y data vector 2
%  x3     - x data vector 3
%  y3     - y data vector 3
%  gtitle - graph title
%  leg1   - legend 1
%  leg2   - legend 2
%  leg3   - legend 3
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
function fig = Graph_BarCurve2(bins1,freq1,bins2,freq2,...
                                x1,y1,x2,y2,gtitle,leg1,leg2,...
                                xlab,ylab,xmin,xmax,ymin,ymax,gname)
	
    % check number of arguments
    if nargin < 18
        error('Too few inputs.')
    elseif nargin > 18
        error('Too many inputs.')
    end
    
    % check arguments
    if length(bins1) ~= length(freq1)
        error('bins1 and freq1 vectors must be same length')
    end
    
    if length(bins2) ~= length(freq2)
        error('bins2 and freq2 vectors must be same length')
    end
    
    if length(x1) ~= length(y1)
        error('x1 and y1 vectors must be same length')
    end
    
    if length(x2) ~= length(y2)
        error('x2 and y2 vectors must be same length')
    end
    
    fig = figure('Name',gname,'NumberTitle','off');
    
    fh1 = bar(bins1,freq1,0.98);
    hold all
    fh2 = bar(bins2,freq2,0.98);
    fh3 = plot(x1,y1,'--r');
    fh4 = plot(x2,y2,'--b');
    set(gcf,'color','white');
    set(gca,'position',[0.2 0.2 0.7 0.7]);
    set(gca,'Box','on');
    set(gca,'TickDir','out','TickLength',[.02 .02]);
    set(gca,'XMinorTick','on','YMinorTick','on');
    set(gca,'XGrid','off','YGrid','on');
    set(gca,'XColor',[.3 .3 .3],'YColor',[.3 .3 .3]);
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
    
    set(fh1,'FaceColor','m');
    set(fh1,'FaceAlpha',0.3);
    set(fh1,'EdgeColor','m');
    set(fh1,'LineStyle','-');
    set(fh2,'FaceColor','c');
    set(fh2,'FaceAlpha',0.3);
    set(fh2,'EdgeColor','c');
    set(fh2,'LineStyle','-');
    set(fh3,'LineWidth',5.0);
    set(fh4,'LineWidth',5.0);
    legend(leg1,leg2);
    xlabel(xlab,'FontSize',18,'FontName','Helvetica');
    ylabel(ylab,'FontSize',18,'FontName','Helvetica');
    
    hold off
    
	title(gtitle,'FontSize',20,'FontName','Helvetica');
    
    saveas(gcf,gname,'png');

end
% -----------------------------------------------------------------