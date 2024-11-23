function [tnmp,v4i,conv] = ffArmS(v123)

    % Comprimento da barra [m]
    b = 1;
      
    % Incidencia
    Incid =[3     5     1
         4     6     1
         1     7     1
         2     8     1
         5     6     0
         6     7     0
         7     8     0
         8     5     0
         2     5     0
         3     6     0
         4     7     0
         1     8     0];
    
    IncidNEG =[3     5     1
         4     6     1
         1     7     1
         2     8     1
         5     6     0
         6     7     0
         7     8     0
         8     5     0
         4     5     0
         1     6     0
         2     7     0
         3     8     0];
    
    
    % Coordenadas dos nos da base [m]
    NB = [0 -b/2 0 b/2; b/2 0 -b/2 0; 0 0 0 0];
%     figure()
    for i=1:3
        [N,v4,conv] = ffQuad( b,NB,v123);
        if ~conv
            v4i = 0;
            tnmp = [0,0,0];
            break
        end
        if i == 1
            v4i = v4;
        end
        plotTensegrity( Incid,N )
        hold on
        % Sets the next bottom as the current top base
        NB = N(:,5:8);  
        [N,~,conv] = ffQuadNEG( b,NB,v123);
        if ~conv
            v4i = 0;
            tnmp = [0,0,0];
            break
        end
        plotTensegrity( IncidNEG,N )
        hold on
        % Sets the next bottom as the current top base
        NB = N(:,5:8);
    end 

    tnmp = mean(N(:,end-3:end)');
end
