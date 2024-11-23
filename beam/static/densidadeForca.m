function [ df ] = densidadeForca( Inc,Co,u1,Klin,lR )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    
    [rw,cl] = size(Co);
    CoN = Co + reshape(u1,cl,rw)';
    df = zeros(length(Inc),1);
    % passar por todos os membros
    for i = 1:length(Inc)
        
        % Entradas
        no1 = Inc(i,1);
        no2 = Inc(i,2);

        % comprimento antigo do elemento [m]
        he = sqrt((Co(no1,1)-Co(no2,1))^2 + (Co(no1,2)-Co(no2,2))^2);
        
        % comprimento novo do elemento [m]
        hen = sqrt((CoN(no1,1)-CoN(no2,1))^2 + (CoN(no1,2)-CoN(no2,2))^2);

        % Forca normal
        Nx = Klin(i)*lR(i)*(hen-he)/he;

        % Densidade de forca [N/m]
        df(i) = Nx/he;       
    end
end

