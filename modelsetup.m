function model = modelsetup(num_x,num_y,L2,order)
	model = {};
	model.a = {};
	model.b = {};

	model.w = zeros([num_x,num_y]);

	ew= {};
	b = {};
	for i =1:num_y
		ew{i}= zeros([i-1,1]);
		b{i} = 0;
	end
	model.ew 	= ew;
	model.b 	= b;

	model.threshold = zeros([1,num_y])+0.5;	
	model.num_y 	= num_y;
	model.num_x 	= num_x;
	model.L2 			= L2;
	model.rate 		= 0.0;
	model.order 	= order;
	
end
