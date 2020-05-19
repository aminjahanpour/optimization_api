% server='http://35.203.55.211'; % Canada
server='http://34.65.208.20'; % Germany

key='email mjahanpo@uwaterloo.ca for a key';

dim = 3;
budget = 20 * dim;
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
    for k = 1 : size(resp.dv, 1)
        f(k)=evaluate(resp.dv(k,:));
    end
    %updating the best objective function (for logging only)
    if min(f) <= f_best
        [f_best,f_best_idx] = min(f);
        x_best = resp.dv(f_best_idx,:), f_best
    end
    %creating a string of evaluated objective function values
    f_string = sprintf('[%.3f];' , f);
    f_string = f_string(1:end-1);
    %submitting the objective function values to the server and requesting for new solutions
    resp=webwrite(server, struct('req', 'roll', 'key', key, 'id', id, 'dim', dim, 'f', f_string), options);
end

resp=webwrite(server, struct('req', 'results', 'key', key, 'id', id), options)


function obj_fun = evaluate(x)
    % example objective function (replace with your own)
    % The API works with 0<=x<=1; you will have to denormalize the x before evaluation
    obj_fun = x(1)+2*x(2)-4.5*x(3);
end