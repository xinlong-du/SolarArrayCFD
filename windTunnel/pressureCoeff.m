close all; clear; clc;
% inputs
tilt='p30';
dir='0';
rowID=1;

%% wind tunnel data
filename = strcat('../../../RWDI/Wind Tunnel Data/tilt_',tilt,'deg.hdf5');
% h5disp(filename);
info = h5info(filename);
level2 = info.Groups(1);
CpRWDI = h5read(filename,strcat('/WindDir_',dir,'deg/Row',num2str(rowID)));
CpRWDI = CpRWDI';
dtNorm = h5read(filename,strcat('/WindDir_',dir,'deg/dtNorm'));

%% CFD data
L=4.29895/30; %chord length
U=9;          %wind speed
dtCFD=0.002;  %output time step
CFDname=strcat('./Data/',tilt,'Dir',dir,'MeshMore/pCopy');
p = readtable(CFDname);
timeCFD=p.Var1;
timeCFD=timeCFD(1:7500); %remove data of the first 5s
% pTop=p{:,338:365};
% pBot=p{:,366:393};
% pTop=p{:,2:29};
% pBot=p{:,30:57};
pTopSta=60+2+(rowID-1)*56;
pTopEnd=60+2+(rowID-1)*56+27;
pBotSta=60+30+(rowID-1)*56;
pBotEnd=60+30+(rowID-1)*56+27;
pTop=p{:,pTopSta:pTopEnd};
pBot=p{:,pBotSta:pBotEnd};
pNet=pTop-pBot;
pNet=pNet(2501:end,:);   %remove data of the first 5s
CpCFD=pNet/(0.5*U^2); %The pressure is kinematic pressure pk=ps/rho (m^2/s^2)

%% compare Cp at each pressure tap and mean
% %two-sample t test to see if RWDI and CFD have the same mean
% %h=0 for the same mean, h=1 for not the same mean
% %this requres data in CpRWDItap is independent
% hp=zeros(28,2);
% for tapID=1:28
%     CpRWDItap=CpRWDI(:,tapID);
%     CpCFDtap=CpCFD(:,tapID);
%     [hp(tapID,1),hp(tapID,2),ci,stats] = ttest2(CpRWDItap,CpCFDtap);
%     %[hp(tapID,1),hp(tapID,2),ci,stats] = ttest2(CpRWDItap,CpCFDtap,'Vartype','unequal');
% end

dtRWDI=dtNorm*L/U;
%only use 15s data from RWDI, note that dtRWDI=dtCFD
CpRWDI=CpRWDI(length(CpRWDI)/2-7500/2+1:length(CpRWDI)/2+7500/2,:);
for tapID=1:28
    CpRWDItap=CpRWDI(:,tapID);
    CpCFDtap=CpCFD(:,tapID);
    comparePSD(dtRWDI,dtCFD,timeCFD,CpRWDItap,CpCFDtap,tapID,rowID,dir,tilt)
end
meanTapsRWDI=mean(CpRWDI,1);
meanTapsCFD=mean(CpCFD,1);
stdTapsRWDI=std(CpRWDI);
stdTapsCFD=std(CpCFD);
meanRWDI=mean(meanTapsRWDI);
meanCFD=mean(meanTapsCFD);
hfig=figure;
plot(1:28,meanTapsRWDI,'kx-')
hold on
plot(1:28,meanTapsCFD,'rx-')
plot(1:28,meanTapsRWDI+stdTapsRWDI,'k--')
plot(1:28,meanTapsCFD+stdTapsCFD,'r--')
plot(1:28,meanTapsRWDI-stdTapsRWDI,'k--')
plot(1:28,meanTapsCFD-stdTapsCFD,'r--')
% legend({'RWDI mean','CFD mean'},'FontSize',8,'FontName','Times New Roman')
legend({'RWDI mean','CFD mean','RWDI mean+/-std','CFD mean+/-std'},'FontSize',8,'FontName','Times New Roman')
xlabel('Tap ID','FontSize',8,'FontName','Times New Roman')
ylabel('Cp','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
xlim([1 28])
%ylim([-0.2 2.2])
xticks(1:3:28)
% save figure
figWidth=6;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout=strcat('.\Data\',tilt,'Dir',dir,'MeshMore\Scale30Row',num2str(rowID),'\0scale30row',num2str(rowID),'meanStdTaps.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');

%mean for a table
meanTableRWDI=mean(CpRWDI,2);
meanTableCFD=mean(CpCFD,2);
stdTableRWDI=std(meanTableRWDI);
stdTableCFD=std(meanTableCFD);
comparePSD(dtRWDI,dtCFD,timeCFD,meanTableRWDI,meanTableCFD,999,rowID,dir,tilt)

for tapID=1:28
CpRWDICFD=[CpRWDI(:,tapID);CpCFD(:,tapID)];
g=[repmat({'RWDI'},length(CpRWDI),1);repmat({'CFD'},length(CpCFD),1)];
hfig=figure;
boxplot(CpRWDICFD,g)
ylabel('Cp','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
% save figure
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout=strcat('.\Data\',tilt,'Dir',dir,'MeshMore\Scale30Row',num2str(rowID),'\scale30row',num2str(rowID),'boxplotTap',num2str(tapID),'.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');
end

%% function for frequency analysis
function comparePSD(dtRWDI,dtCFD,timeCFD,CpRWDItap,CpCFDtap,tapID,rowID,dir,tilt)
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
fileout=strcat('.\Data\',tilt,'Dir',dir,'MeshMore\Scale30Row',num2str(rowID),'\scale30row',num2str(rowID),'PSDtap',num2str(tapID),'.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');

% Plotting PSD data on log-log axes (1 to 20 Hz)
hfig=figure;
loglog(nRWDI,SuuRWDI)
hold on
loglog(nCFD,SuuCFD)
xlim([1,20])
ylim([1e-6,1])
legend({'RWDI','CFD'},'FontSize',8,'FontName','Times New Roman')
xlabel('Frequency','FontSize',8,'FontName','Times New Roman')
ylabel('Power Spectral Density','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
% save figure
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout=strcat('.\Data\',tilt,'Dir',dir,'MeshMore\Scale30Row',num2str(rowID),'\scale30row',num2str(rowID),'PSD1to20Hztap',num2str(tapID),'.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');

% plot time series
timeRWDI=dtRWDI:dtRWDI:dtRWDI*round(timeCFD(end)/dtRWDI);
hfig=figure;
plot(timeRWDI,CpRWDItap(1:round(timeCFD(end)/dtRWDI)))
hold on
plot(timeCFD,CpCFDtap)
xlim([0 timeCFD(end)])
legend({'RWDI','CFD'},'FontSize',8,'FontName','Times New Roman')
xlabel('Time (s)','FontSize',8,'FontName','Times New Roman')
ylabel('Pressure Coefficient','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
% save figure
figWidth=6;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout=strcat('.\Data\',tilt,'Dir',dir,'MeshMore\Scale30Row',num2str(rowID),'\scale30row',num2str(rowID),'timeSeriesTap',num2str(tapID),'.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');
end