% Plot refined IC1–IC12 regions on (e, Δe) plane using conditions based on Table 3.1
L = 0.1;
e_vals = linspace(-3*L, 3*L, 200);
de_vals = linspace(-3*L, 3*L, 200);
[E, DE] = meshgrid(e_vals, de_vals);

% Compute mu_P and mu_N for e and de
muP_e = zeros(size(E));
muN_e = zeros(size(E));
muP_de = zeros(size(DE));
muN_de = zeros(size(DE));

muP_e(E <= -L) = 0;
muP_e(E >= L) = 1;
muP_e((E > -L) & (E < L)) = (E((E > -L) & (E < L)) + L) / (2*L);

muN_e(E <= -L) = 1;
muN_e(E >= L) = 0;
muN_e((E > -L) & (E < L)) = (-E((E > -L) & (E < L)) + L) / (2*L);

muP_de(DE <= -L) = 0;
muP_de(DE >= L) = 1;
muP_de((DE > -L) & (DE < L)) = (DE((DE > -L) & (DE < L)) + L) / (2*L);

muN_de(DE <= -L) = 1;
muN_de(DE >= L) = 0;
muN_de((DE > -L) & (DE < L)) = (-DE((DE > -L) & (DE < L)) + L) / (2*L);

% Plot membership values as region map
figure;
subplot(1,2,1);
contourf(E, DE, muP_e .* muP_de);
colorbar;
title('\mu_P(e) * \mu_P(\Delta e)');
xlabel('e(n)'); ylabel('\Delta e(n)');
grid on;

subplot(1,2,2);
contourf(E, DE, muN_e .* muN_de);
colorbar;
title('\mu_N(e) * \mu_N(\Delta e)');
xlabel('e(n)'); ylabel('\Delta e(n)');
grid on;