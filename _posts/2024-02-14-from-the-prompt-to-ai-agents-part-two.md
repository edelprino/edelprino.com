---
layout: post
title: From the Prompt to AI Agents (Part Two)
date: 2024-02-14
image: https://wallpapercosmos.com/w/middle-retina/e/4/d/459659-2000x1125-desktop-hd-agent-smith-the-matrix-wallpaper.jpg
excerpt: In this follow-up, we explore the evolution of AI agents capable of self-correction and collaborative tasks, marking a leap towards sophisticated, autonomous systems.
---
In the first part, we explored how to transition from a prompt to an initial version of an agent that not only generates SQL queries but also, through the use of function calling, can execute queries on the database and return the results.

This represents the ideal scenario, but what happens if the agent generates an incorrect query? To address this possibility, we might consider reintegrating ChatGPT into the process, creating a system with feedback: the initial request, the instruction to execute the query, and the obtained results. This approach would allow the agent to assess the adequacy of the executed query. If the query is correct, it could simply return the results; otherwise, it would have the opportunity to attempt a new query.

The underlying idea is to create a feedback loop between the response obtained from executing the query and the language model itself, mimicking the process a human would follow. Receive the request, execute the query, obtain a result, and if there's an error, understand the mistake and try the query again. It's up to us to also provide an indication to the agent on how many times to retry the call and, in case of failure, to return as detailed an error description as possible to facilitate debugging and problem-solving.

By extending the code developed previously, we can implement a system that is not limited to a single interaction with ChatGPT but enters into a cycle of iterations. In this cycle, the agent continues to request the execution of functions and to process the results until a definitive conclusion is reached, indicating that the agent has exhausted its options or has successfully completed the assigned task.

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


With this evolution, the agent fully assumes the role that defines it: an entity endowed with contextual knowledge and capable of undertaking autonomous actions. We have thus created a true chatbot capable of interacting with our database, autonomously executing queries, extracting the requested information, and communicating the results in natural language. This represents a significant step towards the realization of advanced interaction systems.

Perhaps the most fascinating aspect is the possibility of having multiple agents collaborate, each equipped with specific skills and tools. Through the collaboration of agents, it is possible to perform highly complex tasks, significantly expanding the system's capabilities. This synergy between agents not only facilitates access to information for non-technical users but can also significantly reduce the workload on technical departments, allowing them to focus on higher-value activities.

Just as we created one agent, we could create others tasked with different duties. The level of detail or how generic to make them is a discussion related to the domain for which the agent is being written. Keep in mind that the more details provided, the more precise the agent will be in executing tasks, but the less reusable it will be in other contexts. For example, one could create an agent that is an expert in bash, thus able to execute commands on the operating system, such as reading or writing files, or monitoring a certain type of resource. The options are endless.

However, we are still talking about different agents, so how can they collaborate with each other? Well, the simplest system is to introduce a "Project Manager". Until now, we have provided LLMs with "classic" functions, deterministic functions like `execute_query(query: str) -> str`, but if we think about it, even an agent can be described like the function above, with `sql_query_manager` taking in a string, in this case, a request, and returning a string, the response.

The project manager would be nothing more than an agent that has other agents as tools instead of functions. It will communicate with them using human language and will be responsible for choosing which agents to use and in what order.

A simple team composed of a ProjectManager, QueryExpert, and BashExpert could easily execute queries, save the results, and perhaps retrieve them for use at later times. The configuration of each individual agent and then of the various teams depends on the context in which they will operate and the limits of the chosen language model.

The exploration of AI agents marks a significant advancement in the realm of artificial intelligence and automation. By developing agents capable of self-correction and executing complex, collaborative tasks, we edge closer to creating sophisticated, autonomous systems that can significantly enhance efficiency and productivity. The implementation of a feedback loop for error correction and the potential for agent collaboration presents a leap towards systems that can autonomously interact with databases, execute queries, and communicate results in natural language. Furthermore, the concept of a "Project Manager" agent orchestrates the collaboration between specialized agents, paving the way for highly complex task execution without the need for direct human intervention. This evolution not only promises to revolutionize the way we interact with information systems but also opens up new possibilities for reducing technical workloads and making advanced data manipulation accessible to non-technical users.