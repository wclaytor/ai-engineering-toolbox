# AI Engineering Toolbox
A list of open-source tools and resources for AI Engineering

## Table of Contents

- [Getting Started](#getting-started)
- [Application Development Frameworks](#application-development-frameworks)
- [Command Line Tools & Libraries](#command-line-tools--libraries)
- [Local AI & Model Deployment](#local-ai--model-deployment)
- [Desktop & GUI Applications](#desktop--gui-applications)
- [Data & Analytics Tools](#data--analytics-tools)
- [Browser Automation & Web Scraping](#browser-automation--web-scraping)
- [Development Tools & IDE Extensions](#development-tools--ide-extensions)
- [Optimization & Performance](#optimization--performance)
- [Scientific & Research Tools](#scientific--research-tools)
- [Model Context Protocol (MCP)](#model-context-protocol-mcp)
- [Experimental & Research Projects](#experimental--research-projects)

-----

## Getting Started

### AI Engineering by Chip Huyen
https://github.com/chiphuyen/aie-book

Note: While the [AI Engineering book](https://www.oreilly.com/library/view/ai-engineering/9781098166298) is not open-source, the resources on GitHub provide wonderful free content, and illustrate why you should buy (and read) the book.

#### Description
AI Engineering book and other resources

#### About the book
The availability of foundation models has transformed AI from a specialized discipline into a powerful development tool everyone can use. This book covers the end-to-end process of adapting foundation models to solve real-world problems, encompassing tried-and-true techniques from other engineering fields and techniques emerging with foundation models.

### Additional Resources
In addition to the projects listed below, this project contains lists of additional resources such as videos, books, and blogs.

[RESOURCES.md](RESOURCES.md)

## Application Development Frameworks

### LangChain
https://github.com/langchain-ai/langchain

#### Description
LangChain is a framework for building LLM-powered applications. It helps you chain together interoperable components and third-party integrations to simplify AI application development — all while future-proofing decisions as the underlying technology evolves.

### LangGraph
https://github.com/langchain-ai/langgraph

#### Description
Trusted by companies shaping the future of agents – including Klarna, Replit, Elastic, and more – LangGraph is a low-level orchestration framework for building, managing, and deploying long-running, stateful agents.

### Flowise
https://github.com/FlowiseAI/Flowise

#### Description
Build AI Agents, Visually

### Agno
https://github.com/agno-agi/agno

#### Description
Agno is a full-stack framework for building Multi-Agent Systems with memory, knowledge and reasoning.

Use Agno to build the 5 levels of Agentic Systems:

- Level 1: Agents with tools and instructions.
- Level 2: Agents with knowledge and storage.
- Level 3: Agents with memory and reasoning.
- Level 4: Agent Teams that can reason and collaborate.
- Level 5: Agentic Workflows with state and determinism.

### Pocket Flow
https://github.com/The-Pocket/PocketFlow

#### Description
Pocket Flow is a 100-line minimalist LLM framework:
- Lightweight: Just 100 lines. Zero bloat, zero dependencies, zero vendor lock-in.
- Expressive: Everything you love—(Multi-)Agents, Workflow, RAG, and more.
- Agentic Coding: Let AI Agents (e.g., Cursor AI) build Agents—10x productivity boost!

### Roast
https://github.com/Shopify/roast

#### Description
A convention-oriented framework for creating structured AI workflows, maintained by the Augmented Engineering team at Shopify.

##### Why you should use Roast
Roast provides a structured, declarative approach to building AI workflows with:

Convention over configuration: Define powerful workflows using simple YAML configuration files and prompts written in markdown (with ERB support)
Built-in tools: Ready-to-use tools for file operations, search, and AI interactions
Ruby integration: When prompts aren't enough, write custom steps in Ruby using a clean, extensible architecture
Shared context: Each step shares its conversation transcript with its parent workflow by default
Step customization: Steps can be fully configured with their own AI models and parameters.
Session replay: Rerun previous sessions starting at a specified step to speed up development time
Parallel execution: Run multiple steps concurrently to speed up workflow execution
Function caching: Flexibly cache the results of tool function calls to speed up workflows
Extensive instrumentation: Monitor and track workflow execution, AI calls, and tool usage (see instrumentation documentation)

### Sim Studio
https://github.com/simstudioai/sim

#### Description
Sim Studio is a lightweight, user-friendly platform for building AI agent workflows.

### DSPy
https://github.com/stanfordnlp/dspy

#### Description
DSPy: The framework for programming—not prompting—language models

### MetaGPT
https://github.com/FoundationAgents/MetaGPT

#### Description
🌟 The Multi-Agent Framework: First AI Software Company, Towards Natural Language Programming

## Command Line Tools & Libraries

### LLM
https://github.com/simonw/llm

#### Description
A CLI tool and Python library for interacting with OpenAI, Anthropic's Claude, Google's Gemini, Meta's Llama and dozens of other Large Language Models, both via remote APIs and with models that can be installed and run on your own machine.

### sqlite-utils
https://github.com/simonw/sqlite-utils

#### Description
Python CLI utility and library for manipulating SQLite databases.

### optillm
https://github.com/codelion/optillm

#### Description
optillm is an OpenAI API compatible optimizing inference proxy which implements several state-of-the-art techniques that can improve the accuracy and performance of LLMs. The current focus is on implementing techniques that improve reasoning over coding, logical and mathematical queries.

It is possible to beat the frontier models using these techniques across diverse tasks by doing additional compute at inference time. A good example of how to combine such techniques together is the CePO approach from Cerebras.

### Semantifly
https://github.com/accretional/semantifly

#### Description
Semantifly
Semantifly is a command line tool for implementing local RAG for the GenAI-for-coding use case.

Users add data, or entire data sources like code repos and cloud projects, and Semantifly automatically gathers all the data corresponding to that data source (such as databases and other resources within a cloud project), serializes them as text and vector embeddings, and adds them to a local vector database. It then provides the necessary funcitonality for this database to be integrated with a LLM to implement Retrieval Augmented Generation with the index data - instead of having to manually tell the LLM what your database schema is, or the structure of an API in another repo within your organization, it can automatically retrive and access that data.

This is currently a work in progress.

### uv
https://github.com/astral-sh/uv

#### Description
An extremely fast Python package and project manager, written in Rust.

### claude-code
https://github.com/anthropics/claude-code

#### Description
Claude Code is an agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster by executing routine tasks, explaining complex code, and handling git workflows - all through natural language commands.

### opencode
https://github.com/sst/opencode

#### Description
AI coding agent, built for the terminal.

### claude-auto-resume
https://github.com/terryso/claude-auto-resume

#### Description
A shell script utility that automatically resumes Claude CLI tasks when usage limits are lifted.

### github-to-sqlite
https://github.com/dogsheep/github-to-sqlite

#### Description
Save data from GitHub to a SQLite database

### context-llemur
https://github.com/jerpint/context-llemur

#### Description
Context management tool for LLM collaboration

### OpenHands
https://github.com/All-Hands-AI/OpenHands

#### Description
🙌 OpenHands: Code Less, Make More

## Local AI & Model Deployment

### ollama
https://github.com/ollama/ollama

#### Description
Get up and running with large language models.

### Open WebUI
https://github.com/open-webui/open-webui

#### Description
Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline. It supports various LLM runners like Ollama and OpenAI-compatible APIs, with built-in inference engine for RAG, making it a powerful AI deployment solution.

### Jan
https://github.com/menloresearch/jan

#### Description
Jan is a ChatGPT-alternative that runs 100% offline on your device. Our goal is to make it easy for a layperson to download and run LLMs and use AI with full control and privacy.

Jan is powered by Cortex, our embeddable local AI engine that runs on any hardware. From PCs to multi-GPU clusters, Jan & Cortex supports universal architectures:

- NVIDIA GPUs (fast)
- Apple M-series (fast)
- Apple Intel
- Linux Debian
- Windows x64

Features:
- Model Library with popular LLMs like Llama, Gemma, Mistral, or Qwen
- Connect to Remote AI APIs like Groq and OpenRouter
- Local API Server with OpenAI-equivalent API
- Extensions for customizing Jan

### koboldcpp
https://github.com/LostRuins/koboldcpp

#### Description
Run GGUF models easily with a KoboldAI UI. One File. Zero Install.

### llama
https://github.com/meta-llama/llama

#### Description
Inference code for Llama models

## Desktop & GUI Applications

### GTK LLM Chat
https://github.com/icarito/gtk-llm-chat

#### Description
A GTK graphical interface for chatting with Large Language Models (LLMs).

### Kiln
https://github.com/Kiln-AI/Kiln

Rapid AI Prototyping and Dataset Collaboration Tool

#### Description
- 🚀 Intuitive Desktop Apps: One-click apps for Windows, MacOS, and Linux. Truly intuitive design.
- 🎛️ Fine Tuning: Zero-code fine-tuning for Llama, GPT-4o, and more. Automatic serverless deployment of models.
- 📊 Evals: Evaluate the quality of your models/tasks using state of the art evaluators.
- 🤖 Synthetic Data Generation: Generate training data with our interactive visual tooling.
- 🧠 Reasoning Models: Train or distill your own custom reasoning models.
- 🤝 Team Collaboration: Git-based version control for your AI datasets. Intuitive UI makes it easy to collaborate with QA, PM, and subject matter experts on structured data (examples, prompts, ratings, feedback, issues, etc.).
- 📝 Prompt Generation: Automatically generate prompts from your data, including chain-of-thought, few-shot, and multi-shot, and more.
- 🌐 Wide Model and Provider Support: Use any model via Ollama, OpenAI, OpenRouter, Fireworks, Groq, AWS, or any OpenAI compatible API.
- 🧑‍💻 Open-Source Library and API: Our Python library and OpenAPI REST API are MIT open source.
- 🔒 Privacy-First: We can't see your data. Bring your own API keys or run locally with Ollama.
- 🗃️ Structured Data: Build AI tasks that speak JSON.
- 💰 Free: Our apps are free, and our library is open-source.

### claudia
https://github.com/getAsterisk/claudia

#### Description
A powerful GUI app and Toolkit for Claude Code - Create custom agents, manage interactive Claude Code sessions, run secure background agents, and more.

### onlook
https://github.com/onlook-dev/onlook

#### Description
The Cursor for Designers • An Open-Source Visual Vibecoding Editor • Visually build, style, and edit your React App with AI

### vibe-kanban
https://github.com/BloopAI/vibe-kanban

#### Description
Kanban board to manage your AI coding agents

### CodeWebChat
https://github.com/robertpiosik/CodeWebChat

#### Description
Free AI coding for the rest of us

## Data & Analytics Tools

### Datasette
https://github.com/simonw/datasette

#### Description
An open source multi-tool for exploring and publishing data

Datasette is a tool for exploring and publishing data. It helps people take data of any shape or size and publish that as an interactive, explorable website and accompanying API.

Datasette is aimed at data journalists, museum curators, archivists, local governments, scientists, researchers and anyone else who has data that they wish to share with the world.

### dataset-generator
https://github.com/metabase/dataset-generator

#### Description
AI Dataset Generator – Create realistic datasets for demos, learning, and dashboards

### label-studio
https://github.com/HumanSignal/label-studio

#### Description
Label Studio is a multi-type data labeling and annotation tool with standardized output format

### haiku.rag
https://github.com/ggozad/haiku.rag

#### Description
Retrieval Augmented Generation based on SQLite

### LightRAG
https://github.com/HKUDS/LightRAG

#### Description
"LightRAG: Simple and Fast Retrieval-Augmented Generation"

## Browser Automation & Web Scraping

### Skyvern
https://github.com/Skyvern-AI/skyvern

#### Description
Skyvern automates browser-based workflows using LLMs and computer vision. It provides a simple API endpoint to fully automate manual workflows on a large number of websites, replacing brittle or unreliable automation solutions.

### workflow-use
https://github.com/browser-use/workflow-use

#### Description
⚙️ Create and run workflows (RPA 2.0)

## Development Tools & IDE Extensions

### Prompt Tower
https://github.com/backnotprop/prompt-tower

#### Description
Turn your entire codebase into AI-ready context in seconds

VS Code Extension Rating Users

The Problem
Copy-pasting files into Claude, ChatGPT, or Cursor one by one. Losing track of context. Getting generic solutions because the AI doesn't understand your architecture. Sound familiar?

The Solution
Select files with checkboxes → Generate perfect context → Copy to clipboard → Paste anywhere.

Prompt Tower packages your codebase—files, directory structure, GitHub issues—into AI-optimized prompts. Built for developers using Gemini's 1M context, Cursor's agent, Claude Code, or any AI assistant.

### Roo-Code
https://github.com/RooCodeInc/Roo-Code

#### Description
Connect with developers, contribute ideas, and stay ahead with the latest AI-powered coding tools.

Roo Code is an AI-powered autonomous coding agent that lives in your editor. It can:

- Communicate in natural language
- Read and write files directly in your workspace
- Run terminal commands
- Automate browser actions
- Integrate with any OpenAI-compatible or custom API/model
- Adapt its "personality" and capabilities through Custom Modes
- Whether you're seeking a flexible coding partner, a system architect, or specialized roles like a QA engineer or product manager, Roo Code can help you build software more efficiently.

### Roo Commander
https://github.com/jezweb/roo-commander

#### Description
Roo Commander: An Advanced Multi-Agent Framework for Roo Code
Roo Commander helps developers using Roo Code manage complex software projects by orchestrating specialized AI agents within VS Code, improving structure, context management, and task delegation.

Roo Commander is an advanced configuration layer and opinionated workflow system built specifically for the Roo Code VS Code extension. It transforms your Roo Code experience by implementing a sophisticated framework for managing software development projects using a structured, multi-agent approach. Imagine having a virtual, specialized software team within your VS Code workspace, orchestrated by the 👑 Roo Commander, to handle tasks with specific expertise and maintain a clear project history.

### claude-task-master
https://github.com/eyaltoledano/claude-task-master

#### Description
An AI-powered task-management system you can drop into Cursor, Lovable, Windsurf, Roo, and others.

### dg
https://github.com/DeepGuide-Ai/dg

#### Description
Self-testing CLI documentation tool that generates interactive demos

### Backlog.md
https://github.com/MrLesk/Backlog.md

#### Description
Backlog.md - A tool for managing project collaboration between humans and AI Agents in a git ecosystem

### vscode-copilot-chat
https://github.com/microsoft/vscode-copilot-chat

#### Description
Copilot Chat extension for VS Code

## Optimization & Performance

### syftr
https://github.com/datarobot/syftr

Efficient Search for Pareto-optimal Flows

#### Description
syftr is an agent optimizer that helps you find the best agentic workflows for a given budget. You bring your own dataset, compose the search space from models and components, and syftr finds the best combination of parameters for your budget. It uses advances in multi-objective Bayesian Optimization and a novel domain-specific "Pareto Pruner" to efficiently sample a search space of agentic and non-agentic flows to estimate a Pareto-frontier (optimal trade-off curve) between accuracy and objectives that compete like cost, latency, throughput.

### lmnr
https://github.com/lmnr-ai/lmnr

#### Description
Laminar - open-source all-in-one platform for engineering AI products. Create data flywheel for your AI app. Traces, Evals, Datasets, Labels. YC S24.

### promptfoo
https://github.com/promptfoo/promptfoo

#### Description
Test your prompts, agents, and RAGs. Red teaming, pentesting, and vulnerability scanning for LLMs. Compare performance of GPT, Claude, Gemini, Llama, and more. Simple declarative configs with command line and CI/CD integration.

### opik
https://github.com/comet-ml/opik

#### Description
Debug, evaluate, and monitor your LLM applications, RAG systems, and agentic workflows with comprehensive tracing, automated evaluations, and production-ready dashboards.

### ai-rag-chat-evaluator
https://github.com/Azure-Samples/ai-rag-chat-evaluator

#### Description
Tools for evaluation of RAG Chat Apps using Azure AI Evaluate SDK and OpenAI

### llm-inference-handbook
https://github.com/bentoml/llm-inference-handbook

#### Description
Everything you need to know about LLM inference

## Scientific & Research Tools

### Rigorous
https://github.com/robertjakob/rigorous

Rigorous AI-Powered Scientific Manuscript Analysis
Cloud Version Available: A cloud version of the AI Reviewer is available at https://www.rigorous.company/. Simply upload your manuscript, provide context on target journal and review focus, and receive a comprehensive PDF report via email within 1-2 working days. We'll provide feedback free of charge — however, we would greatly appreciate your feedback in return via this short form to help us improve the AI Reviewer.

### colette
https://github.com/jolibrain/colette

#### Description
Multimodal RAG to search and interact locally with technical documents of any kind

### symbolicai
https://github.com/ExtensityAI/symbolicai

#### Description
Compositional Differentiable Programming Library

### benchmark
https://github.com/ExtensityAI/benchmark

#### Description
Evaluation of neuro-symbolic engines

### courses
https://github.com/anthropics/courses

#### Description
Anthropic's educational courses

### prompt-eng-interactive-tutorial
https://github.com/anthropics/prompt-eng-interactive-tutorial

#### Description
Anthropic's Interactive Prompt Engineering Tutorial

## Model Context Protocol (MCP)

### Model Context Protocol
https://github.com/modelcontextprotocol/modelcontextprotocol

#### Description
The Model Context Protocol (MCP) is an open standard that enables AI applications to securely connect to data sources and tools. MCP provides a unified way for AI systems to access external context, making AI assistants more capable while maintaining security and user control.

### MCP Servers
https://github.com/modelcontextprotocol/servers

#### Description
A collection of reference implementations for MCP servers, providing secure integrations with various data sources and tools. These servers enable AI applications to access external systems like databases, APIs, file systems, and development tools through the standardized MCP protocol.

### Python MCP SDK
https://github.com/modelcontextprotocol/python-sdk

#### Description
The official Python SDK for building Model Context Protocol servers and clients. This SDK provides the tools and abstractions needed to create secure, standardized integrations between AI applications and external data sources or tools.

### TypeScript MCP SDK
https://github.com/modelcontextprotocol/typescript-sdk

#### Description
The official TypeScript SDK for building Model Context Protocol servers and clients. Enables developers to create type-safe MCP integrations for Node.js applications, providing seamless connectivity between AI systems and external resources.

### rtfmbro-mcp
https://github.com/marckrenn/rtfmbro-mcp

#### Description
rtfmbro provides always-up-to-date, version-specific package documentation as context for coding agents. An alternative to context7

### zen-mcp-server
https://github.com/BeehiveInnovations/zen-mcp-server

#### Description
The power of Claude Code + [Gemini / OpenAI / Grok / OpenRouter / Ollama / Custom Model / All Of The Above] working as one.

### annas-mcp
https://github.com/iosifache/annas-mcp

#### Description
MCP server and CLI tool for searching and downloading documents from Anna's Archive

### CCORP
https://github.com/terhechte/CCORP

#### Description
Claude Code OpenRouter Proxy

### mcp-debug
https://github.com/giantswarm/mcp-debug

## Experimental & Research Projects

### Darwin Gödel Machine
https://github.com/jennyzzt/dgm

#### Description
Darwin Gödel Machine:
Open-Ended Evolution of Self-Improving Agents

Repository for Darwin Gödel Machine (DGM), a novel self-improving system that iteratively modifies its own code (thereby also improving its ability to modify its own codebase) and empirically validates each change using coding benchmarks.

### duende
https://github.com/alefore/duende

#### Description
Agent implementation for Conversational AI

### airbolt
https://github.com/Airbolt-AI/airbolt

### archgw
https://github.com/katanemo/archgw

#### Description
The smart edge and AI gateway for agents. Arch is a proxy server that handles the low-level work in building agents like applying guardrails, routing prompts to the right agent, and unifying access to LLMs. It is framework-agnostic, natively understands prompts, and helps you build agents faster.

### deepwiki-open
https://github.com/AsyncFuncAI/deepwiki-open

#### Description
Open Source DeepWiki: AI-Powered Wiki Generator for GitHub/Gitlab/Bitbucket Repositories. Join the discord: https://discord.gg/gMwThUMeme

### any-llm
https://github.com/mozilla-ai/any-llm

#### Description
Communicate with an LLM provider using a single interface

### yt-transcriber
https://github.com/pmarreck/yt-transcriber

#### Description
TUI app- Give it a YouTube URL and you get a transcription with possible speaker identification and optional summary or translation, all thanks to open-source AI tooling and my lack of enough free time to watch content-sparse YouTube videos

### AdventureAI
https://github.com/s-macke/AdventureAI

#### Description
Interactive Fiction in the Age of AI

### trader
https://github.com/heyitsguay/trader

#### Description
LLM-powered trading sim

### gremllm
https://github.com/awwaiid/gremllm

#### Description
A slight upgrade to the Gremlins in your code

### graphiti
https://github.com/getzep/graphiti

#### Description
Build Real-Time Knowledge Graphs for AI Agents

### Core
https://github.com/RedPlanetHQ/core

#### Description
Your personal plug and play memory layer for LLMs

### Context-Engineering
https://github.com/davidkimai/Context-Engineering

#### Description
"Context engineering is the delicate art and science of filling the context window with just the right information for the next step." — Andrej Karpathy. A frontier, first-principles handbook inspired by Karpathy and 3Blue1Brown for moving beyond prompt engineering to the wider discipline of context design, orchestration, and optimization.

### RL
https://github.com/ivanbelenky/RL

#### Description
R.L. methods and techniques.

### IPWT
https://github.com/dmf-archive/IPWT

#### Description
IPWT: A unified, computationally feasible framework for consciousness, integrating predictive coding, workspace, and integrated information theories.

### doomberg-terminal
https://github.com/adam-s/doomberg-terminal

### agentic-misalignment
https://github.com/anthropic-experimental/agentic-misalignment

### NLSOM
https://github.com/metauto-ai/NLSOM

#### Description
🧠 Societies of Mind & Economy of Minds

### theProtector
https://github.com/IHATEGIVINGAUSERNAME/theProtector

#### Description
Linux Bash Script for the Paranoid Admin on a Budget - real-time monitoring and active threat response

### NerdFonts
https://github.com/PSModule/NerdFonts

#### Description
A PowerShell module to download and install fonts from NerdFonts.

### deskflow
https://github.com/deskflow/deskflow

#### Description
Share a single keyboard and mouse between multiple computers.

-----

to be continued...
