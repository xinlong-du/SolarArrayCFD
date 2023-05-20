close all; clear; clc;
p=readtable('./Data/pCopy');
U=readtable('./Data/UCopy');
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
Uinlet=U{:,2:11};
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
IyCFD=stdUyInlet; %how to calculate turbulence intensity if mean is close to 0
IzCFD=stdUzInlet;
%%
figure
plot(U_RWDI,Z_RWDI)
hold on
plot(meanUxInlet,Z_CFD)
legend('RWDI','CFD')

figure
plot(IuRWDI,Z_RWDI)
hold on
plot(IxCFD,Z_CFD)
legend('RWDI','CFD')