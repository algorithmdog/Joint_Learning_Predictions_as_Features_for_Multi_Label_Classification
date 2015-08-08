function model = modelff(model,x,y)
		model.output = zeros(size(y));
		tmp = [];
		num = size(x,1);
		
		tmp_a = x*model.w;
		
		for i = 1:model.num_y

			a = tmp_a(:,i)+repmat(model.b{i},size(x,1),1);
			if i > 1
				a = a+tmp*model.ew{i};
			end
			a = exp(a)./(1+exp(a));
			tmp = [tmp a];
		
			model.output(:,model.order(i)) = a;
	end

end
