clear all
close all
clc

% Comprimento da barra [m]
b = 1;

% Importar
tnmpall = load('tnmpallp.mat');
tnmpall =  tnmpall.tnmpallp;
vall = load('vallp.mat');
vall =  vall.vallp;
vall(:,4,:)=[];
% Calcular a distância de cada resultado até a origem
normas = zeros(length(tnmpall),1);
for i = 1:length(tnmpall)
    if ~isnan(norm(tnmpall(i,:)))
        normas(i) = norm(tnmpall(i,:));
    end
end

% Remover resultados incorretos
mediana = median(normas);
tol = 0.2;
for i = flip(1:length(tnmpall))
    if mediana*(1+tol)<normas(i) || mediana*(1-tol)>normas(i)
        normas(i) = [];
        tnmpall(i,:) = [];
        vall(i,:) = [];
    end
end

% Posicoes chave
tnmpCss = [0,-0.5,surfFit20(0,-0.5);0,-1,surfFit20(0,-1);0,-1.5,surfFit20(0,-1.5);0,-2,surfFit20(0,-2)];

p = length(tnmpCss);

tnmpCff = zeros(p,3);
v123NN = zeros(p,3);
vallFF = zeros(p,4);
for i = 1:p
    v123NN_ = codmyNNFtrainbr10l5s(tnmpCss(i,:));
    v123NN(i,:) = v123NN_;
    subplot(1,p,i)
    [tnmpCff(i,:), vallFF(i,4), conv] = ffArmS(v123NN_);
    zlim([0,3*b])
    xlim([-b,b])
    ylim([-3*b,b])
    %[tnmpCff(i,:)] = ffArmv4(vallNN(:,:,i));
    view([-1,0,0])
    ax = gca;
    ax.FontSize = 12;
    conv
end

% Plot the workspace obtained from the model
figure()
tnmpallX = tnmpall(:,1);
tnmpallY = tnmpall(:,2);
tnmpallZ = tnmpall(:,3);
plot3(tnmpallX,tnmpallY,tnmpallZ,'ro')
hold on
% Plot 5th order surface approximation of the workspace
[X,Y] = meshgrid(-2.5*b:.25:2.5*b);
Z = surfFit20(X,Y);
C = X.*Y;
s = surf(X,Y,Z,C,'FaceAlpha',0.3);
s.EdgeColor = 'none';
grid on 
grid minor

axis equal
hold on
plot3(tnmpCff(:,1),tnmpCff(:,2),tnmpCff(:,3),'b+', 'MarkerSize',15, 'LineWidth',3)
plot3(tnmpCss(:,1),tnmpCss(:,2),tnmpCss(:,3),'kx', 'MarkerSize',15, 'LineWidth',3)
xlabel('x [m]','FontSize', 12)
ylabel('y [m]','FontSize', 12)
zlabel('z [m]','FontSize', 12)
% Create legend
legend1 = legend('Workspace [form-finding]','Workspace [polynomial fit]', 'Neural network', 'Target');
set(legend1,'Position',[0.730892205302911 0.76400691418201 0.157393847080834 0.12519200880956]);
xlim([-2.5*b,2.5*b])
ylim([-2.5*b,2.5*b])
zlim([0,2.6*b])
ax = gca;
ax.FontSize = 12;
