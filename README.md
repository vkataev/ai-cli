# ai-cli
command line assistant smoothly connecting your requests with LLM of your choice and executing directly returned actions, all in a single C file

## MOTIVATION

Free yourself from writing all those complex actions in command line shell, instead ai assistant will do it for you based on your requests.

Your choices are: **accept** actions (by just pressing **Enter**) with opportunity to **edit** assistan's answer first or **reject** actions by pressing **Ctrl+C**.

## EXAMPLES

If for example, you want to know who did run jobs on a particular Slurm node, you may ask:

```bash
$ ./ai who was running jobs on a slurm node 39 between 1 and 2 hours ago
user847
uset20499
```
The action assitant returned might look like:

```bash
sacct --format="JobID,JobName,User,NodeList,Start,End,State" --allusers --starttime=$(date -d "-2 hours" "+%Y-%m-%dT%H:%M:%S") --endtime=$(date -d "-1 hours" "+%Y-%m-%dT%H:%M:%S") --allocations --node=39 | tail -n +3 | awk '{print $3}' | sort | uniq
```

Other examples:

```bash
$ ./ai replace Solar with solar in every python file in this folder
Done

$ ./ai modify permissions of this folder so no other user can read anything here
Done

$ ./ai find all occurances of subword "perform" in words.txt and print their line numbers
1881
10046
10047
40358

$ ./ai math log of 4096
8.317766166719343

$ ./ai show me last 3 lines in each c file in current folder
    buffer_free(&original);
    return exit_code;
}

$ ./ai what is IP address of somewebsite
xxx.xx.xx.xxx
```

## WARNING

Be careful, because this tool executes actions returned by LLM directly in your shell.

Authors are not responsible for any damage this program can cause.

If you are not familiar with shell commands, do not use this assistant.

## BUILD

```bash
sh run.build_ai.sh
```

or directly

```bash
gcc ai.c -o ai
```

## INSTALL
This will copy ai into your ~/.local/bin and man page into ~/.local/share/man/man1/

```bash
sh run.build_ai.sh
```


## PORTABILITY

You can build and run this tool on literally any platform, fully supported:

- Linux
- macOS
- Android
- FreeBSD
- iOS
- OpenBSD
- NetBSD
- QNX Neutrino
- Windows (MSYS2 or Cygwin)
- WebOS
- Haiku
- SerenityOS
- DragonFly BSD
- illumos
- Solaris
- AIX
- HP-UX
- Tru64 UNIX
- IRIX
- UnixWare
- SCO OpenServer
- Redox OS
- VxWorks
- RTEMS
- INTEGRITY

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



## DEPENDENCIES

You need an LLM engine running locally or remotely.

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
Remember to disable thinking mode - answers model provides will be direct shell actions.


## USAGE

```bash
$ export AI_URL="http://127.0.0.1:8001"
$ ./ai which file in this folder is to build ai tool
./run.build_ai.sh
```

You can accept answer by pressing **Enter** and actions will be executed in shell or you can press **Ctrl+C** to reject entire actions.

You can edit returned answer just like in any editor - use arrow keys to navigate.

To execute actions place cursor to the end of the entire answer and press Enter or reject at any time by pressing Ctrl+C.

## MEMORY USAGE

You can enable assistant's memory with **--memory** flag, in this case it will update AI_MEMORY.md in the current directory.
This helps solving more complex tasks, assistant will remember all previous actions including rejected.

```bash
$ ./ai --memory what operating system do I have
MINGW64_NT-11.0-12345

$ ./ai --memory but it says MINGW...bla bla, I dont know such OS
You are running Windows, but you are using the MINGW64 environment (a common way to run Linux-like tools on Windows).
```


