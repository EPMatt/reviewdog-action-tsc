
# Contribution Guidelines

## How to contribute

If you want to contribute to this project, please read [this wonderful guide from GitHub](https://guides.github.com/activities/forking/) which explains how to fork a repository, make your changes and submit your work by opening a Pull Request.

Any contribution is welcomed and really appreciated! :rocket:

## Tools supporting the development process

This repository includes several tools supporting the development process, which you should be aware of if you plan to contribute to the project.

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)

You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3 (as described in https://help.github.com/en/articles/about-actions#versioning-your-action).

### Lint & Code Quality checks

This reviewdog action template itself is integrated with reviewdog to run lint checks which are useful for the action definition.

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)
- [reviewdog/action-alex](https://github.com/reviewdog/action-alex)

### Dependencies Update Automation

This repository uses [reviewdog/action-depup](https://github.com/reviewdog/action-depup) to automatically update
reviewdog version.

[![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)](https://github.com/EPMatt/reviewdog-action-tsc/pull/6)
