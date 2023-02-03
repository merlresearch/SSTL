% Copyright (C) 2018,2023 Mitsubishi Electric Research Laboratories (MERL)
%
% SPDX-License-Identifier: AGPL-3.0-or-later

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Output
% 1) datasets{ii}.x gives labelled points
% 2) datasets{ii}.testx gives unlabelled points
% 3) theta is the angle with which we rotate the dataset

clear all
N = 30; %Number of datasets
n = 100;
m = 500;

datasets = cell(N,1);
for ii = 1:N

    % Choose a random rotation angle
    theta = rand(1)*pi/2;

    % Create the rotation matrix
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];

    % Generate the spiral data
    data = twospirals(m);

    % Rotate the data
    data(:,1:2) = transpose(R*transpose(data(:,1:2)));

    % Seprate the data from the labels
    X = data(:,1:2);
    y = data(:,3);

    % Create the test and train data sets
    ind_Train = [1:n/2,(m/2+1):(m/2+n/2)];
    X_Train = X(ind_Train,:);
    y_Train = y(ind_Train);
    X_Test = removerows(X,'ind',ind_Train);
    y_Test = removerows(y,'ind',ind_Train);

    % Save the results
    datasets{ii}.testx =  X_Test;
    datasets{ii}.x =  X_Train;
    datasets{ii}.testy =  y_Test;
    datasets{ii}.y =  y_Train;
    datasets{ii}.completex = X;
    datasets{ii}.completey = y;
    datasets{ii}.theta = theta
end



n = 10; %Number of labelled points per dataset
nOld = 100;
for jj = 1:N
    ind_Train = [1:n/2,(nOld/2+1):(nOld/2+n/2)];
    datasets{jj}.x =  datasets{jj}.x(ind_Train,:);
    datasets{jj}.y =  datasets{jj}.y(ind_Train);
end

save spiralSynthetic10Data100N30m500
