# Mass–Spring–Damper System Analysis

A student project by Matej Grajželj exploring time and frequency responses of a mechanical system using MATLAB and Simulink.

## Model

`m*x'' + f*x' + k*x = F(t)` with zero initial conditions.

| Parameter | Value |
|---|---|
| Mass m | 1 kg |
| Stiffness k | 0.5 N/m |
| Damping f | 0.4 N·s/m |
| Step force | 1 N |

States are displacement and velocity. The supplied Simulink model selects velocity (`C = [0 1]`), so its transfer function is `s / (s² + 0.4s + 0.5)`. The script also analyzes displacement, with transfer function `1 / (s² + 0.4s + 0.5)`.

## Run

Requires MATLAB and Control System Toolbox; Simulink is required only to open/run the `.slx` model. Set the MATLAB current folder to this repository, then run:

```matlab
Mass_Spring_Damper
open_system('mehanski_sistem.slx')
```

Run the script first to define A, B, C and D for Simulink. Press Run in Simulink and open Scope to inspect velocity. The unchanged model uses a unit step at 0.01 s; the script uses a step at 0 s. If changing F, also change the Simulink Step block's final value.

## Expected results

- Stable, underdamped response; poles approximately −0.2 ± 0.678233i.
- Natural frequency 0.707107 rad/s; damping ratio 0.282843.
- Displacement settles to 2 m; velocity settles to 0 m/s.
- Exponential decay-envelope time constant: 5 s.
- Plots: step response, Bode, sinusoidal response and Nyquist.

Percentage overshoot and DC-relative bandwidth are evaluated for displacement, not the zero-final-value velocity response. Gain/phase margins illustrate a hypothetical feedback loop, not a controller implemented in the supplied model. Infinite margins are possible.

## Scope and learning

This project provided practical experience in state-space modeling, transfer functions, time-domain simulation and frequency-domain analysis. The MATLAB script and Simulink model were tested, and the Simulink response was consistent with the results obtained in MATLAB. The model also helped connect the system equations with the block-diagram representation and the resulting dynamic response.

The project uses an ideal linear model and does not include nonlinear friction, parameter identification or hardware validation. The accompanying script distinguishes between displacement and velocity so that the results are interpreted correctly.

References: [MATLAB margin](https://www.mathworks.com/help/control/ref/dynamicsystem.margin.html), [stepinfo](https://www.mathworks.com/help/control/ref/dynamicsystem.stepinfo.html).

## Verification status

The MATLAB script and Simulink model were run successfully. The Simulink model produced results consistent with the MATLAB analysis.
