function model = modeltrain(train_x,train_y,L2,order)

	one_x = train_x(1,:);
	one_y = train_y(1,:);


	sample_x = [];
	sample_y = [];
  if size(train_x,1) > 50
      used = zeros(size(train_x,1),1);
      for i = 1:50
         r = randint(1,1,[1,size(train_x,1)]); 
         while used(r,1) == 1
            r = randint(1,1,[1,size(train_x,1)]);
         end
         used(r,1) = 1;
         sample_x = [sample_x;train_x(r,:)];
         sample_y = [sample_y;train_y(r,:)];
      end
  else
      sample_x = train_x;
      sample_y = train_y;
  end

	zero_flag = train_x==0;
	ratio     = sum(sum(zero_flag))/(size(zero_flag,1)*size(zero_flag,2));
	if ratio > 0.9
		train_x= sparse(train_x);
	end
	model  = modelsetup(size(train_x,2),size(train_y,2),L2,order);	

	num_up = 0;
	for epoch=1:200
			if mod(epoch,10) == 0
				fprintf('>');
			end
            model = modelff(model,train_x,train_y);

			low = 0.0;
			high = 1;
			pre_log = 10000.0;
			origin_model = model;
			test = {};
			for k = 1:10
							middle_rate = (high+low)/2;
							
							test = origin_model;
							test.rate  = middle_rate;
							test = modelff(test,sample_x,sample_y);
							test = modelbp(test,sample_x,sample_y);
							test = modelff(test,sample_x,sample_y);
							log1 = modeleval(test,sample_y);
		
							test = origin_model;
							test.rate = middle_rate+0.0001;
							test = modelff(test,sample_x,sample_y);
							test = modelbp(test,sample_x,sample_y);
							test = modelff(test,sample_x,sample_y);
							log2 = modeleval(test,sample_y);
											
	
							if log1 > log2
								low = middle_rate;
							else
								high = middle_rate;
							end											
			end

			model.rate = (low+high)/2;
			model   = modelbp(model,train_x,train_y);
			

	end

	disp(' ');
end
