function plot_dispersion(wn,fr)
    figure2();
    plot(wn',fr','k.-');
    hold on
    grid minor
    xline(0);
    xline(1);
    xline(2);
    xline(3);
end