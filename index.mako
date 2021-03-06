## -*- coding: utf-8 -*-
<%inherit file="base.mako" />
<div class="row">
    <div class="col-sm-3 hidden-xs pc-sidebar">
        <ul class="nav nav-pills nav-stacked pc-sidenav" data-spy="affix" data-offset-top="400">
            <li class="active"><a href="#intro">Introduction</a></li>
            <li><a href="#install">Installation</a></li>
            <li><a href="#plugins">Adding plugins</a></li>
            <li><a href="#usage">Usage</a></li>
            <li><a href="#new-hooks">Creating new hooks</a></li>
            <li><a href="#advanced">Advanced features</a></li>
            <li><a href="#contributing">Contributing</a></li>
        </ul>
    </div>
    <div class="col-sm-9">
        <div id="intro">
            <div class="page-header">
                <h1>Introduction</h1>
            </div>
            <p>
                At Yelp we rely heavily on pre-commit hooks to find and fix common issues before
                changes are submitted for code review. We run our hooks before every commit to
                automatically point out issues like missing semicolons, whitespace problems, and
                testing statements in code. Automatically fixing these issues before posting
                code reviews allows our code reviewer to pay attention to the architecture of a
                change and not worry about trivial errors.
            </p>
            <p>
                As we created more libraries and projects we recognized that sharing our pre
                commit hooks across projects is painful. We copied and pasted bash scripts
                from project to project and had to manually change the hooks to work for
                different project structures.
            </p>
            <p>
                We believe that you should always use the best industry standard linters. Some
                of the best linters are written in languages that you do not use in your project
                or have installed on your machine. For example scss-lint is a linter for SCSS
                written in Ruby. If you’re writing a project in node you should be able to use
                scss-lint as a pre-commit hook without adding a Gemfile to your project or
                understanding how to get scss-lint installed.
            </p>
            <p>
                We built pre-commit to solve our hook issues. It is a multi-language package
                manager for pre-commit hooks. You specify a list of hooks you want and
                pre-commit manages the installation and execution of any hook written in any
                language before every commit. pre-commit is specifically designed to not require
                root access. If one of your developers doesn’t have node installed but modifies
                a JavaScript file, pre-commit automatically handles downloading and building node
                to run jshint without root.
            </p>
        </div>

        <div id="install">
            <div class="page-header">
                <h1>Installation</h1>
            </div>
            <p>Before you can run hooks, you need to have the pre-commit package manager installed.</p>
            <p>Using pip:</p>
            <pre>pip install pre-commit</pre>
            <p>
                Non Administrative Installation:
                <small><em>(To upgrade: run again, to uninstall: pass <code>uninstall</code> to python)</em></small>
            </p>
            <pre>curl http://pre-commit.com/install-local.py | python</pre>
            <p>System Level Install:</p>
            <pre>curl https://bootstrap.pypa.io/get-pip.py | sudo python - pre-commit</pre>
            <p>In a Python Project, add the following to your requirements.txt (or requirements-dev.txt):</p>
            <pre>pre-commit</pre>
            <p>Using <a href="http://brew.sh/">homebrew</a></p>
            <pre>brew install pre-commit</pre>
        </div>

        <div id="plugins">
            <div class="page-header">
                <h1>Adding pre-commit plugins to your project</h1>
            </div>
            <p>Once you have pre-commit installed, adding pre-commit plugins to your project is done with the <code>.pre-commit-config.yaml</code> configuration file.</p>
            <p>Add a file called <code>.pre-commit-config.yaml</code> to the root of your project. The pre-commit config file describes:</p>
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <td><code>repo</code>, <code>sha</code></td>
                        <td>where to get plugins (git repos).  <code>sha</code> can also be a tag.</td>
                    </tr>
                    <tr>
                        <td><code>id</code></td>
                        <td>What plugins from the repo you want to use.</td>
                    </tr>
                    <tr>
                        <td><code>language_version</code></td>
                        <td>(optional) Override the default language version for the hook. See <a href="#overriding-language-version">Advanced Features: "Overriding Language Version"</a>.</td>
                    </tr>
                    <tr>
                        <td><code>files</code></td>
                        <td>(optional) Override the default pattern for files to run on.</td>
                    </tr>
                    <tr>
                        <td><code>exclude</code></td>
                        <td>(optional) File exclude pattern.</td>
                    </tr>
                    <tr>
                        <td><code>args</code></td>
                        <td>(optional) additional parameters to pass to the hook.</td>
                    </tr>
                    <tr>
                        <td><code>stages</code></td>
                        <td>(optional) Confines the hook to the <code>commit</code> or <code>push</code> stage. See <a href="#confining-hooks-to-run-at-certain-stages">Advanced Features: "Confining Hooks To Run At A Certain Stage"</a>.</td>
                    </tr>
                    <tr>
                        <td><code>additional_dependencies</code></td>
                        <td>(optional) A list of dependencies that will be installed in the environment where this hook gets run. One useful application is to install plugins for hooks such as eslint.  <em>new in 0.6.6</em></td>
                    </tr>
                    <tr>
                        <td><code>always_run</code></td>
                        <td>(optional) Default <code>false</code>.  If <code>true</code> this hook will run even if there are no matching files.  <em>new in 0.7.2</em></td>
                    </tr>
                </tbody>
            </table>
            <p>For example:</p>
<pre>
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: v0.4.2
    hooks:
    -   id: trailing-whitespace
</pre>
            <p>This configuration says to download the pre-commit-hooks project and run its trailing-whitespace hook.</p>

            <h2 id="updating-hooks-automatically">Updating hooks automatically</h2>

            <p>
                You can update your hooks to the latest version automatically
                by running <code>pre-commit autoupdate</code>.  This will
                bring the hooks to the latest sha on the master branch.
            </p>
        </div>

        <div id="usage">
            <div class="page-header">
                <h1>Usage</h1>
            </div>
            <p>Run <code>pre-commit install</code> to install pre-commit into your git hooks. pre-commit will now run on every commit. Every time you clone a project using pre-commit running <code>pre-commit install</code> should always be the first thing you do.</p>

            <p>If you want to manually run all pre-commit hooks on a repository, run <code>pre-commit run --all-files</code>. To run individual hooks use <code>pre-commit run &lt;hook_id&gt;</code>.</p>

            <p>The first time pre-commit runs on a file it will automatically download, install, and run the hook. Note that running a hook for the first time may be slow. For example: If the machine does not have node installed, pre-commit will download and build a copy of node.</p>
        </div>

        <div id="new-hooks">
            <div class="page-header">
                <h1>Creating new hooks</h1>
            </div>
            <p>pre-commit currently supports hooks written in JavaScript (node), Python, Ruby and system installed scripts. As long as your git repo is an installable package (gem, npm, pypi, etc.) or exposes an executable, it can be used with pre-commit. Each git repo can support as many languages/hooks as you want.</p>
            <p>
                An executable must satisfy the following things:
                <ul>
                    <li>The hook must exit nonzero on failure or modify files in the working directory (since 0.6.3).</li>
                    <li>It must take filenames as positional arguments.</li>
                </ul>
            </p>
            <p>A git repo containing pre-commit plugins must contain a .pre-commit-hooks.yaml file that tells pre-commit:</p>
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <td><code>id</code></td>
                        <td>The id of the hook - used in pre-commit-config.yaml</td>
                    </tr>
                    <tr>
                        <td><code>name</code></td>
                        <td>The name of the hook - shown during hook execution</td>
                    </tr>
                    <tr>
                        <td><code>entry</code></td>
                        <td>The entry point - The executable to run</td>
                    </tr>
                    <tr>
                        <td><code>files</code></td>
                        <td>The pattern of files to run on.</td>
                    </tr>
                    <tr>
                        <td><code>language</code></td>
                        <td>The language of the hook - tells pre-commit how to install the hook.</td>
                    </tr>
                    <tr>
                        <td><code>always_run</code></td>
                        <td>(optional) Default <code>false</code>.  If <code>true</code> this hook will run even if there are no matching files. <em>new in 0.7.2</em></td>
                    </tr>
                    <tr>
                        <td><code>description</code></td>
                        <td>(optional) The description of the hook.</td>
                    </tr>
                    <tr>
                        <td><code>language_version</code></td>
                        <td>(optional) See <a href="#overriding-language-version">Advanced Features: "Overriding Language Version"</a>.</td>
                    </tr>
                    <tr>
                        <td><code>minimum_pre_commit_version</code></td>
                        <td>
                            (optional) Allows one to indicate a minimum
                            compatible pre-commit version. <em>new in 0.6.7</em>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p>For example:</p>
<pre>
-   id: trailing-whitespace
    name: Trim Trailing Whitespace
    description: This hook trims trailing whitespace.
    entry: trailing-whitespace-fixer
    language: python
    files: \.(js|rb|md|py|sh|txt|yaml|yml)$
</pre>

            <p>
                <em>new in 0.12.0</em> Prior to 0.12.0 the file was
                <code>hooks.yaml</code>
                (now <code>.pre-commit-hooks.yaml</code>).
                For backwards compatibility it is suggested to provide both
                files or suggest users use <code>pre-commit&gt;=0.12.0</code>.
            </p>

            <h2 id="supported-languages">Supported languages</h2>
            <ul>
                <li><a href="#docker">docker</a></li>
                <li><a href="#golang">golang</a></li>
                <li><a href="#node">node</a></li>
                <li><a href="#python">python</a></li>
                <li><a href="#ruby">ruby</a></li>
                <li><a href="#swift">swift</a></li>
                <li><a href="#pcre">pcre</a></li>
                <li><a href="#script">script</a></li>
                <li><a href="#system">system</a></li>
            </ul>

            <h3 id="docker">docker</h3>
            <p><em>new in 0.10.0</em></p>
            <p>
                The hook repository must have a <code>Dockerfile</code>.  It
                will be installed via <code>docker build .</code>.
            </p>
            <p>
                Running Docker hooks requires a running Docker engine on your
                host.  For configuring Docker hooks, your <code>entry</code>
                should correspond to an executable inside the Docker
                container, and will be used to override the default container
                entrypoint. Your Docker <code>CMD</code> will not run when
                pre-commit passes a file list as arguments to the run
                container  command. Docker allows you to use any language
                that's not supported by pre-commit as a builtin.
            </p>
            <p>
                <u>Support:</u> docker hooks are known to work on any system
                which has a working <code>docker</code> executable.  It has
                been tested on linux and macOS.  Hooks that are run via
                <code>boot2docker</code> are known to be unable to make
                modifications to files.
            </p>
            <p>
                See <a href="https://github.com/pre-commit/pre-commit-docker-flake8">this repository</a>
                for an example Docker-based hook.
            </p>

            <h3 id="golang">golang</h3>
            <p><em>new in 0.12.0</em></p>
            <p>
                The hook repository must contain go source code.  It will be
                installed via <code>go get ./...</code>.  pre-commit will
                create an isolated <code>GOPATH</code> for each hook and the
                <code>entry</code> should match an executable which will
                get installed into the <code>GOPATH</code>'s <code>bin</code>
                directory.
            </p>
            <p>
                <u>Support:</u> golang hooks are known to work on any system
                which has go installed.  It has been tested on linux, macOS,
                and windows.
            </p>

            <h3 id="node">node</h3>
            <p>
                The hook repository must have a <code>package.json</code>.  It
                will be installed via <code>npm install .</code>.  The
                installed package will provide an executable that will match
                the <code>entry</code> &ndash; usually through
                <code>bin</code> in package.json.
            </p>
            <p>
                <u>Support:</u> node hooks work without any system-level
                dependencies.  It has been tested on linux and macOS and
                <em>may</em> work under cygwin.
            </p>

            <h3 id="python">python</h3>
            <p>
                The hook repository must have a <code>setup.py</code>.  It
                will be installed via <code>pip install .</code>.  The
                installed package will provide an executable that will match
                the <code>entry</code> &ndash; usually through
                <code>console_scripts</code> or <code>scripts</code> in
                setup.py.
            </p>
            <p>
                <u>Support:</u> python hooks work without any system-level
                depedendencies.  It has been tested on linux, macOS, windows,
                and cygwin.
            </p>

            <h3 id="ruby">ruby</h3>
            <p>
                The hook repository must have a <code>*.gemspec</code>.  It
                will be installed via
                <code>gem build *.gemspec &amp;&amp; gem install *.gem</code>.
                The installed package will produce an executable that will
                match the <code>entry</code> &ndash; usually through
                <code>exectuables</code> in your gemspec.
            </p>
            <p>
                <u>Support:</u> ruby hooks work without any system-level
                dependencies.  It has been tested on linux and macOS and
                <em>may</em> work under cygwin.
            </p>

            <h3 id="swift">swift</h3>
            <p><em>new in 0.11.0</em></p>
            <p>
                The hook repository must have a <code>Package.swift</code>.
                It will be installed via <code>swift build -c release</code>.
                The <code>entry</code> should match an executable created by
                building the repository.
            </p>
            <p>
                <u>Support:</u> swift hooks are known to work on any system
                which has swift installed.  It has been tested on linux and
                macOS.
            </p>

            <h3 id="pcre">pcre</h3>
            <p>
                "Perl Compatible Regular Expressions" &mdash; pcre hooks are a
                quick way to write a simple hook which prevents commits by
                file matching.  Specify the regex as the <code>entry</code>.
            </p>
            <p>
                osx does not ship with a functioning <code>grep -P</code> so
                you'll need <code>brew install grep</code> for pcre hooks to
                function.
            </p>
            <p>
                <u>Support:</u> pcre hooks work on any system which has a
                functioning <code>grep -P</code> (or in the case of macOS:
                <code>ggrep -P</code>).  It has been tested on linux, macOS,
                windows, and cygwin.

            <h3 id="script">script</h3>
            <p>
                Script hooks provide a way to write simple scripts which
                valdiate files. The <code>entry</code> should be a path
                relative to the root of the hook repository.
            </p>
            <p>
                This hook type will not be given a virtual environment to
                work with &ndash; if it needs additional dependencies the
                consumer must install them manually.
            </p>
            <p>
                <u>Support:</u> the support of script hooks depend on the
                scripts themselves.
            </p>

            <h3 id="system">system</h3>
            <p>
                System hooks provide a way to write hooks for system-level
                executables which don't have a supported language above (or
                have special environment requirements that don't allow them to
                run in isolation such as pylint).
            </p>
            <p>
                This hook type will not be given a virtual environment to
                work with &ndash; if it needs additional dependencies the
                consumer must install them manually.
            </p>
            <p>
                <u>Support:</u> the support of system hooks depend on the
                executables.
            </p>


            <h2 id="developing-hooks-interactively">Developing hooks interactively</h2>

            <p>
                Since the <code>repo</code> property of .pre-commit-config.yaml
                can take anything that <code>git clone ...</code> understands,
                it's often useful to point it at a local directory on your
                machine while developing hooks and using
                <code>pre-commit autoupdate</code> to synchronize changes.
<pre>
-   repo: /home/asottile/workspace/pre-commit-hooks
    sha: v0.4.2
    hooks:
    -   id: trailing-whitespace
</pre>
            </p>
        </div>

        <div id="advanced">
            <div class="page-header">
                <h1>Advanced features</h1>
            </div>

            <h2 id="running-in-migration-mode">Running in migration mode</h2>
            <p>By default, if you have existing hooks <code>pre-commit install</code> will install in a migration mode which runs both your existing hooks and hooks for pre-commit. To disable this behavior, simply pass <code>-f</code> / <code>--overwrite</code> to the <code>install</code> command. If you decide not to use pre-commit, <code>pre-commit uninstall</code> will restore your hooks to the state prior to installation.</p>

            <h2 id="temporarily-disabling-hooks">Temporarily disabling hooks</h2>
            <p>Not all hooks are perfect so sometimes you may need to skip execution of one or more hooks. pre-commit solves this by querying a <code>SKIP</code> environment variable. The <code>SKIP</code> environment variable is a comma separated list of hook ids. This allows you to skip a single hook instead of <code>--no-verify</code>ing the entire commit.</p>
            <pre>$ SKIP=flake8 git commit -m "foo"</pre>

            <h2 id="pre-commit-during-commits">pre-commit during commits</h2>
            <p>Running hooks on unstaged changes can lead to both false-positives and false-negatives during committing. pre-commit only runs on the staged contents of files by temporarily saving the contents of your files at commit time and stashing the unstaged changes while running hooks.</p>

            <h2 id="pre-commit-during-merges">pre-commit during merges</h2>
            <p>
                The biggest gripe we&rsquo;ve had in the past with pre-commit
                hooks was during merge conflict resolution.
                When working on very large projects a merge often results in
                hundreds of committed files. I shouldn&rsquo;t need to run
                hooks on all of these files that I didn&rsquo;t even touch!
                This often led to running commit with <code>--no-verify</code>
                and allowed introduction of real bugs that hooks could have
                caught.
            </p>
            <p>
                pre-commit solves this by only running hooks on files that
                conflict or were manually edited during conflict resolution.
                This also includes files which were automatically merged by
                git.  Git isn't perfect and this can often catch implicit
                conflicts (such as with removed python imports).
            </p>

            <h2 id="pre-commit-during-push">pre-commit during push</h2>
            <p>As of version 0.3.5, pre-commit can be used to manage <code>pre-push</code> hooks.  Simply <code>pre-commit install --hook-type pre-push</code>.</p>

            <h2 id="confining-hooks-to-run-at-certain-stages">Confining hooks to run at certain stages</h2>
            <p>If pre-commit during push has been installed, then all hooks (by default) will be run during the <code>push</code> stage. Hooks can however be confined to a stage by setting the <code>stages</code> property in your <code>.pre-commit-config.yaml</code>. The <code>stages</code> property is an array and can be set to either <code>[commit]</code>, <code>[push]</code> or <code>[commit, push]</code>.</p>

            <h2 id="passing-arguments-to-hooks">Passing arguments to hooks</h2>
            <p>Sometimes hooks require arguments to run correctly. You can pass static arguments by specifying the <code>args</code> property in your <code>.pre-commit-config.yaml</code> as follows:</p>
<pre>
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: v0.4.2
    hooks:
    -   id: flake8
        args: [--max-line-length=131]
</pre>
            <p>This will pass <code>--max-line-length=131</code> to <code>flake8</code>.</p>

            <h3>Arguments Pattern in hooks</h3>
            <p>If you are writing your own custom hook as a <code>script</code>-type or even a <code>system</code> hook, your hook should expect to receive the <code>args</code> value and then a list of staged files.</p>

            <p>For example, assuming a <code>.pre-commit-config.yaml</code>:</p>
<pre>
-   repo: git://github.com/path/to/your/hook/repo
    sha: badf00ddeadbeef
    hooks:
    -   id: my-hook-script-id
        args: [--myarg1=1, --myarg1=2]
</pre>

            <p>When you next run <code>pre-commit</code>, your script will be called:</p>
            <pre>path/to/script-or-system-exe --myarg1=1 --myarg1=2 dir/file1 dir/file2 file3</pre>

            <p>If the <code>args</code> property is empty or not defined, your script will be called:</p>
            <pre>path/to/script-or-system-exe dir/file1 dir/file2 file3</pre>

            <h2 id="repository-local-hooks">Repository Local Hooks</h2>
            <p>Repository-local hooks are useful when:</p>
            <ul>
                <li>The scripts are tightly coupled to the repository and it makes sense to distribute the hook scripts with the repository.</li>
                <li>Hooks require state that is only present in a built artifact of your repository (such as your app's virtualenv for pylint)</li>
                <li>The official repository for a linter doesn't have the pre-commit metadata.</li>
            </ul>
            <p>You can configure repository-local hooks by specifying the <code>repo</code> as the sentinel <code>local</code>.</p>
            <p>
                <em>new in 0.13.0</em> repository hooks can use any language
                which supports <code>additional_dependencies</code> or
                <code>pcre</code> / <code>script</code> / <code>system</code>.
                This enables you to install things which previously would
                require a trivial mirror repository.
            </p>
            <p>A <code>local</code> hook must define <code>id</code>, <code>name</code>, <code>language</code>, <code>entry</code>, and <code>files</code> as specified under <a href="#new-hooks">Creating new hooks</a></p>
            <p>Here's an example configuration with a few <code>local</code> hooks:</p>
<pre>
-   repo: local
    hooks:
    -   id: pylint
        name: pylint
        entry: python -m pylint.__main__
        language: system
        files: \.py$
    -   id: check-x
        name: Check X
        entry: ./bin/check-x.sh
        language: script
        files: \.x$
    -   id: scss-lint
        name: scss-lint
        entry: scss-lint
        language: ruby
        language_version: 2.1.5
        files: '\.scss$'
        additional_dependencies: ['scss_lint:0.52.0']
</pre>

            <h2 id="overriding-language-version">Overriding Language Version</h2>
            <p>Sometimes you only want to run the hooks on a specific version of the language. For each language, they default to using the system installed language (So for example if I&rsquo;m running <code>python2.6</code> and a hook specifies <code>python</code>, pre-commit will run the hook using <code>python2.6</code>). Sometimes you don&rsquo;t want the default system installed version so you can override this on a per-hook basis by setting the <code>language_version</code>.</p>
<pre>
-   repo: git://github.com/pre-commit/mirrors-scss-lint
    sha: v0.43.2
    hooks:
    -   id: scss-lint
        language_version: 1.9.3-p484
</pre>
            <p>This tells pre-commit to use <code>1.9.3-p484</code> to run the <code>scss-lint</code> hook.</p>
            <p>Valid values for specific languages are listed below:</p>
            <ul>
                <li>
                    python: Whatever system installed python interpreters you have. The value of this argument is passed as the <code>-p</code> to <code>virtualenv</code>.
                </li>
                <li>
                    node: See <a href="https://github.com/ekalinin/nodeenv#advanced">nodeenv</a>.
                </li>
                <li>
                    ruby: See <a href="https://github.com/sstephenson/ruby-build/tree/master/share/ruby-build">ruby-build</a>
                </li>
            </ul>

            <h2 id="usage-in-continuous-integration">Usage in Continuous Integration</h2>
            <p>
                pre-commit can also be used as a tool for continuous
                integration.  For instance, adding
                <code>pre-commit run --all-files</code> as a CI step will
                ensure everything stays in tip-top shape.
                To check only files which have changed, which may be faster, use something like
                <code>git diff-tree --no-commit-id --name-only -r $REVISION | xargs pre-commit run --files</code>.
            </p>
        </div>

        <div id="contributing">
            <div class="page-header">
                <h1>Contributing</h1>
            </div>
            <p>
                We&rsquo;re looking to grow the project and get more contributors especially to support more languages/versions. We&rsquo;d also like to get the .pre-commit-hooks.yaml files added to popular linters without maintaining forks / mirrors.
            </p>
            <p>Feel free to submit Bug Reports, Pull Requests, and Feature Requests.</p>
            <P>When submitting a pull request, please enable travis-ci for your fork.</p>

            <div class="page-header">
                <h1>Contributors</h1>
            </div>
            <ul>
                <li><a href="https://github.com/asottile">Anthony Sottile</a></li>
                <li><a href="https://github.com/struys">Ken Struys</a></li>
                <li><a href="https://github.com/mfnkl">Molly Finkle</a></li>
                <li><a href="https://github.com/guykisel">Guy Kisel</a></li>
                <li><a href="https://github.com/dupuy">Alexander Dupuy</a></li>
                <li><a href="https://github.com/Lucas-C">Lucas Cimon</a></li>
                <li><a href="https://github.com/caffodian">Alex Tsai</a></li>
                <li><a href="https://github.com/arahayrabedian">Ara Hayrabedian</a></li>
                <li><a href="https://github.com/meunierd">Devon Meunier</a></li>
                <li><a href="https://github.com/barrysteyn">Barry Steyn</a></li>
                <li><a href="https://github.com/blarghmatey">Tobias Macey</a></li>
                <li><a href="https://github.com/laurentsigal">Laurent Sigal</a></li>
                <li><a href="https://github.com/bpicolo">Ben Picolo</a></li>
            </ul>
        </div>
    </div>
</div>
