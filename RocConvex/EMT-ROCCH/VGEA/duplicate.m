function [pop, fit] = duplicate(pop, fit)
	
	m = size(pop, 1);
	dup = zeros(m, 1);
	d = zeros(m, m);
	lens = sum(pop, 2);
	for i = 1 : m
		for j = i + 1 : m
			d(i, j) = sum(pop(i, :) + pop(j, :) == 2);
			if d(i, j) == min(lens(i), lens(j))
				if fit(i, 1) > fit(j, 1)
					dup(i) = 1;
				elseif fit(i, 1) < fit(j, 1)
					dup(j) = 1;
				else
					if lens(i) > lens(j)
						dup(i) = 1;
					else 
						dup(j) = 1;
					end
				end
			end
		end
	end
	
	pop = pop(dup == 0, :);
	fit = fit(dup == 0, :);

end