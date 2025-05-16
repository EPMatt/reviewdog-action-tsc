# reviewdog-action-tsc

![Maintained](https://img.shields.io/badge/maintained-yes-brightgreen) 
[![Tests](https://github.com/EPMatt/reviewdog-action-tsc/actions/workflows/test.yml/badge.svg)](https://github.com/EPMatt/reviewdog-action-tsc/actions/workflows/test.yml)
[![Code Quality](https://github.com/EPMatt/reviewdog-action-tsc/actions/workflows/reviewdog.yml/badge.svg)](https://github.com/EPMatt/reviewdog-action-tsc/actions/workflows/reviewdog.yml)
[![Deps auto update](https://github.com/EPMatt/reviewdog-action-tsc/actions/workflows/depup.yml/badge.svg)](https://github.com/EPMatt/reviewdog-action-tsc/actions/workflows/depup.yml)
[![Release](https://github.com/EPMatt/reviewdog-action-tsc/actions/workflows/release.yml/badge.svg)](https://github.com/EPMatt/reviewdog-action-tsc/actions/workflows/release.yml)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/EPMatt/reviewdog-action-tsc?logo=github&sort=semver)](https://github.com/EPMatt/reviewdog-action-tsc/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

<a href="https://www.buymeacoffee.com/epmatt"><img width="150" alt="yellow-button" src="https://user-images.githubusercontent.com/30753195/133942263-5fef0166-4ab5-4529-b931-37b5d14f02bf.png"></a>

![github-pr-check demo](https://user-images.githubusercontent.com/30753195/133942341-15cd70d7-fb37-44c1-9249-c41580872a2f.png)

This GitHub Action runs [tsc](https://www.typescriptlang.org/docs/handbook/compiler-options.html) with [reviewdog](https://github.com/reviewdog/reviewdog) to improve code checking and review experience for TypeScript-based modules. :dog:

The action will first run `tsc`, then passing the compiler's output to reviewdog for further processing. Reviewdog will then provide a GitHub check either with code annotations as displayed above or with a Pull Request review, depending on the action configuration.

For full documentation regarding reviewdog, its features and configuration options, please visit the [reviewdog repository](https://github.com/reviewdog/reviewdog).

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
    required: false
  workdir:
    description: |
      Working directory relative to the root directory.
      This is where the action will look for a
      package.json which declares typescript as a dependency.
      Default is `.`.
    default: '.'
    required: false
  ### Flags for reviewdog ###
  level:
    description: |
      Report level for reviewdog [info,warning,error].
      Default is `error`.
    default: 'error'
    required: false
  reporter:
    description: |
      Reporter of reviewdog command [github-check,github-pr-check,github-pr-review].
      Default is `github-pr-check`.
    default: 'github-pr-check'
    required: false
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is `added`.
    default: 'added'
    required: false
  fail_level:
    description: |
      If set to `none`, always use exit code 0 for reviewdog. Otherwise, exit code 1 for reviewdog if it finds at least 1 issue with severity greater than or equal to the given level.
      Possible values: [none,any,info,warning,error]
      Default is `none`.
    default: 'none'
    required: false
  reviewdog_flags:
    description: |
      Additional reviewdog flags.
      Default is ``.
    default: ''
    required: false
  tool_name:
    description: 'Tool name to use for reviewdog reporter'
    default: 'tsc'
    required: false
  ### Flags for tsc ###
  tsc_flags:
    description: |
      Flags and args to pass to tsc.
      Default is ``.
    default: ''
    required: false
```

## Usage

This example shows how to configure the action to run on any event occurring on a Pull Request. Reviewdog will report tsc output messages as warnings by opening a code review on the Pull Request which triggered the workflow.

```yaml
name: reviewdog
on: [pull_request]
jobs:
  tsc:
    name: runner / tsc
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: EPMatt/reviewdog-action-tsc@v1
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need
          # [github-pr-check,github-check,github-pr-review].
          # More about reviewdog reporters at
          # https://github.com/reviewdog/reviewdog#reporters
          reporter: github-pr-review
          # Change reporter level if you need
          # [info,warning,error].
          # More about reviewdog reporter level at
          # https://github.com/reviewdog/reviewdog#reporters
          level: warning
```

## FAQs

### How do I run the action on a TS module in a subfolder?

To run the action on a TS module in a subfolder, you can change the path where the action will run with the `workdir` input.

```yaml
name: reviewdog
on: [pull_request]
jobs:
  tsc:
    name: runner / tsc
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: EPMatt/reviewdog-action-tsc@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          level: warning
          # The action will look for a package.json file with typescript
          # declared as a dependency located in the "foo" subfolder.
          workdir: foo
```

### How do I run the action on multiple TS modules?

For more complex setups which require to run the action on multiple TS modules, run the action once for each single module, changing the `workdir` and `tsc_flags` inputs accordingly.

```yaml
name: reviewdog
on: [pull_request]
jobs:
  tsc:
    name: runner / tsc
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      # Run action for the "submodule1" module
      - uses: EPMatt/reviewdog-action-tsc@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          level: warning
          # The action will look for a package.json file with typescript
          # declared as a dependency located in the "submodule1" subfolder.
          workdir: submodule1
      # Run action for the "submodule2" module
      - uses: EPMatt/reviewdog-action-tsc@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          level: warning
          # The action will look for a package.json file with typescript
          # declared as a dependency located in the "submodule2" subfolder.
          workdir: submodule2
```

### Why can't I see the results?
Try looking into the `filter_mode` options explained [here](https://github.com/reviewdog/reviewdog#filter-mode). TypeScript errors will sometimes appear in lines or files that weren't modified by the commit the workflow run is associated with, which instead get filtered with the default `added` option.

## Contributing

Want to improve this action? Cool! :rocket: Please make sure to read the [Contribution Guidelines](CONTRIBUTING.md) prior submitting your work.

Any feedback, suggestion or improvement is highly appreciated!

## Sponsoring

If you want to show your appreciation and support maintenance and future development of this action, please consider **making a small donation [here](https://www.buymeacoffee.com/epmatt)**. :coffee:

Moreover, if you like this project don't forget to **leave a star on [GitHub](https://github.com/EPMatt/reviewdog-action-tsc)**. Such a quick and zero-cost act will allow the action to get more visibility across the community, resulting in more people getting to know and using it. :star:
