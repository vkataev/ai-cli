
```
$ ai show distribution of weights in v_proj0 in file mymodel.safetensors as textual multiline histogram, use 4 bins, range from -.6 to +.6
xxxx     -.6 .. -.3
xxxxxxx  -.3 .. 0.
xxxxx     0. .. +.3
xxx      +.3 .. +.6

$ ai convert all float16 .gguf models in this folder into 4-bit, use slurm_submit.sh script for that
Found 2 files, submitted job IDs: 34289128, 34289129
```

```
$ ai --memory what operating system do I have
MINGW64_NT-11.0-12345

$ ai --memory but it says MINGW...bla bla, I dont know such OS
You are running Windows, but you are using the MINGW64 environment (a common way to run Linux-like tools on Windows).

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


## Usage

```
ai [--memory] your request in plain human language
```

You write your direct request just in natural text. You may refer to any file names, system tools, and essentially to anything.

Then an interactive edit mode will be opened and you have full overview on what LLM has returned.

You can accept LLM's answer by pressing **Enter** and actions will be executed in shell or you can press **Ctrl+C** to reject entire actions.

You can edit returned answer just like in any editor - use arrow keys to navigate.

To execute actions place cursor to the end of the entire answer and press Enter or reject at any time by pressing Ctrl+C.

You can choose any LLM service by setting AI_URL environment variable:

```bash
$ export AI_URL="http://127.0.0.1:8001"
```

### Enabling memory

You can enable assistant's memory with **--memory** flag, in this case it will update AI_MEMORY.md in the current directory.
This helps solving more complex tasks, assistant will remember all previous actions including rejected.


## Build

```bash
gcc ai.c -o ai
```

## Install
Copy ai file into your ~/.local/bin and a man page into ~/.local/share/man/man1/ :
```
sh run.build_ai.sh
```

## Portability

You can build and run this tool on literally any platform, including: Linux, macOS, Android, FreeBSD, iOS, OpenBSD, NetBSD, QNX Neutrino, Windows (MSYS2 or Cygwin), WebOS, Haiku etc.

Most LLM engines are fully supported:

| Engine                          | `/v1/chat/completions` |
| ------------------------------- | ---------------------- |
| llama.cpp                       | Yes                    |
| vLLM                            | Yes                    |
| TensorRT-LLM                    | Yes                    |
| Ollama                          | Yes                    |
| LM Studio                       | Yes                    |
| SGLang                          | Yes                    |
| Text Generation Inference (TGI) | Yes                    |
| Aphrodite Engine                | Yes                    |
| LocalAI                         | Yes                    |
| Xinference                      | Yes                    |
| FastChat                        | Yes                    |
| MLC LLM                         | Yes                    |
| KoboldCpp                       | Partial                |

You only need an access to LLM engine running locally or remotely.

Example how you may run llama.cpp with Gemma-4 model:

```bash
llama-server  --host 0.0.0.0 \
    --model unsloth/gemma-4-12B-it-qat-UD-Q4_K_XL.gguf \
    --temp 1.0 \
    --top-p 0.95 \
    --top-k 64 \
    --port 8001 \
    --chat-template-kwargs '{"enable_thinking":false}'
```
Remember to **disable thinking mode** - answers model provides will be direct shell actions.

## More examples

```bash
$ ai who was running jobs on a slurm node 39 between 1 and 2 hours ago
user847
uset20499
```
The action assitant returned might look like:

```bash
sacct --format="JobID,JobName,User,NodeList,Start,End,State" --allusers --starttime=$(date -d "-2 hours" "+%Y-%m-%dT%H:%M:%S") --endtime=$(date -d "-1 hours" "+%Y-%m-%dT%H:%M:%S") --allocations --node=39 | tail -n +3 | awk '{print $3}' | sort | uniq
```

Other examples:

```bash
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
```

## WARNING

This tool executes actions returned by LLM directly in your shell.

Authors are not responsible for any damage this program can cause.

If you are not familiar with shell commands, do not use this tool.

