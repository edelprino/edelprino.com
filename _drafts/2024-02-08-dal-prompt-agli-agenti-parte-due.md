---
layout: post
title: From the Prompt to AI Agents (Part Two)
date: 2024-02-08
image: https://wallpapercosmos.com/w/middle-retina/e/4/d/459659-2000x1125-desktop-hd-agent-smith-the-matrix-wallpaper.jpg
excerpt:
---
Nella prima parte abbiamo affrontato come passare da un prompt ad un primo abbozzo di agente che non solo generasse query sql ma che, grazie all'utilizzo del function calling, potesse eseguire anche query sul db restituendo il risultato

Questo è l'happy path, il caso ottimale ma cosa accade se l'agente genera una query errata?
Per affrontare questa eventualità, potremmo considerare di reintegrare ChatGPT nel processo, creando un sistema con feedback: la richiesta iniziale, l'istruzione di eseguire la query e i risultati ottenuti. Questo approccio consentirebbe all'agente di valutare l'adeguatezza della query eseguita. Se la query fosse corretta, potrebbe semplicemente restituire i risultati; in caso contrario, avrebbe la possibilità di tentare una nuova query.

L'idea che ci sta alla base è quello di creare un ciclo di feedback tra la risposta ottenuta dall'esecuzione della query e il modello linguistico stesso. Per creare un processo simile a quello che farebbe una persona. Riceve la richiesta, esegue la query, ottiene un risultato, se è un errore, capisce l'errore e riprova la query. Sta a noi fornire anche un'indicazione all'agente sul numero di volte in cui ritentare la chiamata e nel caso restituire una descrizione il più dettagliata possibile dell'errore in modo che possa poi essere più facile fare debug e risolvere eveutali problemi.

Estendendo il codice precedentemente sviluppato, quindi possiamo implementare un sistema che non si limita a una singola interazione con ChatGPT, ma entra in un ciclo di iterazioni. In questo ciclo, l'agente continua a richiedere l'esecuzione di funzioni e a processare i risultati fino a che non si raggiunge una conclusione definitiva, segnalando così che l'agente ha esaurito le sue opzioni o ha completato con successo il compito assegnato.

```
inserire il codice python per il feedback loop sul function calling
```

Con questa evoluzione, l'agente assume pienamente il ruolo che lo definisce: un'entità dotata di conoscenza contestuale e capace di intraprendere azioni autonome. Abbiamo, quindi, creato un vero e proprio chatbot in grado di interagire con il nostro database, eseguendo query in autonomia, estraendo le informazioni richieste e comunicando i risultati in linguaggio naturale. Questo rappresenta un passo significativo verso la realizzazione di sistemi di interazione avanzati.

L'ultimo aspetto, forse anche il più affascinante, è la possibilità di far collaborare più agenti, ciascuno dotato di competenze e strumenti specifici. Attraverso la collaborazione tra agenti, è possibile eseguire compiti di elevata complessità, ampliando notevolmente le potenzialità del sistema. Questa sinergia tra agenti non solo facilita l'accesso alle informazioni per gli utenti non tecnici, ma può anche ridurre significativamente i carichi di lavoro sui reparti tecnici, consentendo loro di concentrarsi su attività di maggior valore.

Come l'agente che abbiamo creato ne potremmo fare altri che hanno altri compiti. Il livello di dettaglio o quanto generici farli è un discorso legato al dominio per cui si sta scrivendo l'agente. Tenendo conto che più dettagli gli si forniscono più lui sarà preciso nelle esecuzioni dei compiti ma meno sarà poi riutilizzabile in altri contesti. 
Ad esempio si potrebbe creare 
