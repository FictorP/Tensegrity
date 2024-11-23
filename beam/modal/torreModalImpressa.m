clear all
close all
clc

% Calcula os modos e as frequências das posições estáticas ensaiadas

maiorsig = 0;
%% Input data
% POSICOES EM METROS E CARGAS EM KG
CoEns = zeros(14,2,200);

CoEns(:,:,1) = [0.05	-0.05
-1.19	9.99
-1.3	18.68
-1.56	27.35
-1.19	36.04
-1.19	44.34
0.55	54.01
10.73	0.08
11.21	9.88
11.1	18.92
11.34	27.35
11.1	35.67
12.08	43.97
11.21	53.53]/100;

loads(1) = 0;


CoEns(:,:,2) = [-0.13	0.1
-0.5	10.82
1.06	19.88
3.32	28.59
6.78	37.05
10.12	44.92
15.72	52.79
10.6	0.21
12.03	8.8
13.33	17.02
15.84	24.44
18.16	32.1
22.08	38.82
25.2	47.41]/100;

loads(2) = .14;


CoEns(:,:,3) = [-0.14	0.08
-0.03	11.44
2.84	20.48
6.81	28.96
12.43	36.34
18.15	42.85
25.99	48.36
10.55	0.31
12.32	8.35
14.52	15.74
18.04	22.02
22	28.19
27.62	33.49
33.15	39.97]/100;

loads(3) = .19;        
        
CoEns(:,:,4)=[-0.03	0.06
0.45	11.83
4.29	20.83
10.05	28.41
18.09	33.56
26.15	37.64
35.75	39.93
10.65	0.31
12.81	7.88
15.58	13.87
19.42	17.95
24.22	22.15
31.19	24.93
39.35	29]/100;

loads(4) = .23;

CoEns(:,:,5) = [-0.05	0.06
1.05	12.16
6.22	20.94
14	26.64
23.46	29.28
32.51	29.76
41.97	28.1
10.6	0.19
13.09	7.08
16.22	11.33
20.06	14.18
25.35	16.21
32.24	16.34
41.14	16.83]/100;

loads(5) = .3;

loads = [0,.095,.16,.23,.31];
% Escolha do ensaio
%ens = 3;
for ens=1:5
Co = CoEns(:,:,ens);


% Young Modulus [Pa]
barra.E = 2e9; 
cabo.E = 3e6*.75;

%cabo.D = .00033;
cabo.D = .0012;

% Rigidez da barra [N/m]
KlinB = 2e9*(.008*.015)/.151;

% Massa da estrutura [kg]
m = .29*14/12;

% Densidade [kg/m³]
cabo.rho = 0;

% Incidência [no1 no2 1=cabo]
Incid = [1	2	1
2	3	1
3	4	1
4	5	1
5	6	1
6	7	1
8	9	1
9	10	1
10	11	1
11	12	1
12	13	1
13	14	1
7   14  1
6	13	1
5	12	1
4	11	1
3	10	1
2	9	1
1	9	0
2	10	0
3	11	0
4	12	0
5	13	0
6	14	0
8	2	0
9	3	0
10	4	0
11	5	0
12	6	0
13	7	0
15  14  1];

% Comprimentos relaxados dos cabos [m]
lR=ones(18,1)*.08;
lR=lR*1.3;
lR(1:6) = lR(1:6) * .75;
lR(13:18) = lR(13:18) * .75;
lR=lR*.935;

% Rigidez linear dos cabos [Pa]
%Klin = cabo.E*(pi*cabo.D^2/4*2)./lR;
Klin = cabo.E*(cabo.D^2*4)./lR;

% Adicionar a base do cabo que puxa
p15 = [.42,.01];
Co = [Co;p15];

% Matriz dos nós [m]
N = Co';

% Número de nós
n = length(N);

% Matriz de conectividade 
% Count the numbers of bar and cable elements 
% contaBarra = 0;
% contaCabo = 0;
C = zeros(length(Incid),n);
for q = 1:length(Incid)
    
    C(q,:) = eFun(Incid(q,2),n) - eFun(Incid(q,1),n);
    
end

% Assemble the global connectivity matrix
% C = [Cb;Cs];

% Matriz dos membros
M = N * C';

% % Bars matrix
% B = M(1:2,1:contaBarra);
% 
% % Cables matrix
% S = M(1:2,contaBarra+1:end);

%% Rigidez L=sig*(In-m.m'/||m||²)+K*m.m'/||m||²
Kg = zeros(2*n,2*n);
Mg = Kg;
Mg2 = Mg;
for q = 1:length(Incid)
    
    % Encontrar os nós e os graus de liberade do elemento
    no = [Incid(q,1) Incid(q,2)];
    gdl1 = [no(1)*2-1, no(1)*2];
    gdl2 = [no(2)*2-1, no(2)*2];
        
    % Comprimento do elemento [m]
    le = ((N(1,Incid(q,1))-N(1,Incid(q,2)))^2 + (N(2,Incid(q,1))-N(2,Incid(q,2)))^2 )^.5;
    
    % Se for barra
    if Incid(q,3)==0
        
        A = (.008*.015);
        le = .151;
        rho = m/12/A/le;
        E = barra.E;
        
        
        % Pré-tensão
        sig = 0;
        
        % Rigidez da barra
        Kel = KlinB;
        
        % L=sig*(In-m.m'/||m||²)+K*m.m'/||m||²
        L = sig*(eye(2)-M(:,q)*M(:,q)'./norm(M(:,q))^2)+ Kel*M(:,q)*M(:,q)'./norm(M(:,q))^2;
       
    else
        
        D = cabo.D;
        A = D^2*4;
        rho = cabo.rho; 
        E = cabo.E;
        q;
        %leN = ((CoN(Incid(q,1),1)-CoN(Incid(q,2),1))^2 + (CoN(Incid(q,1),2)-CoN(Incid(q,2),2))^2 )^.5;
        
        if q<=18
            leN = lR(q);
                   
            % Rigidez
            Kel = Klin(q);
            sig = Klin(q)*(le-leN)/le;
            
            if sig*le/A>=maiorsig
                maiorsig=sig*le/A;
            end
%             % Aumentar rigidez em deformaçao maior que 18%
%             if (le-lR(q))/lR(q)>=.18
%                 Kel = Kel*1.3;
%             end
        end
    
        % Zerar rigidez de cabo frouxo
        if (sig<=0)
            sig = 0;
            Kel=0;
        end
        
        % Rigidez do elemento
        %Kel = E * A / le;
        
        % Para o cabo que puxa
        if (q==31) 
            %E = cabo.E; 
            E = 1.51e9;
            le
            sig = loads(ens)*9.81/le;
            A = 3.1416*.0004*.0004/4;
            Kel = E * A / le;
        end
               
        % L=sig*(In-m.m'/||m||²)+K*m.m'/||m||²
        L = sig*(eye(2)-M(:,q)*M(:,q)'./norm(M(:,q))^2)+ Kel*M(:,q)*M(:,q)'./norm(M(:,q))^2;
    end
    
    % produto de Kronecker
    Ke = kron(C(q,:)'*C(q,:),L);
    
    %Calcular a matriz de massa do elemento    
    Ms =   [2 0 1 0
            0 2 0 1
            1 0 2 0
            0 1 0 2] * (rho*A*le/6);
    
    % Superposição da massa
    Mg(no(1)*2-1:no(1)*2,no(1)*2-1:no(1)*2) = Mg(no(1)*2-1:no(1)*2,no(1)*2-1:no(1)*2) + Ms(1:2,1:2);
    Mg(no(1)*2-1:no(1)*2,no(2)*2-1:no(2)*2) = Mg(no(1)*2-1:no(1)*2,no(2)*2-1:no(2)*2) + Ms(1:2,3:4);
    Mg(no(2)*2-1:no(2)*2,no(1)*2-1:no(1)*2) = Mg(no(2)*2-1:no(2)*2,no(1)*2-1:no(1)*2) + Ms(3:4,1:2);
    Mg(no(2)*2-1:no(2)*2,no(2)*2-1:no(2)*2) = Mg(no(2)*2-1:no(2)*2,no(2)*2-1:no(2)*2) + Ms(3:4,3:4);

    % Superposição da rigidez
    Kg = Kg + Ke;
    
    % Teste futuro
%     Me = kron(abs(C(q,:)'*C(q,:)),(rho*A*le/6)*[2,0;0,2]);
%     Mg2 = Mg2 + Me;
end

%% Engaste
Kg(:,30) =[];
Kg(:,29) =[];
Kg(30,:) =[];
Kg(29,:) =[];
Kg(:,16) =[];
Kg(:,15) =[];
Kg(16,:) =[];
Kg(15,:) =[];
Kg(:,2) =[];
Kg(:,1) =[];
Kg(2,:) =[];
Kg(1,:) =[];

Mg(:,30) =[];
Mg(:,29) =[];
Mg(30,:) =[];
Mg(29,:) =[];
Mg(:,16) =[];
Mg(:,15) =[];
Mg(16,:) =[];
Mg(15,:) =[];
Mg(:,2) =[];
Mg(:,1) =[];
Mg(2,:) =[];
Mg(1,:) =[];

%% Modal analysis
% Eigenvalues and eigenvectors
[ModVec,Mds] = eig(Kg,Mg);
Mds = (diag(Mds).^.5)/2/pi; % Hz

[~,I] = sort(Mds);

% Repeat the sort so Mds and ModVec keep compatible
Mds = Mds(I)
ModVec = ModVec(:,I);
 

% Plotar pmm modos
pmm = 2;
amp = .02;
figure()
    for pm = 1:pmm

    subplot(1,2,pm)    
        for q = 1:length(Incid)

            CoDef = [0;0;ModVec(1:12,pm);0;0;ModVec(13:end,pm)];
            CoDef = reshape(CoDef,2,14)';
    %             if ens > 1
                CoDef = [CoDef;0,0];
    %             end
            no1 = Incid(q,1);
            no2 = Incid(q,2);
            CoF = Co + amp*CoDef;

            plot([Co(no1,1),Co(no2,1)],[Co(no1,2),Co(no2,2)],'k','LineWidth', 1);
            hold on
            axis equal
            plot([CoF(no1,1,1),CoF(no2,1,1)],[CoF(no1,2,1),CoF(no2,2,1)],'r','LineWidth', 2);    
            grid on
            xlim([-.1, .5]);
            ylim([0, .6]);
        end
        title(['Mode ',num2str(pm),' - f = ',num2str(Mds(pm),3),' Hz'])
        freq(ens) = Mds(pm);
        carga(ens) = loads(ens);
        grid on
    %     filename = ['ens',num2str(ens),'modo',num2str(pm),'freq',num2str(Mds(pm)),'.jpg'];
    %     fig = ens*2 + (pm-2);
    %     saveas(fig,filename,'jpg')
    end
    filename = ['ens',num2str(ens),'.jpg'];
    fig = ens;
    saveas(fig,filename,'jpg')
end


