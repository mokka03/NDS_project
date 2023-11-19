function [] = SaveFig(path, name, gcf)
%SAVEFIG Summary of this function goes here
%   Detailed explanation goes here
    if ~exist(path, 'dir')
       mkdir(path)
    end
    save_png = strcat(path, name, ".png");
    save_fig = strcat(path, name, ".fig");
    saveas(gcf,save_png)
    saveas(gcf,save_fig)
end

