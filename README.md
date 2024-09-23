# LiP lab

LiP students are expected to fork the repository and push solutions to the exercises on their fork.

Invitation to the Discord server: **[https://discord.gg/fttNEU38](https://discord.gg/BJPNZVjaP)**

---

## [Tutorial] Getting started

Before diving into the course, let's take care of a few technicalities.

The set-up process is quite involved and may seem overwhelming at first, but bear with it for now. It will pay off in the subsequent lessons. Arguably, the technologies we introduce here will very likely serve the purposes of other courses and even of your future projects.

### 1. Fork this repository

The first thing to do is to fork this repository. Forking will create a new repository that shares the same files and history of this repository, except it's owned by you and you can freely edit it.

You can find the "Fork" action at the top right of the page, next to "Star" button. Select it, then **keep the default options** and hit "Create fork".

![image](https://github.com/user-attachments/assets/089be766-3027-4dd6-9f56-77f2b81e4616)


By now you should be reading this guide from your fork's webpage. 

> [!IMPORTANT]
> The teachers and tutors will update the upstream repository with new content from time to time.
> 
> To reflect these changes to your fork, you have to [synchronize your fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork) regularly.
> 
> The sync action is easily accessible from your fork's main page via the button:
> 
> ![image](https://github.com/user-attachments/assets/1cb8d9e2-3a9f-4734-9149-ab6abcff20ac)
> 
> or in the GitHub CLI via the command `gh repo sync`.
### 2. Set up the development environment

Next, we'll configure your local OS for containerized development.

 1. If you're on Windows, install the WSL 2 back-end. [Follow the official instructions](https://learn.microsoft.com/en-us/windows/wsl/install#install-wsl-command).
 1. Install [Docker Desktop](https://docs.docker.com/get-started/get-docker/). 
 1. Lastly, install [Visual Studio Code](https://code.visualstudio.com/Download).

#### Open WSL

Once you've installed all three applications, start a WSL terminal and go through the initialization procedure, which will ask you to enter a username and a password for your account.

Next, check that you have `git` by issuing the command:

```
git --version
```

It should print a version number.

#### Install the GitHub CLI

This tool is very useful to manage your online repositories from the comfort of the command line. We just need it to perform `git` command as an authenticated user.

To install the GitHub CLI, follow the [installation instructions](https://github.com/cli/cli) that suit your Linux distribution. Then check it's installed with:

```
gh --version
```

#### Log on to GitHub from WSL

First, authenticate to your GitHub account from the GitHub CLI. Run:

```bash
gh auth login
```

and follow the on-screen procedure carefully.

Next, we need let `git` know about your GitHub profile.
Run the following commands being sure to use the username and the email of your GitHub account.

```bash
git config --global user.name <YOUR-USERNAME>
git config --global user.email <YOUR-EMAIL@EXAMPLE.COM>
```

From now on `git` will sign your commits with the given credentials and will act on the behalf of your GitHub account whenever you push to a remote repository, such as your fork.

#### Clone your Lip lab fork

Run the following command from your home folder, replacing `<YOUR-USERNAME>` with your GitHub username:

```
clone https://github.com/YOUR-USERNAME/lip
```

### 3. Open your fork in VS Code

We will now invoke VS Code's command-line interface `code` to start VS Code inside the `lip` folder:

```
code lip
```

Briefly after the VS Code window shows up, you should see a notification like the one in the image:

![image](https://github.com/user-attachments/assets/a50827fe-89e0-4305-99e6-8e04e1dafcca)

Click on the blue button and wait for a while. If everything goes well, VS Code will have opened the repo's container set up for OCaml development.

Try it out by opening the integrated terminal (`Ctrl + J`) and running `utop`.

Congrats! You are now ready to write and test OCaml code.

> [!NOTE]
> 
> The Docker image that VS Code installs comes with the OCaml compiler and many useful libraries that we'll use throughout the course. In particular, this installation includes:
> 
> - [**dune**](https://dune.readthedocs.io/), a build system for OCaml projects, similar to make;
> - [**utop**](https://opam.ocaml.org/blog/about-utop/), a REPL interface for OCaml;
> - [**Menhir**](http://gallium.inria.fr/~fpottier/menhir/), a parser generator;
> - [**ppx_inline_test**](https://github.com/janestreet/ppx_inline_test), a tool for writing in-line tests in OCaml.

### Conclusion

This wraps up the set-up tutorial. Your system in now equipped with the tools required to work on the exercises and on the course final assignment.

Now proceed to test your OCaml knowledge with these warm-up exercises:

1. [Adder](basics/adder)
1. [Recognizer](basics/recognizer)
1. [Tug of war](basics/tugofwar)

---

## Course outline
### Lexing and parsing

1. [A toy lexer](toylexer)
1. [A toy parser](toyparser)
1. [Game of life](life)
### Arithmetic expressions

1. [A minimal language of boolean expressions](expr/boolexpr)
1. [Boolean expressions with not, and, or](expr/andboolexpr)
1. [Typed arithmetic expressions with dynamic type checking](expr/arithexpr)
1. [Typed arithmetic expressions with static type checking](expr/sarithexpr)
### Imperative languages

1. [A simple imperative language](imp/while)
1. [Declaration blocks](imp/blocks)
1. [Functions](imp/fun)

---

## References

- [OCaml Programming: Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/cover.html)
- [OCaml from the very beginning](http://ocaml-book.com/)
- B. Pierce. Types and Programming Languages. MIT Press, 2002
