% clear the memory and the work space and close opened session
close all
clear all
clc

% Read the dataset excel file as a table and save it in the variable "data"
data = readtable('DataSet_2119231.xls');

% Plot the data by considering the temperature as the independent parameter and
% the boiling point elevation as the dependent of the system.
hold on
figure(1)
scatter(data.Temperature_C_, data.Boiling_pointElevation_K_,'b','LineWidth', 2);
title('Dataset plot');
grid on;
xlabel('Temperature');
ylabel('Boiling point levetation');
legend('Dataset');

% constructing the design matrix starts by defining the xdata and the ydata
% and the numbers of points and parameters.

xdata = data.Temperature_C_;
ydata = data.Boiling_pointElevation_K_;

N = length(xdata)       % number of points
M = 2                     % number of parameters
% design matrix
X = [ones(N,1), xdata];

% the dependent parameters matrix
Y = ydata;

% the least square estimator 
P_hat = inv(X'*X)*X'*Y

% find and plot the fitted values
figure(2)
XX = linspace(0, 180, 2);       % independent variable
yy = P_hat(1) + P_hat(2)*XX;    % Fitted points
hold on
scatter(xdata, ydata,'b','LineWidth', 2);
plot(XX, yy, 'r', 'LineWidth', 2);
legend('Dataset', 'Fitted values', 'Location', 'southeast');
title('Dataset plot-Fitted values');
grid on;
xlabel('Temperature');
ylabel('Boiling point levetation');

% variance-covariance matrix
varcov = inv(X'*X)

% The residuals are
epsilon = Y - (X*P_hat)

% The homoskedastic variance
sigma_e = (epsilon'*epsilon)./N-M

% the variances of the parameters
var_p = sigma_e.*varcov;

var_B0 = var_p(1,1)    %variance of the first parameter B0
var_B1 = var_p(2,2)    %variance of the second parameter B1

% the standard deviation
std_dev_B0 = sqrt(var_p(1,1))   %standard deviation of the first parameter B0
std_dev_B1 = sqrt(var_p(2,2))   %standard deviation of the second parameter B1

% singular value decomposition of the design matrix
[U,S,V] = svd(X);

% to solve the LLSQ problem using SVD, first find the economy-size
% decomposition
[U,S,V] = svd(X,"econ");
% now solving the LLSQ problem 
P = (V*inv(S)*U')*Y

% plotting the fitted values found from the SVD solution parameters
figure(3)
XX2 = linspace(0, 180, 2);      % Independent variable
yy2 = P(1) + P(2)*XX;           % Fitted values
hold on
scatter(xdata, ydata,'b','LineWidth', 2);
plot(XX2, yy2, 'r', 'LineWidth', 2);
legend('Dataset', 'SVD Fitted values', 'Location', 'southeast');
title('Dataset plot-SVD Fitted values');
grid on;
xlabel('Temperature');
ylabel('Boiling point levetation');

