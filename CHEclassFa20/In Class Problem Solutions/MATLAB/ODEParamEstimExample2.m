function ODEParamEstimExample2
tdata = [0.5 1.0 5.0 20]; % independent variable, x-axis
xdata = [99 98 50 3; 2 4 35 7]; % dependent variables, y-axis
% alternative
% x1 = [99 98 50 3];
% x2 = [2 4 35 7];
% xdata = [x1; x2];

x0 = [100 1]; % initial conditions [ x1(0) x2(0)];

% Parameter guesses
b1guess = 1;
b2guess = 1;
parameterguesses = [b1guess, b2guess];

% Estimate parameters b1 & b2
%parameters = lsqcurvefit(@(parameterguesses,tdata) model (parameterguesses,tdata) ,parameterguesses, tdata, xdata)
parameters = lsqcurvefit(@(parameterguesses,tdata)model(parameterguesses,tdata,x0),parameterguesses, tdata, xdata)

tforplotting = linspace(tdata(1),tdata(end),101);
xatguesses = model(parameterguesses, tforplotting,x0);
xatsoln = model(parameters,tforplotting,x0);
% Plots
figure(1)
tiledlayout('flow') 
nexttile
plot(tdata,xdata(1,:),'o')
xlabel('t')
ylabel('x1')
hold on
plot(tforplotting,xatguesses(1,:))
plot(tforplotting,xatsoln(1,:),'g')
legend('data','x1 at guesses', 'x1 at soln parameters')
hold off
nexttile
plot(tdata,xdata(2,:),'o')
xlabel('t')
ylabel('x2')
hold on
plot(tforplotting,xatguesses(2,:))
plot(tforplotting,xatsoln(2,:),'g')
legend('data','x2 at guesses', 'x2 at soln parameters')
hold off

function output = model(parameters,t,x0)
    for i = 1:length(t)
        if t(i) == 0 
            tsoln = 0;
            xsoln = x0;
            output(i,:) = ysoln;
        else
            tspan = [0 t(i)]; 
            [tsoln, xsoln] = ode23s(@(t,x) system_of_ODEs(t,x,parameters), tspan, x0);
            output(i,:) = xsoln(end,:);
        end
    end
    output = output';
end

function output = system_of_ODEs(t,x,parameters)
    b1 = parameters(1);
    b2 = parameters(2);
    x1 = x(1);
    x2 = x(2);
    dxdt(1) = -b1*x1*x2;
    dxdt(2) = b1*x1*x2-b2*x2;
    output = dxdt';
end
end