close all; clear; clc;
%% inputs
L=4.29895/30;
twoL=0.286600; %exact in the .STL file
tilt=-30/180*pi;

if tilt<0
% orient=0 deg
% orient=0/180*pi;
% xyzRefTop=[0.613855,3.957359,0.051412];
% xyzRefBot=[0.615305,3.957359,0.048899];

% orient=30 deg
% orient=30/180*pi;
% xyzRefTop=[0.615305,3.387605,0.051412]; %z=0.051411 in the .STL file
% xyzRefBot=[0.616561,3.388330,0.048899]; %z=0.0489 in the .STL file

% orient=60 deg
% orient=60/180*pi;
% xyzRefTop=[0.615305,2.753585,0.051412]; %z=0.051411 in the .STL file
% xyzRefBot=[0.616030,2.754841,0.048899]; %z=0.0489 in the .STL file

% orient=90 deg
orient=90/180*pi;
xyzRefTop=[0.615305,2.224459,0.051412]; %z=0.051411 in the .STL file
xyzRefBot=[0.615305,2.225909,0.048899]; %z=0.0489 in the .STL file

else
    % orient=0 deg
    % orient=0/180*pi;
    % xyzRefTop=[0.613855,3.957359,0.051412];
    % xyzRefBot=[0.615305,3.957359,0.048899];
end

%% calulate probe locations
xyzTapTop=zeros(28,21);
xyzTapBot=zeros(28,21);
xyzNoTapTop=zeros(28,21);
xyzNoTapBot=zeros(28,21);

for i=0:6
    xyzTapTop(:,3*i+1:3*i+3)=tapCoord(i,L,twoL,tilt,orient,xyzRefTop,1);
    xyzTapBot(:,3*i+1:3*i+3)=tapCoord(i,L,twoL,tilt,orient,xyzRefBot,1);
    xyzNoTapTop(:,3*i+1:3*i+3)=tapCoord(i,L,twoL,tilt,orient,xyzRefTop,0);
    xyzNoTapBot(:,3*i+1:3*i+3)=tapCoord(i,L,twoL,tilt,orient,xyzRefBot,0);
end

figure
for i=0:6
    scatter3(xyzTapTop(:,3*i+1),xyzTapTop(:,3*i+2),xyzTapTop(:,3*i+3),'k.')
    hold on
    scatter3(xyzTapBot(:,3*i+1),xyzTapBot(:,3*i+2),xyzTapBot(:,3*i+3),'r.')
    scatter3(xyzNoTapTop(:,3*i+1),xyzNoTapTop(:,3*i+2),xyzNoTapTop(:,3*i+3),'k.')
    scatter3(xyzNoTapBot(:,3*i+1),xyzNoTapBot(:,3*i+2),xyzNoTapBot(:,3*i+3),'r.')
end
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal

%% write probe locations
if tilt<0
fileName=strcat('../RWDItestOF7Dir/RWDItestOF7Dir',num2str(orient/pi*180),'/motorBike/system/probes');
else
    fileName=strcat('../RWDItestOF7Dir/RWDItestOF7P30Dir',num2str(orient/pi*180),'/motorBike/system/probes');
end
fileID=fopen(fileName,'w');
fprintf(fileID,'%14s\n','probeLocations');
fprintf(fileID,'%1s\n','(');
fprintf(fileID,'%1s\n','// probes at inlet to check simulation of turbulent inflow');
for i=1:9
    fprintf(fileID,'    %1s%2.1f %8.6f %2.1f%1s\n','(',0.0,3.147759,i/10,')');
end
fprintf(fileID,'    %1s%2.1f %8.6f %4.2f%1s\n','(',0.0,3.147759,0.98,')');
for i=1:9
    fprintf(fileID,'    %1s%2.1f %8.6f %2.1f%1s\n','(',0.1,3.147759,i/10,')');
end
fprintf(fileID,'    %1s%2.1f %8.6f %4.2f%1s\n','(',0.1,3.147759,0.98,')');
fprintf(fileID,'%1s\n','// probles incident to array');
for i=1:9
    fprintf(fileID,'    %1s%2.1f %8.6f %2.1f%1s\n','(',0.6,3.147759,i/10,')');
end
fprintf(fileID,'    %1s%2.1f %8.6f %4.2f%1s\n','(',0.6,3.147759,0.98,')');

fprintf(fileID,'%1s\n','// probes at inlet to check simulation of turbulent inflow');
for i=1:9
    fprintf(fileID,'    %1s%2.1f %3.1f %2.1f%1s\n','(',0.0,2.7,i/10,')');
end
fprintf(fileID,'    %1s%2.1f %3.1f %4.2f%1s\n','(',0.0,2.7,0.98,')');
for i=1:9
    fprintf(fileID,'    %1s%2.1f %3.1f %2.1f%1s\n','(',0.1,2.7,i/10,')');
end
fprintf(fileID,'    %1s%2.1f %3.1f %4.2f%1s\n','(',0.1,2.7,0.98,')');
fprintf(fileID,'%1s\n','// probles incident to array');
for i=1:9
    fprintf(fileID,'    %1s%2.1f %3.1f %2.1f%1s\n','(',0.6,2.7,i/10,')');
end
fprintf(fileID,'    %1s%2.1f %3.1f %4.2f%1s\n','(',0.6,2.7,0.98,')');

for i = 0:6
    fprintf(fileID,'%6s %1i%1s\n','// table with pressure taps, row',i+1,', top of the panel');
    for j=1:28
        fprintf(fileID,'    %1s%18.16f %18.16f %18.16f%1s\n','(',xyzTapTop(j,3*i+1:3*i+3),')');
    end
    
    fprintf(fileID,'%6s %1i%1s\n','// table with pressure taps, row',i+1,', bottom of the panel');
    for j=1:28
        fprintf(fileID,'    %1s%18.16f %18.16f %18.16f%1s\n','(',xyzTapBot(j,3*i+1:3*i+3),')');
    end
end

for i = 0:6
    fprintf(fileID,'%6s %1i%1s\n','// table without pressure taps, row',i+1,', top of the panel');
    for j=1:28
        fprintf(fileID,'    %1s%18.16f %18.16f %18.16f%1s\n','(',xyzNoTapTop(j,3*i+1:3*i+3),')');
    end
    
    fprintf(fileID,'%6s %1i%1s\n','// table without pressure taps, row',i+1,', bottom of the panel');
    for j=1:28
        fprintf(fileID,'    %1s%18.16f %18.16f %18.16f%1s\n','(',xyzNoTapBot(j,3*i+1:3*i+3),')');
    end
end

fprintf(fileID,'%1s',');');
fclose(fileID);

%% function for calculating tap locations
function xyzTap=tapCoord(rowID,L,twoL,tilt,orient,xyzRef,tapFlag)
dX=L*repmat([0.125;0.125+0.25;0.125+0.25+0.25;0.125+0.25+0.25+0.25],7,1);
dy=L*[repmat(0.125,4,1);...
    repmat(0.125+0.5,4,1);...
    repmat(0.125+0.5+0.75,4,1);...
    repmat(0.125+0.5+0.75+1,4,1);...
    repmat(0.125+0.5+0.75+1+1.25,4,1);...
    repmat(0.125+0.5+0.75+1+1.25+1,4,1);...
    repmat(0.125+0.5+0.75+1+1.25+1+0.75,4,1)];
if tapFlag==0
    dy=11.3*L-dy; %11.3*L=1.6192 in the geometry model
end
dx=dX*cos(tilt)+rowID*twoL;
dz=-dX*sin(tilt);
dxRot=dx*cos(orient)+dy*sin(orient);
dyRot=-(dy*cos(orient)-dx*sin(orient));
xTap=xyzRef(1)+dxRot;
yTap=xyzRef(2)+dyRot;
zTap=xyzRef(3)+dz;
xyzTap=[xTap,yTap,zTap];
figure
scatter3(xTap,yTap,zTap)
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal
end