im1s_compare = 'g3e3f3e3g2e3f3a2b2C3c3g3e3f3e3g2e3nf3a2b2C3c3e2g2g2f2a2A2d3d3g2e3c3nf3d3g3a2b2C3c3C3c3';
im3s_compare = 'G3g3a3G3E3e3f3E3D3d3e3d3b2c3d3e3f3G3nG3g3a3G3D3g3a3B3C4E3F3G3nc3c3c3d3e3d3c3d3E3C3d3d3d3e3f3e3d3e3F3D3ne3f3G3f3e3f3g3A3g3f3g3a3B3a3g3C4C4';
im5s_compare = 'd3b2d3g3d3b2d3b2g2f2a2d2f2a2c3e3c3a2f2d2f2g2d2g2b2d3b2g3d3b2d3b2g2nf2a2d2f2a2c3e3c3a2f2d2f2G2a2d3f3c3e3a2c3e3c3d3f3a2d3f3d3ne3g3e3c3a2c3d3f3a3g3b3a3c3e3a2c3e3c3d3f3a2d3f3d3e3g3b3g3e3c3D3';
im8s_compare = 'C2F2A2F2b2a2g2f2E2G2E2nC2F2A2F2b2a2g2f2E2G2C2E2nA2a2a2A2A2B2a2a2G2g2g2G2f2f2E2F2nA2a2a2A2A2B2A2G2G2F2E2';
im9s_compare = 'b2d3G3C4D3e3c3b2d3b3c4C4A3F3D3G2c3na3b3C4C4C4a3g3B3B3C4E3F3G3E3b2d3nG3C4D3e3c3b2d3a3c4C4A3F3D3';
im6s_compare = 'G2g2G2G2F2G2F2G2nG2g2G2G2F2G2nG2g2G2G2F2G2F2A2nG2g2G2G2F2G2nD2C3b2a2B2C3nA2G2F2F2nD2C3b2a2B2C3nA2G2F2G2F2A2';
im10s_compare = 'D3B3d3e3G3f3a3C4f3g3B3a3G3e3f3D3e3c3nC3f3D3f3g3C4g3f3E3g3c4C4a3g3nF3e3d3E3d3c3D3c3b2C3a2c3F3d3C3e3f3F3E3nC3A3c3e3G3f3a3C4f3g3A3b3G3e3f3D3e3c3nC3A3c3e3G3f3a3C4f3g3A3G3e3f3D3e3c3ng3f3E3g3b3C4a3g3F3e3d3E3d3c3nD3c3b2C3a2c3F3d3C3F3E3';
im13s_compare = 'f3c3c3f3g3c3c3g3a3f3a3g3c3c3a3a3g3a3a3d3d3nf3d3f3d3g3e3g3e3b3g3b3g3nE3c3f3a2b2f3c3e3F3g3c3c3f3g3c3d3a3a3d3d3a3ng3c3C3g3f2d3g3f2e3f3d3f3d3nf3b2g2C3C3B2';

close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%easy pictures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scanFiles = [];
photFiles = [];
%########## Dance %%%%%%%%%%%%%%%%%%%%%%%%%%%% 1
file = {'Images_Training/im1s.jpg'};scanFiles = [scanFiles; file];
file = {'Not existent   /im1c.jpg'};photFiles = [photFiles; file];

%########## Julpolska %%%%%%%%%%%%%%%%%%%%%%%% 2
file = {'Images_Training/im3s.jpg'};scanFiles = [scanFiles; file];
file = {'Images_Training/im3c.jpg'};photFiles = [photFiles; file];

%########## Allegro %%%%%%%%%%%%%%%%%%%%%%%%%% 3
file = {'Images_Training/im5s.jpg'};scanFiles = [scanFiles; file];
file = {'Not existent   /im5c.jpg'};photFiles = [photFiles; file];

%########## Pippi Langstrumpf %%%%%%%%%%%%%%%% 4
file = {'Images_Training/im8s.jpg'};scanFiles = [scanFiles; file];
file = {'Images_Training/im8c.jpg'};photFiles = [photFiles; file];

%########## Bred dina varingar %%%%%%%%%%%%%%% 5
file = {'Images_Training/im9s.jpg'};scanFiles = [scanFiles; file];
file = {'Images_Training/im9c.jpg'};photFiles = [photFiles; file];

%########## Titanic %%%%%%%%%%%%%%%%%%%%%%%%%% 6
file = {'Images_Training/im6s.jpg'};scanFiles = [scanFiles; file];
file = {'Images_Training/im6c.jpg'};photFiles = [photFiles; file];

%########## Naer det lider mot jul %%%%%%%%%%% 7
file = {'Images_Training/im10s.jpg'};scanFiles = [scanFiles; file];
file = {'Images_Training/im10c.jpg'};photFiles = [photFiles; file];

%########## Allemande %%%%%%%%%%%%%%%%%%%%%%% 8
file = {'Images_Training/im13s.jpg'};scanFiles = [scanFiles; file];
file = {'Images_Training/im13c.jpg'};photFiles = [photFiles; file];


%########## Guantanamera %%%%%%%%%%%%%%%%%%%% 9
%file = {'Images_Training/im15s.jpg'};
%needed to adapt size!!!
%file = 'Images_Training/im15se.jpg';
%scanFiles = [scanFiles; file];
%scanFiles
debug = 3;
% 0 einzel
% 1 mach alle dateien
% 2 teste block
% 3 speicher block

switch debug
    
    %###############################################
    % make single tests
    %###############################################
    
    case 0
        file = scanFiles(6);
        %file = photFiles(2);
        img = im2double(imread(char(file)));
        tnm034(img);
        
    case 1
        
        failedFiles = {};  %# To store a list of the files that failed to convert
        successFiles = {};
        for file = photFiles'
            try%# Attempt to perform some computation
                img = im2double(imread(char(file)));
                tnm034(img);
                successFiles = [successFiles; file];
            catch exception %# Catch the exception
                failedFiles = [failedFiles; file];
                continue %# Pass control to the next loop iteration
            end
        end
        successFiles
        failedFiles
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % test the state
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    case 2
        
        disp('run tests')
        failedFiles = {};  %# To store a list of the files that failed to convert
        successFiles = {};
        for file = scanFiles'
            %try%# Attempt to perform some computation
            strCompare = eval(getCompareName(file));
            img = im2double(imread(char(file)));
            strFile = tnm034(img);
            
            if(strcmp(strFile, strCompare))
                disp('---------------------------------------');
                fprintf('Alles ok bei %s',char(file));
                successFiles = [successFiles; char(file)];
            else
                disp('#####################################')
                fprintf('Fehler bei %s',char(file));
                strFile
                strCompare
                failedFiles = [failedFiles; char(file)];
            end
        end
        close all;
        successFiles
        failedFiles
        
        
        
    case 3
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % save the state
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %[year month day hour minute seconds]
        c = clock;
        folder=[];
        folder = [folder 'autoSaved/save_'];
        folder = [folder num2str(c(1))];
        folder = [folder '-'];
        folder = [folder num2str(c(2))];
        folder = [folder '-'];
        folder = [folder num2str(c(3))];
        folder = [folder '_'];
        folder = [folder num2str(c(4))];
        folder = [folder '-'];
        folder = [folder num2str(c(5))];
        
        failedFiles = {};  %# To store a list of the files that failed to convert
        successFiles = {};
        
        
        
        stringSaveFile = [];
        stringSaveFile = [stringSaveFile folder];
        stringSaveFile = [stringSaveFile '/strings.txt'];
        
        
        
        fileID = -1;
        status = mkdir(folder);
        status
        if(status)
            fileID = fopen(stringSaveFile,'w');
            disp('saveImages');
            for file = scanFiles'
                try%# Attempt to perform some computation
                    filePath = [];
                    filePath = [filePath folder];
                    filePath = [filePath '/'];
                    fileName = getCompareName(file);
                    filePath = [filePath fileName];
                    img = im2double(imread(char(file)));
                    [str, h] = tnm034(img);
                    fprintf(fileID,'%s = ''%s'';\n',char(fileName),str);
                    print(h, '-djpeg', char(filePath));
                    successFiles = [successFiles; file];
                catch exception %# Catch the exception
                    failedFiles = [failedFiles; file];
                    continue %# Pass control to the next loop iteration
                end
            end
            fclose(fileID);
        end
        close all;
        successFiles
        failedFiles
        
end
%
% disp('Congratulations. You finished =D');
%
