function log1 = modeleval(model,y)
	%caculate log
	p = model.output;
	log1 = -log(p).*y-log(1-p).*(1-y);
	log1 = sum(sum(log1))/size(y,1);
	log1 = log1 + model.L2*sum(sum(model.w.*model.w));
	for i=1:model.num_y
		log1  = log1 + model.L2*model.b{i}*model.b{i};
	end	

end
