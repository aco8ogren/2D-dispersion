clear; close all;
E = 1;
nu = .3;
t = 1;
K_ele = [
    [-E*t^3*(27 + nu)/(18*nu^2 - 18), -E*t^3*(3 + 5*nu)/(6*nu^2 - 6), -E*t^3*(3 + 17*nu)/(18*nu^2 - 18), -E*t^3*(3 + 5*nu)/(6*nu^2 - 6), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9)];
    [-E*t^3*(3 + 5*nu)/(6*nu^2 - 6), -E*t^3*(27 + nu)/(18*nu^2 - 18), -E*t^3*(3 + 5*nu)/(6*nu^2 - 6), -E*t^3*(3 + 17*nu)/(18*nu^2 - 18), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9)];
    [-E*t^3*(3 + 17*nu)/(18*nu^2 - 18), -E*t^3*(3 + 5*nu)/(6*nu^2 - 6), -E*t^3*(27 + nu)/(18*nu^2 - 18), -E*t^3*(3 + 5*nu)/(6*nu^2 - 6), 10*nu*E*t^3/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9)];
    [-E*t^3*(3 + 5*nu)/(6*nu^2 - 6), -E*t^3*(3 + 17*nu)/(18*nu^2 - 18), -E*t^3*(3 + 5*nu)/(6*nu^2 - 6), -E*t^3*(27 + nu)/(18*nu^2 - 18), 10*nu*E*t^3/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9)];
    [2*E*t^3*(6 + nu)/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 8*E*t^3*(-3 + nu)/(9*nu^2 - 9), -4*nu*E*t^3/(3*nu^2 - 3), -8*nu*E*t^3/(9*nu^2 - 9), -4*nu*E*t^3/(3*nu^2 - 3)];
    [10*nu*E*t^3/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), -4*nu*E*t^3/(3*nu^2 - 3), 8*E*t^3*(-3 + nu)/(9*nu^2 - 9), -4*nu*E*t^3/(3*nu^2 - 3), -8*nu*E*t^3/(9*nu^2 - 9)];
    [10*nu*E*t^3/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), -8*nu*E*t^3/(9*nu^2 - 9), -4*nu*E*t^3/(3*nu^2 - 3), 8*E*t^3*(-3 + nu)/(9*nu^2 - 9), -4*nu*E*t^3/(3*nu^2 - 3)];
    [2*E*t^3*(6 + nu)/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 10*nu*E*t^3/(9*nu^2 - 9), 2*E*t^3*(6 + nu)/(9*nu^2 - 9), -4*nu*E*t^3/(3*nu^2 - 3), -8*nu*E*t^3/(9*nu^2 - 9), -4*nu*E*t^3/(3*nu^2 - 3), 8*E*t^3*(-3 + nu)/(9*nu^2 - 9)]
    ];

F = [0 0 1 0 0 0 0 0]';

K = K_ele;

K([1 2 4],:) = [];
K(:,[1 2 4]) = [];

F([1 2 4]) = [];

w = K\F;
