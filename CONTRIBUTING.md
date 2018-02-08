# Contributing to InteractiveSideMenu

:+1: First of all, big thanks for your desire to contribute in this project :+1:

## How to contribute

The easiest way to contribute is to *report a bug* or *propose a new feature* using [GitHub Issues](https://github.com/handsomecode/InteractiveSideMenu/issues).
Also, feel free to send your suggestions concerning any library issues, documentation and README typos, [Sample](./Sample) improvements, or any other enhancements. **We really appreciate your participation!**

### How to ask a question

Before asking a question, please look through the [README](./README.md) and [Sample application](./Sample) or take a look into [already asked GitHub Issues](https://github.com/handsomecode/InteractiveSideMenu/issues) (even closed). If you still haven't found an answer, feel free to [open an issue](https://github.com/handsomecode/InteractiveSideMenu/issues/new) and ask us your question and mark it with the prepared `question` label.

### How to report a bug

The standard way to report a bug is [GitHub Issues](https://github.com/handsomecode/InteractiveSideMenu/issues).

Explain the problem and include additional details to help maintainers reproduce the problem:

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps to reproduce the problem** in as many details as possible.
- **Provide specific examples** to demonstrate these steps. Include links to files or GitHub projects, or copy/paste snippets. If you're providing snippets in the issue, use Markdown code blocks.
- **Describe the behavior you observed** after following these steps and point out what exactly is the problem with that behavior.
- **Explain the behavior you expected** to see instead and why.
- **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem.
- **If you're reporting a library crash**, include a crash report with a stack trace.

Include details about your configuration and environment:

- **Which version of InteractiveSideMenu** are you using?
- Do you test on the **Simulator** or a **Real device**?
- **iOS version** that you test with.
- **Xcode version** if it could be helpful in your case.

### How to request an enhancement

**Enhancements** are features that you might like to suggest to a project, but aren't necessarily bugs/problems with the existing code. There is *a label* for enhancements in [Github's Issues](https://github.com/handsomecode/InteractiveSideMenu/issues), so you can tag issues as `enhancement`, and thereby allow us to prioritize issues/bugs reported to the project.


### How to tell us about your application

If you are using **InteractiveSideMenu** in your project that is successfully published to AppStore, [send the link](https://github.com/handsomecode/InteractiveSideMenu/issues/new) to us and we'll add you to the list of applications that use the library.


### How to submit changes

When contributing to this repository, please, first discuss the change you wish to make via [issue](https://github.com/handsomecode/InteractiveSideMenu/issues/new).
The preferred workflow for contributing to InteractiveSideMenu is to fork the [main repository](https://github.com/handsomecode/InteractiveSideMenu) on
GitHub, clone, and develop on a branch.

**Steps:**

1. Fork the [project repository](https://github.com/handsomecode/InteractiveSideMenu)
   by clicking on the 'Fork' button near the top right of the page. This creates
   a copy of the code under your GitHub user account. For more details on
   how to fork a repository see [this guide](https://help.github.com/articles/fork-a-repo/).

2. Clone your fork of the *InteractiveSideMenu* repo from your GitHub account to your local disk

   ```bash
   $ git clone git@github.com:YourLogin/InteractiveSideMenu.git
   $ cd InteractiveSideMenu
   ```

3. Checkout to `develop` branch, and create a ``feature`` branch to hold your development changes

   ```bash
   $ git checkout develop
   $ git checkout -b feature/my_updates
   ```

   Always use a ``feature`` branch. It's good practice to add updates to the main branches.

4. Develop the feature on your feature branch. Add changed files using ``git add`` and then ``git commit`` files

   ```bash
   $ git add modified_files
   $ git commit
   ```

   to record your changes in Git, then push the changes to your GitHub account with

   ```bash
   $ git push -u origin feature/my_updates
   ```

5. Add your updates to [Sample](./Sample) as well. Also, don't forget to update [README](./README.md) and [CHANGELOG](./CHANGELOG.md) with your changes.

6. Follow [these instructions](https://help.github.com/articles/creating-a-pull-request-from-a-fork)
to create a pull request from your fork. This will send an email to the committers.

(If any of the above seems like magic to you, please look up the
[Git documentation](https://git-scm.com/documentation) on the web, or ask a friend or another contributor for help)

## Code of Conduct

This project is governed by the [CODE OF CONDUCT](./CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please, report unacceptable behavior to mobile@handsome.is.
