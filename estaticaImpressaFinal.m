clear all
close all
clc

% Determina a posição estática final em cada uma das situações ensaiadas

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

loads(2) = .095;


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

loads(3) = .16;        
        
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

loads(5) = .31;
loads=loads*1.05;

%CoEns = pos(:,:,posicao);

% Incidência (no1, no2, 1 = cabo)
Inc =   [   1	2	1
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
            13	7	0];

% Restrições [nó, GDL]
R = [   1	1
        1	2
        8	1
        8	2];  

% Massa da estrutura [kg]
m = .29*14/12;

% Posição da base [m]
xB = .42;
yB = .01;

% Nó em que o cabo está preso
noc = 14;

% Discretizacao
p = 10000;

% Comprimento relaxado do cabo [m]
% Comprimento relaxado dos elementos [m]
lR = [0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08
0.08];
lR=lR*1.3;
lR(1:6) = lR(1:6) * .75;
lR(13:18) = lR(13:18) * .75;
lR = lR*.935;

% Lado da secao do cabo [m]
dCabo = 1.5e-3;

% Área da seção (um elástico são dois cabos)
Acabo = dCabo^2*4;

% Módulo Young do elastico [Pa]
Ecabo = 3e6*.75;

% Rigidez linear dos cabos [N/m]
Klin = Ecabo*Acabo./lR;

% Rigidez linear da barra [N/m]
KlinB = 2e9*(.008*.015)/.151;

% Escolher a posição
%posicao = 5;
for posicao = 1:5

% Coordenadas naturais dos nós (sem peso nem carga) [m]
Co = [-0.11	0.07
    -1.21	9.61
    -0.97	17.57
    -1.32	25.55
    -0.84	33.89
    -1.21	41.87
    0.48	51.04
    10.64	0.07
    11.85	9.48
    11.48	17.81
    11.72	25.66
    11.48	33.78
    12.14	41.54
    11.02	50.73]/100;
Co1 = Co;    
    
% Força no cabo [N]
Fc = loads(posicao)*9.81;

% Comprimento final do cabo que puxa [m]
Lcf = sqrt((CoEns(noc,1,posicao)-xB)^2 + (CoEns(noc,2,posicao)-yB)^2);
if posicao ==1
    Lcf = 0;
end

df = zeros(length(Inc),1);

fy = 0;
fx = 0;
entrou = 0;
dfg = zeros(length(df),p);
for g = 1:p
    
    [ Kg,f ] = calculaKsig( Co, df, Inc, Klin, KlinB, m, lR );
    
    f=f/p;
    
    Fa = Fc/p;
    %Fa = Fc(3)*3*g^2/p^3;
    
    % Força do cabo [N]
    xp = Co(noc,1);
    yp = Co(noc,2);
    Lc = sqrt((xB-xp)^2 + (yB-yp)^2);

    if Lc > Lcf
   
        f(noc*2-1) = f(noc*2-1) + (xB - xp) * Fa/Lc  ;
        f(noc*2) = f(noc*2) + (yB - yp) * Fa/Lc;

    else
        if entrou==0
            g
            entrou = 1;
        end
    end    
    
    
    % Aplicar as restrições
    li = (R(:,1)-1)*2+R(:,2);

    % Ordenar decrescente para viabilizar remoção das linhas
    li = sort(li,'descend');    
    
    % Remover os gdls restritos
    for q = 1:length(R)
        Kg(li(q),:) = [];
        Kg(:,li(q)) = [];
        f(li(q),:) = [];
    end

    % Resolver o sistema
    u = Kg\f;

    % Inserir em u1 os deslocamentos zerados pelas restrições
    u1 = zeros(length(Co)*2,1);
    li = sort(li);
    q = 1;
    w = 1;
    while w <=length(Co)*2-length(R)

            if q<=length(R) && li(q) == q+w-1 
                u1(w+q-1) = 0;
                q = q + 1;
            else
                u1(w+q-1) = u(w);
                w = w + 1;
            end
    end
    
    % Encontrar a densidade de força de cada elemento [N/m]
    [ df2 ] = densidadeForca( Inc,Co,u1, Klin,lR );
    
    dfg(:,g) = df2;
    df = df2;

    % Atualizar coordenadas dos nos
    [rw,cl] = size(Co);
    Co = Co + reshape(u1,cl,rw)';
end 
   
% Deslocamento total [m]
utot = Co-Co1;

% Fator de ampliação
amp = 1;%.05*max(max(Co))/max(abs(u));

% Encontrar número de membros
[nm,~] = size(Inc);

% Erro
r = .01;

figure();
% Plotar
for q = 1:nm
    no1 = Inc(q,1);
    no2 = Inc(q,2);
    
   hold on
    circle(CoEns(no1,1,posicao),CoEns(no1,2,posicao),r);
    hold on
    circle(CoEns(no2,1,posicao),CoEns(no2,2,posicao),r);
    hold on
    if Inc(q,3)==0
        plot([Co(no1,1),Co(no2,1)],[Co(no1,2),Co(no2,2)], 'r','LineWidth', 2);
        plot([CoEns(no1,1,posicao),CoEns(no2,1,posicao)],[CoEns(no1,2,posicao),CoEns(no2,2,posicao)], '--k','LineWidth', .2);
    else        
        plot([Co(no1,1),Co(no2,1)],[Co(no1,2),Co(no2,2)], 'k','LineWidth', .5);
        plot([CoEns(no1,1,posicao),CoEns(no2,1,posicao)],[CoEns(no1,2,posicao),CoEns(no2,2,posicao)], '--k','LineWidth', .2);
    end
end
plot([CoEns(14,1,posicao),xB],[CoEns(14,2,posicao),yB], '--k','LineWidth', .2);

plot([Co(14,1),xB],[Co(14,2),yB], 'k','LineWidth', .5);
grid on
xlabel('[m]');
ylabel('[m]');
axis equal
xlim([-0.1,0.5]);
ylim([0,0.6]);
filename = ['ens',num2str(posicao),'.jpg'];
fig = posicao;
saveas(fig,filename,'jpg')

end
