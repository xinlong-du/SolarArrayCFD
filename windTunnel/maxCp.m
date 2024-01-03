close all; clear; clc;

maxiCp=zeros(8,1);
maxiCpMean=zeros(8,3);
maxiCpMeanTaps=zeros(8,4);
% inputs
tilt={'n30','p30'};
dir={'0','30','60','90'};
rowID=[1,7];

%% full scale data
in2m=0.0254;   %inch to meter
L=169.25*in2m; %m
U=27.0;        %m/s
rho_air=1.226;

%% wind tunnel data
k=0;
for i=1:2
    for j=1:4
        k=k+1;
        filename = strcat('../../../RWDI/Wind Tunnel Data/tilt_',tilt{i},'deg.hdf5');
        % h5disp(filename);
        info = h5info(filename);
        level2 = info.Groups(1);
        CpRWDI = h5read(filename,strcat('/WindDir_',dir{j},'deg/Row',num2str(rowID(i))));
        CpRWDI = CpRWDI';
        dtNorm = h5read(filename,strcat('/WindDir_',dir{j},'deg/dtNorm'));
        
        CpTopRow1=CpRWDI(:,[9 10 13 14 17 18 21 22]);
        CpTopRow2=CpRWDI(:,[13 14 17 18]);
        CpBotRow1=CpRWDI(:,[11 12 15 16 19 20 23 24]);
        CpBotRow2=CpRWDI(:,[15 16 19 20]);
        CpMeanTopRow1=mean(CpTopRow1,2);
        CpMeanTopRow2=mean(CpTopRow2,2);
        CpMeanBotRow1=mean(CpBotRow1,2);
        CpMeanBotRow2=mean(CpBotRow2,2);
        maxiCp(k)=max(max(abs(CpRWDI)));
        CpMean=mean(CpRWDI,2);
        maxiCpMean(k,1)=max(abs(CpMean));
        maxiCpMeanTaps(k,:)=[max(abs(CpMeanTopRow1)),max(abs(CpMeanTopRow2)),...
            max(abs(CpMeanBotRow1)),max(abs(CpMeanBotRow2))];
        
        dt=dtNorm*L/U;
        dura=dt*length(CpMean);
        maxiCpMean(k,2)=dt;
        maxiCpMean(k,3)=dura;
        
        p=0.5*rho_air*U*U*CpMean;
    end
end