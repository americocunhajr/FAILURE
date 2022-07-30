% -----------------------------------------------------------------
%  graph_samples.m
% ----------------------------------------------------------------- 
%  This functions plots in the same figure the samples of
%  two given random variables.
% ----------------------------------------------------------------- 
%  programmers: Americo Cunha Jr - americo.cunhajr@gmail.com
%               Samuel da Silva  - sam.silva13@gmail.com
%               Yasar Yanik      - ysryanik@gmail.com
%
%  last update: July 30, 2022
% -----------------------------------------------------------------
function fig = graph_samples(samples1,samples2,x1,x2,...
                                    gtitle,xlab,ylab,...
                                    leg1,leg2,...
                                    xmin,xmax,ymin,ymax,gname)
	
    % check number of arguments
    if nargin < 14
        error('Too few inputs.')
    elseif nargin > 15
        error('Too many inputs.')
    end

    % check arguments
    if length(samples1) ~= length(samples1)
        error('samples1 and samples2 vectors must be same length')
    end
    
    fig = figure('Name',gname,'NumberTitle','off');
    
    fh1 = plot(samples1,1:length(samples1),'xm');
    hold all
    fh2 = plot(samples2,1:length(samples2),'*c');
    fh3 =  line([x1 x1],[ymin ymax],'Color','r');
    fh4 =  line([x2 x2],[ymin ymax],'Color','b');
    set(gcf,'color','white');
    set(gca,'position',[0.1 0.2 0.8 0.7]);
    set(gca,'Box','on');
    set(gca,'TickDir','out','TickLength',[.02 .02]);
    set(gca,'XMinorTick','on','YMinorTick','off');
    set(gca,'YTick', []);
    set(gca,'XGrid','off','YGrid','on');
    set(gca,'XColor',[.3 .3 .3],'YColor',[.3 .3 .3]);
    set(gca,'FontName','Helvetica');
    set(gca,'FontSize',18);
    legend(leg1,leg2,'Location','northeast');
    
    xlim([xmin xmax]);
    ylim([ymin ymax]);
    
    set(fh1,'LineWidth',0.5);
    set(fh2,'LineWidth',0.5);
    set(fh3,'LineStyle','--');
    set(fh3,'LineWidth',2.0);
    set(fh4,'LineStyle','--');
    set(fh4,'LineWidth',2.0);
    xlabel(xlab,'FontSize',20,'FontName','Helvetica');
    ylabel(ylab,'FontSize',20,'FontName','Helvetica');
    
    hold off
    
	title(gtitle,'FontSize',20,'FontName','Helvetica');
    
    saveas(gcf,gname,'png');

end
% -----------------------------------------------------------------