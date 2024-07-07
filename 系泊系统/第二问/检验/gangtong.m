function [fitresult, gof] = gangtong(x, y2)
%CREATEFIT(X,Y2)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Output: y2
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 13-Jul-2022 09:31:32 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y2 );

% Set up fittype and options.
ft = fittype( 'power2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [89097.5477842249 -1.30896089114727 0.301139239683851];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', '钢桶' );
h = plot( fitresult, xData, yData );
legend( h, '真实值', '拟合值', 'Location', 'NorthEast', 'Interpreter', 'none' );
title("钢桶的倾斜角度")
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y2', 'Interpreter', 'none' );
grid on


