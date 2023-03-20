close all; clear; clc;
top = readtable('tilt_n30Azim0Row7Tap1Top.csv');
bot = readtable('tilt_n30Azim0Row7Tap1Bot.csv');

%%
pho=1.224; %kg/m^3
pTop=[top.avg_p_];
pBot=[bot.avg_p_];
U=top.avg_U_0__;
pCoeff=(pTop-pBot)./(0.5*pho*U.^2);

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
timeRWDI=dt:dt:78*dt;
figure
plot(timeCFD,pCoeff)
hold on
plot(timeRWDI,data(1,1:78))
legend('CFD','RWDI')
xlabel('Time (s)')
ylabel('Pressure Coefficient')