%% Mass-spring-damper system analysis
% States: displacement and velocity.
% Requires MATLAB and Control System Toolbox.
% Simulink is optional for the plots produced by this script.

clear variables;
close all;
clc;
format compact;


%% Physical parameters

m = 1;      % Mass [kg]
k = 0.5;    % Spring stiffness [N/m]
f = 0.4;    % Viscous damping [N*s/m]
F = 1;      % Applied step force [N]


%% State-space models
% The supplied Simulink model uses A, B, C and D from the workspace.
% C = [0 1] selects velocity as its output.

A = [0, 1; -k / m, -f / m];
B = [0; 1 / m];
C = [0, 1];
D = 0;

velocitySystem = ss(A, B, C, D);
displacementSystem = ss(A, B, [1, 0], D);


%% Transfer function, poles and feedback margins

H0 = tf(velocitySystem);
systemPoles = pole(velocitySystem);

% Margins describe a hypothetical unity negative-feedback loop using
% the numerical velocity transfer model, not an implemented controller.
[Gm, Pm] = margin(H0);
gainMarginDb = 20 * log10(Gm);

disp('Force-to-velocity transfer function:');
disp(H0);

disp('Poles:');
disp(systemPoles);

fprintf('Hypothetical loop gain margin: %.3f dB\n', gainMarginDb);
fprintf('Hypothetical loop phase margin: %.3f deg\n', Pm);


%% Natural frequency and damping

naturalFrequency = sqrt(k / m);
dampingRatio = f / (2 * sqrt(k * m));

% Decay-envelope time constant for this underdamped system.
decayTimeConstant = 2 * m / f;

fprintf('Natural frequency: %.3f rad/s\n', naturalFrequency);
fprintf('Damping ratio: %.3f\n', dampingRatio);
fprintf('Decay-envelope time constant: %.3f s\n', decayTimeConstant);


%% Step response and steady-state analysis

t = 0:0.01:100;
u = F * ones(size(t));

[v, t, states] = lsim(velocitySystem, u, t);

% Percentage overshoot and DC-relative bandwidth are evaluated for
% displacement because the velocity response settles to zero.
displacementStepInfo = stepinfo(displacementSystem);
displacementBandwidth = bandwidth(displacementSystem);

fprintf('Expected steady displacement: %.3f m\n', F / k);
fprintf('Expected steady velocity: 0 m/s; simulated: %.3g m/s\n', v(end));

disp('Displacement step response characteristics:');
disp(displacementStepInfo);

fprintf('Displacement bandwidth: %.3f rad/s\n', displacementBandwidth);


%% Sinusoidal input
% Sinusoidal force with a 1 N amplitude and a 1 Hz frequency.

u_sin = sin(2 * pi * 1 * t);


%% Plot 1 - Step response

figure;

subplot(2, 1, 1);
plot(t, states(:, 1));
grid on;
xlabel('{\itTime} [s]');
ylabel('{\itDisplacement} [m]');
title('Response to a step force');

subplot(2, 1, 2);
plot(t, v);
grid on;
xlabel('{\itTime} [s]');
ylabel('{\itVelocity} [m/s]');


%% Plot 2 - Bode diagram

% Calculate the frequency response of the system
w = logspace(-1, 2, 100); % Frequency vector
[mag, phase, wout] = bode(H0, w); % Magnitude and phase response
A_dB = 20 * log10(squeeze(mag));    % convert to dB and remove singleton dimensions
phaseVec = squeeze(phase);     % convert phase to a vector


figure(2)
subplot(211)
semilogx(wout, A_dB) 
title('Force-to-velocity frequency response');
xlabel('\omega [rad/s]');
ylabel('{\itA}  [dB]');
grid on;

subplot(212)
semilogx(wout, phaseVec)
xlabel('\omega [rad/s]');
ylabel('{\it \phi} [°]');
grid on;


%% Plot 3 - Sinusoidal response

figure;
lsim(velocitySystem, u_sin, t);
grid on;
title('Velocity response to a 1 Hz sinusoidal force');


%% Plot 4 - Nyquist diagram

figure;
nyquist(H0);
grid on;
title('Force-to-velocity Nyquist plot');


% % Optional - Open the Simulink model
% Run the script first to initialize A, B, C and D.
% The model uses a unit step at t = 0.01 s; the script uses t = 0 s.
% To open the model, uncomment the line below.
% 
% open_system('mehanski_sistem.slx');
