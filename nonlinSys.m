function [ f ] = nonlinSys(x,v1,v2,v3,v4,b,NB)
% Newton-Raphson 
% Finds the positions of the upper nodes of a 4 bar tensegrity prism given
% the lengths of its bars, cables, ans base side. Returns conv = False if
% the structure is impossible.
%     bnmp = mean(NB(:,end-3:end)'); % centro da base inferior
%     NB = NB-[bnmp' bnmp' bnmp' bnmp']; % Transladar para a origem do sistema de coordenadas

    % Bottom nodes pos [m]
    x1 = NB(1,1); x2 = NB(1,2); x3 = NB(1,3); x4 = NB(1,4);
    y1 = NB(2,1); y2 = NB(2,2); y3 = NB(2,3); y4 = NB(2,4);
    z1 = NB(3,1); z2 = NB(3,2); z3 = NB(3,3); z4 = NB(3,4);
 
    % Horizontal cables length [m]
    l = b*sqrt(2)/2;
    
    % f vector
    f1 = (x3-x(1))^2  + (y3-x(2))^2  + (z3-x(3))^2  - b^2;
    f2 = (x4-x(4))^2  + (y4-x(5))^2  + (z4-x(6))^2  - b^2;
    f3 = (x1-x(7))^2  + (y1-x(8))^2  + (z1-x(9))^2  - b^2;
    f4 = (x2-x(10))^2 + (y2-x(11))^2 + (z2-x(12))^2 - b^2;

    f5 = (x(1)-x(4))^2  + (x(2)-x(5))^2  + (x(3)-x(6))^2  - l^2;
    f6 = (x(4)-x(7))^2  + (x(5)-x(8))^2  + (x(6)-x(9))^2  - l^2;
    f7 = (x(7)-x(10))^2 + (x(8)-x(11))^2 + (x(9)-x(12))^2 - l^2;
    f8 = (x(10)-x(1))^2 + (x(11)-x(2))^2 + (x(12)-x(3))^2 - l^2;

    f9  = (x2-x(1))^2  + (y2-x(2))^2  + (z2-x(3))^2  - v1^2;
    f10 = (x3-x(4))^2  + (y3-x(5))^2  + (z3-x(6))^2  - v2^2;
    f11 = (x4-x(7))^2  + (y4-x(8))^2  + (z4-x(9))^2  - v3^2;
    f12 = (x1-x(10))^2 + (y1-x(11))^2 + (z1-x(12))^2 - v4^2;

    f = [f1;f2;f3;f4;f5;f6;f7;f8;f9;f10;f11;f12];
end