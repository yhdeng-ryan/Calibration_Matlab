%% plot error
figure('Position', [0 0 1920 1080])
sgtitle(title_name,'fontsize',24)
ylabels1 = ["X (mm)", "Y (mm)", "Z (mm)", "Roll (degee)", "Tilt (degee)", ];
ylabels2 = ["X error (mm)", "Y error (mm)", "Z error (mm)", "Roll error (degee)", "Tilt error (degee)", ];
xlabels = "samples";
hold on

for i = 1:5
    % plot samples
    subplot(2,5,i)
    plot(FK_groundtruth(:, i), 'b')
    hold on; grid on;
    plot(FK_original(:,i), 'r')
    plot(FK_calibrated(:, i), 'c')
    xlabel(xlabels,'fontsize',18);
    ylabel(ylabels1(i),'fontsize',18);
    ax = gca; ax.FontSize = 16; 
    if i==5
        legend(["Ground truth  (Atracsys)", "Original FK", "Calibrated FK"], "Location","best")
    end
    
    % plot box plot
    subplot(2,5,i+5)
    boxplot([err_original(:,i) err_calibrated(:,i)], ...
         'Labels',{'original', 'calibrated'});
    set(gca, 'ActivePositionProperty', 'position','FontSize',14)
    ylabel(ylabels2(i),'fontsize',18);
    grid on;
end