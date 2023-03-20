close all; clear; clc;
top = readtable('tilt_n30Azim0Row7Tap1Top.csv');
bot = readtable('tilt_n30Azim0Row7Tap1Bot.csv');

%%
rho=1.0; %The pressure is kinematic pressure pk=ps/rho (m^2/s^2)
pTop=[top.avg_p_];
pBot=[bot.avg_p_];
% U=top.avg_U_0__;
U=18;
pCoeff=(pTop-pBot)./(0.5*rho*U.^2);

%% wind tunnel data
filename = '../../../RWDI/Wind Tunnel Data/tilt_n30deg.hdf5';
% h5disp(filename);
info = h5info(filename);
level2 = info.Groups(1);
data = h5read(filename,'/WindDir_0deg/Row7');
dtNorm = h5read(filename,'/WindDir_0deg/dtNorm');

%% compare
L=4.29895;
dt=dtNorm*L/mean(U);
timeCFD=top.Time;
timeRWDI=dt:dt:round(timeCFD(end)/dt)*dt;
figure
plot(timeCFD,pCoeff)
hold on
plot(timeRWDI,data(1,1:round(timeCFD(end)/dt)))
legend('CFD','RWDI')
xlabel('Time (s)')
ylabel('Pressure Coefficient')

figure
plot(timeCFD,pTop)
hold on
plot(timeCFD,pBot)
legend('Top pressure','Bottom pressure')
xlabel('Time (s)')
ylabel('Pressure (m^2/s^2)')