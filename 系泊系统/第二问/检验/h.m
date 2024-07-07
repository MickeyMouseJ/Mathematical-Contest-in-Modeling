function [fitresult, gof] = h(x, y1)
%CREATEFIT(X,Y1)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Output: y1
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 13-Jul-2022 09:13:59 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y1 );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', '浮标浸没在海水中的深度' );
h = plot( fitresult, xData, yData );
legend( h, '真实值', '拟合值', 'Location', 'NorthEast', 'Interpreter', 'none' );
title("浮标浸没在海水中的深度")
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y1', 'Interpreter', 'none' );
grid on


