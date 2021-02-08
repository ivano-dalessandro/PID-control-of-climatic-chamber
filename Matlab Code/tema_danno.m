delete(instrfind);

FGEN = visa('ni', 'GPIB0::2::INSTR'); %definiamo il generatore di funzione
DMM = visa('ni', 'GPIB0::3::INSTR'); %definiamo il multimetro utilizzato per le misure di tensione

fopen(FGEN); %accendiamo il generatore di funzione
fopen(DMM); %accendiamo il multimetro 

query(FGEN, '*idn?')
query(DMM, '*idn?')

N = 100; %numero di campioni di tensione di ingresso
%Definiamo il range di tensione di ingresso permesso dal dimmer elettronico
Vmin = 0; %limite inferiore del range di tensione
Vmax = 10; %limite superiore del range di tensione
Vinput = linspace(Vmin, Vmax, N); %definiamo la tensione di alimentazione in ingresso al dimmer
Vout = NaN*zeros(size(Vinput)); %inizializziamo il vettore che conterrà i valori misurati di tensione in uscita dal dimmer 
                                %mediante multimetro AGILENT
                                
fprintf(FGEN, 'APPLY:DC DEF,DEF,0');
for k = 1:N
    comm = sprintf('APPLY:DC DEF,DEF,%6.2f',Vinput(k));
    fprintf(FGEN, comm);
    pause(0.1);
    Vout(k) = query(DMM, 'MEAS:VOLT:AC?','%s','%f');
    plot(Vinput, Vout, 'o-');
    hold on
end
title('Curva caratteristica del dimmer');


fprintf(FGEN, 'APPLY:DC DEF,DEF,0');



fclose(FGEN); %spegniamo il generatore di funzione
fclose(DMM); %spegniamo il multimetro 

