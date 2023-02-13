%% Error scattter plot

% tranl part
err_original_t = vecnorm(err_original(:,1:3), 2, 2);
err_calibrated_t = vecnorm(err_calibrated(:,1:3), 2, 2);
err_t_max = max([err_original_t; err_calibrated_t]);

plot_err(FK_original(:,1:3), err_original_t, err_t_max, 'mm')
title(strcat(title_name, ': T erorr original'),'fontsize',20)
plot_err(FK_calibrated(:,1:3), err_calibrated_t, err_t_max, 'mm')
title(strcat(title_name, ': T erorr calibrated'),'fontsize',20)

% rot part
err_original_r = vecnorm(err_original(:,4:5), 2, 2);
err_calibrated_r = vecnorm(err_calibrated(:,4:5), 2, 2);
err_r_max = max([err_original_r; err_calibrated_r]);

plot_err(FK_original(:,1:3), err_original_r, err_r_max, 'degree')
title(strcat(title_name, ': R erorr original'),'fontsize',20)
plot_err(FK_calibrated(:,1:3), err_calibrated_r, err_r_max, 'degree')
title(strcat(title_name, ': R erorr calibrated'),'fontsize',20)

function plot_err(point, value, max, unit)
figure()
box on; axis equal; grid on; hold on;
c_norm = floor( value / max * 255) + 1;
color = jet(256);

if size(point,2) == 3
    scatter3(point(:,1), point(:,2), point(:,3), 100, color(c_norm(:),:), 'filled', 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.8)
    xlabel("X",'FontSize', 15); ylabel("Y",'FontSize', 15); zlabel("Z",'FontSize', 15);
elseif size(point,2) == 2
    scatter3(point(:,1), point(:,2), 100, color(c_norm(:),:), 'filled', 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.8)
    xlabel("X",'FontSize', 15); ylabel("Y",'FontSize', 15); zlabel("Z",'FontSize', 15);
end
colormap(jet); cb = colorbar('FontSize', 15); caxis([0 max]); ylabel(cb, strcat('error (', unit, ')'), 'FontSize',15)
end