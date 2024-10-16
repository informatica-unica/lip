## [Tutorial] Getting started

Before diving into the course, let's take care of a few technicalities.

This set up process is quite involved and may seem overwhelming at first, but bear with it for now. It will pay off in the subsequent lessons. Arguably, the technologies we introduce here will very likely serve the purposes of other courses and even of your future projects.

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

1.  If you're on Windows (at least 10), install the WSL 2 back-end. [Follow the official instructions](https://learn.microsoft.com/en-us/windows/wsl/install#install-wsl-command).
1.  Install [Docker Desktop](https://docs.docker.com/get-started/get-docker/).
1.  Lastly, install [Visual Studio Code](https://code.visualstudio.com/Download).

### [Windows users only] Configure WSL

_Skip this section and jump to "Configure git" if you don't use Windows._

Hit the keys `Win + S` and search for "WSL" or "Ubuntu". Clicking the first result should open a pitch-black window with white text on it.

Read it carefully, and make sure you understand it as you go through the initialization procedure.
It will eventually ask you to enter a username and a password for your account. Note these down.

Every time you start WSL, you should be logged in to a user account. This is made clear by the shell prompt ending with a `$` sign. If this is your case, skip to "Configure Docker for WSL" below.

#### Creating a user account manually

If your prompt line ends with the `#` character after starting WSL, that means you're signed as root, which is not ideal.

In the following commands, replace `username` with one of your choice. To create a user account manually, run:

```
adduser username --ingroup sudo
```

Input a password and don't bother filling out the other fields. Then, to login into your new account:

```
login username
```

Future WSL sessions will start in this user account.

Additional references: [Microsoft Learn guide](https://learn.microsoft.com/en-us/windows/wsl/setup/environment), [Ubuntu Wiki](https://help.ubuntu.com/community/RootSudo#Allowing_other_users_to_run_sudo).

> [!NOTE]
> To start WSL as root again, run the following command from PowerShell, replacing `distro` with one of your installations shown by `wsl --list`:
>
> ```
> wsl -d distro -u root
> ```

#### Configure Docker for WSL

On Docker Desktop, make sure WSL 2 integration is enabled. Follow the actions shown in this gif:

  ![non-exact-turn](https://github.com/user-attachments/assets/16715217-1087-44b1-8d22-b89543695520)

It's okay if the last page doesn't exactly match yours (I have many WSL distros): it suffices to check the box for the default distro.

### 3. Configure git

From now on we will be working solely on the command line of a Linux shell. If you're on Windows, that means you're going to be typing commands within a WSL shell running Ubuntu. Otherwise, as a Linux or macOS user, you're going to be using your OS's native shell.

Many commercial Linux distributions, including the one shipped with WSL, already come with `git` preinstalled, but it doesn't hurt to check:

```
git --version
```

If that command fails, then you must [install `git` for your distro](https://git-scm.com/downloads/linux). For Ubuntu and WSL it boils down to the two commands:

```
sudo apt update
sudo apt install git
```

#### Install the GitHub CLI

Next, we want the GitHub CLI. The GitHub CLI is a useful tool to manage your online repositories from the comfort of the command line. We just need it to perform `git` commands as an authenticated user.

To install the GitHub CLI, follow the [installation instructions for Linux](https://github.com/cli/cli/blob/trunk/docs/install_linux.md). Then check it's installed with:

```
gh --version
```

#### Login to GitHub from the shell

First, authenticate to your GitHub account from the GitHub CLI. Run:

```bash
gh auth login
```

and follow the on-screen procedure carefully.

Next, we need to let `git` know about your GitHub profile.
Run the following commands, being sure to use the username and the email of your GitHub account.

```bash
git config --global user.name your-username
git config --global user.email your-email@example.com
```

From now on `git` will sign your commits with the given credentials and will act on the behalf of your GitHub account whenever you push to a remote repository, such as your fork.

#### Clone your LiP lab fork

Run the following command from your home folder, replacing `your-username` with your GitHub username:

```
git clone https://github.com/your-username/lip
```

This downloads a local copy of your fork in a new directory called `lip`.

### 4. Open the VS Code container

We will now invoke VS Code's command-line interface `code` to launch VS Code inside the `lip` folder:

```
code lip
```

Briefly after the VS Code window shows up, you should see a notification like the one in the image:

![image](https://github.com/user-attachments/assets/a50827fe-89e0-4305-99e6-8e04e1dafcca)

Click on the blue button and wait for a while. If everything goes well, VS Code will have opened the repo's container set up for OCaml development.

Try it out the Dev Container by opening the integrated terminal (`Ctrl + J`, then click on the "+" icon) and enter the command `utop`. Play with some OCaml expressions, then exit `utop` by pressing `Ctrl + D`.

Congrats! You are now ready to write and test OCaml code.

> [!NOTE]
>
> The Dev Container you've just opened transforms your VS Code into a fully integrated OCaml IDE. It comprises the [OCaml Platform extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform#getting-started) and an installation of the OCaml compiler enriched with many useful libraries. In particular, this installation includes:
>
> - [**dune**](https://dune.readthedocs.io/), a build system for OCaml projects, similar to make;
> - [**utop**](https://opam.ocaml.org/blog/about-utop/), a REPL interface for OCaml;
> - [**Menhir**](http://gallium.inria.fr/~fpottier/menhir/), a parser generator;
> - [**ppx_inline_test**](https://github.com/janestreet/ppx_inline_test), a tool for writing in-line tests in OCaml.

## First project

To check that everything is installed correctly, we set up a first project (see [here](https://ocaml.org/docs/up-and-running#starting-a-new-project) for more detailed instructions).

Navigate to `lip/basics` folder.
Then, create a new project called `helloworld` using dune. Below, the lines starting with `>` contain the expected output of the given shell commands:

```
dune init project helloworld
> Success: initialized project component named helloworld
```

This command creates a directory `helloworld` with the following file structure:

```
helloworld/
├── dune-project
├── bin
│   └── dune
│   └── main.ml
├── lib
│   └── dune
├── test
│   ├── dune
│   └── helloworld.ml
└── helloworld.opam
```

To check that the OCaml installation was successful, try to build the project from the `helloworld` directory:

```bash
cd helloworld
dune build
```

If there are no errors, the output should be empty.
Run the project as follows:

```
dune exec helloworld
> Hello, World!
```

We will discuss the project structure in detail in the next exercise. For the moment, note that the `_build` directory contains the output of the `dune build` command. This includes the `main.exe` executable inside the `_build/default/bin/` subdirectory.

> [!NOTE]
> In this very first project, all the source code is in `./bin/main.ml`. For more complex projects, we will mainly write our source code in the `lib` directory.

#### Push the solution to GitHub

We won't do much else in this first project, so let's see how to record our changes to the fork.

Assuming you're still under the `basics/helloworld` directory, run the following command:

```
git add .
```

Let's break it down. We're invoking `git` with two arguments. The first one, `add`, is a git subcommand that lets you add new or modified files to the set of changes that should be recorded in the next commit (i.e. the _index_). The second argument, `.`, stands for the current directory (`basics/helloworld`).

> [!TIP]
> The command `git status` lets you review the changes you've staged for a commit.
>
> If you wish to unstage a change from the index, invoke `git restore --staged` on the changed files.

Next, we commit the contents of the `helloworld` folder. A commit must be supplemented with a commit message describing the changes.

```
git commit -m "Create first dune project in basics/helloworld"
```

As before, `commit` is a subcommand of git. It accepts an optional argument, introduced by `-m`, that lets us specify the commit message as a string.

The changes are still stored on our local file system. To update the remote fork repository with your commit, issue the command:

```
git push
```

The dual action of pushing is pulling. You'll only need to pull some commits to your local fork when the teachers update the upstream repository and you have synced your fork as previously noted.
The command to pull is, you guessed it:

```bash
git pull
```

This might not work if you have some pending changes not yet committed to your working tree. In this case you can temporarily store away the modified files with:

```bash
git stash
```

and restore them later on top of the newer commits using:

```bash
git stash apply
```

> [!TIP]
> You can always append the `--help` option to any of the above git subcommands to fully explore their functionality.
>
> We've shown just a few basic git commands here. Refer to the [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf) for more important commands.

## Conclusion

You made it to the end of Getting Started tutorial! You and your system should now be ready to take on the more theoretical stuff.

Here's a final diagram to help you understand the lab workflow.

![image](https://github.com/user-attachments/assets/8ae392cf-997c-483f-bf49-60d169726e9f)