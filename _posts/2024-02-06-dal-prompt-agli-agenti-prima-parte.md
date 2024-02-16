---
layout: post
title: Dal Prompt agli Agenti AI (Prima Parte)
date: 2024-02-09
image: https://ik.imagekit.io/edelprino/edelprino/blog/matrix-4-agent-smith-1024x614_I3h7cAr0P.webp?updatedAt=1707560286932
excerpt: "Esplora la rivoluzione dell'IA che trasforma l'automazione: dal semplice prompt agli agenti AI sofisticati, scopri come la tecnologia sta ridefinendo il nostro approccio ai dati e alla robotica. Quando l'IA incontra i propri errori, inizia la ver..."
---
Con l'avvento di Chat GPT e l'espansione delle capacità dei Modelli di Linguaggio di Grande Dimensione (LLM), il mondo dell'intelligenza artificiale ha iniziato ad esplorare nuove frontiere, in particolare lo sviluppo di agenti autonomi dotati di avanzate capacità di ragionamento e capaci di eseguire azioni specifiche. Questo crescente interesse ha portato alla nascita di diversi framework dedicati, sebbene il principio fondamentale dietro questa evoluzione rimanga sorprendentemente semplice.

La nostra familiarità con gli LLM, e Chat GPT in particolare, è iniziata con l'uso interattivo tipico delle chat: iniziare una conversazione, fare domande, ricevere risposte, e il processo continua fino a quando non si raggiunge la soddisfazione informativa. Tuttavia, ci siamo presto resi conto che molte delle azioni richieste, come la generazione di query SQL per interrogare database, hanno una natura ripetitiva che si presta all'automazione.

La soluzione più immediata a questa necessità di automazione prevede la creazione di un prompt personalizzato, contenente campi variabili da adattare di volta in volta a esigenze specifiche. Ad esempio, per generare una query SQL basata su istruzioni specifiche, si potrebbe strutturare un prompt nel seguente modo:

```
Sei il miglior esperto di SQL al mondo e ho bisogno del tuo aiuto.
Voglio che tu traduca la richiesta che farò dal linguaggio umano a una query SQL sintatticamente corretta per MySQL 5.7.
Di seguito ti fornirò la descrizione delle tabelle in modo che tu possa capire di quali campi si sta parlando nella richiesta e produrre query corrette:

+-------------+------------------+------+-----+---------+----------------+
| Field       | Type             | Null | Key | Default | Extra          |
+-------------+------------------+------+-----+---------+----------------+
| id          | int(11)          | NO   | PRI | NULL    | auto_increment |
| playhead    | int(10) unsigned | NO   |     | NULL    |                |
| payload     | longtext         | NO   |     | NULL    |                |
| recorded_on | varchar(32)      | NO   |     | NULL    |                |
+-------------+------------------+------+-----+---------+----------------+
```

Questo approccio rappresenta il primo passo verso la concezione di un agente, poiché, se ogni sessione di chat fosse iniziata con istruzioni preimpostate su come elaborare una query SQL, avremmo creato un "Gestore di Query SQL": un inizio di agente capace di fornire automaticamente la query SQL richiesta. Implementare un tale sistema in Python è sorprendentemente semplice.

```python
SQL_MANAGER_PROMPT = "Sei il miglior esperto di SQL al mondo..."
def sql_query_manager(request: str) -> str:
    completion = client.chat.completions.create(
      model="gpt-3.5-turbo",
      messages=[
        {"role": "system", "content": SQL_MANAGER_PROMPT},
        {"role": "user", "content": request}
      ]
    )
    return completion.choices[0].message
```

Elevare le capacità di questo codice non solo per generare query SQL ma anche per eseguirle e restituire i risultati rappresenta un salto qualitativo nella sua utilità e complessità. Questo avanzamento apre la strada ad automazioni più sofisticate e interazioni più ricche con i database, senza la necessità di intervento umano nella trascrizione e nell'esecuzione delle query.

Per raggiungere questo obiettivo, è fondamentale che il modello di linguaggio che stiamo interrogando produca risposte formattate secondo uno standard preciso. Questo approccio consente l'interpretazione e l'uso dell'output direttamente nel codice, automatizzando l'esecuzione delle query.

Integrando istruzioni su come l'output dovrebbe essere formattato e passando un certo parametro nella richiesta, si può sfruttare la capacità di Chat GPT di produrre risposte che rispettano il formato JSON. Questa caratteristica è particolarmente preziosa in quanto garantisce che l'output sia non solo semanticamente corretto ma anche sintatticamente conforme agli standard richiesti per l'elaborazione automatica.

OpenAI ha recentemente introdotto una caratteristica rivoluzionaria chiamata [Function calling](https://platform.openai.com/docs/guides/function-calling), che espande notevolmente il potenziale delle nostre funzioni. Questa innovazione consente alle risposte di includere non solo testo ma anche istruzioni specifiche per eseguire funzioni definite dall'utente. In pratica, si dice all'agente cosa fare e quali strumenti ha a disposizione, e poi, seguendo il principio di "mi dici cosa fare e io lo faccio", il modello comunica le chiamate da effettuare e con quali argomenti, a quel punto eseguiamo il codice in modo acritico utilizzando i parametri forniti. Qui un esempio se volete il codice complete lo trovate su 
[Github](https://gist.github.com/edelprino/6f8ecd724f09cde0eb19e3fc7f12fa65).

```python
def sql_query_manager(request: str) -> str:
    try:
        response = client.chat.completions.create(
            model="gpt-4-1106-preview",
            messages=[{"role": "system", "content": SQL_MANAGER_PROMPT}, {"role": "user", "content": request}],
            tools=[{
                "type": "function",
                "function": {
                    "name": "execute_query",
                    "description": "Execute query on mysql database",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "query": {"type": "string", "description": "The query to execute on mysql database"},
                        },
                        "required": ["query"]
                    }
                }
            }]
        )

        if response.choices[0].finish_reason == "tool_calls":
            arguments = json.loads(response.choices[0].message.tool_calls[0].function.arguments)
            return execute_query(arguments["query"])

        return response.choices[0].message.content
    except Exception as e:
        return f"There was an error: {e}"
```

Inizialmente, abbiamo automatizzato la generazione di query SQL, trasformando i desideri in istruzioni SQL concrete. Successivamente, abbiamo esteso l'automazione all'esecuzione delle query, completando il flusso da "Desideri" a "Query SQL" e infine a "Risultati della Query".

Questo rappresenta il percorso ideale, ma cosa succede se l'agente genera una query errata? Possiamo far sì che si corregga da solo? Ma soprattutto, come passiamo da un gestore di query SQL a una serie di agenti che eseguono compiti complessi? Queste sono alcune delle domande che esploreremo nella seconda parte.