% Copyright (C) 2018,2023 Mitsubishi Electric Research Laboratories (MERL)
%
% SPDX-License-Identifier: AGPL-3.0-or-later

clear all
% setting default paths
setpaths

%% Load the dataset
test_error = zeros(20,10);
load('ssl_parkinson_regression_data_m10_results.mat')
for ff = 1:10

    filename = strcat('Datasets/ssl_parkinson_regression_datam10v', num2str(ff));
    load(strcat(filename,'.mat'))

    % Feature space: X \in R^{m x d}
    % Label space: Y \in {-1,1} for binary classification


    %% Feature selection in the dataset (may not be needed)
    % feature_select = [1];
    % for jj = 1:length(datasets)
    %     x_train = datasets{jj}.x;
    %     x_test = datasets{jj}.testx;
    %     x_complete = datasets{jj}.completex;
    %     datasets{jj}.x = x_train(:,feature_select);
    %     datasets{jj}.testx = x_test(:,feature_select);
    %     datasets{jj}.completex = x_complete(:,feature_select);
    % end

    %% Laplacian SVM
    % Assign regularization parameters, Adjancency matrix (kNN) parameters
    options=make_options('gamma_I',5,'gamma_A',1,'NN',6,'KernelParam',3.0);
    options.Verbose=1;
    options.Hinge=0;
    options.UseBias=1; %This is bias in SVM.
    options.LaplacianNormalize=0; %Normalize the graph Laplacian
    options.NewtonLineSearch=0; % This is to get learning rate

    %Make all labels +1 and -1 (This is helpful when dataset is labeled as
    %{0,1}.


    % combine all datapoints in single X,Y and create a laplacian for each
    % dataset.

    fprintf('Computing Laplacian...\n\n');
    X = [];
    Y = [];
    YOrig = [];
    Lap = cell(length(datasets),1);
    numb_train_task = 35; % Total number of training datasets
    for ii = 1:length(datasets)
        if ii<=numb_train_task
            X_train = datasets{ii}.x;
            X_test = datasets{ii}.testx;
            XComplete = [X_train ; X_test];
            X = [X; XComplete ];
            YComplete = zeros(length(XComplete),1);
            YComplete(1:size(X_train,1)) = datasets{ii}.y;
            Y = [Y; YComplete ];
            Y_train =  datasets{ii}.y;
            Y_test = datasets{ii}.testy;
            YOrig = [YOrig; Y_train;Y_test ];
            Lap{ii} = laplacian(options,XComplete);
            numb_examples(ii,1) = size(XComplete,1);
        else

            X_test = datasets{ii}.testx;
            X = [X; X_test ];
            YComplete = zeros(size(X_test,1),1);
            Y = [Y; YComplete ];
            Y_test = datasets{ii}.testy;
            YOrig = [YOrig;Y_test ];
            Lap{ii} = laplacian(options,X_test);
            numb_examples(ii,1) = size(X_test,1);
        end
    end
    numb_training_examples = sum(numb_examples(1:numb_train_task)); %Total number of training examples so that we can calculate training and testing error.

    % Add X and Y in the datastructure
    data.X=X; % may be useless because we are giving predefined kernel.
    data.Y=Y;

    for rr = 1:20
        fprintf('Computing Gram matrix (kernel)...\n\n');
        %Kernel calculation
        % parameter initialization for kernel calculations
        L = 100; % parameter for fast kernel calculation
        Q = 100; % parameter for fast kernel calculation
        D = 100; % parameter for fast kernel calculation
        bw_kde1 = bw1_est_all(rr,ff); %127.4275; % bandwidth of the kernel on X
        bw_kde2 = bw2_est_all(rr,ff); % 6.9519;  ; % bandwidth of the kernel on X for estimating P_X
        bw_kde3 = bw3_est_all(rr,ff); %3.3598; % bandwidth of the kernel on P_X

        % Random matrix of the same size as d x L
        Wl = randn(size(X,2),L)/(bw_kde2);

        % Use placeholder matrecies to speed up the computation.
        Zx = zeros(length(datasets),2*L);
        Z_x = zeros(size(X,1),2*L);

        % initialize an index
        jj = 0;

        % Loop through all data sets to calculate the kernel matrix
        for ii=1:length(datasets)

            % For each trainign data set
            if ii<=numb_train_task

                % Take the labeled examples
                xitrain = datasets{ii}.x;

                % Take the unlabeled samples
                xitest = datasets{ii}.testx;
                xi = [xitrain;xitest ];
                % find the total data length
                total_len = size(xitrain,1) + size(xitest,1);

                % Approximate a single term in the gram matrix
                Zx(ii,:) = [sum(cos(xi*Wl)) sum(sin(xi*Wl))]/(sqrt(L)*size(xi,1));

                % now the kernel on the distributions is the same across any two data sets
                % so we need to scale it to a vector instead of an float, by
                % multiplying by a
                e = ones(total_len,1);

                % Update an index so that we can skip in the matrix to the next
                % data set location
                ind_jj = jj+1:jj+total_len;

                % now combine the kroniker delta product
                Z_x(ind_jj,:) = kron(Zx(ii,:),e);

                % update the index
                jj = jj + total_len;

            else % for each test data set

                % Same notation as above but does not include lines that have
                % labeled data.
                xi = datasets{ii}.testx;
                xitest = datasets{ii}.testx;
                total_len = size(xitest,1);
                Zx(ii,:) = [sum(cos(xi*Wl)) sum(sin(xi*Wl))]/(sqrt(L)*size(xi,1));
                e = ones(total_len,1);
                ind_jj = jj+1:jj+total_len;
                Z_x(ind_jj,:) = kron(Zx(ii,:),e);
                jj = jj + total_len;
            end
        end

        % Here we now are going to combine the total kernel by multiplying the data
        % kernel with the distribution kernel - Z_x is used to calculate the distribution kernel, X
        % is where we will build the data kernel
        new_vec = [bw_kde1*Z_x bw_kde3*X];

        % Use the Gaussian kernel approximation - faster than exact implementation
        Wq = randn(size(new_vec,2),Q)/(bw_kde1*bw_kde3);

        % Final Representation to calculate the final product kernel
        Z = [cos(new_vec*Wq) sin(new_vec*Wq)]/sqrt(Q);


        % add kernel and laplacian in the data strucure needed
        data.K= Z*Z'; %calckernel(options,X,X);
        data.L= blkdiag(Lap{:});


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

        classifier=laprlsc(options,data);
        fprintf('It took %f seconds.\n',classifier.traintime);

        % computing error rate
        out=(data.K(:,classifier.svs)*classifier.alpha+classifier.b);
        YEst = out(numb_training_examples+1:end);
        YTrue = YOrig(numb_training_examples+1:end);

        test_error(rr,ff) = sum( (YEst - YTrue).^2 )/length(YOrig(numb_training_examples+1:end));
        fprintf('Error rate=%.1f\n\n',test_error(rr,ff));

    end

end

% Save the results
result_filename = strcat('ssl_parkinson_regression_data_m10','_sslresults');
save(result_filename,'test_error')
