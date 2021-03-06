% Model recovery wrapper for meta-d fit
%
% SF 2014

Ntrials = 10000;
c = 0;
c1 = [-1.5 -1 -0.5];
c2 = [0.5 1 1.5];

d = [0.5 1 1.5 2];
noise = [0 0.5 1];

for i = 1:length(d)
    for j = 1:length(noise)
        % Generate data
        sim = type2_SDT_sim(d(i), noise(j), c, c1, c2, Ntrials);
        
        % Fit data
        fit = fit_meta_d_mcmc(sim.nR_S1, sim.nR_S2);
        
        % Store fitted parameters
        meta_d(i,j) = fit.meta_da;
        ci_l(i,j) = quantile(fit.mcmc.samples.meta_d(:),0.025);
        ci_u(i,j) = quantile(fit.mcmc.samples.meta_d(:),0.975);
    end
end

% Plot predicted and fitted parameters
h1 = figure;
for j = 1:length(noise)
    hold on
%     plot(d, meta_d(:,j));
    errorarea(d, meta_d(:,j), ci_l(:,j), ci_u(:,j), 'k', [0.5 0.5 0.5]);
end
line([0 2.5], [0 2.5], 'linewidth', 1.5, 'linestyle', '--', 'color', 'k')
xlabel('d''','FontSize', 18);
ylabel('meta-d''', 'FontSize', 18);
set(gca, 'FontSize', 18);
box off

print(h1,'-dpng','-r300','-zbuffer','Model_recovery.png');