---
layout: post
title: From the Prompt to AI Agents (Part One)
date: 2024-02-09
image: https://fandomwire.com/wp-content/uploads/2020/09/matrix-4-agent-smith-1024x614.jpg
excerpt: "Explore the AI revolution transforming automation: From simple prompts to sophisticated AI agents, see how technology is reshaping our approach to data and robotics. But when AI encounters its own errors, the real magic begins. Discover how in..."
---
With the advent of Chat GPT and the expansion of the capabilities of Large Language Models (LLM), the world of artificial intelligence has begun to explore new frontiers, particularly the development of autonomous agents equipped with advanced reasoning abilities and capable of performing specific actions. This growing interest has led to the birth of several dedicated frameworks, although the fundamental principle behind this evolution remains surprisingly simple.

Our familiarity with LLMs, and Chat GPT in particular, began with the typical interactive use of chats: starting a conversation, asking questions, receiving answers, and the process continues until informational satisfaction is achieved. However, we soon realized that many of the required actions, such as generating SQL queries to query databases, have a repetitive nature that lends itself to automation.

The most immediate solution to this need for automation involves creating a customized prompt, containing variable fields to be adapted from time to time to specific needs. For example, to generate an SQL query based on specific instructions, one could structure a prompt in the following way:

```
You are the best SQL expert in the world and I need your help.
I want you to translate the request I will make from human language to a syntactically correct SQL query for MySQL 5.7.
Below I will provide you with the description of the tables so that you can understand which fields are being talked about in the request and produce correct queries:

+-------------+------------------+------+-----+---------+----------------+
| Field       | Type             | Null | Key | Default | Extra          |
+-------------+------------------+------+-----+---------+----------------+
| id          | int(11)          | NO   | PRI | NULL    | auto_increment |
| playhead    | int(10) unsigned | NO   |     | NULL    |                |
| payload     | longtext         | NO   |     | NULL    |                |
| recorded_on | varchar(32)      | NO   |     | NULL    |                |
+-------------+------------------+------+-----+---------+----------------+
```

This approach represents the first step towards the conception of an agent, as, if every chat session were started with pre-set instructions on how to process an SQL query, we would have created an "SQL Query Manager": a beginning-of-agent capable of automatically providing the requested SQL query. Implementing such a system in Python is surprisingly simple.

```python
SQL_MANAGER_PROMPT = "You are the best SQL expert in the world..."
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

This code snippet illustrates how to create a simple agent, the "SQL Query Manager", using Chat GPT's API. After defining the API key and the `sql_query_manager` function, it is possible to pass only the description of the query needs to the function, which will send the prompt to Chat GPT and return a response containing the SQL query based on the instructions provided.

Elevating the capabilities of this code to not only generate SQL queries but also execute them and return the results represents a qualitative leap in its utility and complexity. This advancement paves the way for more sophisticated automation and richer interactions with databases, without the need for human intervention in transcribing and executing the queries.

To achieve this goal, it is crucial that the language model we are querying produces responses formatted according to a precise standard. This approach allows for the interpretation and use of the output directly in the code, automating the execution of queries.

By integrating instructions on how the output should be formatted and passing a certain parameter in the request, one can leverage [Chat GPT's ability to produce responses that respect the JSON format](https://platform.openai.com/docs/guides/text-generation/json-mode). This feature is particularly valuable as it ensures that the output is not only semantically correct but also syntactically compliant with the standards required for automatic processing.

OpenAI has recently introduced a revolutionary feature called [Function calling](https://platform.openai.com/docs/guides/function-calling), which greatly expands the potential of our functions. This innovation allows responses to include not only text but also specific instructions to execute functions defined by the user. In practice, you tell the agent what to do and what tools it has at its disposal, and then, following the principle of "you tell me what to do and I do it," the model communicates the calls to be made and with which arguments, at which point we execute the code in a brainless manner using the provided parameters.

```
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
            print(response.choices[0].message.tool_calls[0].function.arguments)
            arguments = json.loads(response.choices[0].message.tool_calls[0].function.arguments)
            return execute_query(arguments["query"])

        return response.choices[0].message.content
    except Exception as e:
        return f"There was an error: {e}"
```
[Here you can find the complete code](https://gist.github.com/edelprino/6f8ecd724f09cde0eb19e3fc7f12fa65).

Initially, we automated the generation of SQL queries, transforming desires into concrete SQL instructions. Subsequently, we extended automation to the execution of queries, completing the flow from "Desires" to "SQL Query" and finally to "Query Results."

This represents the ideal path, but what happens if the agent generates an incorrect query? Can we make it correct itself? But above all, how do we move from a manager for SQL queries to a series of agents that perform complex tasks? These are some of the questions we will explore in part two.
