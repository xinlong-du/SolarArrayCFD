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
IudIuref=Iu/Iu(1);
Y=log(IudIuref);
alphaIu=(X'*X)\(X'*Y);

IvdIvref=Iv/Iv(1);
Y=log(IvdIvref);
alphaIv=(X'*X)\(X'*Y);

IwdIwref=Iw/Iw(1);
Y=log(IwdIwref);
alphaIw=(X'*X)\(X'*Y);

figure
plot(Iu,ZdL,'bo','LineWidth',1)
hold on
plot(Iv,ZdL,'rsquare','LineWidth',1)
plot(Iw,ZdL,'gv','LineWidth',1)
plot(Iu(1)*(y/0.6).^alphaIu,y,'k','LineWidth',1)
plot(Iv(1)*(y/0.6).^alphaIv,y,'r','LineWidth',1)
plot(Iw(1)*(y/0.6).^alphaIw,y,'g','LineWidth',1)
legend('Measured Iu','Measured Iv','Measured Iw','Iu*(Z/Zref)^{-0.2186}','Iv*(Z/Zref)^{-0.1479}','Iw*(Z/Zref)^{0.0172}')
legend('Location','Northwest')
xlabel('U/Uref')
ylabel('z/L')
xlim([0.0,0.25])
ylim([0.0,4.0])

RuuRef=(Iu(1)*Uref)^2;
RvvRef=(Iv(1)*Uref)^2;
RwwRef=(Iw(1)*Uref)^2;
alphaRuu=2*(alphaIu+alphaU);
alphaRvv=2*(alphaIv+alphaU);
alphaRww=2*(alphaIw+alphaU);
%% LDict
meanxLu=mean(xLudL)*L; %unit: m
meanxLv=mean(xLvdL)*L;
meanxLw=mean(xLwdL)*L;