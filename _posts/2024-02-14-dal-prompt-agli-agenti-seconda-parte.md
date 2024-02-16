---
layout: post
title: Dal Prompt agli Agenti AI (Seconda Parte)
date: 2024-02-14
image: https://wallpapercosmos.com/w/middle-retina/e/4/d/459659-2000x1125-desktop-hd-agent-smith-the-matrix-wallpaper.jpg
excerpt: In questo seguito, esploriamo l'evoluzione degli agenti AI capaci di autocorrezione e compiti collaborativi, segnando un passo avanti verso sistemi sofisticati e autonomi.
---
Nella [prima parte](https://edelprino.com/dal-prompt-agli-agenti-prima-parte), abbiamo esplorato come passare da un prompt a una versione iniziale di un agente che non solo genera query SQL, ma anche, attraverso l'uso della chiamata di funzioni, può eseguire le query sul database e restituire i risultati.

Questo rappresenta lo scenario ideale, ma cosa succede se l'agente genera una query errata? Per affrontare questa possibilità, potremmo considerare di reintegrare ChatGPT nel processo, creando un sistema con feedback: la richiesta iniziale, l'istruzione per eseguire la query e i risultati ottenuti. Questo approccio consentirebbe all'agente di valutare l'adeguatezza della query eseguita. Se la query è corretta, potrebbe semplicemente restituire i risultati; altrimenti, avrebbe l'opportunità di tentare una nuova query.

L'idea di base è creare un ciclo di feedback tra la risposta ottenuta dall'esecuzione della query e il modello di linguaggio stesso, imitando il processo che seguirebbe un essere umano. Ricevere la richiesta, eseguire la query, ottenere un risultato e, in caso di errore, comprendere l'errore e provare nuovamente la query. Spetta a noi fornire anche un'indicazione all'agente su quante volte riprovare la chiamata e, in caso di fallimento, restituire una descrizione dell'errore il più dettagliata possibile per facilitare il debug e la risoluzione dei problemi.

Estendendo il codice sviluppato in precedenza, possiamo implementare un sistema che non si limita a una singola interazione con ChatGPT, ma entra in un ciclo di iterazioni. In questo ciclo, l'agente continua a richiedere l'esecuzione di funzioni e a elaborare i risultati fino a raggiungere una conclusione definitiva, indicando che l'agente ha esaurito le sue opzioni o ha completato con successo il compito assegnato.

```python
def system_message(content: str):
	return {"role": "system", "content": content},

def user_message(content: str):
	return {"role": "user", "content": content},

def assistant_message(calls):
	return {"role": "assistant", "content": content, "tool_calls": calls}

def tool_message(id: str, content: str = ""):
	return {"role": "tool", "content": content, "tool_call_id": id}

def call_query_manager_brain(messages):
	response = client.chat.completions.create(
		model="gpt-4-1106-preview",
		messages=messages,
		tools=[{
			"type": "function",
			"function": {
				"name": "execute_query",
				"description": "Execute query on mysql database",
				...
			}
		}]
	)

	if response.choices[0].finish_reason == "tool_calls":
		tool_calls = response.choices[0].message.tool_calls

		tool_call = tool_calls[0] # this is an example but you can have multiple calls!
		arguments = json.loads(tool_call.function.arguments)
		query_result = execute_query(arguments["query"])
		messages = messages + [assistant_message(tool_calls), tool_message(tool_call.id, query_result)]

		return call_query_manager_brain(messages)

	return response.choices[0].message.content



def sql_query_manager(request: str) -> str:
	try:
		messages = [
			system_message(SQL_MANAGER_PROMPT),
			user_message(request)
		]
		return call_query_manager_brain(messages)
	except Exception as e:
		return f"There was an error: {e}"

```

Con questa evoluzione, l'agente assume pienamente il ruolo che lo definisce: un'entità dotata di conoscenza contestuale e capace di intraprendere azioni autonome. Abbiamo così creato un vero chatbot capace di interagire con il nostro database, eseguendo autonomamente le query, estraendo le informazioni richieste e comunicando i risultati in linguaggio naturale. Questo rappresenta un passo significativo verso la realizzazione di sistemi di interazione avanzati.

Forse l'aspetto più affascinante è la possibilità di avere più agenti che collaborano, ognuno dotato di competenze e strumenti specifici. Attraverso la collaborazione degli agenti, è possibile eseguire compiti altamente complessi, espandendo significativamente le capacità del sistema. Questa sinergia tra agenti non solo facilita l'accesso alle informazioni per gli utenti non tecnici, ma può anche ridurre significativamente il carico di lavoro sui dipartimenti tecnici, consentendo loro di concentrarsi su attività di maggiore valore.

Così come abbiamo creato un agente, potremmo crearne altri incaricati di compiti diversi. Il livello di dettaglio o quanto renderli generici è una discussione relativa al dominio per cui viene scritto l'agente. Tieni presente che più dettagli vengono forniti, più preciso sarà l'agente nell'eseguire compiti, ma meno riutilizzabile sarà in altri contesti. Ad esempio, si potrebbe creare un agente che è un esperto in bash, quindi in grado di eseguire comandi sul sistema operativo, come leggere o scrivere file, o monitorare un certo tipo di risorsa. Le opzioni sono infinite.

Tuttavia, stiamo ancora parlando di agenti diversi, quindi come possono collaborare tra loro? Bene, il sistema più semplice è introdurre un "Project Manager". Fino ad ora, abbiamo fornito alle LLM funzioni "classiche", funzioni deterministiche come `execute_query(query: str) -> str`, ma se ci pensiamo, anche un agente può essere descritto come la funzione sopra, con `sql_query_manager` che prende in input una stringa, in questo caso una richiesta, e restituisce una stringa, la risposta.

Il project manager non sarebbe altro che un agente che ha altri agenti come strumenti invece che funzioni. Comunicherà con loro usando il linguaggio umano e sarà responsabile della scelta di quali agenti utilizzare e in quale ordine.

Un semplice team composto da un ProjectManager, un QueryExpert e un BashExpert potrebbe facilmente eseguire query, salvare i risultati e forse recuperarli per usarli in momenti successivi. La configurazione di ciascun agente individuale e poi dei vari team dipende dal contesto in cui opereranno e dai limiti del modello di linguaggio scelto.

L'esplorazione degli agenti AI segna un significativo avanzamento nel regno dell'intelligenza artificiale e dell'automazione. Sviluppando agenti capaci di autocorrezione e di eseguire compiti complessi e collaborativi, ci avviciniamo alla creazione di sistemi sofisticati e autonomi che possono migliorare significativamente l'efficienza e la produttività. L'implementazione di un ciclo di feedback per la correzione degli errori e il potenziale per la collaborazione tra agenti rappresenta un salto verso sistemi che possono interagire autonomamente con i database, eseguire query e comunicare i risultati in linguaggio naturale. Inoltre, il concetto di un agente "Project Manager" che orchestra la collaborazione tra agenti specializzati apre la strada all'esecuzione di compiti altamente complessi senza la necessità di un intervento umano diretto. Questa evoluzione non solo promette di rivoluzionare il modo in cui interagiamo con i sistemi informativi, ma apre anche nuove possibilità per ridurre il carico di lavoro tecnico e rendere la manipolazione avanzata dei dati accessibile agli utenti non tecnici.