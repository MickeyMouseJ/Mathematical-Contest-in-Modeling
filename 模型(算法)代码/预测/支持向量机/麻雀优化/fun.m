function Fitness = fun(x,inputs,outputs)

v = 5;
cmd = ['-v ',num2str(v),' -t 2',' -c ',num2str(x(1)),' -g ',num2str(x(2)),' -s 3 -p 0.1 -q'];

error = libsvmtrain(inputs,outputs,cmd);

Fitness=error;
