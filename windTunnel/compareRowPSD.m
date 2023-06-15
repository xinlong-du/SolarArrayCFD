close all; clear; clc;
%% wind tunnel data
filename = '../../../RWDI/Wind Tunnel Data/tilt_n30deg.hdf5';
% h5disp(filename);
info = h5info(filename);
level2 = info.Groups(1);
CpRWDIrow1 = h5read(filename,'/WindDir_0deg/Row1');
CpRWDIrow1 = CpRWDIrow1';
CpRWDIrow2 = h5read(filename,'/WindDir_0deg/Row2');
CpRWDIrow2 = CpRWDIrow2';
dtNorm = h5read(filename,'/WindDir_0deg/dtNorm');

%% structure info
L=4.29895/30; %chord length
U=9;          %wind speed
dtRWDI=dtNorm*L/U;

%% compare PSD
%only use 15s data from RWDI, note that dtRWDI=dtCFD
CpRWDIrow1=CpRWDIrow1(length(CpRWDIrow1)/2-7500/2+1:length(CpRWDIrow1)/2+7500/2,:);
CpRWDIrow2=CpRWDIrow2(length(CpRWDIrow2)/2-7500/2+1:length(CpRWDIrow2)/2+7500/2,:);
tapID=1;
CpRWDIrow1tap=CpRWDIrow1(:,tapID);
CpRWDIrow2tap=CpRWDIrow2(:,tapID);

nfftS=1024*16; % number of Fourier Points (resolution)
%RWDI
Fs=1/dtRWDI;
[SuuRWDIrow1,nRWDIrow1]=periodogram(CpRWDIrow1tap,[],'onesided',nfftS,Fs); % Suu: ONE-SIDED PSD, n: frequency, Hz
[SuuRWDIrow2,nRWDIrow2]=periodogram(CpRWDIrow2tap,[],'onesided',nfftS,Fs); % Suu: ONE-SIDED PSD, n: frequency, Hz

% Plotting PSD data on log-log axes
hfig=figure;
loglog(nRWDIrow1,SuuRWDIrow1)
hold on
loglog(nRWDIrow2,SuuRWDIrow2)
legend({'RWDI row1','RWDI row2'},'FontSize',8,'FontName','Times New Roman')
xlabel('Frequency','FontSize',8,'FontName','Times New Roman')
ylabel('Power Spectral Density','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')

SuuRWDIrow1Mrow2=SuuRWDIrow1-SuuRWDIrow2;
hfig=figure;
plot(nRWDIrow1,SuuRWDIrow1Mrow2)
legend({'RWDI row1 - row2'},'FontSize',8,'FontName','Times New Roman')
xlabel('Frequency','FontSize',8,'FontName','Times New Roman')
ylabel('Power Spectral Density','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
xlim([1,20])
