# Plena Imago
Dette er en boligmodel som danner grundlag for modulet for nybyggeri i **Plena Imago**, hvor boligmarkedet opdeles i en urban og en rural geografi. Husholdningernes boligefterspørgsel bestemmes i et nestet CES-system, hvor boligkapital først vælges relativt til andre goder og derefter opdeles i by- og landboliger samt i nye og gamle boliger. Udvidelsen gør det muligt at analysere regionale forskelle i prisgennemslag fra regulering og boligforbrug samt urbaniseringsdynamikker over tid.

På udbudssiden introduceres eksplicit brug af jord som input i nybyggeri. I landområder antages frit udbud af jord til en eksogen pris, mens byområder er karakteriseret ved knaphed, nedrivning af eksisterende bygninger og endogen prisdannelse på jord. Bygherrerne maksimerer profit givet en CES-produktionsfunktion for nybyggeri, hvor både jord og selve bygningen indgår i produktion af nybyggeri. Modellen sikrer fuld konsistens mellem jordpriser, nedrivninger, nybyggeri og udviklingen i boligbestanden på tværs af områder.

Samlet giver modellen et konsistent, dynamisk system, der beskriver boligefterspørgsel og nybyggeri i Danmark. 

## Første installation på ny maskine
Kør først <code>paths.cmd</code>. Derefter <code>install.cmd</code> <br> 
Det er antaget at GAMS ligger i <code>C:/GAMS/49</code>. Hvis dette ikke er tilfældet så korriger <code>paths.cmd</code>
## Land/By
Dette sættes i toppen af <code>Byggerimodel.gms</code>:<br>
<code>\#--------------------------------------------------<br>
\# BY=1 betyder By. BY=0 betyder Land <br>
\#--------------------------------------------------<br>
\$setlocal BY 1;<br></code>  

## GitHub
For at bruge github skal du fortælle hvem du er. Det gør du ved at åbne en ny teminal og køre disse kommandoer med din mail og navn. Dit navn kan vælges frit og bruges til at vise hvem der har lavet ændringer. Derfor bedst hvis det er dit rigtige navn (for better blaming!)<br>  
<code>
git config --global user.email "you@example.com"<br>
git config --global user.name "Your Name"
</code><br>




