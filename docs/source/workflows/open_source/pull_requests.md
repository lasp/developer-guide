## Pull Request and Review Standards

Before any code is merged into the code base, it will need to be put up for pull request (PR) and reviewed. The pull request should be created following
the checklist for pull requests.

### Checklist for Pull Requests

* Read through your own diff and look for weirdness. e.g. mistakes or accidental changes
* Update the changelog, if one exists.
* Update the PR title for clarity and write a nice PR summary for your reviewers
* Add the correct reviewers, if you know them

Ask the following questions:

* Is any of the code functionality not already available via native or third-party python libraries?
* Does the code execute successfully?
    * Do all the tests pass in the existing test suite?
    * Does the newly added functionality run without errors?
* Is the code documented and commented sufficiently such that it is easy to read and follow?
    * Are docstrings included for all new modules, classes, and functions?
    * Are in-line comments included to provide necessary context?
    * Are any documentation files in other locations updated?
* Have all debugging/print statements been removed?
* Does the code contain sufficient exception handling?
* Does the code contain no deprecation warnings?
* Does the code include new unit tests?
* Are any new dependencies correctly added to the ``pyproject.toml`` file?

### Before opening a pull request

Before you create the pull request, you should go through the checklist for pull requests to ensure the proposed changes meet the repository standards.

The PR should be as small as possible. However, the code included in the PR should be complete. All code merged into the main branch should meet the repository standards and work as expected.

If you want to work on the pull request or are not yet finished with the code, please indicate this by marking the pull request as a
[draft or WIP](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests#draft-pull-requests) PR.
Anyone looking at the PR will be able to quickly see it is not final. Marking your PR as draft means you are asking someone for an initial review, or if you want to get comments on your
initial design. If you put up a draft PR, indicate whether or not you are looking for initial reviews in the summary.

Finally, if you are addressing an existing issue, make sure that issue is [linked](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword) in your PR. If there is not an existing issue, then you should either create an issue or address WHY you are opening the PR specifically.

### During review

As a reviewer, please follow these rules of thumb:

1. Comments should be clear in addressing why you want to see the change
1. Comments should be polite, but straightforward and candid
1. If you leave a review, continue to follow up on replies to your questions or comments and review the changes you requested
1. It is nice, but not required, to provide examples for suggestions (particularly for things like name changes)
1. If you require a change to be addressed, add a "request changes" comment. If you make one of these comments, it means you are blocking the code review from merging until that change is addressed.
1. If you make a "request changes" comment, you must create a follow up review where you change that to an approving review (or make another "request changes" review). Please do this in a timely matter so you do not block the PR for longer than necessary.

As an author:

1. If you would like to request a specific review from someone, make sure they are marked as a reviewer or called out in a comment on the review (by typing `@<username>`)
1. Please respond to PR comments in a timely manner and according to the LASP Code of Conduct

As a team:

1. All parties need to be respectful during code reviews and follow the LASP Code of Conduct
1. Don't take comments personally - treat everyone as a fellow team member working to produce excellent code, not as adversaries to defeat before you can merge
1. Be honest - if you disagree with someones comment, start a discussion on why that is the case

### Before merging

Before merging, a pull request needs one approving review. While the review is open, anyone can make comments or request changes on the PR.

Although only one approval is required, you must follow these rules:

1. If you know there is someone with a particular expertise or vested interest in your changes, **do not merge or close the pull request until they get a chance to review.**
1. Do not merge until you have addressed all the comments on your review, even if you have an approval from someone.
1. Make sure you have left the review open for a sufficient amount of time to allow people to review.
1. If someone asked for changes beyond a nitpick, do not merge until you have an approval or thumbs up from them. This does not mean you need to change your code if you don't agree with them, but you should explain why you will not be making the changes and make sure they are ok with merging anyway.
1. You should go through the pull request checklist.
1. You should ensure ALL checks on the PR pass (tests are passing)
1. If you have a lot of commits, clean up the commits by running a [rebase](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) and combining commits.

