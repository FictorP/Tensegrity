function [C] = incidencia(inc, N)
    nos = length(N(:,1));
    membros = length(inc(:,1));
    
    C = zeros(membros, nos);
    for i=1:1:membros
        C(i, inc(i,1)) = -1;
        C(i, inc(i,2)) = 1;
    end
end
