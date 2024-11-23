function [ Ksig,f ] = calculaKsig( Co, df, Inc, Klin, KlinB,m,lR )
%Encontra a matriz de rigidez global e o vetor carregamento considerando
%peso próprio para g=9.81m/s²

    
    % Conectividade conforme notacao de Skelton
    C = incidencia( Inc(:,1:2), Co);
    
    % Matriz dos nos conforme notacao de Skelton
    N = Co';
    
    % Matriz dos membros conforme notacao de Skelton
    M = N*C';
    
    % Peso proprio
    g = 9.81;
    
    f = zeros(length(Co)*2,1);
    Ksig = zeros(length(Co)*2);
    for q = 1:length(Inc) 
           
        no1 = Inc(q,1);
        no2 = Inc(q,2);
        he = sqrt((Co(no1,1)-Co(no2,1))^2 + (Co(no1,2)-Co(no2,2))^2);

        sig = df(q);
        
        % Se cabo
        if (Inc(q,3)==1)
            
            Kel = Klin(q);
                 
%             % Diminuir rigidez em deformaçao maior que 20%
%             if (he-lR(q))/lR(q)>=.20
%                 Kel = Kel*.9;
%             end
            
            % Zerar pretensao negativa
            if (he<lR)
                sig = 0;
                
                if q<=7 && q>=12
                    Kel = 0;
                end
            end
            
        % Se barra    
        else
            sig = 0;
            Kel = KlinB;
            
            % Carregamento
            p = m/12*g;
            f(Inc(q,1)*2) = f(Inc(q,1)*2) + p/2;
            f(Inc(q,2)*2) = f(Inc(q,2)*2) + p/2;
        end
        
        % Skelton
        L = sig*(eye(2)-M(:,q)*M(:,q)'./norm(M(:,q))^2) + Kel*M(:,q)*M(:,q)'./norm(M(:,q))^2;
        
        % produto de Kronecker
        Ke = kron(C(q,:)'*C(q,:),L);

        % Assembly
        Ksig = Ksig + Ke;
    end
end

