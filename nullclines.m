clear;

%%% This creates the nullclines folder if it dous not exist
path = 'figure/nullclines/';
if ~exist(path, 'dir')
   mkdir(path)
end

%% Parameters
V1 = -0.01;
V2 = 0.15;
V3 = @(u) 0.08 - u;
V4 = 0.02;
E_l = -0.5;
E_k = -0.7;
E_Ca = 1;
g_Ca = 0.9;
g_l = 0.5;
g_k = 2;
mu = 0.01;
I = @(u) 0.08 - 0.03*u;
m_inf = @(V) .5*(1 + tanh((V-V1)/V2));
w_inf = @(V,u) .5*(1 + tanh((V-V3(u))/V4));
lambda = @(V,u) 1/3*cosh((V-V3(u))/(2*V4));

%%% Equations
f = @(V,w,u) I(u) - g_l*(V-E_l) - g_k*w*(V-E_k) - g_Ca*m_inf(V)*(V-E_Ca);
g = @(V,w,u) lambda(V,u)*(w_inf(V,u) - w);

%% Compute surfaces
V_ = -.8:0.001:.4;
w_ = -.2:0.001:.6;
% u_ = 0;
% u_ = -.1:0.01:.15; % Just to find equilibrium points
u_ = linspace(-0.0541,0.1389,25);   % In the range of the stable cycle of the solution of u

f_surf = zeros([length(V_) length(w_) length(u_)]);
g_surf = zeros([length(V_) length(w_) length(u_)]);

% Compute the surfaces
for k = 1:length(u_)
    fprintf('Working on %i out of %i\n',k,length(u_));
    for i = 1:length(V_)
        for j = 1:length(w_)
            f_surf(i,j,k) = f(V_(i),w_(j),u_(k)) ;
            g_surf(i,j,k) = g(V_(i),w_(j),u_(k)) ;
        end
    end
end



%% Plot nullclines

[X,Y] = meshgrid(V_,w_);

figure(965)
for n = 1:length(u_)
    clf;
    contour(X,Y,f_surf(:,:,n)',[0 0])
    hold on;
    contour(X,Y,g_surf(:,:,n)',[0 0],'--')
    hold off;
    legend('f = 0', 'g = 0')
    xlabel('V')
    ylabel('w')
    title(['u = ' num2str(u_(n))])
    set(gca,'FontSize',13)
    drawnow;
%     pause(.2); % uncomment if you want to slow down the plotting
%     saveas(gcf,['figure/nullclines/u' num2str(n) '.png'])
end

