---
layout: post
title: Dal prompt agli agenti (Parte 2)
date: 2024-02-06
image: https://www.denofgeek.com/wp-content/uploads/2021/12/the-matrix-resurrections-agent-smith-hugo-weaving.jpg?fit=1600%2C1067
excerpt:
---
Proseguendo il nostro viaggio nell'esplorazione delle frontiere dell'intelligenza artificiale, questa seconda puntata si addentrerà nelle nuove dimensioni di autonomia e efficienza che gli agenti AI stanno raggiungendo, trasformando radicalmente il modo in cui interagiamo con i dati e le tecnologie. 

 Elevare le capacità di un agente per renderlo non solo in grado di generare query SQL, ma anche di eseguirle e restituire i risultati, rappresenta un salto qualitativo nella sua utilità e complessità. Questo avanzamento apre la strada a un'automazione più sofisticata e a interazioni più ricche con i database, senza la necessità di intervento umano per la trascrizione e l'esecuzione delle query.

Per realizzare questo obiettivo è molto importante 

Per realizzare questo obiettivo, è fondamentale che l'agente produca risposte formattate secondo uno standard preciso. Questo approccio consente di interpretare e utilizzare l'output direttamente nel codice, automatizzando l'esecuzione delle query. Un esempio di prompt che potrebbe essere utilizzato per generare una query SQL, assicurandosi che l'output sia esclusivamente la query stessa, potrebbe essere:

```
"Genera una query SQL per selezionare tutti i record dalla tabella 'clienti' dove 'anno_nascita' è maggiore del 1990. Assicurati che l'output sia solo la query SQL."
```

Integrando le istruzioni su come l'output deve essere formattato, si può sfruttare la capacità di Chat GPT di produrre risposte che rispettino un formato specifico, come un JSON valido. Questa caratteristica è particolarmente preziosa poiché garantisce che l'output sia non solo semanticamente corretto ma anche sintatticamente conforme agli standard richiesti per l'elaborazione automatica.

Per trasformare l'agente in un esecutore di query, si può procedere nel seguente modo:

```python
import openai
import mysql.connector

# Configura la connessione al database MySQL
conn = mysql.connector.connect(
    host="indirizzo_host",
    user="nome_utente",
    password="password",
    database="nome_database"
)
cursor = conn.cursor()

# Chiave API OpenAI
openai.api_key = 'la_tua_chiave_API'

def esegui_query_sql_da_gpt(prompt):
    # Genera la query SQL tramite Chat GPT
    response = openai.Completion.create(
      engine="text-davinci-003",
      prompt=prompt,
      temperature=0.5,
      max_tokens=150
    )
    query_sql = response.choices[0].text.strip()

    # Esegue la query SQL sul database MySQL
    try:
        cursor.execute(query_sql)
        risultati = cursor.fetchall()
        for riga in risultati:
            print(riga)
    except Exception as e:
        print("Errore durante l'esecuzione della query:", e)

# Esempio di utilizzo
prompt = "Genera una query SQL per selezionare tutti i record dalla tabella 'clienti' dove 'anno_nascita' è maggiore del 1990. Assicurati che l'output sia solo la query SQL."
esegui_query_sql_da_gpt(prompt)
```

Questo codice dimostra come un agente possa non solo formulare query SQL complesse ma anche eseguirle direttamente su un database MySQL, rendendo il processo completamente automatizzato. Attraverso questa implementazione, l'agente acquisisce una doppia capacità: comprendere il linguaggio SQL e interagire attivamente con i database, eseguendo query e restituendo risultati. Questo rappresenta un significativo passo avanti nella creazione di agenti intelligenti e autonomi, capaci di svolgere compiti specifici con un alto grado di indipendenza.

OpenAI ha recentemente introdotto una funzionalità rivoluzionaria denominata "function calling", che amplia notevolmente le potenzialità degli agenti basati su GPT. Questa innovazione permette alle risposte di includere non solo testo ma anche istruzioni specifiche per eseguire funzioni definite dall'utente. In pratica, si comunica all'agente cosa deve fare e quali strumenti ha a disposizione, e poi, seguendo il principio "tu mi dici quello che devo fare e io lo faccio", l'agente ci comunica le chiamate da fare e con che argomenti.

Immaginiamo di voler utilizzare questa funzionalità per eseguire query SQL attraverso le nostre interazioni con l'agente. Il codice sottostante rappresenta un esempio di come potrebbe essere implementato utilizzando le "function calling":

```python
# Esempio ipotetico, la funzionalità specifica di "function calling" per eseguire query SQL
# direttamente tramite ChatGPT non è fornita nel codice di esempio attuale di OpenAI.

def esegui_query_sql(query):
    # Funzione che esegue la query SQL e restituisce i risultati
    pass

# Utilizzo di function calling con OpenAI (ipotetico)
response = openai.Completion.create(
  engine="text-davinci-003",
  prompt="Esegui questa query SQL e restituisci i risultati: SELECT * FROM utenti;",
  temperature=0.5,
  max_tokens=150,
  function_calling=True  # Ipotesi su come potrebbe essere abilitata la funzione
)
```

