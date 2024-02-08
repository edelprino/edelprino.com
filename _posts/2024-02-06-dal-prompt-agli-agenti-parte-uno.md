---
layout: post
title: Dal prompt agli agenti (Parte 1)
date: 2024-02-06
image: https://cdn.mos.cms.futurecdn.net/QRb9NDmmumKoiLz3TBwjGW-1200-80.png
excerpt: Scopri come gli agenti AI stanno rivoluzionando il mondo dell'automazione, aprendo nuove possibilità in campi che vanno dalla robotica alla gestione dei dati. Immergiti nell'evoluzione degli agenti AI, dalla loro nascita ai recenti sviluppi in tecnologie come Chat GPT e Large Language Models. Non perdere l'opportunità di esplorare come l'intelligenza artificiale sta trasformando il futuro dell'automazione con soluzioni innovative e accessibili.
---
Gli agenti nell'intelligenza artificiale (AI) rappresentano entità software o hardware capaci di agire autonomamente in un ambiente per raggiungere determinati obiettivi. Questi agenti possono percepire l'ambiente attraverso sensori e agire su di esso mediante attuatori (o strumenti). La loro importanza risiede nella capacità di automatizzare compiti, prendere decisioni in tempo reale e adattarsi a situazioni nuove o inaspettate, migliorando così l'efficienza e l'efficacia in vari campi applicativi, dalla robotica alla gestione dei dati, fino all'assistenza clienti.

Con l'avvento di Chat GPT e l'espansione delle capacità degli Large Language Models (LLM), il mondo dell'intelligenza artificiale ha iniziato a esplorare nuove frontiere, in particolare lo sviluppo di agenti autonomi dotati di capacità di ragionamento avanzate e in grado di eseguire azioni specifiche. Questo interesse crescente ha portato alla nascita di diversi framework dedicati, sebbene il principio fondamentale alla base di questa evoluzione rimanga sorprendentemente semplice.

La nostra familiarità con gli LLM, e Chat GPT in particolare, ha avuto inizio con l'uso interattivo tipico delle chat: si avvia una conversazione, si pongono domande, si ricevono risposte, e il processo continua fino al raggiungimento di una soddisfazione informativa. Tuttavia, ci siamo presto resi conto che molte delle azioni richieste, come la generazione di query SQL per interrogare database, presentano un carattere ripetitivo che si presta all'automazione.

La soluzione più immediata a questo bisogno di automazione consiste nell'elaborare un prompt personalizzato, contenente campi variabili da adattare di volta in volta alle esigenze specifiche. Ad esempio, per generare una query SQL basata su specifiche istruzioni, si potrebbe strutturare un prompt nel seguente modo:

```
Sei il migliore esperto di SQL al mondo e ho bisogno del tuo aiuto.
Voglio che traduca la richiesta che ti farò dal linguaggio umano ad una query SQL sintatticamente corretta per MySQL 5.7.
Restituisci solo la query sql, nessuna considerazione.
Qui di seguito ti fornirò la descrizione delle tabelle in modo che tu possa capire di quali campi si sta parlando nella richiesta e produrre query corrette:

+-------------+------------------+------+-----+---------+----------------+
| Field       | Type             | Null | Key | Default | Extra          |
+-------------+------------------+------+-----+---------+----------------+
| id          | int(11)          | NO   | PRI | NULL    | auto_increment |
| playhead    | int(10) unsigned | NO   |     | NULL    |                |
| payload     | longtext         | NO   |     | NULL    |                |
| recorded_on | varchar(32)      | NO   |     | NULL    |                |
+-------------+------------------+------+-----+---------+----------------+

Richiesta:
....
```

Questo approccio rappresenta il primo passo verso la concezione di un agente, poiché, se ogni sessione di chat fosse avviata con istruzioni pre-impostate su come elaborare una query SQL, avremmo creato un "SQL Query Manager": un agente capace di fornire automaticamente la query SQL richiesta. Implementare un sistema del genere in Python è sorprendentemente semplice.

```python
SQL_MANAGER_PROMPT = "Sei il migliore esperto di SQL al mondo..."

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

Questo frammento di codice illustra come creare un semplice agente, il "SQL Query Manager", utilizzando le API di Chat GPT. Dopo aver definito la chiave API e la funzione `sql_query_manager`, è possibile passare qualsiasi descrizione delle esigenze di query alla funzione, che invierà il prompt a Chat GPT e restituirà una query SQL basata sulle istruzioni fornite. Questo esempio dimostra non solo la potenzialità degli LLM nel creare agenti autonomi per compiti specifici ma anche la relativa facilità con cui tali soluzioni possono essere implementate.

In conclusione, questo primo articolo della serie ha gettato le basi per comprendere l'importanza e il potenziale degli agenti nell'intelligenza artificiale, delineando il loro ruolo fondamentale nell'evoluzione dell'automazione e nell'ottimizzazione dei processi in vari settori. Abbiamo esplorato le origini, l'evoluzione e le applicazioni attuali degli agenti AI, ponendo le premesse per una discussione più approfondita su come questi possono essere resi ancora più intelligenti e versatili. Nei prossimi articoli, ci addentreremo ulteriormente nelle tecniche avanzate e nelle strategie innovative per potenziare le capacità degli agenti AI, esaminando casi d'uso concreti e le ultime frontiere dell'intelligenza artificiale. 