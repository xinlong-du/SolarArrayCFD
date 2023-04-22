close all; clear; clc;
%% wind tunnel data
filename = '../../../RWDI/Wind Tunnel Data/tilt_n30deg.hdf5';
% h5disp(filename);
info = h5info(filename);
level2 = info.Groups(1);
CpRWDI = h5read(filename,'/WindDir_0deg/Row7');
dtNorm = h5read(filename,'/WindDir_0deg/dtNorm');

%% CFD data
L=4.29895/36; %chord length
U=3;          %wind speed
dtCFD=0.005;  %output time step

p = readtable('./Data/pCopy');
timeCFD=p.Var1;
pTop=p{:,2:29};
pBot=p{:,170:197};
pNet=pTop-pBot;
CpCFD=pNet/(0.5*U^2); %The pressure is kinematic pressure pk=ps/rho (m^2/s^2)

%% compare each pressure tap
dtRWDI=dtNorm*L/U;
for tapID=1:28
    CpRWDItap=CpRWDI(tapID,:);
    CpCFDtap=CpCFD(:,tapID);
    comparePSD(dtRWDI,dtCFD,timeCFD,CpRWDItap,CpCFDtap,tapID)
end

%% function for frequency analysis
function comparePSD(dtRWDI,dtCFD,timeCFD,CpRWDItap,CpCFDtap,tapID)
nfftS=1024*16; % number of Fourier Points (resolution)
%RWDI
Fs=1/dtRWDI;
[SuuRWDI,nRWDI]=periodogram(CpRWDItap,[],'onesided',nfftS,Fs); % Suu: ONE-SIDED PSD, n: frequency, Hz

%CFD
Fs=1/dtCFD;
[SuuCFD,nCFD]=periodogram(CpCFDtap,[],'onesided',nfftS,Fs);

% Plotting PSD data on log-log axes
hfig=figure;
loglog(nRWDI,SuuRWDI)
hold on
loglog(nCFD,SuuCFD)
legend({'RWDI','CFD'},'FontSize',8,'FontName','Times New Roman')
xlabel('Frequency','FontSize',8,'FontName','Times New Roman')
ylabel('Power Spectral Density','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
% save figure
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout=strcat('.\Output\PSDtap',num2str(tapID),'.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');

% plot time series
timeRWDI=dtRWDI:dtRWDI:dtRWDI*round(timeCFD(end)/dtRWDI);
hfig=figure;
plot(timeRWDI,CpRWDItap(1:round(timeCFD(end)/dtRWDI)))
hold on
plot(timeCFD,CpCFDtap)
legend({'RWDI','CFD'},'FontSize',8,'FontName','Times New Roman')
xlabel('Time (s)','FontSize',8,'FontName','Times New Roman')
ylabel('Pressure Coefficient','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
% save figure
figWidth=6;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout=strcat('.\Output\timeSeriesTap',num2str(tapID),'.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');
end