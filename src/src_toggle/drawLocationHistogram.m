function outF = drawLocationHistogram(x)
    set(gcf,'color','white');
    edges = -2:0.2:2;

    x = x(:);
    n = histc(x,edges);
    n = n/sum(n);
    h = bar(edges,n);
    set(h,'EdgeColor','w')
    [~,~,greyBlue] = myColours();
    set(h(1),'FaceColor',greyBlue);

    
    edges = -2:1:2;
    set(gca,'XTick',edges);
    axis tight

    xlabel('x-location');
    ylabel('Observed relative frequency');

    hold on
    outF = h;
end