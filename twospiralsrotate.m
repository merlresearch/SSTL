% Copyright (C) 2018,2023 Mitsubishi Electric Research Laboratories (MERL)
%
% SPDX-License-Identifier: AGPL-3.0-or-later

% Clear MATLAB
clear variables;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this plot we show datasets with different rotations for demonstration.
%  In this plot we can see that all datasets have different marginal distribution.

figure;
hold on;
dotsize = 12;
 colormap([1 0 .5;   % magenta
           0 0 .8;   % blue
           0 .6 0;   % dark green
           .3 1 0]); % bright green

subplot(231);
data = twospirals(500);
data(:,2) = data(:,2) + 10;
scatter(data(:,1), data(:,2), dotsize, data(:,3)); axis equal;
title('Two spirals');

subplot(232);
data = twospirals(500);
data(:,2) = data(:,2) + 10;
theta = pi/6;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
data(:,1:2) = transpose(R*transpose(data(:,1:2)));
scatter(data(:,1), data(:,2), dotsize, data(:,3)); axis equal;
title('Two spirals pi/6');

subplot(233);
data = twospirals(500);
data(:,2) = data(:,2) + 10;
theta = pi/3;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
data(:,1:2) = transpose(R*transpose(data(:,1:2)));
scatter(data(:,1), data(:,2), dotsize, data(:,3)); axis equal;
title('Two spirals pi/3');

subplot(234);
data = twospirals(200);
data(:,2) = data(:,2) + 10;
theta = pi/2;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
data(:,1:2) = transpose(R*transpose(data(:,1:2)));
scatter(data(:,1), data(:,2), dotsize, data(:,3)); axis equal;
title('Two spirals pi/2');

subplot(235);
data = twospirals(100);
data(:,2) = data(:,2) + 10;
theta = 2*pi/3;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
data(:,1:2) = transpose(R*transpose(data(:,1:2)));
scatter(data(:,1), data(:,2), dotsize, data(:,3)); axis equal;
title('Two spirals 2pi/3');

subplot(236);
data = twospirals(100);
data(:,2) = data(:,2) + 10;
theta = pi;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
data(:,1:2) = transpose(R*transpose(data(:,1:2)));
scatter(data(:,1), data(:,2), dotsize, data(:,3)); axis equal;
title('Two spirals pi');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this plot we show shift in one of the rotated dataset for demonstration
% purpose. In this plot we can see that rotated dataset and non-rotated dataset
% have different manifold structure.
figure;
hold on;
dotsize = 100;
 colormap([1 0 .5;   % magenta
           0 0 .8;   % blue
           0 .6 0;   % dark green
           .3 1 0]); % bright green

subplot(121);
data = twospirals(500);
data(:,2) = data(:,2) + 10;
scatter(data(:,1), data(:,2), dotsize, data(:,3)); axis equal;
axis square
title('Theta = 0');


subplot(122);
data = twospirals(500);
data(:,2) = data(:,2) + 10;
theta = pi/2;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
data(:,1:2) = transpose(R*transpose(data(:,1:2)));
scatter(data(:,1), data(:,2), dotsize, data(:,3)); axis equal;
title('Theta = pi/2');
axis square
