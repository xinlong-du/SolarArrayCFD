close all; clear; clc;
rowI=1;
rowJ=7;
%% wind tunnel data
filename = '../../../RWDI/Wind Tunnel Data/tilt_n30deg.hdf5';
% h5disp(filename);
info = h5info(filename);
level2 = info.Groups(1);
CpRWDIrowI = h5read(filename,strcat('/WindDir_0deg/Row',num2str(rowI)));
CpRWDIrowI = CpRWDIrowI';
CpRWDIrowJ = h5read(filename,strcat('/WindDir_0deg/Row',num2str(rowJ)));
CpRWDIrowJ = CpRWDIrowJ';
dtNorm = h5read(filename,'/WindDir_0deg/dtNorm');

%% structure info
L=4.29895/30; %chord length
U=9;          %wind speed
dtRWDI=dtNorm*L/U;

%% compare PSD
%only use 15s data from RWDI, note that dtRWDI=dtCFD
CpRWDIrowI=CpRWDIrowI(length(CpRWDIrowI)/2-7500/2+1:length(CpRWDIrowI)/2+7500/2,:);
CpRWDIrowJ=CpRWDIrowJ(length(CpRWDIrowJ)/2-7500/2+1:length(CpRWDIrowJ)/2+7500/2,:);
for tapID=1:28
    CpRWDIrowItap=CpRWDIrowI(:,tapID);
    CpRWDIrowJtap=CpRWDIrowJ(:,tapID);
    comparePSDrow(rowI,rowJ,CpRWDIrowItap,CpRWDIrowJtap,dtRWDI,tapID)
end

meanTableRowI=mean(CpRWDIrowI,2);
meanTableRowJ=mean(CpRWDIrowJ,2);
comparePSDrow(rowI,rowJ,meanTableRowI,meanTableRowJ,dtRWDI,999)

function comparePSDrow(rowI,rowJ,PSDrowI,PSDrowJ,dtRWDI,tapID)
nfftS=1024*16; % number of Fourier Points (resolution)
%RWDI
Fs=1/dtRWDI;
[SuuRWDIrow1,nRWDIrow1]=periodogram(PSDrowI,[],'onesided',nfftS,Fs); % Suu: ONE-SIDED PSD, n: frequency, Hz
[SuuRWDIrow2,nRWDIrow2]=periodogram(PSDrowJ,[],'onesided',nfftS,Fs); % Suu: ONE-SIDED PSD, n: frequency, Hz

% Plotting PSD data on log-log axes
hfig=figure;
loglog(nRWDIrow1,SuuRWDIrow1)
hold on
loglog(nRWDIrow2,SuuRWDIrow2)
legend({strcat('RWDI row',num2str(rowI)),strcat('RWDI row',num2str(rowJ))},'FontSize',8,'FontName','Times New Roman')
xlabel('Frequency','FontSize',8,'FontName','Times New Roman')
ylabel('Power Spectral Density','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
% save figure
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout=strcat('.\Output\compareRowPSD\PSD',num2str(rowI),'and',num2str(rowJ),'tap',num2str(tapID),'.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');

SuuRWDIrow1Mrow2=SuuRWDIrow1-SuuRWDIrow2;
hfig=figure;
plot(nRWDIrow1,SuuRWDIrow1Mrow2)
legend({strcat('RWDI row',num2str(rowI),' - row',num2str(rowJ))},'FontSize',8,'FontName','Times New Roman')
xlabel('Frequency','FontSize',8,'FontName','Times New Roman')
ylabel('Power Spectral Density','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
xlim([1,20])
% save figure
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout=strcat('.\Output\compareRowPSD\PSDdiff',num2str(rowI),'and',num2str(rowJ),'tap',num2str(tapID),'.');
print(hfig,[fileout,'tif'],'-r300','-dtiff');
end
