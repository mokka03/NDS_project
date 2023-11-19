clear;

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

%% Solve DES
% Z := [V w u]
disp('Working on DES')

DES = @(t,Z) [
    f(Z(1),Z(2),Z(3));
    g(Z(1),Z(2),Z(3));
    mu*(0.22+Z(1))
];

ic = [-0.0249663;2.66312e-7;-0.0500763];
t_span = [0 10000];

[t,z] = ode45(DES, t_span, ic);

%% Plot
disp('Working on plotting')
%%% Solution of DES
figure(382)
clf;
subplot(3,1,1)
plot(t,z(:,1));
xlim([0 2000])
xlabel('t')
ylabel('V(t)')

subplot(3,1,2)
plot(t,z(:,2));
xlim([0 2000])
xlabel('t')
ylabel('w(t)')

subplot(3,1,3)
plot(t,z(:,3));
xlim([0 2000])
xlabel('t')
ylabel('u(t)')

% SaveFig('figure/','DES_solution',gcf)

%%% Phase space
% Compute the plotted interval
dist = zeros([1 length(t)]);
for i = 1:length(t)-1
    dist(i) = norm(z(end,:)-z(i,:));
end

[~,locs] = findpeaks(-dist,'MinPeakHeight',-3e-3);
t_start = locs(end)-1;

% Plot
figure(383)
clf;
plot3(z(t_start:end,3),z(t_start:end,2),z(t_start:end,1))
view([40 -10])
grid on;
xlabel('u')
ylabel('w')
zlabel('V')
set(gca,'FontSize',14)

% SaveFig('figure/','phase_space',gcf)