% Copyright (C) 2018,2023 Mitsubishi Electric Research Laboratories (MERL)
%
% SPDX-License-Identifier: AGPL-3.0-or-later

function [out] = trainingLapSVM(options,data)

%  fprintf('Training LapSVM in the primal with Newton''s method...\n');
%  classifier=lapsvmp(options,data);
% %
% % % computing error rate
% fprintf('It took %f seconds.\n',classifier.traintime);
% out=sign(data.K(:,classifier.svs)*classifier.alpha+classifier.b);
% er=100*(length(data.Y)-nnz(out==YOrig))/length(data.Y);
% fprintf('Error rate=%.1f\n\n',er);
% test_error = 100*sum(out(numb_training_examples+1:end) ~= YOrig(numb_training_examples+1:end))/length(YOrig(numb_training_examples+1:end))

% training the classifier
fprintf('Training LapSVM in the primal with early stopped PCG...\n');
options.Cg=1; % PCG
options.MaxIter=1000; % upper bound
options.CgStopType=1; % 'stability' early stop
options.CgStopParam=0.015; % tolerance: 1.5%
options.CgStopIter=3; % check stability every 3 iterations
classifier=lapsvmp(options,data);
fprintf('It took %f seconds.\n',classifier.traintime);

% computing error rate
out = data.K(:,classifier.svs)*classifier.alpha+classifier.b;
