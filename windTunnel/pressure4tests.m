close all; clear; clc;
% inputs
tilt='n30';
dir='0';
rowID=1;
tapIDlow=15;
tapIDhigh=16;

%% wind tunnel data
filename = strcat('../../../RWDI/Wind Tunnel Data/tilt_',tilt,'deg.hdf5');
% h5disp(filename);
info = h5info(filename);
level2 = info.Groups(1);
CpRWDI = h5read(filename,strcat('/WindDir_',dir,'deg/Row',num2str(rowID)));
CpRWDI = CpRWDI';
dtNorm = h5read(filename,strcat('/WindDir_',dir,'deg/dtNorm'));

%% plot
L=4.29895/30; %chord length
U=9;          %wind speed
dtRWDI=dtNorm*L/U;
CpRWDI=CpRWDI(length(CpRWDI)/2-7500/2+1:length(CpRWDI)/2+7500/2,:);
timeRWDI=dtRWDI:dtRWDI:dtRWDI*7500;

hfig=figure;
plot(timeRWDI,CpRWDI(1:7500,tapIDlow))
hold on
plot(timeRWDI,CpRWDI(1:7500,tapIDhigh))
xlim([0 15])
legend({'Tap 15','Tap 16'},'FontSize',8,'FontName','Times New Roman')
xlabel('Time (s)','FontSize',8,'FontName','Times New Roman')
ylabel('Pressure Coefficient','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')

%% plot force and moment
force=(CpRWDI(1:7500,tapIDlow)+CpRWDI(1:7500,tapIDhigh))/2;
moment1=CpRWDI(1:7500,tapIDlow)-force;
moment2=force-CpRWDI(1:7500,tapIDhigh);
dist=moment1./force;

figure
subplot(3,1,1)
plot(timeRWDI,force)
xlim([0 15])
xlabel('Time (s)','FontSize',8,'FontName','Times New Roman')
ylabel('Force','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
subplot(3,1,2)
plot(timeRWDI,moment1)
xlim([0 15])
xlabel('Time (s)','FontSize',8,'FontName','Times New Roman')
ylabel('Moment','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
subplot(3,1,3)
plot(timeRWDI,dist)
xlim([0 15])
ylim([-1 1])
yticks(-1:0.5:1)
xlabel('Time (s)','FontSize',8,'FontName','Times New Roman')
ylabel('Distance','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')