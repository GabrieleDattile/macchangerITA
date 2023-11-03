# MacchangerITA.sh

## Descrizione

MacchangerITA.sh è uno script bash che cambia l'indirizzo MAC della tua interfaccia di rete in modo casuale o specifico. Questo script usa il comando `ip` per gestire le interfacce di rete e il comando `openssl` per generare indirizzi MAC casuali. Puoi usare questo script per modificare temporaneamente il tuo indirizzo MAC e nascondere la tua identità di rete.

## Requisiti

Per eseguire questo script, devi avere i seguenti requisiti:

- Un sistema operativo Linux o Unix
- Il comando `ip` installato sul tuo sistema
- Il comando `openssl` installato sul tuo sistema
- I privilegi di root o sudo per modificare le interfacce di rete

## Uso

Per usare questo script, devi seguire questi passi:

- Scarica lo script dal [link]([(https://github.com/GabrieleDattile/macchangerITA/blob/main/README.md)] o clona il repository con il comando `git clone https://github.com/GabrieleDattile/macchangerITA.sh.git`
- Rendi lo script eseguibile con il comando `chmod +x macchangerITA.sh`
- Esegui lo script con il comando `sudo ./macchangerITA.sh [opzione] [interfaccia]`

Le opzioni disponibili sono:

- `-r, --random`: Genera un indirizzo MAC casuale e lo imposta
- `-m, --mac MAC`: Imposta un indirizzo MAC personalizzato, es. `./macchangerITA.sh -m aa:bb:cc:dd:ee:ff en0`
- `-p, --permanente`: Ripristina l'indirizzo MAC al valore permanente
- `-s, --mostra`: Mostra l'indirizzo MAC corrente
- `-v, --versione`: Stampa la versione
- `-h, --aiuto`: Mostra il messaggio di aiuto

## Esempio

Ecco un esempio di output dello script:

```bash
$ sudo ./macchangerITA.sh -r en0
Indirizzo MAC permanente: 00:11:22:33:44:55
Vecchio indirizzo MAC: 00:11:22:33:44:55
Nuovo indirizzo MAC: 66:77:88:99:aa:bb
