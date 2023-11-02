%Simulacao do PageRank
%Faculdade de Educacao Tecnologica do Estado do Rio de Janeiro - FAETERJ
%Laboratorio Nacional de Computacao Cientifica - LNCC
%Oscar Neiva Eulalio Neto
%Orientador: Eduardo Krempser da Silva
%Co-orientador: Marcos Garcia Todorov

clear
clc
close all

%Numero de estados
N = 4;

%Numero de matrizes distribuidas
NPn = N;

%Horizonte de tempo
T = 50;

%Horizonte de tempo do metodo de monte carlo 
itmax = 50;

%Parametro m do modelo distribuido
m = 0.15;

%Vetor aleatorio
%x = rand(1,N);
%x = diag(x*ones(N,1))\x;

%Vetores estaticos
x = [0 0 0 1];

%Outros vetores
y = x;
xd = x;
yd = x;
z = x;
zr = x;
w = zeros(T+1,N);

%Matriz estocastica aleatoria (linha)
%P = rand(N);
%P = diag(P*ones(N,1))\P;

%Matriz estocastica estatica
P = [0 0 0 1; 0.5 0 0.5 0; 0 0 0 1; 0.5 0.5 0 0];

%Vetor de uns
v1 = ones(1,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Equacao de M
M = 2*m/(N-m*(N-2));

%Matriz tridimensional de zeros
PP = zeros(size(P,1),size(P,2),N);

%Insere valores na matriz tridimensional
for i=1:N
	%Insere uns nas diagonais
	PP(i,i,:) = 1;
	
	%Copia linhas para as matrizes distribuidas
    PP(i,:,i) = P(i,:);
end

for it=1:itmax
	for k=1:T
		%Gera numero para representar a matriz distribuida
		Pn = ceil(rand*NPn);

		%Power Method
		x(k+1,:) = x(k,:)*P;
		
		%Teleportation model (nao distribuido)
		y(k+1,:) = (1-M)*(x(k,:)*P) + (M/N)*v1;

		%Matrizes links distribuidas
		xd(k+1,:) = xd(k,:) * PP(:,:,Pn);

		%Teleportation model (distribuido)
		yd(k+1,:) = (1-M)*(xd(k,:)*PP(:,:,Pn)) + (M/NPn)*v1;

		%Media no tempo (nao recursiva)
		z(k,:) = sum(yd)/(T+1);

		%Media no tempo (recursiva)
		zr(k+1,:) = (((k+1)/(k+2)) * zr(k,:)) + ((1/(k+2))*yd(k+1,:));
	end
	w = w + zr./itmax;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Imprime resultados
clf

figure(1);
%subplot(211);
plot(x,'Linewidth',2.0);
set(gca,'fontsize',20);
set(gca,'XLim',[1 T]);
set(gca,'YLim',[0 2/N]);
title('Power Method');
ylabel('Pages values');
xlabel('Time');
print('-depsc2','powermethod');

figure(2);
%subplot(212);
plot(y, 'Linewidth', 2.0);
set(gca,'fontsize',20);
set(gca,'XLim',[1 T]);
set(gca,'YLim',[0 2/N]);
title('Teleportation Model');
ylabel('Pages values');
xlabel('Time');
print('-depsc2','teleportation');

%figure(3);
%subplot(211);
%plot(xd, 'Linewidth', 1.0);
%set(gca,'fontsize',20);
%set(gca,'XLim',[1 T]);
%set(gca,'YLim',[0 2/N]);
%title('PageRank With Distributed Link Matrices');
%ylabel('Pages values');
%xlabel('Time');
%print('-depsc2','pagedistributed');

figure(4);
%subplot(212);
plot(yd, 'Linewidth', 2.0);
set(gca,'fontsize',20);
set(gca,'XLim',[1 T]);
set(gca,'YLim',[0 2/N]);
title('Teleportation Model With Distributed Link Matrices');
ylabel('Pages values');
xlabel('Time');
print('-depsc2','teledistributed');

%figure(5);
%subplot(7,2,9);
%plot(z);
%set(gca,'fontsize',20);
%set(gca,'XLim',[1 T]);
%set(gca,'YLim',[0 2/N]);
%title('Time Average (Not Recursive)');
%ylabel('Pages values');
%xlabel('Time');
%print('-depsc2','polyak','-F:30');

figure(6);
%subplot(211);
plot(zr, 'Linewidth', 2.0);
set(gca,'fontsize',20);
set(gca,'XLim',[1 T]);
set(gca,'YLim',[0 2/N]);
title('Time Average (Recursive)');
ylabel('Pages values');
xlabel('Time');
print('-depsc2','timerecursive');

figure(7);
%subplot(212);
plot(w, 'Linewidth', 2.0);
set(gca,'fontsize',20);
set(gca,'XLim',[1 itmax]);
set(gca,'YLim',[0 2/N]);
title('Monte Carlo Simulation');
ylabel('Pages values');
xlabel('Time');
print('-depsc2','montecarlo');
