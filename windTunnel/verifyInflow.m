close all; clear; clc;
p=readtable('./Data/Dir0MeshMore/pCopy');
U=readtable('./Data/Dir0MeshMore/UCopy');
Z_CFD=[0.1:0.1:0.9 0.98];

L=4.29895/30;    %chord length
ZrefdL=0.7;
Zref=ZrefdL*L;   %referenceDist
Uref=9;          %referenceValue (m/s)
windProfile=readtable('../../../RWDI/Inflow/windProfile.txt');
ZdL=windProfile.z_L_c;
UdUref=windProfile.U_U_ref;
IuRWDI=windProfile.Iu;
IvRWDI=windProfile.Iv;
IwRWDI=windProfile.Iw;
Z_RWDI=ZdL*L;
U_RWDI=UdUref*Uref;

%%
timeCFD=U.Var1;
Uinlet=U{:,2:11}; %probe locations: +0(x=0.0,y=3.1), +10(x=0.1,y=3.1), +20(x=0.6,y=3.1), +30(x=0.0,y=2.7), +40(x=0.1,y=2.7), +50(x=0.6,y=2.7)
idx=strfind(Uinlet,')');
UxInlet=zeros(size(Uinlet));
UyInlet=zeros(size(Uinlet));
UzInlet=zeros(size(Uinlet));
for i=1:size(Uinlet,1)
    for j=1:size(Uinlet,2)
        Uinlet{i,j}=Uinlet{i,j}(1:idx{i,j}-1);
        Uinlet{i,j}=str2num(Uinlet{i,j});
        UxInlet(i,j)=Uinlet{i,j}(1);
        UyInlet(i,j)=Uinlet{i,j}(2);
        UzInlet(i,j)=Uinlet{i,j}(3);
    end
end
meanUxInlet=mean(UxInlet);
meanUyInlet=mean(UyInlet);
meanUzInlet=mean(UzInlet);
stdUxInlet=std(UxInlet);
stdUyInlet=std(UyInlet);
stdUzInlet=std(UzInlet);
IxCFD=stdUxInlet./meanUxInlet;
%For Ix and Iy, how to calculate turbulence intensity if mean is close to 0?

%%
figure
plot(U_RWDI,Z_RWDI,'k','LineWidth',1)
hold on
plot(meanUxInlet,Z_CFD,'r--','LineWidth',1)
legend({'RWDI mean','CFD mean'},'FontSize',8,'FontName','Times New Roman')
legend('Location','Northwest')
xlabel('U (m/s)','FontSize',8,'FontName','Times New Roman')
ylabel('Z (m)','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')

figure
plot(IuRWDI,Z_RWDI,'k','LineWidth',1)
hold on
plot(IxCFD,Z_CFD,'r--','LineWidth',1)
legend({'RWDI mean','CFD mean'},'FontSize',8,'FontName','Times New Roman')
legend('Location','Northeast')
xlabel('Iu','FontSize',8,'FontName','Times New Roman')
ylabel('Z (m)','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')

Iuref=(IuRWDI(2)-IuRWDI(1))*(ZrefdL-ZdL(1))/(ZdL(2)-ZdL(1))+IuRWDI(1);
IudIuref=IuRWDI/Iuref;
ZdZref=ZdL/ZrefdL;
X=log(ZdZref);
Y=log(UdUref);
alphaU=(X'*X)\(X'*Y);
Y=log(IudIuref);
alphaI=(X'*X)\(X'*Y);
y=0:0.02:7;

hfig=figure;
plot(UdUref,ZdL,'bo','LineWidth',1)
hold on
plot((y/ZrefdL).^alphaU,y,'k','LineWidth',1)
plot(meanUxInlet/Uref,Z_CFD/L,'r--','LineWidth',1)
legend({'Measured','(Z/Zref)^{0.1349}','CFD'},'FontSize',8,'FontName','Times New Roman')
legend('Location','Northwest')
xlabel('U/Uref','FontSize',8,'FontName','Times New Roman')
ylabel('Z/L','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
xlim([0.5,1.4])

% save figure
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout='./Data/Dir0MeshMore/verifyInflow/inflowMean.';
print(hfig,[fileout,'tif'],'-r300','-dtiff');

hfig=figure;
plot(IuRWDI,ZdL,'bo','LineWidth',1)
hold on
plot(Iuref*(y/ZrefdL).^alphaI,y,'k','LineWidth',1)
plot(IxCFD,Z_CFD/L,'r--','LineWidth',1)
legend({'Measured','0.1848*(Z/Zref)^{-0.2254}','CFD'},'FontSize',8,'FontName','Times New Roman')
legend('Location','Southwest')
xlabel('Iu','FontSize',8,'FontName','Times New Roman')
ylabel('Z/L','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
xlim([0.0,0.25])

% save figure
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
fileout='./Data/Dir0MeshMore/verifyInflow/inflowIu.';
print(hfig,[fileout,'tif'],'-r300','-dtiff');