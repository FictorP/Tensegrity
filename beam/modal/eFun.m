function [V] = eFun(pos,siz)
% Cria um vetor V de comprimento siz cheio de zeros e com um unico 1 na
% posicao pos

V = zeros(1,siz);
V(pos) = 1;

end

