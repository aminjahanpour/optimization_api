server='http://45.32.213.42';
key='fake_key';
dim = 2;
budget = 200 * dim;
id = 'matlab_example';

options = weboptions('MediaType','application/json',  'Timeout', 1000);

resp=webwrite(server,      struct('req', 'del',   'key', key, 'id', id), options)
resp=webwrite(server,      struct('req', 'create','key', key, 'id', id, 'dim', dim, 'budget', budget), options)
resp=webwrite(server, struct('req', 'ask',   'key', key, 'id', id), options)

% arbitrary values for f_best
f_best = 10e20;
while char(resp.dv(1,1)) ~= "budget_used_up"
    %creating the vector of objective functions from recoeved solutions
    f=[];
    for k = 1 : length(resp.dv)
        f(k)=evaluate(resp.dv(k,:));
    end
    %updating the best objective function (for logging only)
    if min(f) <= f_best
        [f_best,f_best_idx] = min(f);
        x_best = resp.dv(f_best_idx,:), f_best
    end
    %creating a string of evaluated objective function values
    f_string = sprintf('%.3f,' , f);
    f_string = f_string(1:end-1);
    %submitting the objective function values to the server and requesting for new solutions
    resp=webwrite(server, struct('req', 'roll', 'key', key, 'id', id, 'dim', dim, 'f', f_string), options);
end

function obj_fun = evaluate(x)
    % example objective function (replace with your own)
    % Optoria works with 0<=x<=1; you will have to denormalize the x before evaluation
    obj_fun = x(1)+2*x(2);
end




