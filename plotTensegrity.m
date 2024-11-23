function plotTensegrity( Incid,N )
% Creates a 3D plot of a tensegrity structure.
% Incid = [node1 node2 1=bar/0=cable]
% N = [x1...xn;y1...yn;z1...zn] Nodes matrix
%figure1 = figure;
for q = 1:length(Incid) % plotar todos os elementos 

    % Plotar as barras
    if Incid(q,3)==1
        no = [Incid(q,1) Incid(q,2)];            
        plot3([N(1,no(1)),N(1,no(2))],[N(2,no(1)),N(2,no(2))],[N(3,no(1)),N(3,no(2))],'r','LineWidth', 5)
        hold on

    % Plotar os cabos
    else
        no = [Incid(q,1) Incid(q,2)];            
        plot3([N(1,no(1)),N(1,no(2))],[N(2,no(1)),N(2,no(2))],[N(3,no(1)),N(3,no(2))],'k','LineWidth', 2)
        hold on
    end
    hold on
    axis equal
    grid on
end
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
% xlim([-.25,.25])
% ylim([-.25,.25])
% zlim([0,.4])

% L1 = norm(N(:,1)-N(:,5));
% L2 = norm(N(:,2)-N(:,6));
% L3 = norm(N(:,3)-N(:,7));
% L4 = norm(N(:,4)-N(:,8));
% t1 = ['L1 = ',num2str(L1,3),'m'];
% t2 = ['L2 = ',num2str(L2,3),'m'];
% t3 = ['L3 = ',num2str(L3,3),'m'];
% t4 = ['L4 = ',num2str(L4,3),'m'];

% Create textbox
%annotation(figure1,'textbox',[0 0.1 .16 0.18],'String',{t1,t2,t3,t4},'FitBoxToText','off');

end

