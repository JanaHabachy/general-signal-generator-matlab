%% General Signal Generator
clc;
clear;
close all;

%% User Inputs
fs      = input('Enter sampling frequency: ');
t_start = input('Enter start time: ');
t_end   = input('Enter end time: ');

t = t_start : 1/fs : t_end;
x = zeros(size(t));

num_bp = input('Enter number of break points: ');

break_points = [];
if num_bp > 0
    break_points = input('Enter break point positions: ');
end

break_points = sort(break_points);
regions = [t_start break_points t_end];

%% Signal Generation
for i = 1:length(regions)-1
    fprintf('\nRegion %d (%.2f to %.2f)\n', i, regions(i), regions(i+1));
    disp('Signal type: 1=DC, 2=Ramp, 3=Polynomial, 4=Exponential, 5=Sinusoidal');

    choice = input('Enter choice: ');
    idx = (t >= regions(i)) & (t < regions(i+1));

    switch choice
        case 1  % DC
            A = input('Amplitude: ');
            x(idx) = A;

        case 2  % Ramp
            m = input('Slope: ');
            c = input('Intercept: ');
            x(idx) = m * t(idx) + c;

        case 3  % Polynomial
            A = input('Amplitude: ');
            p = input('Power: ');
            c = input('Intercept: ');
            x(idx) = A * t(idx).^p + c;

        case 4  % Exponential
            A = input('Amplitude: ');
            a = input('Exponent: ');
            x(idx) = A * exp(a * t(idx));

        case 5  % Sinusoidal
            A   = input('Amplitude: ');
            f   = input('Frequency: ');
            phi = input('Phase: ');
            x(idx) = A * sin(2 * pi * f * t(idx) + phi);
    end
end

%% Original Signal Plot
figure;
plot(t, x, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');

%% Signal Operations
disp('Choose operation:');
disp('1) Amplitude scaling');
disp('2) Time reversal');
disp('3) Time shift');
disp('4) Expansion');
disp('5) Compression');
disp('6) None');

op = input('Enter operation number: ');

t_new = t;
x_new = x;

switch op
    case 1  % Amplitude Scaling
        k = input('Enter scaling value: ');
        x_new = k * x;

    case 2  % Time Reversal
        t_new = -t;
        [t_new, idx] = sort(t_new);
        x_new = x(idx);

    case 3  % Time Shift
        shift = input('Enter shift value: ');
        t_new = t + shift;

    case 4  % Expansion
        a = input('Enter expansion value (>1): ');
        t_new = a * t;

    case 5  % Compression
        a = input('Enter compression value (<1): ');
        t_new = a * t;

    case 6
        % No operation
end

%% Modified Signal Plot
figure;
plot(t_new, x_new, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Modified Signal');
