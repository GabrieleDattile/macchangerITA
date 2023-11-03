#!/bin/bash

# Funzione per mostrare il messaggio di aiuto
mostra_aiuto() {
  echo "Uso: sudo $0 [opzione] [interfaccia]"
  echo "Opzioni:"
  echo "  -r, --random    Genera un indirizzo MAC casuale e lo imposta"
  echo "  -m, --mac MAC   Imposta un indirizzo MAC personalizzato, es. $0 -m aa:bb:cc:dd:ee:ff en0"
  echo "  -p, --permanente Ripristina l'indirizzo MAC al valore permanente"
  echo "  -s, --mostra      Mostra l'indirizzo MAC corrente"
  echo "  -v, --versione   Stampa la versione"
  echo "  -h, --aiuto      Mostra questo messaggio di aiuto"
}

# Funzione per controllare se l'interfaccia esiste
controlla_interfaccia() {
  if ! ip link show "$1" &> /dev/null; then
    echo "Interfaccia $1 non trovata."
    exit 1
  fi
}

# Funzione per generare un indirizzo MAC casuale
genera_mac_casuale() {
  # Genera un numero casuale di 12 cifre esadecimali
  local esadecimale_casuale=$(openssl rand -hex 6)

  # Inserisci i due punti ogni due cifre
  local mac_casuale=$(echo "$esadecimale_casuale" | sed 's/\(..\)/\1:/g;s/:$//')

  # Restituisci l'indirizzo MAC casuale
  echo "$mac_casuale"
}

# Funzione per ottenere l'indirizzo MAC permanente
ottieni_mac_permanente() {
  # Leggi l'indirizzo MAC permanente dal file ethtool
  local mac_permanente=$(ethtool -P "$1" | awk '{print $3}')

  # Restituisci l'indirizzo MAC permanente
  echo "$mac_permanente"
}

# Funzione per cambiare l'indirizzo MAC
cambia_mac() {
  # Controlla se l'interfaccia esiste
  controlla_interfaccia "$2"

  # Ottieni l'indirizzo MAC corrente
  local mac_corrente=$(ip link show "$2" | awk '/ether/ {print $2}')

  # Controlla se l'opzione è valida
  case "$1" in
    -r|--random)
      # Genera un indirizzo MAC casuale
      local nuovo_mac=$(genera_mac_casuale)

      # Cambia l'indirizzo MAC con il valore casuale
      ip link set dev "$2" down
      ip link set dev "$2" address "$nuovo_mac"
      ip link set dev "$2" up
      ;;
    -m|--mac)
      # Controlla se l'indirizzo MAC è valido
      if [[ "$3" =~ ^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$ ]]; then
        # Cambia l'indirizzo MAC con il valore specificato
        local nuovo_mac="$3"
        ip link set dev "$2" down
        ip link set dev "$2" address "$nuovo_mac"
        ip link set dev "$2" up
      else
        echo "Indirizzo MAC non valido: $3"
        exit 1
      fi
      ;;
    -p|--permanente)
      # Ottieni l'indirizzo MAC permanente
      local nuovo_mac=$(ottieni_mac_permanente "$2")

      # Cambia l'indirizzo MAC con il valore permanente
      ip link set dev "$2" down
      ip link set dev "$2" address "$nuovo_mac"
      ip link set dev "$2" up
      ;;
    -s|--mostra)
      # Mostra l'indirizzo MAC corrente
      echo "Indirizzo MAC corrente: $mac_corrente"
      exit 0
      ;;
    -v|--versione)
      # Stampa la versione
      echo "macchangerITA.sh versione 1.0"
      exit 0
      ;;
    -h|--aiuto)
      # Mostra il messaggio di aiuto
      mostra_aiuto
      exit 0
      ;;
    *)
      # Mostra il messaggio di errore
      echo "Opzione non valida: $1"
      mostra_aiuto
      exit 1
      ;;
  esac

  # Mostra il risultato del cambio
  echo "Indirizzo MAC permanente: $(ottieni_mac_permanente "$2")"
  echo "Vecchio indirizzo MAC: $mac_corrente"
  echo "Nuovo indirizzo MAC: $nuovo_mac"
}

# Controlla se lo script è eseguito come root
if [ "$EUID" -ne 0 ]; then
  echo "Questo script richiede i privilegi di root."
  exit 1
fi

# Controlla se ci sono argomenti
if [ "$#" -eq 0 ]; then
  mostra_aiuto
  exit 1
fi

# Chiama la funzione principale
cambia_mac "$@"
