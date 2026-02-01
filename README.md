# blueprint-tutorial

This repository is a minimal example showing how to configure and generate Lean documentation using doc-gen4 and leanblueprint.
The goal is to keep things as simple and explicit as possible, while still showing a complete working setup.

**All references have the information that I'm writing, this is just a step by step guide of _what I've done_**

[This is the output example](https://j-mayoral.github.io/blueprint-tutorial/)

# Requirements

Install leanblueprint

First, set up a clean Python environment (or reuse one you already have) and install leanblueprint.

If you want to create a fresh virtual environment, you can do:
 
```sh 
mkdir .envs
cd .envs
python3 -m venv .lean_env
source .lean_env/bin/activate
```

Once the environment is active, install leanblueprint:

```sh
pip install leanblueprint
```

You can verify that the installation was successful by running:

```sh
pip freeze | grep leanblueprint
```

You should see something similar to:

```sh
leanblueprint==0.0.20
```

At this point, you are ready to start working on the project.


## Create or work on a repo

The most natural workflow is to create a GitHub repository for your project.

The repository must be public, since GitHub Pages on the free plan only works for public repositories.

Once the repository is created, you can start working on a Lean project.

Additionally, make sure to configure GitHub Actions and Pages correctly:

1. Under your repository name, click Settings.
2. In the sidebar, go to Actions → General.
3. Enable "Allow GitHub Actions to create and approve pull requests".
4. Go to Pages in the settings sidebar.
5. In the Source dropdown, select GitHub Actions.


## Lean project

Create (or reuse) a Lean project.

In this repository, blueprint-example is used as a minimal Lean project to keep things simple.

Inside blueprint-example, there is a very small example in Basic.lean:

```lean

def sum_until: Nat → Nat
| 0 => 0
| n + 1 => Nat.succ n + sum_until n

theorem sum_first_natural_numbers : ∀ n : Nat,
  2 * (sum_until n) = n * (n + 1) :=
by
  intro n
  induction n with
  | zero => grind [sum_until]
  | succ n ih => grind [sum_until] 
```
This is the Lean code we will reference when generating the blueprint documentation.

# Start working
## Generate the Blueprint configuration

From the root directory of the Lean project, run:

```sh
leanblueprint new
```

You will be prompted with a series of questions.
If you are unsure about any of them, the default answers are usually fine.

After the setup finishes, you will be asked whether to create a commit.
If everything goes well, you should see:

```sh
You are all set 🎉
```

## Generate Blueprint documentation

After running `leanblueprint new`, a new directory will appear:

```blueprint/src```

Inside this directory, you can start writing the documentation that formalizes your results in LaTeX.

The main entry point is:

```blueprint/src/content.tex```

You can treat this file as the main body of a LaTeX template.
For example, here is a simple document that references the Lean objects defined above:

```latex
\begin{definition}[Sum until]
  \label{def:sum_until}
  \lean{sum_until}
  For every natural number n in N, we define
    sum_until(n) := sum from k = 0 to n of k.
\end{definition}

\begin{theorem}[Sum of the first n natural numbers]
  \lean{sum_first_natural_numbers}
  \leanok
  \uses{def:sum_until}
  For every n in N,
    sum_until(n) = n(n+1)/2.
\end{theorem}

\begin{proof}
  \leanok
  This follows from a straightforward induction on n.
\end{proof}
```

## IMPORTANT NOTE ABOUT GITHUB ACTIONS

I was not able to get the GitHub Actions workflow to run successfully unless I disabled the following options in .github/workflows:

```yaml
- name: Build and lint project
  uses: leanprover/lean-action@434f25c2f80ded67bba02502ad3a86f25db50709
  with:
    build: true
    lint: false
    mk_all-check: false
```

After adjusting this, you can commit your changes and push them to GitHub.

If everything is configured correctly, you should see a pipeline running under the Actions tab of your repository, and the documentation should be generated automatically (for me it took about 10 min).

# Run it in local

Here’s a **cleaned-up, clear, and idiomatic English rewrite** of that section, with improved structure and presentation while keeping it concrete and technical.

You can drop this directly into your `README.md`.

---

## Previewing the documentation locally

You can always generate the documentation by pushing your changes and letting GitHub Actions run. However, during development it is often useful to preview the documentation locally and check that everything is working correctly.

For this purpose, `leanblueprint` provides two useful commands:

* `leanblueprint web`
* `leanblueprint serve`

### Generating local blueprint assets

First, run:

```
leanblueprint web
```

This command generates several auxiliary files under the `blueprint/` directory.

**Important:**
Do **not** commit these generated files. They are meant for local development only and are automatically generated by the GitHub Actions workflow. From a remote point of view, they are unnecessary.

### Serving the blueprint locally

Next, run:

```
leanblueprint serve
```

This starts a local web server (usually at `http://localhost:8000`).
Open this address in your browser to view the rendered documentation. The page should closely match what will be published via GitHub Actions.

## doc-gen4 documentation

In addition to the blueprint, the GitHub Actions workflow also generates the **doc-gen4** documentation for the Lean project.

If you are developing Lean code and LaTeX documentation in parallel, make sure the doc-gen4 documentation is up to date. You can generate it locally with:

```
lake build YourProject:docs
```

This command produces the documentation under:

```
.lake/build/doc
```

You can serve it locally by running the following command inside that directory:

```
python3 -m http.server
```

## Linking local doc-gen4 documentation

To use the locally served doc-gen4 documentation together with the blueprint preview, edit the file:

```
blueprint/web.tex
```

and replace the `\dochome` directive with your local server address:

```latex
\dochome{http://localhost:8000} % Instead of the GitHub Pages URL
```

This ensures that links from the blueprint point to your locally generated doc-gen4 documentation during development.


# REFERENCES

leanblueprint:
https://github.com/PatrickMassot/leanblueprint

doc-gen4:
https://github.com/leanprover/doc-gen4
