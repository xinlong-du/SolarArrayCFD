close all; clear; clc;
L=4.29895/36;    %chord length
Zref=0.6*L;   %referenceDist
Uref=3;       %referenceValue 18/6=3m/s
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
x=0.5:0.01:1.4;                                 %U/Uref
plot(x,exp(log(x)/alpha)*0.6,'k','LineWidth',1) %0.6 is used to convert Z/Zref to Z/L
y=0:0.02:4;                                     %Z/L
plot((y/0.6).^alpha,y,'r--','LineWidth',1)      %0.6 is used to convert Z/L to Z/Zref
legend('Measured','(Z/Zref)^{0.15}')
legend('Location','Northwest')
xlabel('U/Uref')
ylabel('z/L')
xlim([0.5,1.4])
ylim([0.0,4.0])

%linear regression
ZdZref=ZdL/0.6;
X=log(ZdZref);
Y=log(UdUref);
alphaU=(X'*X)\(X'*Y);
figure
plot(UdUref,ZdL,'o','LineWidth',1)
hold on
x=0.5:0.01:1.4;                                  %U/Uref
plot(x,exp(log(x)/alphaU)*0.6,'k','LineWidth',1) %0.6 is used to convert Z/Zref to Z/L
y=0:0.02:4;                                      %Z/L
plot((y/0.6).^alphaU,y,'r--','LineWidth',1)      %0.6 is used to convert Z/L to Z/Zref
legend('Measured','(Z/Zref)^{0.1187}')
legend('Location','Northwest')
xlabel('U/Uref')
ylabel('z/L')
xlim([0.5,1.4])
ylim([0.0,4.0])
%% RDict
ZrefI=0.62*L;
ZdZrefI=ZdL/0.62;
X=log(ZdZrefI);
IudIuref=Iu/Iu(1);
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
plot(Iu(1)*(y/0.62).^alphaI,y,'k','LineWidth',1)
plot(Ivref*(y/0.62).^alphaI,y,'r','LineWidth',1)
plot(Iwref*(y/0.62).^alphaI,y,'g','LineWidth',1)
legend('Measured Iu','Measured Iv','Measured Iw','Iuref*(Z/Zref)^{-0.2243}','Ivref*(Z/Zref)^{-0.2243}','Iwref*(Z/Zref)^{-0.2243}')
legend('Location','Northwest')
xlabel('Turbulence Intensity')
ylabel('z/L')
xlim([0.0,0.25])
ylim([0.0,4.0])

RuuRef=(Iu(1)*Uref)^2;
RvvRef=(Ivref*Uref)^2;
RwwRef=(Iwref*Uref)^2;
alphaRuu=2*(alphaI+alphaU);
alphaRvv=2*(alphaI+alphaU);
alphaRww=2*(alphaI+alphaU);
%% LDict
meanxLu=mean(xLudL)*L; %unit: m
meanxLv=mean(xLvdL)*L;
meanxLw=mean(xLwdL)*L;