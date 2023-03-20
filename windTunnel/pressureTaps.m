close all; clear; clc;
L=4.29895;
tilt=30/180*pi;
xRefTop=69.90789;
yRefTop=1.517623;
zRefTop=64.540925;
xRefBot=69.92289;
yRefBot=1.491642;
zRefBot=64.540925;
xyzTapTop=tapCoord(L,tilt,xRefTop,yRefTop,zRefTop);
xyzTapBot=tapCoord(L,tilt,xRefBot,yRefBot,zRefBot);
%% function for calculating tap locations
function xyzTap=tapCoord(L,tilt,xRef,yRef,zRef)
dX=L*repmat([0.125;0.125+0.25;0.125+0.25+0.25;0.125+0.25+0.25+0.25],7,1);
dz=L*[repmat(0.125,4,1);...
    repmat(0.125+0.5,4,1);...
    repmat(0.125+0.5+0.75,4,1);...
    repmat(0.125+0.5+0.75+1,4,1);...
    repmat(0.125+0.5+0.75+1+1.25,4,1);...
    repmat(0.125+0.5+0.75+1+1.25+1,4,1);...
    repmat(0.125+0.5+0.75+1+1.25+1+0.75,4,1)];
dx=dX*cos(tilt);
dy=dX*sin(tilt);
xTap=xRef+dx;
yTap=yRef+dy;
zTap=zRef+dz;
xyzTap=[xTap,yTap,zTap];
%scatter3(xTap,zTap,yTap)
end