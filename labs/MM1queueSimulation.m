%%
%  Simulation of M/M/1 queue
%
%  INPUTS
%  n        Number of completed services
%  lambda   Arrival rate
%  mu       Service rate
%
%  OUTPUTS
%  D        Average delay
%  W        Average waiting time
%  B        Average utilization
function [D,W,B] = MM1queueSimulation(n,lambda,mu)

% Variables
serverStatus=0; % 0 is idle, 1 is busy
tArrivals=[]; % times of arrival of the customers waiting in the queue
clock=0;
lastDelay=0;
lastDelayTime=0;

% Event list
tArrivalEvent=(-1/lambda)*log(rand(1,1)); %generate first arrival
tDepartureEvent=inf;

% Statistical counters
nDelay=0;
sDelay=0;
nWait=0;
sWait=0;
aQueue=0;
aBusy=0;

while nWait~=n
    % check whether the next event is an arrival or a departure
    prevClock=clock;
    if tArrivalEvent<tDepartureEvent
        clock=tArrivalEvent;

        % update waiting time
        aQueue=aQueue+(clock-prevClock)*length(tArrivals);
        % update busy time
        aBusy=aBusy+(clock-prevClock)*serverStatus;
        
        % Check whether  customer can proceed to server
        if serverStatus==0
            nDelay=nDelay+1;
            serverStatus=1;
            tDepartureEvent = clock + (-1/mu)*log(rand(1,1)); % schedule departure
            tArrivalEvent=clock+(-1/lambda)*log(rand(1,1)); % schedule new arrival
            lastDelay=0;
            lastDelayTime=clock;
        else
        % or enqueue him
            tArrivals(end+1)=clock;% store time of arrival
            tArrivalEvent=clock+(-1/lambda)*log(rand(1,1)); % schedule new arrival
        end
    else
    % we have a departure
        clock = tDepartureEvent;

        % update queue length
        aQueue=aQueue+(clock-prevClock)*length(tArrivals);
        % update busy time
        aBusy=aBusy+(clock-prevClock)*serverStatus;
        
        % take customer out of service
        serverStatus=0;
        tDepartureEvent = inf; % don't forget this one
        
        % keep track of waiting time
        nWait=nWait+1;
        sWait=sWait+lastDelay+(clock-lastDelayTime);
        
        % check whether there is someone waiting in queue
        if ~isempty(tArrivals)
            % register his delay
            lastDelay=clock-tArrivals(1);
            lastDelayTime=clock;
            sDelay = sDelay + lastDelay;
            nDelay = nDelay + 1;
            % calculate departure
            serverStatus=1;
            tDepartureEvent = clock + (-1/mu)*log(rand(1,1));
            %take him out of queue
            tArrivals(1)=[];
        end
    end
end

W=sWait/nWait; % Average waiting time
D=sDelay/nDelay;
B=aBusy/clock;
