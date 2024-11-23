clear all
close all
clc

% Determina as frequências naturais das posições estáticas intermediárias

maiorsig = 0;
%% Input data
% Dados das simulacoes estáticas
CoEnsS = load('CoSim148');
loadsS = load('loads148');
CoEns = CoEnsS.CoSim;
loads = loadsS.loads;

% Comprimentos finais do cabo que puxa [m]
L = [0.493600000000000,0.399600000000000,0.281300000000000,0.158500000000000];
Lcf = [linspace(L(1),L(2),50) linspace(L(2),L(3),50) linspace(L(3),L(4),50)];
Lcf(51) = [];
Lcf(100) = [];

% Inicializar matriz que contem todas as frequencias de todos os ensaios
freq = zeros(24,length(loads));

% Passar por todos os ensaios
for ens=1:length(loads)

    % Ler a posicao 'ens'
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
    C = zeros(length(Incid),n);
    for q = 1:length(Incid)

        C(q,:) = eFun(Incid(q,2),n) - eFun(Incid(q,1),n);

    end

    % Matriz dos membros
    M = N * C';

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

            if q<=18
                leN = lR(q);

                % Rigidez
                Kel = Klin(q);
                sig = Klin(q)*(le-leN)/le;

                if sig*le/A>=maiorsig
                    maiorsig=sig*le/A;
                end
            end

            % Zerar rigidez de cabo frouxo
            if (sig<=0)
                sig = 0;
                Kel=0;
            end

            % Para o cabo que puxa
            if (q==31) 
                E = 1.51e9;
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
    Mds = Mds(I);
    ModVec = ModVec(:,I);

    % Armazenar as frequências
    freq(:,ens) = Mds;

end

% Plotar resultados ate o modo pm
pm = 8;
figure()
for i = 1:pm
    plot(freq(i,:),Lcf/.61)
    hold on
end
xlabel('w Hz')
ylabel('^{lf}/_{lo}')
grid on
warning('off', 'MATLAB:legend:IgnoringExtraEntries')
legend('mode 1','mode 2','mode 3','mode 4','mode 5','mode 6','mode 7','mode 8','mode 9','mode 10','mode 11','mode 12','Location','southeast')
axis ij

l1 = [.80918,.655082,.461148,.259836];
m1 = [2.93,3.2,3.25,3.38];
m2 = [4.4,4.37,6.12]
l2 = [.80918,.655082,.259836]
legend off
plot(m1,l1,'kx')
plot(m2,l2,'k+')
legend('mode 1 (numerical)','mode 2 (numerical)','mode 1 (experimental)','mode 2 (experimental)','Location','southeast')
