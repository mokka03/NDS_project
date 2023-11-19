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


%% Distance
disp('Working on distance')

dist = zeros([1 length(t)]);
for i = 1:length(t)-1
    dist(i) = norm(z(end,:)-z(i,:));
end

[pks,locs] = findpeaks(-dist,'MinPeakHeight',-3e-3);

figure(1)
clf;
plot(dist)
hold on;
plot(locs,dist(locs),'o')
hold off;