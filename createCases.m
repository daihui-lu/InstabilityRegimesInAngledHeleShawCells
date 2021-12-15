close all;
clear;
[status,cmdout] = system('pwd');
homeDir = cmdout;
disp(homeDir);

geo = [1 2 3];
alpha = [-5*10^(-4) 0 5*10^(-4)];
Amplitudes = '1(0.2)';

beta = [0.375 0.5 0.625 0.75 0.8 1];

removeOld = true;

if removeOld
    system('rm -r newCases')
end

% Main folder (do not use because of error in absolute path)
folderName = homeDir
casesFolder = './newCases'

mkdir(casesFolder)
cd(casesFolder)

caseId = 1;

for geoId = 1:length(geo)
    
    % Pattern for creating folders
    subFolder = sprintf('geo%i',geo(geoId))    
    folderGeo = sprintf('./%s',subFolder)    
    mkdir(folderGeo)
    cd(folderGeo);
    

    if geoId == 1
        
        Ca = [0.005 0.007 0.008 0.009 0.01];
        
    else if geoId == 2
            
            Ca = [0.002 0.003 0.004 0.005 0.007];
            
        else
            
            Ca = [0.001 0.002 0.003 0.0043 0.005];
        end;
    end;

    
    for CaId = 1:length(Ca)
        
        CaFolder = sprintf('Ca_%i',Ca(CaId))
        folderCa = sprintf('./%s',CaFolder)    
        mkdir(folderCa)
        cd(folderCa)

            % Case creation
            command = 'cp -r ../../../baseCase/* .';
            system(command);
            
            % Create parameters.H                              
            fid = fopen('./parameters.H','wt'); 
            gamma = 0.0295; %surface tension
            mu = 830*7.831*10^(-5);
            aveVel = Ca(CaId) * gamma /12/mu;
            endChannel = 0.001 + 0.2 * alpha(geoId);
                        
            fprintf(fid,'aveVel  %f;',aveVel);
            fprintf(fid,'endChannel  %f;',endChannel);
            fprintf(fid,'Amplitudes  %s;',Amplitudes);

            fclose(fid);            
            
            %submit Job!!!
            caseName = sprintf('case%i',caseId);
            command = sprintf('mv baseCase.bin %s | qsub %s',caseName,caseName)
            system(command);
            
            
             % back to Ca folder
            cd('../')
            caseId = caseId+1;

     end
    
    
    
    % back to Geo folder
    cd('../');
    
end

cd('../');
    

