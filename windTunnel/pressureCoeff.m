close all; clear; clc;
%% wind tunnel data
filename = '../../../RWDI/Wind Tunnel Data/tilt_n30deg.hdf5';
% h5disp(filename);
info = h5info(filename);
level2 = info.Groups(1);
data = h5read(filename,'/WindDir_0deg/Row7');
dtNorm = h5read(filename,'/WindDir_0deg/dtNorm');

%% CFD data
tap1Top = readtable('tilt_n30Azim0Row7Tap1Top.csv');
tap1Bot = readtable('tilt_n30Azim0Row7Tap1Bot.csv');
tap2Top = readtable('tilt_n30Azim0Row7Tap2Top.csv');
tap2Bot = readtable('tilt_n30Azim0Row7Tap2Bot.csv');
tap3Top = readtable('tilt_n30Azim0Row7Tap3Top.csv');
tap3Bot = readtable('tilt_n30Azim0Row7Tap3Bot.csv');
tap4Top = readtable('tilt_n30Azim0Row7Tap4Top.csv');
tap4Bot = readtable('tilt_n30Azim0Row7Tap4Bot.csv');
tap5Top = readtable('tilt_n30Azim0Row7Tap5Top.csv');
tap5Bot = readtable('tilt_n30Azim0Row7Tap5Bot.csv');
tap6Top = readtable('tilt_n30Azim0Row7Tap6Top.csv');
tap6Bot = readtable('tilt_n30Azim0Row7Tap6Bot.csv');
tap7Top = readtable('tilt_n30Azim0Row7Tap7Top.csv');
tap7Bot = readtable('tilt_n30Azim0Row7Tap7Bot.csv');
tap8Top = readtable('tilt_n30Azim0Row7Tap8Top.csv');
tap8Bot = readtable('tilt_n30Azim0Row7Tap8Bot.csv');

[pCoeff(:,1),meanRWDI(1),meanCFD(1)]=calpCoeff(tap1Top,tap1Bot,data,dtNorm,1);
[pCoeff(:,2),meanRWDI(2),meanCFD(2)]=calpCoeff(tap2Top,tap2Bot,data,dtNorm,2);
[pCoeff(:,3),meanRWDI(3),meanCFD(3)]=calpCoeff(tap3Top,tap3Bot,data,dtNorm,3);
[pCoeff(:,4),meanRWDI(4),meanCFD(4)]=calpCoeff(tap4Top,tap4Bot,data,dtNorm,4);
[pCoeff(:,5),meanRWDI(5),meanCFD(5)]=calpCoeff(tap5Top,tap5Bot,data,dtNorm,5);
[pCoeff(:,6),meanRWDI(6),meanCFD(6)]=calpCoeff(tap6Top,tap6Bot,data,dtNorm,6);
[pCoeff(:,7),meanRWDI(7),meanCFD(7)]=calpCoeff(tap7Top,tap7Bot,data,dtNorm,7);
[pCoeff(:,8),meanRWDI(8),meanCFD(8)]=calpCoeff(tap8Top,tap8Bot,data,dtNorm,8);
%%
tapIDs=1:8;
figure
plot(tapIDs,meanRWDI)
hold on
plot (tapIDs,meanCFD)
xlabel('Pressure tap ID')
ylabel('Pressure coefficient')
legend('RWDI','CFD')
%% mean over space
mean2RWDI=mean(meanRWDI);
mean2CFD=mean(meanCFD);
%%
function [pCoeff,meanRWDI,meanCFD]=calpCoeff(top,bot,data,dtNorm,tapID)
rho=1.0; %The pressure is kinematic pressure pk=ps/rho (m^2/s^2)
pTop=[top.avg_p_];
pBot=[bot.avg_p_];
% U=top.avg_U_0__;
U=18;
pCoeff=(pTop-pBot)./(0.5*rho*U.^2);

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

%% statistics
meanRWDI=mean(data(tapID,:));
meanCFD=mean(pCoeff);
figure
plot(dt:dt:length(data)*dt,data(tapID,:))
legend('CFD','RWDI')
xlabel('Time (s)')
ylabel('Pressure Coefficient')
end