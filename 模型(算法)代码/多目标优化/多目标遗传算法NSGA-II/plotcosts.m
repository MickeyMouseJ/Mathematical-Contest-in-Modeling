function plotcosts(pop)

    costs = [pop.cost];
    
    plot(costs(1, :), costs(2, :), 'r*', 'MarkerSize', 10);
    xlabel('最大竖向位移[mm]');
    ylabel('工程造价[万元]');
    title('Pareto解集');
    grid on;

end
