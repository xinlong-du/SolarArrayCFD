close all; clear; clc;
L=4.29895/30;    %chord length
ZrefdL=0.7;
Zref=ZrefdL*L;   %referenceDist
Uref=9;          %referenceValue (m/s)
windProfile=readtable('../../../RWDI/Inflow/windProfile.txt');
ZdL=windProfile.z_L_c;
UdUref=windProfile.U_U_ref;
Iu=windProfile.Iu;
Iv=windProfile.Iv;
Iw=windProfile.Iw;
xLudL=windProfile.xLu_L_c;
xLvdL=windProfile.xLv_L_c;
xLwdL=windProfile.xLw_L_c;

%% UDict
%use alpha from RWDI
alpha=0.15;   %power law
figure
plot(UdUref,ZdL,'o','LineWidth',1)
hold on
x=0.5:0.01:1.4;                                      %U/Uref
plot(x,exp(log(x)/alpha)*ZrefdL,'k','LineWidth',1)   %ZrefdL is used to convert Z/Zref to Z/L
y=0:0.02:4;                                          %Z/L
plot((y/ZrefdL).^alpha,y,'r--','LineWidth',1)        %ZrefdL is used to convert Z/L to Z/Zref
legend('Measured','(Z/Zref)^{0.15}','(Z/Zref)^{0.15}')
legend('Location','Northwest')
xlabel('U/Uref')
ylabel('z/L')
xlim([0.5,1.4])
ylim([0.0,4.0])

%linear regression
ZdZref=ZdL/ZrefdL;
X=log(ZdZref);
Y=log(UdUref);
alphaU=(X'*X)\(X'*Y);
figure
plot(UdUref,ZdL,'o','LineWidth',1)
hold on
x=0.5:0.01:1.4;                                       %U/Uref
plot(x,exp(log(x)/alphaU)*ZrefdL,'k','LineWidth',1)   %ZrefdL is used to convert Z/Zref to Z/L
y=0:0.02:4;                                           %Z/L
plot((y/ZrefdL).^alphaU,y,'r--','LineWidth',1)        %ZrefdL is used to convert Z/L to Z/Zref
legend('Measured','(Z/Zref)^{0.1349}','(Z/Zref)^{0.1349}')
legend('Location','Northwest')
xlabel('U/Uref')
ylabel('z/L')
xlim([0.5,1.4])
ylim([0.0,4.0])
%% RDict
Iuref=(Iu(2)-Iu(1))*(ZrefdL-ZdL(1))/(ZdL(2)-ZdL(1))+Iu(1);
IudIuref=Iu/Iuref;
Y=log(IudIuref);
alphaI=(X'*X)\(X'*Y);

Y=log(Iv);
Ivref=exp(mean(Y-alphaI*X));

Y=log(Iw);
Iwref=exp(mean(Y-alphaI*X));

figure
plot(Iu,ZdL,'bo','LineWidth',1)
hold on
plot(Iv,ZdL,'rsquare','LineWidth',1)
plot(Iw,ZdL,'gv','LineWidth',1)
plot(Iuref*(y/ZrefdL).^alphaI,y,'k','LineWidth',1)
plot(Ivref*(y/ZrefdL).^alphaI,y,'r','LineWidth',1)
plot(Iwref*(y/ZrefdL).^alphaI,y,'g','LineWidth',1)
legend('Measured Iu','Measured Iv','Measured Iw','Iuref*(Z/Zref)^{-0.2254}','Ivref*(Z/Zref)^{-0.2254}','Iwref*(Z/Zref)^{-0.2254}')
legend('Location','Northwest')
xlabel('Turbulence Intensity')
ylabel('z/L')
xlim([0.0,0.25])
ylim([0.0,4.0])

RuuRef=(Iuref*Uref)^2;
RvvRef=(Ivref*Uref)^2;
RwwRef=(Iwref*Uref)^2;
alphaRuu=2*(alphaI+alphaU);
alphaRvv=2*(alphaI+alphaU);
alphaRww=2*(alphaI+alphaU);
%% LDict
meanxLu=mean(xLudL)*L; %unit: m
meanxLv=mean(xLvdL)*L;
meanxLw=mean(xLwdL)*L;