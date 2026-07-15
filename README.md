## Principles

- single C file
- no dependencies
- unix philosophy: natural language → shell action → execute
- backend agnostic: uses /v1/chat/completions, works with all local LLM servers
- interactive safety model: review/edit generated command before execution

## Usage

```
ai [--memory] your request in plain human language
```

You write your direct request just in natural text. You may refer to any file names, system tools, and essentially to anything.

As LLM is replying you are in interactive edit mode having full overview on what LLM returns.

To accept LLM's answer press **Enter** - answer will be executed in your shell.

To reject LLM's answer press **Ctrl+C** - nothing will be executed.

You can edit returned answer just like in any editor - use arrow keys to navigate.

To execute edited answer place cursor to the end of the entire answer and press Enter or reject at any time by pressing Ctrl+C.

You can choose any LLM service by setting AI_URL environment variable:

```bash
$ export AI_URL="http://127.0.0.1:8001"
```
Enable assistant's memory with **--memory** flag, so it will keep history in AI_MEMORY.md in the current directory - assistant will remember all previous requests and actions including rejected.


## Build & Install

```bash
gcc ai.c -o ai

sh run.install_ai.sh
#OR cp ./ai ~/.local/bin && cp ./ai.1 ~/.local/share/man/man1/ && export PATH=$PATH:~/.local/bin
```

## Portability

It will fly on any platform: Linux, macOS, Android, FreeBSD, iOS, OpenBSD, NetBSD, QNX Neutrino, Windows (MSYS2 or Cygwin), WebOS, Haiku etc.

Most LLM engines are fully supported: llama.cpp, vLLM, TensorRT-LLM, Ollama, LM Studio, etc.

You only need set AI_URL pointing to your LLM server:
```bash
$ export AI_URL="http://127.0.0.1:8001"
```

Example how to run llama.cpp server with Gemma-4 model:

```bash
llama-server  --host 0.0.0.0 \
    --model unsloth/gemma-4-12B-it-qat-UD-Q4_K_XL.gguf \
    --temp 1.0 \
    --top-p 0.95 \
    --top-k 64 \
    --port 8001 \
    --chat-template-kwargs '{"enable_thinking":false}'
```
and **disable thinking mode** - answers model provides will be direct shell actions.

## Usage examples

```
$ ai who was running jobs on a slurm node 39 between 1 and 2 hours ago
user847
uset20499
```
The action assitant returned might look like: sacct --format="JobID,JobName,User,NodeList,Start,End,State" --allusers --starttime=$(date -d "-2 hours" "+%Y-%m-%dT%H:%M:%S") --endtime=$(date -d "-1 hours" "+%Y-%m-%dT%H:%M:%S") --allocations --node=39 | tail -n +3 | awk '{print $3}' | sort | uniq

Thus, you are really happy to not remembering and entering this mess manually

```
$ ai replace Solar with solar in every python file in this folder
Done

$ ai modify permissions of this folder so no other user can read anything here
Done

$ ai find all occurances of subword "perform" in words.txt and print their line numbers
1881
10046
10047
40358

$ ai math log of 4096
8.317766166719343

$ ai show me last 3 lines in each c file in current folder
    buffer_free(&original);
    return exit_code;
}

$ ai what is IP address of somewebsite
xxx.xx.xx.xxx

$ ai show distrib of v_0 in m.safetensors as txt histogram,4 bins,range -.6 to +.6
xxxx     -.6 .. -.3
xxxxxxx  -.3 .. 0.
xxxxx     0. .. +.3
xxx      +.3 .. +.6

$ ai convert all float16 .gguf models in cur folder into 4-bit, use slurm_submit.sh
Found 2 files, submitted job IDs: 34289128, 34289129

$ ai --memory what operating system do I have
MINGW64_NT-11.0-12345

$ ai --memory but it says MINGW...bla bla, I dont know such OS
You are running Windows, but you are using the MINGW64 environment (Linux-like tools on Win).

$ ai --memory I see, so install ffmpeg
Done, ffmpeg package was installed using pacman
```

## Motivation

I was thinking how to automate my daily routine like shell commands and instead to switch completely to natural language.

Often I switch from terminal shell to external or local LLM chatbot to ask it sometimes about like "how to convert all file names to lower case, a one line in python or shell".

What if I make a small tool which will send my requests in natural language to a local LLM and receive replies which are executable by just pressing Enter on my side?

I decided to make a tiny LLM harness in a highly portable way - no any external dependency, a single C source, so it can directly run on any remote or local machine.

So, how should it work? It's obvious I need to send some information about user's environment to LLM, e.g. cli tools available, OS, current directory path, etc.

This way, LLM generates much better replies.

And since I am lazy to type double quotes, let's assume all text after ai command itself is my request, like: ai what time is it

And it works! Additional check is given to user to edit LLM's reply, reject it, or accept it - and it will trigger execution.

User's choices are: **accept** actions (by just pressing **Enter**) with opportunity to **edit** assistan's answer first or **reject** actions by pressing **Ctrl+C**.

## Safety

This tool executes actions returned by LLM directly in your shell.

Authors are not responsible for any damage this program can cause.

If you are not familiar with shell commands, do not use this tool.

