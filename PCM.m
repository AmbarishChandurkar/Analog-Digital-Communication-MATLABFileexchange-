clc;
close all;
clearvars;
n=input('Enter for n-bit PCM system :  '); %Encodebook Bit Length
n1=input('Enter Sampling Frequency : '); %Sampling Frequency
L = 2^n; %Number of Quantisation Levels

%% Here we pllot the Analog Signal and its Sampled form
Vmax = 8;
x = 0:pi/n1:4*pi;  %Construction of Signal            
ActualSignl=Vmax*sin(x); %Actual input
subplot(3,1,1);
plot(ActualSignl);
title('Analog Signal');

subplot(3,1,2); %Sampled Version
stem(ActualSignl);grid on;  title('Sampled Sinal'); 

%% Now perform the Quantization Process

Vmin=-Vmax; %Since the Signal is sine 
StepSize=(Vmax-Vmin)/L;                             % Diference between each quantisation level
QuantizationLevels=Vmin:StepSize:Vmax;              % Quantisation Levels - For comparison
codebook=Vmin-(StepSize/2):StepSize:Vmax+(StepSize/2);  % Quantisation Values - As Final Output of qunatiz 
[ind,q]=quantiz(ActualSignl,QuantizationLevels,codebook);       % Quantization process


NonZeroInd = find(ind ~= 0);
ind(NonZeroInd) = ind(NonZeroInd) - 1; 
        % MATLAB gives indexing from 1 to N.But we need indexing from 0, to convert it into binary codebook
   
BelowVminInd = find(q == Vmin-(StepSize/2));
q(BelowVminInd) = Vmin+(StepSize/2);
  %This is for correction, as signal values cannot go beyond Vmin
  %But quantiz may suggest it, since it return the Values lower than Actual
  %Signal Value
subplot(3,1,3);
stem(q);grid on;                    % Display the Quantize values
title('Quantized Signal');
%% Having Quantised the values, we perform the Encoding Process
figure
TransmittedSig = de2bi(ind,'left-msb');   % Encode the Quantisation Level
SerialCode = reshape(TransmittedSig',[1 size(TransmittedSig,1)*size(TransmittedSig,2)]);
subplot(2,1,1); grid on;
stairs(SerialCode);              % Display the SerialCode Bit Stream
axis([0 100 -2 3]);  title('Transmitted Signal');

%% Now we perform the Demodulation Of PCM signal

RecievedCode=reshape(SerialCode,n,length(SerialCode)/n);  %Again Convert the SerialCode into Frames of 1 Byte
index = bi2de(RecievedCode','left-msb');                   %Binary to Decimal Conversion
q = (StepSize*index);  %Convert into Voltage Values
q = q + (Vmin+(StepSize/2)); % Above step gives a DC shfted version of Actual siganl
%Thus it is necessary to bring it to zero level
subplot(2,1,2); grid on;
plot(q);     % Plot Demodulated signal
title('Demodulated Signal');