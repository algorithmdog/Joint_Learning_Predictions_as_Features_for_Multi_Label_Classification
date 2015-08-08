function cco(data_dir)
	addpath('../EVAL');
	addpath('../UTIL');
	addpath('../THRESHOLD');
	rand('seed',777);
	maxNumCompThreads(1);
	train_x = load(strcat(data_dir,'/train.x'));
	train_y = load(strcat(data_dir,'/train.y'));
    test_x  = load(strcat(data_dir,'/test.x'));
    test_y  = load(strcat(data_dir,'/test.y'));	
	x = [train_x;test_x];
	y = [train_y;test_y];
	order = [1:size(train_y,2)];

	fold = 10;
	loss = zeros([fold,8]);
    times = zeros([fold,2]);
	for idx = 1:fold
		[train_x,train_y,test_x,test_y]= cvsplit(x,y,idx,fold);

        tic;
		model  	= modeltrain(train_x,train_y,1e-3,order);	
		model   = modelff(model,train_x,train_y);
		model.threshold = threshold(model.output,train_y);
		train_time = toc;	

		tic;
		model = modelff(model,test_x,test_y);
		test_time =  toc;

		[loss(idx,5),loss(idx,6),loss(idx,7),loss(idx,8)] = evaluate_rank(model.output,test_y);
		result = model.output > model.threshold;
		[loss(idx,1),loss(idx,2),loss(idx,3),loss(idx,4)]=evaluate(result,test_y);
        times(idx,1) = train_time;
        times(idx,2) = test_time;
        
	end
	
	[average,variance] = average_variance(loss);	
	disp('average:');
	disp(average);
	disp('variance:');
	disp(variance);

    disp(['train_time && test_time']);
    [average,variance] = average_variance(times);
    disp(average);
    disp(variance);
end
