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

%% output L, R, U, and points for inlet
Z=0.984488/183:0.984488/183:0.984488;
Z=Z';

%U
U=Uref*(Z/Zref).^alphaU;
figure
plot(UdUref,ZdL,'o','LineWidth',1)
hold on
x=0.5:0.01:1.4;                                       %U/Uref
plot(x,exp(log(x)/alphaU)*ZrefdL,'k','LineWidth',1)   %ZrefdL is used to convert Z/Zref to Z/L
plot(U/Uref,Z/L,'r--','LineWidth',1)
legend('Measured','(Z/Zref)^{0.1349}','Sampling points')
legend('Location','Northwest')
xlabel('U/Uref')
ylabel('z/L')

%%
Z_test=ZdL*L;
U_test=UdUref*Uref;
logZ=log(Z_test);
P_fit=polyfit(logZ,U_test,1);
a=P_fit(1);
b=P_fit(2);
% Finding the parameters of the log-law model from a,b
u_star_est=a*0.4; % From best-fit expression: u<star>=a*k=a*0.4
z0_est=exp(-b/a); % From best-fit expression: z0=exp(-b/a)
figure
% Plot experimental data and compare them against the model
k=0.4; % Von-Karmann constant
z_model=20*z0_est:0.01:Z_test(end);
U_model=u_star_est/k*log(z_model./z0_est);
plot(U_model,z_model,U_test,Z_test,'rx')
title('\rmProblem 1: log-law wind speed profile')
xlabel('Mean wind speed [m/s]')
ylabel('Elevation [m]')
legend('Model','Experimental data','Location','best')
%%

%R
Ruu=RuuRef*(Z/Zref).^alphaRuu;
Rvv=RvvRef*(Z/Zref).^alphaRvv;
Rww=RwwRef*(Z/Zref).^alphaRww;
Ruv=-u_star_est^2;
figure
plot(Ruu,Z,'r-','LineWidth',1)
hold on
plot(Rvv,Z,'b-','LineWidth',1)
plot(Rww,Z,'m-','LineWidth',1)
xlabel('Ruu')
ylabel('Z')
