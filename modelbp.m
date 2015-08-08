function model = modelbp(model,x,y)
	%disp(model.order);
	num_x = model.num_x;
	num_y = model.num_y;
	ext_f = [];
	for i = 1:num_y
		ext_f = [ext_f model.output(:,model.order(i))];
		tmp_d_a{i} = zeros(size(x,1),1);
		tmp_d_o{i} = model.output(:,model.order(i)).*(1-model.output(:,model.order(i)));
	end

	%caculate the derivate
	for i=num_y:-1:1
			tmp_d_a{i} =  tmp_d_a{i}.*tmp_d_o{i}+model.output(:,model.order(i)) - y(:,model.order(i));

			tmp_w       = model.ew{i};
			for j = 1:i-1;
					tmp_d_a{j} = tmp_d_a{j}+tmp_d_a{i}.*tmp_w(j,1);
			end
	end

	%update the weight
	d_a = zeros(size(y));
  for i = 1:num_y
    d_a(:,i) = tmp_d_a{i};
  end
  dw 	= x'*d_a/size(x,1);
	model.w = model.w - model.rate*(dw+model.L2*model.w);

	dew = ext_f'*d_a/size(x,1); 
  db_list = sum(d_a)/size(x,1);
  for i = model.num_y:-1:1
		if i > 1
			model.ew{i}= model.ew{i}- model.rate*(dew(1:i-1,i)+model.L2*model.ew{i});
    end
		model.b{i} = model.b{i} - model.rate*(db_list(i)+model.L2*model.b{i});
  end

end
