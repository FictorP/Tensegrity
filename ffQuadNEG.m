function [ N,v4,conv ] = ffQuadNEG( b,NB,v123 )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    % Inclined cables [m]
    v1 = v123(1); v2 = v123(2); v3 = v123(3); 
    
    % Sort the lowest possible l4
    minv4 = 0;
    maxv4 = b;
    v4 = .541;
    itS = 1;
    conv = 0;
    while itS < 20 || exitflag ~= 1
        
        % Normal vector that defines the bottom base plane
        n = cross(NB(:,2)-NB(:,1),NB(:,4)-NB(:,1));
        n = n/norm(n);
              
        % Initial guess [m]
        x = NB + [n n n n]*b*.38;
        x = reshape(x,12,1);
        
        [X,~,exitflag] = fsolve(@(x) nonlinSysNEG(x,v1,v2,v3,v4,b,NB),x,optimoptions('fsolve','Display','off','Algorithm','levenberg-marquardt'));

        % Nodes matrix
        N = [NB,reshape(X,3,4)];
        
        if exitflag == 1
            maxv4 = v4;
            v4 = (v4 + minv4)/2;
        else
            minv4 = v4;
            v4 = (v4 + maxv4)/2;
        end
        itS = itS + 1;
        if itS>20
            if maxv4==b || minv4 == 0
                %disp('Não convergiu');
                return
            else
                    
                [X,~,exitflag] = fsolve(@(x) nonlinSysNEG(x,v1,v2,v3,maxv4,b,NB),x,optimoptions('fsolve','Display','off','Algorithm','levenberg-marquardt'));

                % Nodes matrix
                N = [NB,reshape(X,3,4)];
                break
            end
        end
    end

    % Calcula v4 [m]
    v4 = norm(N(:,1)-N(:,8));
    conv = 1;
end

