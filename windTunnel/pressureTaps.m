close all; clear; clc;
L=4.29895/30;
tilt=30/180*pi;
xRefTop=[0.613855;0.900455;1.187055;1.473655;1.760255;2.046855;2.333455];
yRefTop=3.957359;
zRefTop=0.051411;
xRefBot=[0.615305;0.901905;1.188505;1.475105;1.761705;2.048305;2.334905];
yRefBot=3.957359;
zRefBot=0.0489;
xyzTapTop=zeros(28,21);
xyzTapBot=zeros(28,21);

for i=0:6
    xyzTapTop(:,3*i+1:3*i+3)=tapCoord(L,tilt,xRefTop(i+1),yRefTop,zRefTop);
    xyzTapBot(:,3*i+1:3*i+3)=tapCoord(L,tilt,xRefBot(i+1),yRefBot,zRefBot);
end

figure
for i=0:6
    scatter3(xyzTapTop(:,3*i+1),xyzTapTop(:,3*i+2),xyzTapTop(:,3*i+3),'k.')
    hold on
    scatter3(xyzTapBot(:,3*i+1),xyzTapBot(:,3*i+2),xyzTapBot(:,3*i+3),'r.')
end
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal
%% function for calculating tap locations
function xyzTap=tapCoord(L,tilt,xRef,yRef,zRef)
dX=L*repmat([0.125;0.125+0.25;0.125+0.25+0.25;0.125+0.25+0.25+0.25],7,1);
dy=-L*[repmat(0.125,4,1);...
    repmat(0.125+0.5,4,1);...
    repmat(0.125+0.5+0.75,4,1);...
    repmat(0.125+0.5+0.75+1,4,1);...
    repmat(0.125+0.5+0.75+1+1.25,4,1);...
    repmat(0.125+0.5+0.75+1+1.25+1,4,1);...
    repmat(0.125+0.5+0.75+1+1.25+1+0.75,4,1)];
dx=dX*cos(tilt);
dz=dX*sin(tilt);
xTap=xRef+dx;
yTap=yRef+dy;
zTap=zRef+dz;
xyzTap=[xTap,yTap,zTap];
figure
scatter3(xTap,yTap,zTap)
xlabel('X')
ylabel('Y')
zlabel('Z')
end