function nn = nrmse(xtrue, xhat)
% function nn = nrmse(xtrue, xhat)
% finds the nrmse between the true and estimated vectors
% inputs:       xtrue - true vector
%               xhat  - estimated vector
% outputs:      nn    - NRMSE betweeen xtrue & xhat

nn = norm(xhat(:) - xtrue(:)) / norm(xtrue(:));
