close all; clear; clc;

maximumCp=zeros(8,1);
% inputs
tilt={'n30','p30'};
dir={'0','30','60','90'};
rowID=[1,7];

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

        maximumCp(k)=max(max(abs(CpRWDI)));
    end
end