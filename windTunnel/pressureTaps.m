close all; clear; clc;
L=4.29895/36;
tilt=30/180*pi;
xRefTop=1.941897;
yRefTop=3.142196;
zRefTop=0.042157;
xRefBot=1.942314;
yRefBot=3.142196;
zRefBot=0.041434;
xyzTapTop=tapCoord(L,tilt,xRefTop,yRefTop,zRefTop);
xyzTapBot=tapCoord(L,tilt,xRefBot,yRefBot,zRefBot);
figure
scatter3(xyzTapTop(:,1),xyzTapTop(:,2),xyzTapTop(:,3),'k.')
hold on
scatter3(xyzTapBot(:,1),xyzTapBot(:,2),xyzTapBot(:,3),'r.')
xlabel('X')
ylabel('Y')
zlabel('Z')
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