% -----------------------------------------------------------------
%  Graph_MainStresses.m
% ----------------------------------------------------------------- 
%  This functions plots in the same figure the main stresses.
% ----------------------------------------------------------------- 
%  programmers: Americo Cunha Jr - americo.cunhajr@gmail.com
%               Samuel da Silva  - sam.silva13@gmail.com
%               Yasar Yanik      - ysryanik@gmail.com
%
%  last update: July 30, 2022
% -----------------------------------------------------------------
function fig = Graph_MainStresses(sigma1,sigma2,SY,...
                                  gtitle,xlab,ylab,...
                                  leg1,leg2,leg3,...
                                  xmin,xmax,ymin,ymax,gname)
	
    % check number of arguments
    if nargin < 14
        error('Too few inputs.')
    elseif nargin > 15
        error('Too many inputs.')
    end

    % check arguments
    if length(sigma1) ~= length(sigma2)
        error('sigma1 and sigma2 vectors must be same length')
    end
    
    % Tresca and von Mises curves
    Tresca = @(x,y) max([abs(x),abs(y),abs(x-y)]) - SY;
    vMises = @(x,y) x.^2 + y.^2 - x.*y - SY.^2;
    
    fig = figure('Name',gname,'NumberTitle','off');
    
    hold all
    fh1 = fimplicit(Tresca,'Color','r');
    fh2 = fimplicit(vMises,'Color','b');
    fh3 = plot(sigma1,sigma2,'dg');
    set(gcf,'color','white');
    set(gca,'position',[0.1 0.2 0.8 0.7]);
    set(gca,'Box','on');
    set(gca,'TickDir','out','TickLength',[.02 .02]);
    %set(gca,'XMinorTick','on','YMinorTick','off');
    set(gca,'XTick', []);
    set(gca,'YTick', []);
    %set(gca,'XGrid','off','YGrid','on');
    set(gca,'XColor',[.3 .3 .3],'YColor',[.3 .3 .3]);
    set(gca,'FontName','Helvetica');
    set(gca,'FontSize',18);
    legend(leg1,leg2,leg3,'Location','southeast');
    
    xlim([xmin xmax]);
    ylim([ymin ymax]);
    
    set(fh3,'LineWidth',0.5);
    set(fh1,'LineWidth',3.0);
    set(fh1,'LineStyle','-');
    set(fh2,'LineWidth',3.0);
    set(fh2,'LineStyle','-');
    set(fh3,'MarkerSize',10.0);
    xlabel(xlab,'FontSize',20,'FontName','Helvetica');
    ylabel(ylab,'FontSize',20,'FontName','Helvetica');
    %uistack(fh1,'top');
    %uistack(fh2,'top');
    %uistack(fh3,'top');

    hold off
    
	title(gtitle,'FontSize',20,'FontName','Helvetica');
    
    saveas(gcf,gname,'png');

end
% -----------------------------------------------------------------