function [fitresult, gof] = maolian(x, y3)
%CREATEFIT(X,Y3)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Output: y3
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 13-Jul-2022 09:40:12 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y3 );

% Set up fittype and options.
ft = fittype( 'power2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.StartPoint = [1804.24518967354 -0.641687552507437 0.603125989059258];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', '锚链' );
h = plot( fitresult, xData, yData );
legend( h, '真实值', '拟合值', 'Location', 'NorthEast', 'Interpreter', 'none' );
title("锚链与海床的夹角")
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y3', 'Interpreter', 'none' );
grid on


